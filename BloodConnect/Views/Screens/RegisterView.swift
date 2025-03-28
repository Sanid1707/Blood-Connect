//import SwiftUI
//
//struct RegisterView: View {
//    // MARK: - State
//    @StateObject private var viewModel = RegisterViewModel()
//    @Environment(\.colorScheme) var colorScheme
//    
//    var body: some View {
//        ZStack {
//            // Background with gradient
//            LinearGradient(
//                gradient: Gradient(colors: [Color.white, Color(hex: "FFEEF1")]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            // Blood drop pattern (subtle background)
//            GeometryReader { geo in
//                VStack(spacing: geo.size.height / 20) {
//                    ForEach(0..<5) { row in
//                        HStack(spacing: geo.size.width / 10) {
//                            ForEach(0..<4) { col in
//                                Image(systemName: "drop.fill")
//                                    .foregroundColor(AppColor.primaryRed.opacity(0.03))
//                                    .rotationEffect(.degrees(180))
//                                    .offset(x: CGFloat((col % 2) * 10), y: CGFloat((row % 2) * 10))
//                            }
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            .ignoresSafeArea()
//            
//            // Main content
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading, spacing: 16) {
//                    
//                    // MARK: - Back Button
//                    Button(action: {
//                        viewModel.goBack()
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .font(.title3)
//                            .foregroundColor(.black)
//                            .padding(10)
//                            .background(Color.white.opacity(0.8))
//                            .clipShape(Circle())
//                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//                    }
//                    .padding(.top, 8)
//                    
//                    // MARK: - Logo and Title
//                    VStack(alignment: .leading, spacing: 6) {
//                        HStack {
//                            Image(systemName: "drop.fill")
//                                .font(.title)
//                                .foregroundColor(AppColor.primaryRed)
//                            
//                            Text("BloodConnect")
//                                .font(.title3)
//                                .fontWeight(.bold)
//                                .foregroundColor(AppColor.primaryRed)
//                        }
//                        .padding(.bottom, 8)
//                        
//                        Text("Sign Up Your Account!")
//                            .font(Typography.title)
//                            .foregroundColor(.black)
//                        
//                        Text("Welcome to Blood Connect! Create a new account to continue")
//                            .font(Typography.caption)
//                            .foregroundColor(.gray)
//                            .padding(.bottom, 5)
//                    }
//                    .padding(.top, 10)
//                    
//                    // MARK: - Text Fields
//                    VStack(spacing: 16) {
//                        // Email field
//                        CustomTextField(
//                            placeholder: "Name",
//                            text: $viewModel.name,
//                            icon:"person.fill"
//                         
//                        )
//                        CustomTextField(
//                            placeholder: "Email",
//                            text: $viewModel.email,
//                            icon:"envelope.fill"
//                         
//                        )
//                        
//                        // Password field
//                        CustomTextField(
//                            placeholder: "Password",
//                            text: $viewModel.password,
//                            isSecure: true,
//                            icon: "lock.fill"
//                        )
//                        CustomTextField(
//                            placeholder: "Confirm Password",
//                            text: $viewModel.confirmPassword,
//                            isSecure: true,
//                            icon: "lock.fill"
//                        )
//                        CustomTextField(
//                            placeholder: "Blood Group",
//                            text: $viewModel.bloodGroup,
//                            icon: "drop.fill"
//                        )
//                        CustomTextField(
//                            placeholder: "Country",
//                            text: $viewModel.country,
//                            icon: "globe"
//                        )
//                        
//                                               
//                        
//                    }
//                    .padding(.top, 8)
//                    
//                    // MARK: - Remember Me & Forgot Password
//                    HStack {
//                        // Remember Me toggle with animation
//                        Button(action: {
//                            viewModel.agreeToTerms.toggle()
//                        })
//                        {
//                            HStack(spacing:6)
//                            {
//                                Image(systemName: viewModel.agreeToTerms ?  "checkmark.square.fill": "square" )
//                                    .foregroundColor(viewModel.agreeToTerms ? AppColor.primaryRed : .gray)
//                                Text("I agree to the terms & conditions")
//                                    .foregroundColor(   .black)
//                                    .font(.footnote)
//                            }
//                        }
//                    }
//                    .padding(.top, 4)
//                    
//                    // MARK: - Sign In Button
//                    CustomButton(
//                        title: "Sign Up",
//                        action: viewModel.signIn,
//                        isLoading: viewModel.isLoading,
//                        height: 50
//                    )
//                    .padding(.top, 16)
//                    
//                    // MARK: - OR Divider
//                    HStack {
//                        Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(.gray.opacity(0.3))
//                        
//                        Text("Or")
//                            .foregroundColor(.gray)
//                            .font(Typography.footnote)
//                            .padding(.horizontal, 8)
//                        
//                        Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(.gray.opacity(0.3))
//                    }
//                    .padding(.vertical, 16)
//                    
//                   
//                    VStack(spacing: 12) {
//                        // Google Sign In Button
//                        SocialLoginButton(provider: .google) {
//                            viewModel.signUpWithGoogle()
//                        }
//                        
//                        // Apple Sign In Button
//                        SocialLoginButton(provider: .apple) {
//                            viewModel.signUpWithApple()
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    
//                    // MARK: - Sign Up Link
//                    HStack {
//                        Text("Already have an account?")
//                            .foregroundColor(.gray)
//                            .font(Typography.footnote)
//                        
//                        Button(action: {
//                            viewModel.goToSignUp()
//                        }) {
//                            Text("Sign In")
//                                .foregroundColor(AppColor.primaryRed)
//                                .font(Typography.captionBold)
//                                .underline()
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.top, 16)
//                    .padding(.bottom, 8)
//                }
//                .padding(.horizontal, 24)
//                .padding(.top, 8)
//                .padding(.bottom, 20)
//            }
//            .safeAreaInset(edge: .bottom) {
//                // Add a small spacer at the bottom to ensure content isn't cut off
//                Color.clear.frame(height: 10)
//            }
//            
//            // Show alert if there's an error
//            .alert(isPresented: $viewModel.showAlert) {
//                Alert(
//                    title: Text("Error"),
//                    message: Text(viewModel.alertMessage),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//#Preview {
//    RegisterView()
//}
