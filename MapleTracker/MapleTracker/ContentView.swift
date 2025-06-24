//
//  Copyright © 2025 Ohlulu. All rights reserved.
//

import AppKit
import ScreenCaptureKit
import SwiftUI

struct ContentView: View {
  @State private var capturedImage: NSImage?

  var body: some View {
    VStack {
      if let image = capturedImage {
        Image(nsImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: 300)
      }

      Button("截圖指定應用程式") {
        captureWindowOfApp(appName: "Claude")
      }
      .padding()
    }
    .padding()
  }

  private func captureWindowOfApp(appName: String) {
    Task {
      do {
        let availableContent = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)

        guard
          let targetApp = availableContent.applications.first(where: { $0.bundleIdentifier == "com.anthropic.claudefordesktop" }),
          let targetWindow = availableContent.windows.first(where: { $0.owningApplication == targetApp })
        else {
          return
        }

        let filter = SCContentFilter(desktopIndependentWindow: targetWindow)
        let configuration = SCStreamConfiguration()
        configuration.width = Int(targetWindow.frame.width)
        configuration.height = Int(targetWindow.frame.height)

        let image = try await SCScreenshotManager.captureImage(
          contentFilter: filter, configuration: configuration)

        await MainActor.run {
          self.capturedImage = NSImage(cgImage: image, size: targetWindow.frame.size)
        }
      } catch {
        print("Screenshot failed: \(error)")
      }
    }
  }
}

#Preview {
  ContentView()
}
