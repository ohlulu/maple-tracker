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
      })
    else {
      throw Error.canNotFindMapleStory
    }

    // Get all windows for the target app
    let appWindows = availableContent.windows.filter { $0.owningApplication == targetApp }

    // Print all windows for debugging
    print("Found \(appWindows.count) windows for MapleStory:")
    for (index, window) in appWindows.enumerated() {
      print("Window \(index): \(window.title ?? "No Title") - Frame: \(window.frame)")
    }

    // Find the main window (usually the largest one that's not a toolbar/menu)
    guard
      let targetWindow = appWindows
        //        .filter({ window in
        //          // Filter out small windows (likely toolbars/menus)
        //          let minWidth: CGFloat = 400
        //          let minHeight: CGFloat = 300
        //          return window.frame.width >= minWidth && window.frame.height >= minHeight
        //        })
        .max(by: { window1, window2 in
          // Get the largest window (by area)
          let area1 = window1.frame.width * window1.frame.height
          let area2 = window2.frame.width * window2.frame.height
          return area1 < area2
        })
    else {
      throw Error.canNotFindMapleStory
    }

    print("Selected window: \(targetWindow.title ?? "No Title") - Frame: \(targetWindow.frame)")

    let filter = SCContentFilter(desktopIndependentWindow: targetWindow)
    let configuration = SCStreamConfiguration()
    configuration.width = Int(targetWindow.frame.width)
    configuration.height = Int(targetWindow.frame.height)

    let image = try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: configuration)

    return NSImage(cgImage: image, size: targetWindow.frame.size)
  }
}
