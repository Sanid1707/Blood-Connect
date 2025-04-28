import SwiftUI
import MapKit

struct FindDonorsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var donors: [User] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    private let userService = UserService()
    
    // Filtered donors based on search text
    var filteredDonors: [User] {
        if searchText.isEmpty {
            return donors
        } else {
            return donors.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                ($0.county?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.bloodType?.rawValue.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar with back button
            TopBarView(
                title: "Find Donor",
                showBackButton: true,
                onBackTapped: {
                    presentationMode.wrappedValue.dismiss()
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            
            // Search Bar
            SearchBarView(searchText: $searchText)
                .padding(.top, 16)
                .padding(.horizontal)
            
            if isLoading {
                Spacer()
                ProgressView("Loading donors...")
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            } else if let errorMessage = errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
                Button("Retry") {
                    loadDonors()
                }
                .padding()
                .background(AppColor.primaryRed)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
            } else if filteredDonors.isEmpty {
                Spacer()
                VStack {
                    if searchText.isEmpty {
                        Text("No donors found")
                            .foregroundColor(AppColor.secondaryText)
                    } else {
                        Text("No donors match your search")
                            .foregroundColor(AppColor.secondaryText)
                    }
                }
                .padding()
                Spacer()
            } else {
                // Donor List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredDonors) { donor in
                            DonorCardView(donor: donor)
                                .padding(.horizontal)
                                .padding(.top, 12)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(AppColor.background)
            }
        }
        .background(Color(AppColor.background).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .onAppear {
            loadDonors()
        }
    }
    
    private func loadDonors() {
        isLoading = true
        errorMessage = nil
        
        // First check if we have donors in local SwiftData
        let localDonors = userService.getIndividualDonors()
        
        if !localDonors.isEmpty {
            self.donors = localDonors
            self.isLoading = false
        }
        
        // Then attempt to sync with Firebase in the background
        Task {
            do {
                await userService.syncWithFirebase()
                
                // Fetch again after sync
                let updatedDonors = userService.getIndividualDonors()
                if updatedDonors.isEmpty && localDonors.isEmpty {
                    self.errorMessage = "No donors available"
                } else {
                    self.donors = updatedDonors
                }
            } catch {
                if localDonors.isEmpty {
                    self.errorMessage = "Failed to load donors"
                }
                print("Error syncing with Firebase: \(error.localizedDescription)")
            }
            
            self.isLoading = false
        }
    }
}

// Donor Card View
struct DonorCardView: View {
    let donor: User
    @State private var showDetails = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile image
            ProfileImageView(imageURL: "")
                .frame(width: 60, height: 60)
            
            // Name and location
            VStack(alignment: .leading, spacing: 6) {
                Text(donor.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppColor.text)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                        .foregroundColor(AppColor.primaryRed)
                    
                    Text(donor.county ?? donor.address ?? "Unknown location")
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.secondaryText)
                }
            }
            
            Spacer()
            
            // Blood type using BloodDropComponent
            BloodDropComponent(bloodType: donor.bloodType?.rawValue ?? "?")
                .padding(.trailing, 8)
        }
        .padding(18)
        .background(AppColor.card)
        .cornerRadius(16)
        .shadow(color: AppColor.shadow, radius: 2, x: 0, y: 1)
        .onTapGesture {
            showDetails = true
        }
        .sheet(isPresented: $showDetails) {
            UserDetailsView(user: donor)
        }
    }
}

// Remote image loader with caching
struct ProfileImageView: View {
    let imageURL: String
    @State private var image: UIImage? = nil
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.gray.opacity(0.2))
            
            // Loading placeholder
            if image == nil {
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            // Actual image when loaded
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: imageURL), !imageURL.isEmpty else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}

struct FindDonorsView_Previews: PreviewProvider {
    static var previews: some View {
        FindDonorsView()
    }
}

// MARK: - Enhanced Donor Details View
struct UserDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    let user: User
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#FFFFFF"),
                    Color(hex: "#F9F9F9")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Drawer handle
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 18)
                
                ScrollView {
                    VStack(spacing: 22) {
                        // Header with profile image and basic info
                        HStack(spacing: 16) {
                            // Profile image with animated border
                            ProfileImageView(imageURL: "")
                                .frame(width: 76, height: 76)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [AppColor.primaryRed, AppColor.primaryRed.opacity(0.7)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2.5
                                        )
                                )
                                .shadow(color: AppColor.primaryRed.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            // Basic info with styled text
                            VStack(alignment: .leading, spacing: 6) {
                                Text(user.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(AppColor.text)
                                
                                if let county = user.county {
                                    HStack(spacing: 4) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColor.primaryRed)
                                        
                                        Text(county)
                                            .font(.system(size: 14))
                                            .foregroundColor(AppColor.secondaryText)
                                    }
                                }
                                
                                HStack(alignment: .center, spacing: 6) {
                                    // Blood type in styled container
                                    Text(user.bloodType?.rawValue ?? "Unknown")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(
                                            Capsule()
                                                .fill(AppColor.primaryRed)
                                        )
                                }
                            }
                            
                            Spacer()
                            
                            // Close button with improved styling
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.gray)
                                    .padding(9)
                                    .background(
                                        Circle()
                                            .fill(Color.gray.opacity(0.12))
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Custom divider
                        HStack {
                            RoundedRectangle(cornerRadius: 1)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.25), Color.gray.opacity(0.1)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 1)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        
                        // Contact Information
                        InfoSectionView(title: "Contact Information") {
                            VStack(spacing: 14) {
                                ContactRow(icon: "envelope.fill", title: "Email", value: user.email)
                                
                                if let phone = user.phoneNumber {
                                    ContactRow(icon: "phone.fill", title: "Phone", value: phone)
                                }
                                
                                if let address = user.address {
                                    ContactRow(icon: "house.fill", title: "Address", value: address)
                                }
                                
                                if let eircode = user.eircode {
                                    ContactRow(icon: "mappin.and.ellipse", title: "Eircode", value: eircode)
                                }
                            }
                        }
                        
                        // User location map if coordinates are available
                        if let latitude = user.latitude, let longitude = user.longitude {
                            InfoSectionView(title: "Location") {
                                VStack(spacing: 15) {
                                    DonorLocationMapView(latitude: latitude, longitude: longitude, name: user.name)
                                        .frame(height: 220)
                                        .cornerRadius(14)
                                        .shadow(color: Color.black.opacity(0.07), radius: 5, x: 0, y: 2)
                                        .padding(.bottom, 4)
                                    
                                    // Get directions button
                                    Button(action: {
                                        let url = URL(string: "http://maps.apple.com/?ll=\(latitude),\(longitude)")!
                                        UIApplication.shared.open(url)
                                    }) {
                                        HStack {
                                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                                .font(.system(size: 16))
                                            Text("Get Directions")
                                                .font(.system(size: 15, weight: .medium))
                                        }
                                        .foregroundColor(AppColor.primaryRed)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(AppColor.primaryRed, lineWidth: 1.5)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(AppColor.primaryRed.opacity(0.05))
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        // Donation History if available
                        if user.donationCount > 0 || user.lastDonationDate != nil {
                            InfoSectionView(title: "Donation History") {
                                VStack(spacing: 14) {
                                    if let lastDate = user.lastDonationDate {
                                        ContactRow(
                                            icon: "calendar",
                                            title: "Last Donation",
                                            value: formatDate(lastDate),
                                            iconColor: .blue
                                        )
                                    }
                                    
                                    ContactRow(
                                        icon: "drop.fill",
                                        title: "Total Donations",
                                        value: "\(user.donationCount)",
                                        iconColor: AppColor.primaryRed
                                    )
                                    
                                    // Badge based on donation count
                                    HStack(spacing: 14) {
                                        ZStack {
                                            Circle()
                                                .fill(badgeColor(for: user.donationCount).opacity(0.15))
                                                .frame(width: 36, height: 36)
                                            
                                            Image(systemName: badgeIcon(for: user.donationCount))
                                                .font(.system(size: 16))
                                                .foregroundColor(badgeColor(for: user.donationCount))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("Donor Status")
                                                .font(.system(size: 13))
                                                .foregroundColor(AppColor.secondaryText)
                                            
                                            Text(badgeTitle(for: user.donationCount))
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(AppColor.text)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        
                        // Additional Information if available
                        if let availability = user.availability {
                            InfoSectionView(title: "Additional Information") {
                                ContactRow(
                                    icon: "clock.fill",
                                    title: "Availability",
                                    value: availability,
                                    iconColor: .purple
                                )
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                }
                
                // Call action button
                if let phone = user.phoneNumber {
                    VStack {
                        // Soft gradient divider
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gray.opacity(0.05),
                                Color.gray.opacity(0.15)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 8)
                        
                        Button(action: {
                            if let url = URL(string: "tel://\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 18))
                                
                                Text("Contact Donor")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColor.primaryRed,
                                        AppColor.primaryRed.opacity(0.85)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: AppColor.primaryRed.opacity(0.25), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 6)
                        .padding(.bottom, 16)
                    }
                    .background(Color.white)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func badgeTitle(for donationCount: Int) -> String {
        switch donationCount {
        case 0: return "New Donor"
        case 1...2: return "Bronze Donor"
        case 3...5: return "Silver Donor"
        case 6...9: return "Gold Donor"
        default: return "Platinum Donor"
        }
    }
    
    private func badgeIcon(for donationCount: Int) -> String {
        switch donationCount {
        case 0: return "heart"
        case 1...2: return "drop.fill"
        case 3...5: return "drop.fill"
        case 6...9: return "heart.fill"
        default: return "star.fill"
        }
    }
    
    private func badgeColor(for donationCount: Int) -> Color {
        switch donationCount {
        case 0: return .gray
        case 1...2: return .brown
        case 3...5: return .gray
        case 6...9: return .yellow
        default: return .purple
        }
    }
}

// Styled section view with title
struct InfoSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Section title with accent
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColor.text)
                
                Rectangle()
                    .fill(AppColor.primaryRed.opacity(0.2))
                    .frame(height: 1)
            }
            
            // Content with card styling
            content
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                )
        }
        .padding(.horizontal, 20)
    }
}

// Contact info row with icon and data
struct ContactRow: View {
    let icon: String
    let title: String
    let value: String
    var iconColor: Color = AppColor.primaryRed
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Icon with colored background
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            
            // Text content with better spacing
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(AppColor.secondaryText)
                
                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(AppColor.text)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

// Simplified map view for donor location
struct DonorLocationMapView: View {
    let latitude: Double
    let longitude: Double
    let name: String
    
    @State private var region: MKCoordinateRegion
    
    init(latitude: Double, longitude: Double, name: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        
        // Initialize the region with a reasonable zoom level
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [DonorLocation(name: name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))]) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack(spacing: 0) {
                    // Blood drop pin
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 36, height: 36)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                        
                        Image(systemName: "drop.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColor.primaryRed)
                    }
                    
                    // Name label with stylish design
                    Text(location.name)
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppColor.primaryRed)
                        )
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                        .offset(y: 4)
                }
            }
        }
    }
}

// Model for map annotation
struct DonorLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
} 
