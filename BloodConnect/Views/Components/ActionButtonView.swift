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
                    .frame(width: 55, height: 55)
                    .overlay(
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(AppColor.primaryRed)
                    )
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(AppColor.defaultText)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
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
                    
                    ActionButtonView(
                        icon: "cross.case.fill",
                        title: "Blood Bank"
                    ) {
                        print("Button tapped")
                    }
                }
            }
            .padding()
        }
    }
} 
