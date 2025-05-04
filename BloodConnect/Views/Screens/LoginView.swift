import SwiftUI

struct LoginView: View {
    // MARK: - State
    @StateObject private var viewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showPassword = false
    
    init() {
        // Initialize the view model on the main actor
        _viewModel = StateObject(wrappedValue: { @MainActor in 
            return LoginViewModel()
        }())
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    // Back Button
                    Button(action: {
                        viewModel.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    
                    Spacer()
                    
                    // Logo
                    HStack(spacing: 8) {
                        Image(systemName: "drop.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "E6134C"))
                        
                        Text("BloodConnect")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "E6134C"))
                    }
                    
                    Spacer()
                }
                .padding(.top, 16)
                
                Text("Sign In")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 16)
                
                Text("Welcome back! Please enter your details")
                    .font(.body)
                    .foregroundColor(Color.gray)
                    .padding(.top, 4)
                    .padding(.bottom, 24)
                
                // MARK: - Email Field
                Text("Email Address")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .font(.system(size: 18))
                    
                    TextField("", text: $viewModel.email)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.vertical, 16)
                        .font(.system(size: 16))
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.bottom, 16)
                
                // MARK: - Password Field
                Text("Password")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .font(.system(size: 18))
                    
                    if showPassword {
                        TextField("", text: $viewModel.password)
                            .foregroundColor(.black)
                            .padding(.vertical, 16)
                            .font(.system(size: 16))
                    } else {
                        SecureField("", text: $viewModel.password)
                            .foregroundColor(.black)
                            .padding(.vertical, 16)
                            .font(.system(size: 16))
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                            .padding(.trailing, 16)
                            .font(.system(size: 18))
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.bottom, 16)
                
                // MARK: - Remember Me & Forgot Password
                HStack {
                    // Remember Me toggle
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.rememberMe.toggle()
                        }
                    }) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.rememberMe ? Color(hex: "E6134C") : Color.white)
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Circle()
                                            .stroke(viewModel.rememberMe ? Color(hex: "E6134C") : Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                                
                                if viewModel.rememberMe {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Text("Remember Me")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.forgotPassword()
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(Color(hex: "E6134C"))
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                // MARK: - Sign In Button
                Button(action: viewModel.signIn) {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: "E6134C"))
                            .frame(height: 56)
                            .cornerRadius(12)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign In")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(viewModel.isLoading)
                .padding(.bottom, 16)
                
                // MARK: - Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            authViewModel.showSignUp(true)
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(Color(hex: "E6134C"))
                            .font(.system(size: 15, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "FAF9F9"))
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.setAuthViewModel(authViewModel)
            }
        }
    }
}

#Preview {
    LoginView()
}
