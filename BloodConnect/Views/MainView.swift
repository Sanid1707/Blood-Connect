import SwiftUI
import SwiftData

struct MainView: View {
    @State private var selectedTab: Tab = .home
    @Namespace private var animation
    @State private var showingDebugView = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Background color
                Color.white.ignoresSafeArea()
                
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tag(Tab.home)
                        .transition(.slide)
                    
                    InboxView()
                        .tag(Tab.inbox)
                        .transition(.slide)
                    
                    NotificationsView()
                        .tag(Tab.notifications)
                        .transition(.slide)
                    
                    ProfileView()
                        .tag(Tab.profile)
                        .transition(.slide)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom animated bottom navigation
                VStack(spacing: 0) {
                    Divider()
                        .opacity(0.2)
                    
                    BottomNavigationView(selectedTab: $selectedTab)
                        .background(Color.white)
                }
                .animation(.easeInOut, value: selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarHidden(true)
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showingDebugView = true
                        }) {
                            Image(systemName: "database.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.blue)
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding([.top, .trailing], 16)
                    }
                    Spacer()
                }, alignment: .topTrailing
            )
            .sheet(isPresented: $showingDebugView) {
                SwiftDataDebugView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modelContainer(for: [UserModel.self, BloodSeekerModel.self, DonationCenterModel.self, OperatingHoursModel.self])
    }
} 
