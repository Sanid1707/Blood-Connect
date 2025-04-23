//
//  ReviewSectionView.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct ReviewSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Review (256)")
                .font(.headline)

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 40)
                .overlay(Text("Write A Review").foregroundColor(.gray))

            ReviewRow(
                name: "Lilian Jack",
                time: "1 hour ago",
                rating: "4.7",
                message: "I was very happy donating today. They made me feel like I was saving the world. Also appreciated the complimentary snacks.",
                avatar: "Person"
            )
        }
        .padding(.horizontal)
    }
}

struct ReviewSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSectionView()
            .previewLayout(.sizeThatFits)
    }
}

