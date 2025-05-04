import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(hex: "FFEEF1")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if isActive {
                AuthView()
                    .transition(.opacity)
                    .environmentObject(authViewModel)
            } else {
                VStack {
                    VStack(spacing: 20) {
                        // App logo
                        Image(systemName: "drop.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppColor.primaryRed)
                        
                        // App name
                        Text("BloodConnect")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(AppColor.primaryRed)
                        
                        // Tagline
                        Text("Donate Blood, Save Lives")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
                    
                    // Loading indicator
                    VStack {
                        Spacer().frame(height: 80)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColor.primaryRed))
                            .scaleEffect(1.5)
                    }
                }
            }
        }
        .onAppear {
            // Debug: Check and print authentication status
            let authService = FirebaseAuthService()
            let isAuth = authService.isAuthenticated()
            print("DEBUG - Auth Check in SplashView: isAuthenticated = \(isAuth)")
            
            if let token = try? authService.keychainService.getAuthToken() {
                print("DEBUG - Auth token exists: \(token.prefix(10))...")
            } else {
                print("DEBUG - No auth token found in keychain")
            }
            
            print("DEBUG - Auth status from ViewModel: isAuthenticated = \(authViewModel.isAuthenticated)")
            
            // Automatically transition to AuthView after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeIn(duration: 0.7)) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
} 