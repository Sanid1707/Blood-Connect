import SwiftUI

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case inbox = "envelope.fill"
    case notifications = "bell.fill"
    case profile = "person.fill"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .inbox: return "Inbox"
        case .notifications: return "Alerts"
        case .profile: return "Profile"
        }
    }
}

struct BottomNavigationView: View {
    @Binding var selectedTab: Tab
    @Namespace private var namespace
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    // Icon with animated bubble background
                    ZStack {
                        if selectedTab == tab {
                            Capsule()
                                .fill(AppColor.primaryRed.opacity(0.2))
                                .frame(width: 50, height: 30)
                                .matchedGeometryEffect(id: "bubble", in: namespace)
                        }
                        
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == tab ? AppColor.primaryRed : .gray)
                            .frame(width: 50, height: 30)
                    }
                    
                    // Tab title with animation
                    Text(tab.title)
                        .font(.system(size: 12))
                        .foregroundColor(selectedTab == tab ? AppColor.primaryRed : .gray)
                        .opacity(selectedTab == tab ? 1 : 0.7)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 20 : 0)
    }
}

struct BottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Spacer()
                BottomNavigationView(selectedTab: .constant(.home))
            }
        }
    }
} 