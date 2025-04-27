import SwiftUI

struct DonateView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: DonateTab = .all
    @State private var organizations: [User] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    private let userService = UserService()
    
    // Get organizations based on selected tab
    var displayedOrganizations: [User] {
        switch selectedTab {
        case .all:
            return organizations
        case .recent:
            // Sort by most recently created (using default array since we don't track creation date)
            return Array(organizations.prefix(min(2, organizations.count)))
        case .urgent:
            // For demonstration, we'll consider blood types O- and B- as urgent
            // In a real app, you would have a property on organizations to mark them as urgent
            return organizations.filter { 
                let bloodTypeNeeded = $0.bloodType?.rawValue.lowercased() ?? ""
                return bloodTypeNeeded.contains("o-") || bloodTypeNeeded.contains("b-")
            }
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
            
            if isLoading {
                Spacer()
                ProgressView("Loading organizations...")
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            } else if let errorMessage = errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
                Button("Retry") {
                    loadOrganizations()
                }
                .padding()
                .background(AppColor.primaryRed)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
            } else if displayedOrganizations.isEmpty {
                Spacer()
                Text("No organizations found for this category")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                // Header section with count
                HStack {
                    Text("\(displayedOrganizations.count) Organizations")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColor.secondaryText)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 12)
                
                // Organization List
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(displayedOrganizations) { organization in
                            BloodSeekerCardView(
                                name: organization.name,
                                seekerDescription: organization.organizationDescription ?? "Blood donation center",
                                timeAgo: getTimeAgoString(organization),
                                location: organization.address ?? organization.county ?? "Unknown location",
                                bloodType: organization.bloodType?.rawValue ?? "All",
                                imageURL: "",
                                onDonate: {
                                    handleDonate(organization: organization)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(Color.white)
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
        .onAppear {
            loadOrganizations()
        }
    }
    
    private func loadOrganizations() {
        isLoading = true
        errorMessage = nil
        
        // First check if we have organizations in local SwiftData
        let localOrganizations = userService.getOrganizations()
        
        if !localOrganizations.isEmpty {
            self.organizations = localOrganizations
            self.isLoading = false
        }
        
        // Then attempt to sync with Firebase in the background
        Task {
            do {
                await userService.syncWithFirebase()
                
                // Fetch again after sync
                let updatedOrganizations = userService.getOrganizations()
                if updatedOrganizations.isEmpty && localOrganizations.isEmpty {
                    self.errorMessage = "No organizations available"
                } else {
                    self.organizations = updatedOrganizations
                }
            } catch {
                if localOrganizations.isEmpty {
                    self.errorMessage = "Failed to load organizations"
                }
                print("Error syncing with Firebase: \(error.localizedDescription)")
            }
            
            self.isLoading = false
        }
    }
    
    // Helper function to generate time ago string
    private func getTimeAgoString(_ organization: User) -> String {
        // In a real app, you'd use the lastUpdated timestamp
        // For now, we'll generate a random recent time
        let randomMinutes = Int.random(in: 1...120)
        return "\(randomMinutes) min ago"
    }
    
    // Safe method to handle donate action
    private func handleDonate(organization: User) {
        // Safely handle the donation action
        print("Donate tapped for \(organization.name)")
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
