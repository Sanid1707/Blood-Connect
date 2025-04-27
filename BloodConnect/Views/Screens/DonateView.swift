import SwiftUI

struct DonateView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: DonateTab = .all
    
    // Sample donor data organized by categories
    let allDonors = [
        (name: "Oliver James", description: "Lorem ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "7 Min Ago", location: "Washington, D.C.", bloodType: "B+", imageURL: ""),
        (name: "Benjamin Jack", description: "Lorem ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "30 Min Ago", location: "Florida", bloodType: "A-", imageURL: ""),
        (name: "Thomas Carter", description: "Lorem ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "45 Min Ago", location: "California", bloodType: "O+", imageURL: "")
    ]
    
    let recentDonors = [
        (name: "Emily Wilson", description: "Recently registered donor looking to help with emergency cases.", timeAgo: "2 Min Ago", location: "New York, NY", bloodType: "AB+", imageURL: ""),
        (name: "Michael Brown", description: "Available for donation at City Hospital this weekend.", timeAgo: "15 Min Ago", location: "Boston, MA", bloodType: "O-", imageURL: "")
    ]
    
    
    let urgentDonors = [
        (name: "Sarah Johnson", description: "Urgently needed for surgery happening tomorrow morning.", timeAgo: "Just Now", location: "Chicago, IL", bloodType: "B-", imageURL: ""),
        (name: "Robert Williams", description: "Critical need for rare blood type for emergency transfusion.", timeAgo: "5 Min Ago", location: "Dallas, TX", bloodType: "AB-", imageURL: ""),
        (name: "James Peterson", description: "Urgent request for child in ICU needing immediate transfusion.", timeAgo: "10 Min Ago", location: "Seattle, WA", bloodType: "O+", imageURL: "")
    ]
    
    // Get donors based on selected tab
    var displayedDonors: [(name: String, description: String, timeAgo: String, location: String, bloodType: String, imageURL: String)] {
        switch selectedTab {
        case .all:
            return allDonors
        case .recent:
            return recentDonors
        case .urgent:
            return urgentDonors
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            TopBarView(
                title: "Donate",
                showBackButton: true,
                onBackTapped: {
                    presentationMode.wrappedValue.dismiss()
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            
            // Tab selector
            DonateTabView(selectedTab: $selectedTab)
                .padding(.top, 8)
            
            // Header section with count
            HStack {
                Text("\(displayedDonors.count) Donors")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColor.secondaryText)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 12)
            
            // Donor List
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(displayedDonors, id: \.name) { donor in
                        BloodSeekerCardView(
                            name: donor.name,
                            seekerDescription: donor.description,
                            timeAgo: donor.timeAgo,
                            location: donor.location,
                            bloodType: donor.bloodType,
                            imageURL: donor.imageURL,
                            onDonate: {
                                handleDonate(donorName: donor.name)
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.3), value: selectedTab) // Smooth animation when changing tabs
    }
    
    // Safe method to handle donate action
    private func handleDonate(donorName: String) {
        // Safely handle the donation action
        print("Donate tapped for \(donorName)")
    }
}

// Enum for donation tabs
enum DonateTab {
    case all, recent, urgent
    
    var title: String {
        switch self {
        case .all: return "All"
        case .recent: return "Recent"
        case .urgent: return "Urgent"
        }
    }
}

// Custom tab view for donation categories
struct DonateTabView: View {
    @Binding var selectedTab: DonateTab
    let tabs: [DonateTab] = [.all, .recent, .urgent]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(tabs, id: \.title) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(tab.title)
                                .font(.system(size: 16, weight: selectedTab == tab ? .semibold : .regular))
                                .foregroundColor(selectedTab == tab ? AppColor.primaryRed : AppColor.secondaryText)
                                .frame(maxWidth: .infinity)
                            
                            // Red indicator for selected tab
                            Rectangle()
                                .fill(selectedTab == tab ? AppColor.primaryRed : Color.clear)
                                .frame(height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 4) // Adding vertical padding to tabs
            
            Divider()
                .background(AppColor.dividerGray)
        }
        .padding(.horizontal)
    }
}

struct DonateView_Previews: PreviewProvider {
    static var previews: some View {
        DonateView()
    }
} 
