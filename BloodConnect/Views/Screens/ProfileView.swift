
import SwiftUI
import MapKit

struct ProfileView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.1044, longitude: -122.6575),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        VStack(spacing: 10) {
            // Header
            TopBarView(
                title: "Profile",
                showBackButton: true,
                onBackTapped: {
   
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            .padding()
            // Profile Image and Info
            VStack(spacing: 8) {
                Image("Person") // Replace with your asset name or AsyncImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                Text("Lilian Jack")
                    .font(.title3).bold()
                Text("Last Donation: December, 2023")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            // Stats
            HStack(spacing: 16) {
                StatBox(title: "Donated", value: "05")
                StatBox(title: "Blood Type", value: "A-")
                StatBox(title: "Life Saved", value: "06")
            }

            // Map
            Map(coordinateRegion: $region)
                .frame(height: 400)
                .cornerRadius(12)
                .padding(.horizontal)

            Spacer()

            // Swipe to Request
            SwipeView(defaultText: "Swipe to Request Blood", swipedText: "Request Sent!")


        }
        .padding()
    }
}

struct StatBox: View {
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3)
                .bold()
        }
        .frame(width: 100, height: 60)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
