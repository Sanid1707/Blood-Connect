//import SwiftUI
//
//struct ProfileView: View {
//    var body: some View {
//        VStack {
//            // Header
//            HStack {
//                Text("Profile")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding()
//                
//                Spacer()
//                
//                Button(action: {}) {
//                    Image(systemName: "gearshape.fill")
//                        .font(.title)
//                        .foregroundColor(.gray)
//                }
//                .padding()
//            }
//            
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Profile Header
//                    VStack(spacing: 15) {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100, height: 100)
//                            .foregroundColor(.gray)
//                        
//                        Text("John Doe")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                        
//                        Text("Blood Type: A+")
//                            .font(.subheadline)
//                            .foregroundColor(.red)
//                    }
//                    .padding(.vertical)
//                    
//                    // Stats
//                    HStack(spacing: 30) {
//                        VStack {
//                            Text("12")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            Text("Donations")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        VStack {
//                            Text("3")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            Text("Requests")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        VStack {
//                            Text("150")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            Text("Points")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(15)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5)
//                    
//                    // Menu Items
//                    VStack(spacing: 0) {
//                        ForEach([
//                            ("person.fill", "Personal Information"),
//                            ("bell.fill", "Notifications"),
//                            ("gear.fill", "Settings"),
//                            ("questionmark.circle.fill", "Help & Support"),
//                            ("arrow.right.square.fill", "Logout")
//                        ], id: \.0) { icon, title in
//                            Button(action: {}) {
//                                HStack {
//                                    Image(systemName: icon)
//                                        .foregroundColor(.red)
//                                        .frame(width: 30)
//                                    
//                                    Text(title)
//                                        .foregroundColor(.primary)
//                                    
//                                    Spacer()
//                                    
//                                    Image(systemName: "chevron.right")
//                                        .foregroundColor(.gray)
//                                }
//                                .padding()
//                            }
//                            Divider()
//                        }
//                    }
//                    .background(Color.white)
//                    .cornerRadius(15)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5)
//                }
//                .padding()
//            }
//        }
//        .background(Color.gray.opacity(0.05))
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//} 

import SwiftUI
import MapKit

struct ProfileView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.1044, longitude: -122.6575),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                Spacer()
                Text("Profile")
                    .font(.headline)
                Spacer()
                Spacer().frame(width: 24) // To balance the chevron
            }
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
            SwipeToRequestView()

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

struct SwipeToRequestView: View {
    @GestureState private var dragOffset = CGSize.zero
    @State private var isSwiped = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.red.opacity(0.1))
                .frame(height: 50)

            Text(isSwiped ? "Blood Requested!" : "Swipe Box Right to Request Blood")
                .foregroundColor(.red)
                .bold()
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if value.translation.width > 100 {
                        withAnimation {
                            isSwiped = true
                        }
                        // You can trigger your request action here
                    }
                }
        )
        .padding(.bottom)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
