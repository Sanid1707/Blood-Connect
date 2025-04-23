import SwiftUI

struct NotificationItem {
    let icon: String
    let title: String
    let subtitle: String
}

struct NotificationCard: View {
    var item: NotificationItem
    let action : () -> Void
    
    var body: some View {
        Button(action: action){
            HStack {
                Circle()
                    .fill(AppColor.primaryRed)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: item.icon)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(AppColor.defaultText)
                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .foregroundColor(AppColor.secondaryText)
            }
            .padding()
            .background(AppColor.cardLightGray)
            .cornerRadius(10)
        }
    }
    
}
struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCard(
            item: NotificationItem(
                icon: "heart.circle.fill",
                title: "Feel Healthier",
                subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting."
            ),
            action: {
            
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}


