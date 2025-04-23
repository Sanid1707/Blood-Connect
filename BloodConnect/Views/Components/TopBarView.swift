import SwiftUI

struct TopBarView: View {
    let title: String
    let showBackButton: Bool
    var onBackTapped: (() -> Void)?
    var onSettingsTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            // Back button or spacer
            if showBackButton {
                Button(action: {
                    onBackTapped?()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
            
            // Title
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColor.primaryRed)
            
            Spacer()
            
            // Settings button
            Button(action: {
                onSettingsTapped?()
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TopBarView(
                title: "Blood Connect",
                showBackButton: false,
                onBackTapped: {},
                onSettingsTapped: {}
            )
            Spacer()
        }
    }
} 
