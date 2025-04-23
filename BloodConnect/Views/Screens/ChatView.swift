import SwiftUI

struct ChatView: View {

    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            TopBarView(
                title: "Benjamin Jack",
                showBackButton: true,
                onBackTapped: {
    
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Messages
                    MessageBubble(text: "Lorem Ipsum is simply dum printing and", time: "9:31", isSender: true, isVoice: false)
                    MessageBubble(text: "Lorem Ipsum is simply dum printing and", time: "9:31", isSender: false, isVoice: false)
                    MessageBubble(text: "Lorem Ipsum is simply dum printing and", time: "9:31", isSender: true, isVoice: false)
                    MessageBubble(text: "", time: "9:31", isSender: true, isVoice: true)
                    MessageBubble(text: "", time: "9:31", isSender: false, isVoice: true)
                    MessageBubble(text: "", time: "9:31", isSender: true, isVoice: true)
                }
                .padding()
            }

            // Input bar
            HStack(spacing: 12) {
                TextField("Type A Message", text: .constant(""))
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(25)

                Button(action: {}) {
                    Image(systemName: "mic")
                        .foregroundColor(AppColor.primaryRed)
                }

                Button(action: {}) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(AppColor.primaryRed)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

struct MessageBubble: View {
    var text: String
    var time: String
    var isSender: Bool
    var isVoice: Bool

 

    var body: some View {
        HStack {
            if !isSender { Spacer() }

            VStack(alignment: .leading, spacing: 4) {
                if isVoice {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.white)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 80, height: 20)
                        Spacer()
                    }
                } else {
                    Text(text)
                        .foregroundColor(isSender ? .white : .black)
                }

                HStack(spacing: 4) {
                    Text(time)
                        .font(.caption2)
                        .foregroundColor(isSender ? .white.opacity(0.8) : .gray)
                    if isSender {
                        Image(systemName: "checkmark")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(isSender ? AppColor.primaryRed : Color(UIColor.systemGray5))
            .cornerRadius(20)
            .frame(maxWidth: 250, alignment: isSender ? .trailing : .leading)

            if isSender { Spacer() }
        }
    }
}

#Preview {
    ChatView()
}
