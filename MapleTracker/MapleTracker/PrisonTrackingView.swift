import SwiftUI

struct PrisonTrackingView: View {
    @State private var isRecording = false
    
    var body: some View {
      VStack(spacing: 0) {
          HeaderView(isRecording: $isRecording)
              .id("header") // Stable identity for better diffing
          
          StatsContainerView()
              .id("stats") // Stable identity for better diffing
      }
      .background(AppColors.primaryBackground)
      .padding(.horizontal, 10)
      .frame(maxWidth: 600)
    }
}

private extension PrisonTrackingView {
    private var backgroundView: some View {
        ZStack {
            AppColors.primaryBackground
                .ignoresSafeArea()
            prisonBarsPattern
                .ignoresSafeArea()
        }
    }
    
    private var prisonBarsPattern: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.clear, location: 0),
                .init(color: Color.clear, location: 0.067),
                .init(color: Color.gray.opacity(0.12), location: 0.067),
                .init(color: Color.gray.opacity(0.12), location: 0.073),
                .init(color: Color.clear, location: 0.073),
                .init(color: Color.clear, location: 1)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var containerBackground: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(AppColors.containerBackground)
            .stroke(AppColors.primaryBorder, lineWidth: 1)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    PrisonTrackingView()
        .preferredColorScheme(.dark)
}
