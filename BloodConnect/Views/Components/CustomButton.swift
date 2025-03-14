import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var backgroundColor: Color = AppColor.primaryRed
    var textColor: Color = .white
    var height: CGFloat = 56
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .shadow(color: backgroundColor.opacity(0.3), radius: 10, x: 0, y: 5)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(1.2)
                } else {
                    Text(title)
                        .font(Typography.buttonText)
                        .fontWeight(.semibold)
                        .foregroundColor(textColor)
                }
            }
            .frame(height: height)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "Sign In") {}
        CustomButton(title: "Loading", action: {}, isLoading: true) // Fixed: Provide empty closure and set isLoading to true
        CustomButton(title: "Secondary", action: {}, backgroundColor: .gray.opacity(0.1), textColor: .black) // Fixed: Provide empty closure
    }
    .padding()
}
