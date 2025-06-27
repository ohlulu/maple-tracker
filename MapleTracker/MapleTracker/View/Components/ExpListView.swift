import SwiftUI

struct ExpListView: View {
    let noDataMessage: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                NoDataView(message: noDataMessage)
                    .id("no-data")
            }
        }
        .frame(maxHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.surfaceVariant)
        )
        .clipped()
    }
}

struct ExpItemView: View {
    let timeStamp: String
    let expGain: String
    
    var body: some View {
        HStack {
            Text(timeStamp)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundColor(AppColors.secondary)
            
            Spacer()
            
            Text(expGain)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundColor(AppColors.accent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(AppColors.surface)
        )
    }
}

struct NoDataView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(AppColors.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity)
    }
}

#Preview("Exp List") {
    ExpListView(noDataMessage: "尚未開始服刑")
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.background)
}

#Preview("Exp Item") {
    ExpItemView(timeStamp: "第 1 分鐘", expGain: "+15,420 EXP")
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.background)
}
