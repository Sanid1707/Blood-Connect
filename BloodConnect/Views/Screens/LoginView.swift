import SwiftUI

struct LoginView: View {
    // MARK: - State
    @StateObject private var viewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {
        // Initialize the view model on the main actor
        _viewModel = StateObject(wrappedValue: { @MainActor in 
            return LoginViewModel()
        }())
    }
    
    var body: some View {
        ZStack {
            // Background with gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(hex: "FFEEF1")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Blood drop pattern (subtle background)
            GeometryReader { geo in
                VStack(spacing: geo.size.height / 20) {
                    ForEach(0..<5) { row in
                        HStack(spacing: geo.size.width / 10) {
                            ForEach(0..<4) { col in
                                Image(systemName: "drop.fill")
                                    .foregroundColor(AppColor.primaryRed.opacity(0.03))
                                    .rotationEffect(.degrees(180))
                                    .offset(x: CGFloat((col % 2) * 10), y: CGFloat((row % 2) * 10))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea()
            
            // Main content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - Back Button
                    Button(action: {
                        viewModel.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.top, 8)
                    
                    // MARK: - Logo and Title
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "drop.fill")
                                .font(.title)
                                .foregroundColor(AppColor.primaryRed)
                            
                            Text("BloodConnect")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppColor.primaryRed)
                        }
                        .padding(.bottom, 8)
                        
                        Text("Sign In")
                            .font(Typography.title)
                            .foregroundColor(.black)
                        
                        Text("Welcome back! Please enter your details")
                            .font(Typography.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                    }
                    .padding(.top, 10)
                    
                    // MARK: - Text Fields
                    VStack(spacing: 16) {
                        // Email field
                        CustomTextField(
                            placeholder: "Email Address",
                            text: $viewModel.email,
                            icon: "envelope.fill"
                        )
                        
                        // Password field
                        CustomTextField(
                            placeholder: "Password",
                            text: $viewModel.password,
                            isSecure: true,
                            icon: "lock.fill"
                        )
                    }
                    .padding(.top, 8)
                    
                    // MARK: - Remember Me & Forgot Password
                    HStack {
                        // Remember Me toggle with animation
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.rememberMe.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(viewModel.rememberMe ? AppColor.primaryRed : Color.gray, lineWidth: 1.5)
                                        .frame(width: 18, height: 18)
                                    
                                    if viewModel.rememberMe {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(AppColor.primaryRed)
                                            .frame(width: 18, height: 18)
                                        
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Text("Remember Me")
                                    .foregroundColor(.black)
                                    .font(Typography.footnote)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.forgotPassword()
                        }) {
                            Text("Forgot Password?")
                                .foregroundColor(AppColor.primaryRed)
                                .font(Typography.footnote)
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.top, 4)
                    
                    // MARK: - Sign In Button
                    CustomButton(
                        title: "Sign In",
                        action: viewModel.signIn,
                        isLoading: viewModel.isLoading,
                        height: 50
                    )
                    .padding(.top, 16)
                    
                    // MARK: - OR Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("Or continue with")
                            .foregroundColor(.gray)
                            .font(Typography.footnote)
                            .padding(.horizontal, 8)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .padding(.vertical, 16)
                    
                    // MARK: - Social Logins
                    VStack(spacing: 12) {
                        // Google Sign In Button
                        SocialLoginButton(provider: .google) {
                            viewModel.signInWithGoogle()
                        }
                        
                        // Apple Sign In Button
                        SocialLoginButton(provider: .apple) {
                            viewModel.signInWithApple()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // MARK: - Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                            .font(Typography.footnote)
                        
                        Button(action: {
                            withAnimation {
                                // Switch to sign up view in parent AuthView
                                authViewModel.showSignUp(true)
                            }
                        }) {
                            Text("Sign Up")
                                .foregroundColor(AppColor.primaryRed)
                                .font(Typography.captionBold)
                                .underline()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .safeAreaInset(edge: .bottom) {
                // Add a small spacer at the bottom to ensure content isn't cut off
                Color.clear.frame(height: 10)
            }
            
            // Show alert if there's an error
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Pass the authViewModel to the LoginViewModel
            viewModel.setAuthViewModel(authViewModel)
        }
    }
}

#Preview {
    LoginView()
}
