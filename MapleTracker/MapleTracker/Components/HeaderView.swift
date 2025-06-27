import SwiftUI

struct HeaderView: View {
  @Binding var isRecording: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        VStack(alignment: .leading, spacing: 5) {
          Text("練功服刑記錄系統")
            .font(.system(size: 18, weight: .bold, design: .monospaced))
            .foregroundColor(AppColors.secondaryText)
            .textCase(.uppercase)

          Text("建檔日期：2025-01-15 | 系統版本：v1.0.0")
            .font(.system(size: 12, design: .monospaced))
            .foregroundColor(AppColors.subtleText)
        }

        Spacer()

        VStack(alignment: .trailing, spacing: 5) {
          // Status button
          Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
              isRecording.toggle()
            }
          }) {
            Text(isRecording ? "暫停放風" : "繼續服刑")
              .font(.system(size: 14, weight: .bold, design: .monospaced))
              .foregroundColor(AppColors.buttonText)
              .textCase(.uppercase)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .background(AppColors.buttonBackground)
              .cornerRadius(3)
              .overlay(
                RoundedRectangle(cornerRadius: 3)
                  .stroke(AppColors.secondaryBorder, lineWidth: 1)
              )
          }
          .buttonStyle(PlainButtonStyle())
          .scaleEffect(isRecording ? 0.95 : 1.0)
          .animation(.easeInOut(duration: 0.1), value: isRecording)

          // Recording indicator
          if isRecording {
            RecordingIndicatorView()
              .transition(.opacity)
          }
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 15)
    .overlay(
      Rectangle()
        .fill(AppColors.secondaryBorder)
        .frame(height: 1),
      alignment: .bottom
    )
  }
}

struct RecordingIndicatorView: View {
  @State private var isPulsing = false

  var body: some View {
    HStack(spacing: 8) {
      Circle()
        .fill(AppColors.pulseColor)
        .frame(width: 8, height: 8)
        .scaleEffect(isPulsing ? 0.8 : 1.0)
        .opacity(isPulsing ? 0.3 : 1.0)
        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)
        .onAppear {
          isPulsing = true
        }

      Text("監控中")
        .font(.system(size: 11, design: .monospaced))
        .foregroundColor(AppColors.indicatorText)
        .textCase(.uppercase)
    }
  }
}

#Preview {
  HeaderView(isRecording: .constant(false))
    .preferredColorScheme(.dark)
}

#Preview("Recording") {
  HeaderView(isRecording: .constant(true))
    .preferredColorScheme(.dark)
}
