import SwiftUI

struct StatsContainerView: View {
    var body: some View {
        HStack(spacing: 16) {
            StatCardView(
                title: "每分鐘勞動成果", 
                noDataMessage: "尚未開始服刑"
            )
            
            StatCardView(
                title: "每十分鐘勞動成果", 
                noDataMessage: "需服刑滿10分鐘"
            )
        }
    }
}

struct StatCardView: View {
    let title: String
    let noDataMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundColor(AppColors.onSurfaceVariant)
            
            ExpListView(noDataMessage: noDataMessage)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.surface)
        )
    }
}

#Preview {
    StatsContainerView()
        .preferredColorScheme(.dark)
        .padding()
        .background(AppColors.background)
}
