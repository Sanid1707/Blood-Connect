import SwiftUI

struct BloodCenterDetailView: View {
    var body: some View {
        VStack(spacing: 16) {
            BloodCenterImageView(imageName: "BloodCenter")

            BloodCenterInfoView(
                name: "Cork Blood Center",
                location: "Cork",
                rating: "3.5",
                centerDescription: "A blood donation facility centered at the heart of Cork"
            )

            ReviewSectionView()

            Spacer()

            SwipeView(defaultText: "Swipe to Get Direction" , swipedText: "Getting Directions...")

        }
        .padding(.top)
    }
}


#Preview {
    BloodCenterDetailView()
}

