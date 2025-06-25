//
//  Copyright © 2025 Ohlulu. All rights reserved.
//

import AppKit
import ScreenCaptureKit
import SwiftUI

struct ContentView: View {
  private let screenshot = Screenshot()
  @State private var capturedImage: NSImage?

  var body: some View {
    VStack {
      if let image = capturedImage {
        Image(nsImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }

      Button("截圖指定應用程式") {
        Task {
          for try await image in screenshot.start() {
            capturedImage = image
          }
        }
      }
      .padding()

      Button("停止截圖") {
        screenshot.stop()
      }
      .padding()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
