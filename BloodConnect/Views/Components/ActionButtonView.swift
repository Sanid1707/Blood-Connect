import SwiftUI

struct ActionButtonView: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(AppColor.cardLightGray)
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .overlay(
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(AppColor.primaryRed)
                    )
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColor.defaultText)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 8)
            .frame(width: 90)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
            )
        }
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                ActionButtonView(
                    icon: "drop.fill",
                    title: "Find Donors"
                ) {
                    print("Button tapped")
                }
                
                ActionButtonView(
                    icon: "heart.fill",
                    title: "Donate"
                ) {
                    print("Button tapped")
                }
            }
            .padding()
        }
    }
} 
