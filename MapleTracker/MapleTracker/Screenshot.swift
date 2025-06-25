//
//  Copyright © 2025 Ohlulu. All rights reserved.
//

import Foundation
import ScreenCaptureKit

final class Screenshot {
  enum Error: Swift.Error {
    case canNotFindMapleStory
  }

  private var isRunning = false
  private var continuation: AsyncThrowingStream<NSImage, Swift.Error>.Continuation?

  func start() -> AsyncThrowingStream<NSImage, Swift.Error> {
    return AsyncThrowingStream<NSImage, Swift.Error> { continuation in
      self.continuation = continuation
      self.isRunning = true

      Task {
        while self.isRunning {
          do {
            let image = try await self.captureWindowOfApp()
            continuation.yield(image)

            // Wait for 60 seconds before next capture
//            try await Task.sleep(nanoseconds: 60_000_000_000)  // 60 seconds
            try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 seconds
          } catch {
            continuation.finish(throwing: error)
            break
          }
        }
        continuation.finish()
      }
    }
  }

  func stop() {
    isRunning = false
    continuation?.finish()
    continuation = nil
  }

  func captureWindowOfApp() async throws -> NSImage {
    let availableContent = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: false)

    guard
      let targetApp = availableContent.applications.first(where: {
        $0.bundleIdentifier == "com.nexon.mod.inhouse"
      }),
      let targetWindow = availableContent.windows.first(where: {
        $0.owningApplication == targetApp
      })
    else {
      throw Error.canNotFindMapleStory
    }
    
    print(targetWindow.frame)

    let filter = SCContentFilter(desktopIndependentWindow: targetWindow)
    let configuration = SCStreamConfiguration()
    configuration.width = Int(targetWindow.frame.width)
    configuration.height = Int(targetWindow.frame.height)

    let image = try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: configuration)

    return NSImage(cgImage: image, size: targetWindow.frame.size)
  }
}
