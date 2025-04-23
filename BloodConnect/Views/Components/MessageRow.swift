import SwiftUI

struct Message {
    let name: String
    let time: String
    var unread: Bool = false
}

struct MessageRow: View {
    var message: Message
    var action: () -> Void = {} // Default empty action

    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(AppColor.dividerGray)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(message.name.prefix(1)))
                            .font(.headline)
                            .foregroundColor(AppColor.defaultText)
                    )

                VStack(alignment: .leading) {
                    Text(message.name)
                        .bold()
                        .foregroundColor(AppColor.defaultText)
                    Text("Lorem ipsum is simply...")
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                }

                Spacer()

                VStack {
                    if message.unread {
                        Circle()
                            .fill(AppColor.primaryRed)
                            .frame(width: 12, height: 12)
                    }
                    Text(message.time)
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle()) // makes the full row tappable
        }
        .buttonStyle(PlainButtonStyle()) // removes button styling like blue highlight
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MessageRow(
            message: Message(name: "Liam Elijah", time: "9:31", unread: true)
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
