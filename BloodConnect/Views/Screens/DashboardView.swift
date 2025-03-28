import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    @State private var isLoaded = false
    
    // Ensure we have simple data that doesn't rely on external models
    let actions = [
        ("drop.fill", "Find Donors", AppColor.primaryRed),
        ("heart.fill", "Donate", AppColor.primaryRed),
        ("cross.case.fill", "Blood Bank", AppColor.primaryRed),
        ("hand.raised.fill", "Support", AppColor.primaryRed),
        ("exclamationmark.triangle.fill", "Blood Req.", AppColor.primaryRed),
        ("ellipsis", "More", AppColor.primaryRed)
    ]
    
    // Sample data directly in the view to avoid dependencies
    let bloodSeekers = [
        (name: "James Peterson", desc: "Lorem ipsum is simply dummy text of the printing and typesetting industry.", time: "5 Min Ago", location: "London, England", bloodType: "B+"),
        (name: "Sarah Johnson", desc: "Urgently need blood donation for surgery scheduled tomorrow morning.", time: "30 Min Ago", location: "Manchester, UK", bloodType: "O-"),
        (name: "Robert Williams", desc: "Need blood for emergency transfusion at City Hospital.", time: "1 Hour Ago", location: "Birmingham, UK", bloodType: "A+")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            HStack {
                Button(action: {}) {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Blood Connect")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.primaryRed)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar
                    SearchBarView(searchText: $searchText)
                        .padding(.top, 15)
                    
                    // Map View with light theme
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .overlay(
                                ZStack {
                                    // Grid lines
                                    Path { path in
                                        // Horizontal lines
                                        path.move(to: CGPoint(x: 0, y: 60))
                                        path.addLine(to: CGPoint(x: 400, y: 60))
                                        path.move(to: CGPoint(x: 0, y: 120))
                                        path.addLine(to: CGPoint(x: 400, y: 120))
                                        
                                        // Vertical lines
                                        path.move(to: CGPoint(x: 133, y: 0))
                                        path.addLine(to: CGPoint(x: 133, y: 180))
                                        path.move(to: CGPoint(x: 266, y: 0))
                                        path.addLine(to: CGPoint(x: 266, y: 180))
                                    }
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    
                                    // Location markers
                                    ForEach(0..<3) { i in
                                        let positions = [(100, 40), (200, 90), (300, 40)]
                                        let icons = ["drop.fill", "cross.case.fill", "drop.fill"]
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 36, height: 36)
                                            .shadow(color: Color.black.opacity(0.1), radius: 2)
                                            .overlay(
                                                Image(systemName: icons[i])
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 16))
                                            )
                                            .offset(x: CGFloat(positions[i].0 - 200), y: CGFloat(positions[i].1 - 90))
                                    }
                                }
                            )
                            .frame(height: 180)
                            .padding(.horizontal)
                        
                        // Location button
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "location.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
                                }
                                .padding(.trailing, 25)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    
                    // Action Buttons Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 30) {
                        ForEach(actions, id: \.0) { icon, title, color in
                            VStack(spacing: 10) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                                    .overlay(
                                        Image(systemName: icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(color)
                                    )
                                
                                Text(title)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 5)
                            .opacity(isLoaded ? 1.0 : 0)
                            .animation(
                                Animation.easeIn(duration: 0.3)
                                    .delay(0.2),
                                value: isLoaded
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Blood Seekers Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Blood Seeker")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button("See All") {
                                // Handle see all action
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                        }
                        .padding(.horizontal)
                        
                        ForEach(bloodSeekers, id: \.name) { seeker in
                            BloodSeekerCard(seeker: seeker)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .background(Color.white)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isLoaded = true
                }
            }
        }
    }
}

// Extracted component for Blood Seeker Card
struct BloodSeekerCard: View {
    let seeker: (name: String, desc: String, time: String, location: String, bloodType: String)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading) {
                    Text(seeker.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(seeker.time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(seeker.bloodType)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.red)
            }
            
            Text(seeker.desc)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineLimit(2)
                .padding(.vertical, 5)
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.gray)
                Text(seeker.location)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Donate")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
} 
