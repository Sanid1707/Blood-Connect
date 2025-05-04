import SwiftUI
import MapKit

struct DashboardView: View {
    @State private var searchText = ""
    @State private var isLoaded = false
    @State private var showFindDonorsView = false
    @State private var showDonateView = false
    @State private var showMapScreen = false
    @State private var showBloodRequestView = false
    @State private var showBloodRequestsListView = false
    @State private var users: [User] = []
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603), // Default to Dublin
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )
    @State private var isLoading = true
    @State private var mapAnnotations: [MapLocation] = []
    @State private var debugInfo: String = "Loading..."
    @State private var bloodRequests: [BloodRequest] = []
    @State private var isLoadingBloodRequests = true
    
    private let userService = UserService()
    private let bloodRequestService = BloodRequestService()

    let actions = [
        ("drop.fill", "Find Donors", AppColor.primaryRed),
        ("heart.fill", "Donate", AppColor.primaryRed),
        ("cross.case.fill", "Blood Bank", AppColor.primaryRed),
        ("hand.raised.fill", "Support", AppColor.primaryRed),
        ("exclamationmark.triangle.fill", "Blood Req.", AppColor.primaryRed),
        ("ellipsis", "More", AppColor.primaryRed)
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TopBarView(
                    title: "Blood Connect",
                    showBackButton: false,
                    onSettingsTapped: {}
                )

                ScrollView {
                    VStack(spacing: 20) {
                        SearchBarView(searchText: $searchText)
                            .padding(.top, 15)

                        VStack {
                            if isLoading {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .overlay(
                                        ProgressView("Loading map data...")
                                            .progressViewStyle(CircularProgressViewStyle())
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(AppColor.dividerGray, lineWidth: 1)
                                    )
                                    .frame(height: 180)
                                    .padding(.horizontal)
                            } else if mapAnnotations.isEmpty {
                                // Show information if no annotations exist
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .overlay(
                                        VStack(spacing: 12) {
                                            Text("No location data available")
                                                .foregroundColor(.gray)
                                            
                                            Button("Generate Sample Locations") {
                                                createSampleLocations()
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .background(AppColor.primaryRed)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        }
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(AppColor.dividerGray, lineWidth: 1)
                                    )
                                    .frame(height: 180)
                                    .padding(.horizontal)
                            } else {
                                // Actual map view with annotations
                                ZStack(alignment: .bottomTrailing) {
                                    Map(coordinateRegion: $mapRegion, annotationItems: mapAnnotations) { location in
                                        MapAnnotation(coordinate: location.coordinate) {
                                            VStack(spacing: 0) {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.white)
                                                        .frame(width: 32, height: 32)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                                    
                                                    Image(systemName: location.type == .donor ? "drop.fill" : "cross.fill")
                                                        .font(.system(size: 16, weight: .semibold))
                                                        .foregroundColor(location.type == .donor ? AppColor.primaryRed : Color.blue)
                                                }
                                                
                                                // Display name labels
                                                Text(location.name)
                                                    .font(.system(size: 10, weight: .medium))
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 3)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(location.type == .donor ? AppColor.primaryRed : Color.blue)
                                                    )
                                                    .foregroundColor(.white)
                                                    .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
                                                    .offset(y: 2)
                                            }
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(AppColor.dividerGray, lineWidth: 1)
                                    )
                                    
                                    // Add zoom control buttons directly on the map
                                    VStack(spacing: 10) {
                                        Button(action: {
                                            zoomIn()
                                        }) {
                                            Image(systemName: "plus")
                                                .padding(8)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .shadow(radius: 2)
                                        }
                                        
                                        Button(action: {
                                            zoomOut()
                                        }) {
                                            Image(systemName: "minus")
                                                .padding(8)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .shadow(radius: 2)
                                        }
                                    }
                                    .padding(10)
                                }
                                .frame(height: 180)
                                .padding(.horizontal)
                            }

                            // Debug info text - only visible in development
                            #if DEBUG
                            VStack(alignment: .leading, spacing: 5) {
                                Text(debugInfo)
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Button("Reset Data") {
                                        resetMapData()
                                    }
                                    .font(.system(size: 10))
                                    .foregroundColor(.red)
                                    
                                    Button("Reload") {
                                        loadMapData()
                                    }
                                    .font(.system(size: 10))
                                    .foregroundColor(.blue)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            #endif

                            HStack {
                                Spacer()
                                Button(action: {
                                    showMapScreen = true
                                }) {
                                    Image(systemName: "paperplane.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(AppColor.primaryRed)
                                        .clipShape(Circle())
                                }
                                .padding(.trailing, 25)
                                .padding(.bottom, 10)
                            }
                        }
                        .fullScreenCover(isPresented: $showMapScreen) {
                            NearbyMapView()
                        }

                        // Quick Actions Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Quick Actions")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppColor.defaultText)
                                .padding(.horizontal)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                                ForEach(0..<actions.count, id: \.self) { index in
                                    QuickActionButton(
                                        iconName: actions[index].0,
                                        title: actions[index].1,
                                        color: actions[index].2,
                                        action: {
                                            handleQuickAction(index)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Blood Seeker Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Blood Requests")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColor.defaultText)

                                Spacer()

                                Button("See All") {
                                    showBloodRequestsListView = true
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColor.primaryRed)
                            }
                            .padding(.horizontal)

                            if isLoadingBloodRequests {
                                // Loading indicator
                                HStack {
                                    Spacer()
                                    ProgressView("Loading blood requests...")
                                        .padding()
                                    Spacer()
                                }
                            } else if bloodRequests.isEmpty {
                                // No requests message
                                HStack {
                                    Spacer()
                                    Text("No blood requests available")
                                        .foregroundColor(.gray)
                                        .padding()
                                    Spacer()
                                }
                            } else {
                                // Show up to 3 most recent blood requests
                                ForEach(Array(bloodRequests.prefix(3)), id: \.id) { request in
                                    BloodSeekerCardView(
                                        name: request.patientName,
                                        seekerDescription: "Requires \(request.unitsRequired) units of \(request.bloodGroup) blood type. \(request.isUrgent ? "URGENT" : "")",
                                        timeAgo: getTimeAgoString(date: request.createdAt),
                                        location: "Coordinates: \(String(format: "%.2f", request.latitude)), \(String(format: "%.2f", request.longitude))",
                                        bloodType: request.bloodGroup,
                                        imageURL: "",
                                        onDonate: {
                                            // Handle donation action
                                            print("Donate tapped for \(request.patientName)")
                                        }
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
            .background(Color.white)
            .onAppear {
                loadMapData()
                loadBloodRequests()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isLoaded = true
                    }
                }
            }

            NavigationLink(destination: FindDonorsView(), isActive: $showFindDonorsView) { EmptyView() }
            NavigationLink(destination: DonateView(), isActive: $showDonateView) { EmptyView() }
            NavigationLink(destination: PostBloodRequestView(), isActive: $showBloodRequestView) { EmptyView() }
            NavigationLink(destination: BloodRequestsListView(), isActive: $showBloodRequestsListView) { EmptyView() }
        }
    }

    // MARK: - Actions
    
    private func handleQuickAction(_ index: Int) {
        switch index {
        case 0: // Find Donors
            showFindDonorsView = true
        case 1: // Donate
            showDonateView = true
        case 2: // Blood Bank
            print("Blood Bank tapped")
        case 3: // Support
            print("Support tapped")
        case 4: // Blood Request
            showBloodRequestView = true
        case 5: // More
            showBloodRequestsListView = true
        default:
            break
        }
    }
    
    // MARK: - Data Loading
    
    private func loadBloodRequests() {
        isLoadingBloodRequests = true
        
        // Load blood requests from service
        DispatchQueue.main.async {
            self.bloodRequests = self.bloodRequestService.getAllBloodRequests()
            self.isLoadingBloodRequests = false
        }
    }
    
    private func getTimeAgoString(date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days) \(days == 1 ? "day" : "days") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) \(hours == 1 ? "hour" : "hours") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "min" : "mins") ago"
        } else {
            return "Just now"
        }
    }
    
    // MARK: - Map Methods
    
    private func loadMapData() {
        isLoading = true
        var newAnnotations: [MapLocation] = []
        
        // Get all users with location data from UserService
        Task {
            let allUsers = userService.getAllUsers()
            
            for user in allUsers {
                if let latitude = user.latitude, let longitude = user.longitude {
                    let locationType: MapLocation.LocationType = user.userType == "donor" ? .donor : .organization
                    let location = MapLocation(
                        id: user.id ?? UUID().uuidString,
                        name: user.name,
                        coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        type: locationType
                    )
                    newAnnotations.append(location)
                }
            }
            
            // Process the results on the main thread
            DispatchQueue.main.async {
                self.mapAnnotations = newAnnotations
                self.isLoading = false
                
                if !newAnnotations.isEmpty {
                    // Center the map on the first annotation
                    self.mapRegion = MKCoordinateRegion(
                        center: newAnnotations[0].coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                    )
                }
                
                self.updateDebugInfo()
            }
        }
    }
    
    private func createSampleLocations() {
        mapAnnotations = [
            MapLocation(
                id: "1",
                name: "John Donor",
                coordinate: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603),
                type: .donor
            ),
            MapLocation(
                id: "2",
                name: "Dublin Blood Center",
                coordinate: CLLocationCoordinate2D(latitude: 53.3445, longitude: -6.2674),
                type: .organization
            ),
            MapLocation(
                id: "3",
                name: "Sarah Donor",
                coordinate: CLLocationCoordinate2D(latitude: 53.3396, longitude: -6.2592),
                type: .donor
            )
        ]
        
        updateDebugInfo()
    }
    
    private func resetMapData() {
        mapAnnotations = []
        updateDebugInfo()
    }
    
    private func updateDebugInfo() {
        debugInfo = "Map has \(mapAnnotations.count) annotations (\(mapAnnotations.filter { $0.type == .donor }.count) donors, \(mapAnnotations.filter { $0.type == .organization }.count) organizations)"
    }
    
    private func zoomIn() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: max(mapRegion.span.latitudeDelta * 0.5, 0.001),
            longitudeDelta: max(mapRegion.span.longitudeDelta * 0.5, 0.001)
        )
        mapRegion.span = newSpan
    }
    
    private func zoomOut() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: min(mapRegion.span.latitudeDelta * 2, 50),
            longitudeDelta: min(mapRegion.span.longitudeDelta * 2, 50)
        )
        mapRegion.span = newSpan
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

// Quick Action Button Component
struct QuickActionButton: View {
    let iconName: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColor.defaultText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
