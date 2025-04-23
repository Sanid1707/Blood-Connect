//
//  ReviewRow.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct ReviewRow: View {
    var name: String
    var time: String
    var rating: String
    var message: String
    var avatar: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(avatar)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name).bold()
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(rating)
                            .font(.caption)
                    }
                }
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(message)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ReviewRow_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRow(
            name: "Lilian Jack",
            time: "1 hour ago",
            rating: "4.7",
            message: "Very happy donating today. They made me feel like I was saving the world!",
            avatar: "Person"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
