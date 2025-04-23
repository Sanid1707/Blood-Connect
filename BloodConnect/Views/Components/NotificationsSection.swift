//
//  NotificationsSection.swift
//  BloodConnect
//
//  Created by Student on 23/04/2025.
//

import SwiftUI

struct NotificationSection: View {
    var title: String
    var notifications: [NotificationItem]
    var onTap: (NotificationItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .bold()
                .font(.subheadline)
                .foregroundColor(AppColor.defaultText)

            ForEach(notifications, id: \.title) { item in
                NotificationCard(item: item) {
                                  onTap(item)
                              }
            }
        }
    }
}

struct NotificationSection_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSection(
            title: "Today",
            notifications: [
                NotificationItem(icon: "heart.circle.fill", title: "Feel Healthier", subtitle: "Tips for donors."),
                NotificationItem(icon: "camera.fill", title: "Health Tips", subtitle: "Stay hydrated!")
            ],
            onTap: { item in
                print("Tapped: \(item.title)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

