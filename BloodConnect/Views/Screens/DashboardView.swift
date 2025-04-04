import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    @State private var isLoaded = false
    @State private var showFindDonorsView = false
    
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
        (name: "James Peterson", desc: "I am anaemic and urgently need blood today.please reach out.Transportation and Feeding can be provided.", time: "5 Min Ago", location: "London, England", bloodType: "B+", imageURL: "https://randomuser.me/api/portraits/men/23.jpg"),
        (name: "Sarah Johnson", desc: "Urgently need blood donation for surgery scheduled tomorrow morning.", time: "30 Min Ago", location: "Manchester, UK", bloodType: "O-", imageURL: "https://randomuser.me/api/portraits/women/45.jpg"),
        (name: "Robert Williams", desc: "Need blood for emergency transfusion at City Hospital.", time: "1 Hour Ago", location: "Birmingham, UK", bloodType: "A+", imageURL: "https://randomuser.me/api/portraits/men/76.jpg")
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Using the new TopBarView component
                TopBarView(
                    title: "Blood Connect",
                    showBackButton: false,
                    onSettingsTapped: {
                        // Handle settings action
                    }
                )
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Search Bar
                        SearchBarView(searchText: $searchText)
                            .padding(.top, 15)
                        
                        // Map View with light theme
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
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
                                        .stroke(AppColor.dividerGray, lineWidth: 1)
                                        
                                        // Map icons
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 32, height: 32)
                                            .shadow(color: AppColor.shadowColor, radius: 2)
                                            .overlay(
                                                Image(systemName: "drop.fill")
                                                    .foregroundColor(AppColor.primaryRed)
                                                    .font(.system(size: 14))
                                            )
                                            .offset(x: -90, y: -50)
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 32, height: 32)
                                            .shadow(color: AppColor.shadowColor, radius: 2)
                                            .overlay(
                                                Image(systemName: "cross.fill")
                                                    .foregroundColor(AppColor.primaryRed)
                                                    .font(.system(size: 14))
                                            )
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 32, height: 32)
                                            .shadow(color: AppColor.shadowColor, radius: 2)
                                            .overlay(
                                                Image(systemName: "drop.fill")
                                                    .foregroundColor(AppColor.primaryRed)
                                                    .font(.system(size: 14))
                                            )
                                            .offset(x: 90, y: -50)
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(AppColor.dividerGray, lineWidth: 1)
                                )
                                .frame(height: 180)
                                .padding(.horizontal)
                            
                            // Location button
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {}) {
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
                        }
                        
                        // Action Buttons Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                            ForEach(Array(zip(actions.indices, actions)), id: \.0) { index, actionItem in
                                let (icon, title, color) = actionItem
                                
                                ActionButtonView(icon: icon, title: title) {
                                    handleActionButtonTap(index: index)
                                }
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
                                    .foregroundColor(AppColor.defaultText)
                                
                                Spacer()
                                
                                Button("See All") {
                                    // Handle see all action
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColor.primaryRed)
                            }
                            .padding(.horizontal)
                            
                            ForEach(bloodSeekers, id: \.name) { seeker in
                                BloodSeekerCardView(
                                    name: seeker.name,
                                    description: seeker.desc,
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isLoaded = true
                    }
                }
            }
            
            // Navigation to FindDonorsView
            NavigationLink(
                destination: FindDonorsView(),
                isActive: $showFindDonorsView,
                label: { EmptyView() }
            )
        }
    }
    
    private func handleActionButtonTap(index: Int) {
        switch index {
        case 0: // Find Donors
            showFindDonorsView = true
        case 1: // Donate
            print("Donate tapped")
        case 2: // Blood Bank
            print("Blood Bank tapped")
        case 3: // Support
            print("Support tapped")
        case 4: // Blood Req
            print("Blood Req tapped")
        case 5: // More
            print("More tapped")
        default:
            break
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
} 
