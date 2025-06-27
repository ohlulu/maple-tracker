import SwiftUI

struct StatsContainerView: View {
    var body: some View {
        HStack(spacing: 2) {
            StatCardView(
                title: "每分鐘勞動成果", 
                noDataMessage: "尚未開始服刑"
            )
            
            StatCardView(
                title: "每十分鐘勞動成果", 
                noDataMessage: "需服刑滿10分鐘"
            )
        }
        .background(AppColors.primaryBorder)
        .padding(2)
    }
}

struct StatCardView: View {
    let title: String
    let noDataMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(AppColors.tertiaryText)
                .textCase(.uppercase)
            
            ExpListView(noDataMessage: noDataMessage)
        }
        .padding(15)
        .background(AppColors.cardBackground)
        .overlay(
            Rectangle()
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    StatsContainerView()
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.containerBackground)
}