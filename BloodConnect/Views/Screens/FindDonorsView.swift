import SwiftUI

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
                            .foregroundColor(.gray)
                    } else {
                        Text("No donors match your search")
                            .foregroundColor(.gray)
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
                .background(Color.white)
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
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
                    .foregroundColor(AppColor.defaultText)
                
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
        .background(AppColor.cardLightGray)
        .cornerRadius(16)
        .shadow(color: AppColor.shadowColor, radius: 2, x: 0, y: 1)
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

// Add this new view at the end of the file
struct UserDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    let user: User
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar with back button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(AppColor.primaryRed))
                }
                
                Spacer()
                
                Text("Donor Details")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColor.defaultText)
                
                Spacer()
                
                // Empty view for balance
                Color.clear
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Profile section
            VStack(spacing: 24) {
                // Profile image
                ProfileImageView(imageURL: "")
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(AppColor.primaryRed, lineWidth: 3)
                    )
                
                // Name
                Text(user.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColor.defaultText)
                
                // Blood type
                BloodDropComponent(bloodType: user.bloodType?.rawValue ?? "Unknown")
                    .scaleEffect(1.2)
                    .padding(.bottom, 8)
                
                // Contact section
                VStack(spacing: 16) {
                    contactRow(icon: "envelope.fill", title: "Email", value: user.email)
                    
                    if let phone = user.phoneNumber {
                        contactRow(icon: "phone.fill", title: "Phone", value: phone)
                    }
                    
                    if let address = user.address {
                        contactRow(icon: "location.fill", title: "Address", value: address)
                    }
                    
                    if let county = user.county {
                        contactRow(icon: "map.fill", title: "County", value: county)
                    }
                }
                .padding()
                .background(AppColor.cardLightGray)
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
                
                // Contact button
                Button(action: {
                    // Handle contact donor action
                    if let phone = user.phoneNumber, let url = URL(string: "tel://\(phone)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 16))
                        Text("Contact Donor")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColor.primaryRed)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .disabled(user.phoneNumber == nil)
                .opacity(user.phoneNumber == nil ? 0.6 : 1.0)
            }
            .padding(.top)
        }
    }
    
    private func contactRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColor.primaryRed)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(AppColor.secondaryText)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColor.defaultText)
            }
            
            Spacer()
        }
    }
} 
