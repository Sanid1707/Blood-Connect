import SwiftUI
import MapKit

struct NearbyMapView: View {
    @StateObject private var locationVM = LocationViewModel()
    @State private var places: [Place] = []
    @State private var users: [User] = []

    var body: some View {
        ZStack {
            if locationVM.showMap {
                Map(coordinateRegion: $locationVM.region, showsUserLocation: true, annotationItems: places) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        Image(systemName: place.type == .donor ? "drop.fill" : "cross.fill")
                            .foregroundColor(place.type == .donor ? .red : .blue)
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }
                .edgesIgnoringSafeArea(.all)
            } else {
                Text("Loading location...")
                    .onAppear {
                        locationVM.requestPermission()
                    }
            }
            
            if locationVM.permissionDenied {
                VStack {
                    Text("Location permission denied. Enable it in settings.")
                        .padding()
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .foregroundColor(.red)
                }
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding()
            }
        }
                .onAppear {
                    locationVM.requestPermission()
                           loadNearbyData()
                       }
        }
    
    private func loadNearbyData() {
        Task {
            do {
                let fetchedUsers = try await FirebaseDataService.shared.fetchAllUsers()

                self.places = fetchedUsers.compactMap { user in
                    guard let lat = user.latitude, let lon = user.longitude else { return nil }
                    return Place(
                        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                        type: user.userType.lowercased() == "center" ? .center : .donor
                    )
                }
            } catch {
                print("Error fetching users: \(error)")
            }
        }
    }

}

// MARK: - Dummy Data
struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let type: PlaceType
    
    enum PlaceType {
        case donor, center
    }
}

let dummyAnnotations: [Place] = [
    Place(coordinate: CLLocationCoordinate2D(latitude: 53.35, longitude: -6.26), type: .donor), //Dublin City Centre
    Place(coordinate: CLLocationCoordinate2D(latitude: 53.36, longitude: -6.28), type: .center), //st.James Hospital
    Place(coordinate: CLLocationCoordinate2D(latitude: 53.345, longitude: -6.27), type: .donor) // Trinity College Area
]
