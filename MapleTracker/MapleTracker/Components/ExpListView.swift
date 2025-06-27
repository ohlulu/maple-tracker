import SwiftUI

struct ExpListView: View {
    let noDataMessage: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 2) {
                NoDataView(message: noDataMessage)
                    .id("no-data") // Stable identity
            }
        }
        .frame(maxHeight: 180)
        .background(listBackground)
        .clipped() // Performance optimization
    }
    
    // Extract background for better performance
    private var listBackground: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(AppColors.listBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
    }
}

struct ExpItemView: View {
    let timeStamp: String
    let expGain: String
    
    var body: some View {
        HStack {
            Text(timeStamp)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(AppColors.subtleText)
            
            Spacer()
            
            Text(expGain)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(AppColors.expText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(AppColors.itemBackground)
        .overlay(
            Rectangle()
                .stroke(AppColors.itemBorder, lineWidth: 1)
        )
    }
}

struct NoDataView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 12, design: .monospaced))
            .foregroundColor(AppColors.disabledText)
            .italic()
            .multilineTextAlignment(.center)
            .padding(.horizontal, 10)
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity)
    }
}

#Preview("Exp List") {
    ExpListView(noDataMessage: "尚未開始服刑")
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.containerBackground)
}

#Preview("Exp Item") {
    ExpItemView(timeStamp: "第 1 分鐘", expGain: "+15,420 EXP")
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.containerBackground)
}
