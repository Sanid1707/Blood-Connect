import SwiftUI

struct AuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(hex: "FFEEF1")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if authViewModel.isAuthenticated {
                MainView()
                    .transition(.opacity)
            } else {
                ZStack {
                    // Login view is always present but may be hidden
                    LoginView()
                        .environmentObject(authViewModel)
                        .opacity(authViewModel.showingSignUp ? 0 : 1)
                        .zIndex(0)
                    
                    // Sign up view slides in when needed
                    if authViewModel.showingSignUp {
                        NewSignUpView()
                            .environmentObject(authViewModel)
                            .transition(.move(edge: .trailing))
                            .zIndex(1)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: authViewModel.showingSignUp)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: authViewModel.isAuthenticated)
        .onAppear {
            // Double-check authentication status when this view appears
            print("DEBUG - AuthView appeared, checking authentication")
            let authService = FirebaseAuthService()
            if authService.isAuthenticated() && !authViewModel.isAuthenticated {
                print("DEBUG - AuthView found user is authenticated, updating UI")
                authViewModel.authenticate()
            }
        }
    }
}

// AuthViewModel to coordinate between LoginView and SignUpView
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showingSignUp = false
    
    func showSignUp(_ show: Bool) {
        print("AuthViewModel - showSignUp called with show=\(show)")
        // Don't re-animate if already in the desired state
        if showingSignUp != show {
            withAnimation(.easeInOut(duration: 0.3)) {
            showingSignUp = show
            }
        }
    }
    
    func authenticate() {
        print("AuthViewModel - authenticate called")
        withAnimation {
            isAuthenticated = true
        }
    }
    
    func logout() {
        print("AuthViewModel - logout called")
        withAnimation {
            isAuthenticated = false
        }
    }
}

#Preview {
    AuthView()
} 