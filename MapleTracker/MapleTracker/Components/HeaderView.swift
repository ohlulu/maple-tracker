import SwiftUI

struct HeaderView: View {
    @Binding var isRecording: Bool

    var body: some View {
        HStack(spacing: 20) {
            // Title Section
          VStack(alignment: .leading, spacing: 8) {
                Text("練功服刑記錄系統")
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .foregroundColor(AppColors.onBackground)
                
                Text("建檔日期：2025-01-15 | 系統版本：v1.0.0")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundColor(AppColors.secondary)
            }
            
            // Control Section
            HStack {
                Spacer()
                
                HStack(spacing: 12) {
                    // Status button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isRecording.toggle()
                        }
                    }) {
                        Text(isRecording ? "暫停放風" : "開始服刑")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isRecording ? AppColors.accent : AppColors.accentRed)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(isRecording ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isRecording)

                    // Recording indicator
                    if isRecording {
                        RecordingIndicatorView()
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surface)
        )
    }
}

struct RecordingIndicatorView: View {
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(AppColors.accent)
                .frame(width: 10, height: 10)
                .scaleEffect(isPulsing ? 0.7 : 1.0)
                .opacity(isPulsing ? 0.4 : 1.0)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
                .onAppear {
                    isPulsing = true
                }

            Text("監控中")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppColors.secondary)
        }
    }
}

#Preview {
    HeaderView(isRecording: .constant(false))
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.background)
}

#Preview("Recording") {
    HeaderView(isRecording: .constant(true))
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.background)
}
