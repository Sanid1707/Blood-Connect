import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .home
    @Namespace private var animation
    
    var body: some View {
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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
} 