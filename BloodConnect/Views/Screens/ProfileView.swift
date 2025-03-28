import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        Text("John Doe")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Blood Type: A+")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    .padding(.vertical)
                    
                    // Stats
                    HStack(spacing: 30) {
                        VStack {
                            Text("12")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Donations")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("3")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Requests")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("150")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Points")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        ForEach([
                            ("person.fill", "Personal Information"),
                            ("bell.fill", "Notifications"),
                            ("gear.fill", "Settings"),
                            ("questionmark.circle.fill", "Help & Support"),
                            ("arrow.right.square.fill", "Logout")
                        ], id: \.0) { icon, title in
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: icon)
                                        .foregroundColor(.red)
                                        .frame(width: 30)
                                    
                                    Text(title)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            Divider()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                }
                .padding()
            }
        }
        .background(Color.gray.opacity(0.05))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 