import SwiftUI

struct PrisonTrackingView: View {
    @State private var isRecording = false
    
    var body: some View {
      VStack(spacing: 24) {
          // Header Section
          HeaderView(isRecording: $isRecording)
              .id("header")
          
          // Stats Section
          StatsContainerView()
              .id("stats")
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .frame(maxWidth: 680)
    }
}


#Preview {
    PrisonTrackingView()
        .preferredColorScheme(.dark)
}
