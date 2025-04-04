import SwiftUI

struct FindDonorsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    
    // Sample donor data with remote image URLs
    let donors = [
        (name: "Liam Elijah", location: "New York", bloodType: "A+", imageURL: "https://randomuser.me/api/portraits/men/32.jpg"),
        (name: "Oliver James", location: "Washington, D.C.", bloodType: "B-", imageURL: "https://randomuser.me/api/portraits/men/44.jpg"),
        (name: "Michel Lucas", location: "Arizona", bloodType: "O+", imageURL: "https://randomuser.me/api/portraits/men/55.jpg"),
        (name: "Benjamin Jack", location: "Florida", bloodType: "AB+", imageURL: "https://randomuser.me/api/portraits/men/67.jpg"),
        (name: "Archer Noah", location: "Georgia", bloodType: "O-", imageURL: "https://randomuser.me/api/portraits/men/22.jpg"),
        (name: "Daniel Henry", location: "California", bloodType: "A-", imageURL: "https://randomuser.me/api/portraits/men/78.jpg")
    ]
    
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
            
            // Donor List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(donors, id: \.name) { donor in
                        DonorCardView(donor: donor)
                            .padding(.horizontal)
                            .padding(.top, 12)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

// Donor Card View
struct DonorCardView: View {
    let donor: (name: String, location: String, bloodType: String, imageURL: String)
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile image with remote URL
            ProfileImageView(imageURL: donor.imageURL)
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
                    
                    Text(donor.location)
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.secondaryText)
                }
            }
            
            Spacer()
            
            // Blood type using BloodDropComponent
            BloodDropComponent(bloodType: donor.bloodType)
                .padding(.trailing, 8)
        }
        .padding(18)
        .background(AppColor.cardLightGray)
        .cornerRadius(16)
        .shadow(color: AppColor.shadowColor, radius: 2, x: 0, y: 1)
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
        guard let url = URL(string: imageURL) else { return }
        
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
