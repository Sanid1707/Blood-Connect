import SwiftUI

struct NotificationItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let message: String
    let timeAgo: String
    let isRead: Bool
}

struct NotificationsView: View {
    @State private var notifications = [
        NotificationItem(
            icon: "drop.fill",
            title: "New Blood Request",
            message: "John Doe is looking for B+ blood type in your area",
            timeAgo: "2m ago",
            isRead: false
        ),
        NotificationItem(
            icon: "checkmark.circle.fill",
            title: "Donation Successful",
            message: "Thank you for your donation at City Hospital",
            timeAgo: "1h ago",
            isRead: true
        ),
        NotificationItem(
            icon: "bell.fill",
            title: "Reminder",
            message: "You can donate blood again in 2 days",
            timeAgo: "3h ago",
            isRead: true
        )
    ]
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Notifications")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bell.badge.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding()
            }
            
            // Notifications list
            List {
                ForEach(notifications) { notification in
                    HStack(spacing: 12) {
                        Image(systemName: notification.icon)
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(notification.title)
                                .font(.system(size: 16, weight: .medium))
                            Text(notification.message)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                            Text(notification.timeAgo)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if !notification.isRead {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(Color.white)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
} 