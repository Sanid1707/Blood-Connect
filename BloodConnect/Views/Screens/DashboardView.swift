import SwiftUI
import MapKit

struct DashboardView: View {
    @State private var searchText = ""
    @State private var isLoaded = false
    @State private var showFindDonorsView = false
    @State private var showDonateView = false
    @State private var showMapScreen = false
    @State private var showBloodRequestView = false
    @State private var users: [User] = []
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603), // Default to Dublin
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )
    @State private var isLoading = true
    @State private var mapAnnotations: [MapLocation] = []
    @State private var debugInfo: String = "Loading..."
    
    private let userService = UserService()

    let actions = [
        ("drop.fill", "Find Donors", AppColor.primaryRed),
        ("heart.fill", "Donate", AppColor.primaryRed),
        ("cross.case.fill", "Blood Bank", AppColor.primaryRed),
        ("hand.raised.fill", "Support", AppColor.primaryRed),
        ("exclamationmark.triangle.fill", "Blood Req.", AppColor.primaryRed),
        ("ellipsis", "More", AppColor.primaryRed)
    ]

    let bloodSeekers = [
        (name: "James Peterson", desc: "I am anaemic and urgently need blood today.please reach out.Transportation and Feeding can be provided.", time: "5 Min Ago", location: "London, England", bloodType: "B+", imageURL: "https://randomuser.me/api/portraits/men/23.jpg"),
        (name: "Sarah Johnson", desc: "Urgently need blood donation for surgery scheduled tomorrow morning.", time: "30 Min Ago", location: "Manchester, UK", bloodType: "O-", imageURL: "https://randomuser.me/api/portraits/women/45.jpg"),
        (name: "Robert Williams", desc: "Need blood for emergency transfusion at City Hospital.", time: "1 Hour Ago", location: "Birmingham, UK", bloodType: "A+", imageURL: "https://randomuser.me/api/portraits/men/76.jpg")
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

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                            ForEach(Array(zip(actions.indices, actions)), id: \ .0) { index, actionItem in
                                let (icon, title, color) = actionItem

                                ActionButtonView(icon: icon, title: title) {
                                    handleActionButtonTap(index: index)
                                }
                                .opacity(isLoaded ? 1.0 : 0)
                                .animation(
                                    Animation.easeIn(duration: 0.3).delay(0.2),
                                    value: isLoaded
                                )
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Blood Seeker")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColor.defaultText)

                                Spacer()

                                Button("See All") {}
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppColor.primaryRed)
                            }
                            .padding(.horizontal)

                            ForEach(bloodSeekers, id: \ .name) { seeker in
                                BloodSeekerCardView(
                                    name: seeker.name,
                                    seekerDescription: seeker.desc,
                                    timeAgo: seeker.time,
                                    location: seeker.location,
                                    bloodType: seeker.bloodType,
                                    imageURL: seeker.imageURL,
                                    onDonate: {
                                        print("Donate tapped for \(seeker.name)")
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
            .background(Color.white)
            .onAppear {
                loadMapData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isLoaded = true
                    }
                }
            }

            NavigationLink(destination: FindDonorsView(), isActive: $showFindDonorsView) { EmptyView() }
            NavigationLink(destination: DonateView(), isActive: $showDonateView) { EmptyView() }
            NavigationLink(destination: PostBloodRequestView(), isActive: $showBloodRequestView) { EmptyView() }
        }
    }

    private func handleActionButtonTap(index: Int) {
        switch index {
        case 0:
            showFindDonorsView = true
        case 1:
            showDonateView = true
        case 2:
            print("Blood Bank tapped")
        case 3:
            print("Support tapped")
        case 4:
            showBloodRequestView = true
        case 5:
            print("More tapped")
        default:
            break
        }
    }
    
    private func loadMapData() {
        isLoading = true
        mapAnnotations = []
        debugInfo = "Loading..."
        
        // First, check if we have users in local SwiftData
        let localUsers = userService.getAllUsers()
        debugInfo = "Found \(localUsers.count) total users in SwiftData"
        
        // Process local data first if available
        if !localUsers.isEmpty {
            processUsers(localUsers)
        }
        
        // If we still don't have any annotations, create sample data in debug mode
        #if DEBUG
        if mapAnnotations.isEmpty {
            debugInfo += " | No users with valid coordinates found"
        }
        #else
        // In production, automatically create sample data if none exists
        if mapAnnotations.isEmpty {
            createSampleLocations()
        }
        #endif
        
        // Then sync with Firebase in the background for latest data
        Task {
            do {
                await userService.syncWithFirebase()
                
                // Get updated users after sync
                let updatedUsers = userService.getAllUsers()
                debugInfo += " | After sync: \(updatedUsers.count) users"
                
                // Only update UI if we got new data
                if updatedUsers.count > localUsers.count {
                    processUsers(updatedUsers)
                }
            } catch {
                debugInfo += " | Sync error: \(error.localizedDescription)"
                print("Error syncing with Firebase: \(error.localizedDescription)")
            }
            
            isLoading = false
        }
    }
    
    private func processUsers(_ users: [User]) {
        // Process users that have location data
        let validUsers = users.filter { user in
            guard let latitude = user.latitude, let longitude = user.longitude else {
                return false
            }
            
            // Verify coordinates are valid
            return latitude != 0 && longitude != 0
        }
        
        debugInfo += " | Valid users with locations: \(validUsers.count)"
        
        // Create annotations
        self.mapAnnotations = validUsers.map { user in
            MapLocation(
                id: user.id ?? UUID().uuidString,
                name: user.name,
                coordinate: CLLocationCoordinate2D(
                    latitude: user.latitude ?? 0,
                    longitude: user.longitude ?? 0
                ),
                type: user.userType.lowercased() == "organization" ? .organization : .donor
            )
        }
        
        // Adjust region if we have annotations
        if let firstLocation = mapAnnotations.first {
            mapRegion.center = firstLocation.coordinate
            mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        }
        
        isLoading = false
    }
    
    private func createSampleLocations() {
        // Create hardcoded sample locations for the map
        mapAnnotations = [
            MapLocation(
                id: "sample-donor-1",
                name: "John Smith",
                coordinate: CLLocationCoordinate2D(latitude: 53.349805, longitude: -6.260310),
                type: .donor
            ),
            MapLocation(
                id: "sample-donor-2",
                name: "Mary Jones",
                coordinate: CLLocationCoordinate2D(latitude: 53.347402, longitude: -6.257588),
                type: .donor
            ),
            MapLocation(
                id: "sample-org-1",
                name: "Dublin Blood Bank",
                coordinate: CLLocationCoordinate2D(latitude: 53.339428, longitude: -6.261924),
                type: .organization
            ),
            MapLocation(
                id: "sample-org-2",
                name: "St. James Hospital",
                coordinate: CLLocationCoordinate2D(latitude: 53.341598, longitude: -6.291809),
                type: .organization
            )
        ]
        
        // Save the sample users to SwiftData
        Task {
            for i in 0..<mapAnnotations.count {
                let location = mapAnnotations[i]
                
                let user = User(
                    id: location.id,
                    email: "sample\(i+1)@example.com",
                    name: location.name,
                    phoneNumber: "+353 \(87000000 + i)",
                    bloodType: i % 2 == 0 ? BloodType.aPositive : BloodType.oNegative,
                    donationCount: Int.random(in: 0...10),
                    county: "Dublin",
                    userType: location.type == .donor ? "donor" : "organization",
                    address: "Sample Address \(i+1), Dublin",
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    organizationDescription: location.type == .organization ? "Blood donation center" : nil
                )
                
                do {
                    _ = try await userService.createUser(user)
                } catch {
                    debugInfo += " | Error creating user: \(error.localizedDescription)"
                }
            }
            
            debugInfo += " | Added 4 sample locations"
        }
        
        // Center the map on Dublin with appropriate zoom level
        mapRegion.center = CLLocationCoordinate2D(latitude: 53.3458, longitude: -6.2575)
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        isLoading = false
    }
    
    private func resetMapData() {
        isLoading = true
        mapAnnotations = []
        
        Task {
            // This would need a method in the DatabaseManager to reset all users
            // Here we'll just remove existing data from the view
            debugInfo = "Reset requested - map data cleared"
            isLoading = false
        }
    }
    
    private func zoomIn() {
        mapRegion.span = MKCoordinateSpan(
            latitudeDelta: max(0.001, mapRegion.span.latitudeDelta * 0.7),
            longitudeDelta: max(0.001, mapRegion.span.longitudeDelta * 0.7)
        )
    }
    
    private func zoomOut() {
        mapRegion.span = MKCoordinateSpan(
            latitudeDelta: min(0.5, mapRegion.span.latitudeDelta * 1.3),
            longitudeDelta: min(0.5, mapRegion.span.longitudeDelta * 1.3)
        )
    }
}

// Custom model for map annotations is now in Models/MapLocation.swift
// Removed duplicate declaration

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
