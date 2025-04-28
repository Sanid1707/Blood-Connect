import SwiftUI
import MapKit
import Combine

struct ProfileView: View {
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603), // Default to Dublin
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var showLogoutAlert = false
    @State private var currentUser: User?
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var mapAnnotation: MapLocation?
    
    // Environment object for authentication
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Presentation mode for navigation
    @Environment(\.presentationMode) var presentationMode
    
    // Services
    private let authService = FirebaseAuthService()
    private let userService = UserService()

    var body: some View {
        VStack(spacing: 10) {
            // Header
            TopBarView(
                title: "Profile",
                showBackButton: true,
                onBackTapped: {
                    presentationMode.wrappedValue.dismiss()
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            
            if isLoading {
                Spacer()
                ProgressView("Loading profile...")
                Spacer()
            } else if let errorMessage = errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
                Button("Retry") {
                    loadUserData()
                }
                .padding()
                .background(AppColor.primaryRed)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
            } else if let user = currentUser {
                ScrollView {
                    VStack(spacing: 8) {
                        // Profile Image and Info
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .foregroundColor(AppColor.primaryRed)
                            .clipShape(Circle())
                        
                        Text(user.name)
                            .font(.title3).bold()
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if let lastDonation = user.lastDonationDate {
                            Text("Last Donation: \(formatDate(lastDonation))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("No previous donations")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // User Type Badge
                        Text(user.userType.capitalized)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(user.userType.lowercased() == "donor" ? AppColor.primaryRed : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 4)
                    }
                    .padding(.vertical)

                    // Stats
                    HStack(spacing: 16) {
                        StatBox(title: "Donated", value: "\(user.donationCount)")
                        
                        StatBox(
                            title: "Blood Type",
                            value: user.bloodType?.rawValue ?? "Unknown"
                        )
                        
                        StatBox(
                            title: "Location",
                            value: user.county ?? "Unknown"
                        )
                    }
                    .padding(.bottom)

                    // Contact Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Info")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(AppColor.primaryRed)
                            Text(user.phoneNumber ?? "Not provided")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        if let address = user.address, !address.isEmpty {
                            HStack(alignment: .top) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(AppColor.primaryRed)
                                Text(address)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Map - only show if user has location data
                    if user.latitude != nil && user.longitude != nil {
                        VStack(alignment: .leading) {
                            Text("Location")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            if let annotation = mapAnnotation {
                                Map(coordinateRegion: $mapRegion, annotationItems: [annotation]) { location in
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
                                .frame(height: 220)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            } else {
                                Text("Location not available")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    // Additional Information for Organizations
                    if user.userType.lowercased() == "organization" {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Organization Details")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if let description = user.organizationDescription, !description.isEmpty {
                                HStack(alignment: .top) {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(AppColor.primaryRed)
                                    Text(description)
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            
                            if let workingHours = user.workingHours, !workingHours.isEmpty {
                                HStack(alignment: .top) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(AppColor.primaryRed)
                                    Text(workingHours)
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }

                    // Logout Button
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20))
                            
                            Text("Log Out")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColor.primaryRed, AppColor.primaryRed.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: AppColor.primaryRed.opacity(0.3), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    
                    if user.userType.lowercased() == "donor" {
                        // Swipe to Request
                        SwipeView(defaultText: "Swipe to Request Blood", swipedText: "Request Sent!")
                            .padding(.bottom, 8)
                            .padding(.top, 20)
                    }
                }
            } else {
                Spacer()
                Text("No user data available")
                    .foregroundColor(.gray)
                    .padding()
                
                Button("Login") {
                    authViewModel.logout()
                }
                .padding()
                .background(AppColor.primaryRed)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
            }
        }
        .onAppear {
            loadUserData()
        }
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Yes, Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
    
    private func loadUserData() {
        isLoading = true
        errorMessage = nil
        
        // Call the getCurrentUser method to get current user data
        Task {
            do {
                // Try to get from the authentication service first
                var user: User? = nil
                
                if authService.isAuthenticated() {
                    let publisher = authService.getCurrentUser()
                    
                    // Use a custom extension to convert the publisher to async/await
                    user = try await publisher.asyncFirst()
                }
                
                // If we couldn't get the user from auth, try to find a local user
                if user == nil {
                    // This would typically be more sophisticated, looking up the correct user
                    // For now, we'll just grab any user from SwiftData if available
                    let localUsers = userService.getAllUsers()
                    if !localUsers.isEmpty {
                        user = localUsers.first
                    }
                }
                
                // Update the UI
                if let user = user {
                    self.currentUser = user
                    
                    // Update map if user has location
                    if let latitude = user.latitude, let longitude = user.longitude {
                        self.mapRegion = MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                        
                        self.mapAnnotation = MapLocation(
                            id: user.id ?? UUID().uuidString,
                            name: user.name,
                            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                            type: user.userType.lowercased() == "organization" ? .organization : .donor
                        )
                    }
                } else {
                    errorMessage = "Could not retrieve user data"
                }
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
                print("Error loading user: \(error)")
            }
            
            isLoading = false
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func logout() {
        // Call FirebaseAuthService to handle logout
        authService.signOut()
        
        // Post a notification to ensure a complete logout
        NotificationCenter.default.post(name: NSNotification.Name("LogoutRequested"), object: nil)
        
        // Update AuthViewModel to trigger navigation to login screen
        DispatchQueue.main.async {
            // Set isAuthenticated to false to show login view
            authViewModel.isAuthenticated = false
            authViewModel.logout()
            
            // Force UI refresh by posting a notification
            NotificationCenter.default.post(name: NSNotification.Name("ForceAuthUIRefresh"), object: nil)
            
            // For debugging
            print("User logged out, explicitly setting isAuthenticated to false")
        }
    }
}

// Helper for converting Combine publisher to async/await
extension Publisher {
    func asyncFirst() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            
            cancellable = self.first()
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        cancellable?.cancel()
                        continuation.resume(returning: value)
                    }
                )
        }
    }
}

// Custom model for map annotations is now in Models/MapLocation.swift
// Removed duplicate declaration

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
            .environmentObject(AuthViewModel())
    }
}
