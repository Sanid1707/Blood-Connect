import SwiftUI

struct AuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            if authViewModel.isAuthenticated {
                MainView()
                    .transition(.opacity)
            } else {
                if authViewModel.showingSignUp {
                    SignUpView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                        .environmentObject(authViewModel)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width > 100 {
                                        withAnimation {
                                            authViewModel.showSignUp(false)
                                        }
                                    }
                                }
                        )
                } else {
                    LoginView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)
                        ))
                        .environmentObject(authViewModel)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < -100 {
                                        withAnimation {
                                            authViewModel.showSignUp(true)
                                        }
                                    }
                                }
                        )
                }
            }
        }
    }
}

// AuthViewModel to coordinate between LoginView and SignUpView
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showingSignUp = false
    
    func showSignUp(_ show: Bool) {
        withAnimation {
            showingSignUp = show
        }
    }
    
    func authenticate() {
        withAnimation {
            isAuthenticated = true
        }
    }
    
    func logout() {
        withAnimation {
            isAuthenticated = false
        }
    }
}

#Preview {
    AuthView()
} 