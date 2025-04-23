


import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Header
            TopBarView(
                title: "Notification",
                showBackButton: true,
                onBackTapped: {
    
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Today Section
                    NotificationSection(title: "Today", notifications: [
                        NotificationItem(icon: "hand.thumbsup.fill", title: "Grateful for You!", subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting."),
                        NotificationItem(icon: "heart.circle.fill", title: "Feel Healthier", subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting."),
                        NotificationItem(icon: "camera.fill", title: "Health Tips For Donors", subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting.")
                    ],
                                        onTap: { item in
                                                                   print("Tapped Today: \(item.title)")
                                                               }
                    )

                    // Yesterday Section
                    NotificationSection(title: "Yesterday", notifications: [
                        NotificationItem(icon: "drop.fill", title: "B+ Blood Needed In Your Area", subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting."),
                        NotificationItem(icon: "person.2.fill", title: "You have got Donate request", subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting."),
                        NotificationItem(icon: "checkmark.seal.fill", title: "Account Setup Successful!", subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting.")
                    ],
                                        onTap: { item in
                                                                   print("Tapped Today: \(item.title)")
                                                               }
                    )
                }
                .padding()
            }

        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

