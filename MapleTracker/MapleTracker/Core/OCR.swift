//
//  Copyright © 2025 Ohlulu. All rights reserved.
//

import AppKit
import CoreImage
import Foundation
import Vision

struct OCRResult {
  let text: String
  let confidence: Float
  let boundingBoxes: [CGRect]
}

actor OCRService {

  enum Error: Swift.Error {
    case invalidImage
    case noTextFound
    case recognitionFailed(Swift.Error)
    case unsupportedImageFormat
  }

  func recognize(from image: NSImage, region: CGRect = CGRect.full()) async throws -> String {
    let result = try await performOCRInRegion(on: image, region: region)
    return result.text
  }

  func recognizeDetails(from image: NSImage, region: CGRect = CGRect.full()) async throws -> OCRResult {
    return try await performOCRInRegion(on: image, region: region)
  }
}

extension OCRService {
  private func performOCRInRegion(on image: NSImage, region: CGRect) async throws -> OCRResult {
    guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
      throw Error.invalidImage
    }

    return try await withCheckedThrowingContinuation { continuation in
      let request = VNRecognizeTextRequest { request, error in
        if let error = error {
          continuation.resume(throwing: Error.recognitionFailed(error))
          return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation],
          !observations.isEmpty
        else {
          continuation.resume(throwing: Error.noTextFound)
          return
        }

        var allText: [String] = []
        var totalConfidence: Float = 0
        var boundingBoxes: [CGRect] = []

        for observation in observations {
          guard let topCandidate = observation.topCandidates(1).first else { continue }

          allText.append(topCandidate.string)
          totalConfidence += topCandidate.confidence
          boundingBoxes.append(observation.boundingBox)
        }

        let finalText = allText.joined(separator: "\n")
        let averageConfidence = observations.isEmpty ? 0 : totalConfidence / Float(observations.count)

        let result = OCRResult(
          text: finalText,
          confidence: averageConfidence,
          boundingBoxes: boundingBoxes
        )

        continuation.resume(returning: result)
      }

      request.regionOfInterest = region
      request.recognitionLevel = .accurate
      request.recognitionLanguages = ["en-US"]

      let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

      Task {
        do {
          try handler.perform([request])
        } catch {
          continuation.resume(throwing: Error.recognitionFailed(error))
        }
      }
    }
  }
}

extension NSImage {

  func preprocessForOCR() -> NSImage? {
    guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }

    let context = CIContext()
    let ciImage = CIImage(cgImage: cgImage)

    let contrastFilter = CIFilter(name: "CIColorControls")!
    contrastFilter.setValue(ciImage, forKey: kCIInputImageKey)
    contrastFilter.setValue(1.3, forKey: kCIInputContrastKey)
    contrastFilter.setValue(1.1, forKey: kCIInputBrightnessKey)

    guard let contrastOutput = contrastFilter.outputImage else { return nil }

    let sharpenFilter = CIFilter(name: "CISharpenLuminance")!
    sharpenFilter.setValue(contrastOutput, forKey: kCIInputImageKey)
    sharpenFilter.setValue(0.4, forKey: kCIInputSharpnessKey)

    guard let finalOutput = sharpenFilter.outputImage,
      let processedCGImage = context.createCGImage(finalOutput, from: finalOutput.extent)
    else {
      return nil
    }

    return NSImage(cgImage: processedCGImage, size: self.size)
  }

  func cropToRegion(_ region: CGRect) -> NSImage? {
    guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }

    let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
    let cropRect = CGRect(
      x: region.origin.x * imageSize.width,
      y: region.origin.y * imageSize.height,
      width: region.size.width * imageSize.width,
      height: region.size.height * imageSize.height
    )

    guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }

    return NSImage(cgImage: croppedCGImage, size: cropRect.size)
  }
}

private extension CGRect {
  static func full() -> CGRect {
    CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
  }
}

extension OCRService.Error: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidImage:
      return "Invalid image provided for OCR processing"
    case .noTextFound:
      return "No text was found in the image"
    case .recognitionFailed(let error):
      return "Text recognition failed: \(error.localizedDescription)"
    case .unsupportedImageFormat:
      return "Unsupported image format"
    }
  }
}
