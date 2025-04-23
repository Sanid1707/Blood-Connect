import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()

    let countries = ["Louth", "Dublin", "Meath", "Westmeath"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Back Button
                Button(action: {
                    viewModel.goToSignIn()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
              
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
                    

                // Title & Subtitle
                Text("Sign Up Your Account")
                    .font(.system(size: 22, weight: .bold))

                Text("Create an account to Get Started ")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

                // Full Name
                TextField("David John", text: $viewModel.name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                // Email
                TextField("davidjohn172@gmail.com", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                // Password
                HStack {
                    if viewModel.showPassword {
                        TextField("15#@aa09", text: $viewModel.password)
                    } else {
                        SecureField("15#@aa09", text: $viewModel.password)
                    }

                    Button(action: {
                        viewModel.showPassword.toggle()
                    }) {
                        Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                // Blood Type Picker
                Menu {
                    ForEach(BloodType.allCases, id: \.self) { type in
                        Button(type.displayName) {
                            viewModel.bloodType = type
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.bloodType.displayName)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }

                // Country Picker
                Menu {
                    ForEach(countries, id: \.self) { country in
                        Button(country) {
                            viewModel.country = country
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.country.isEmpty ? "Select County" : viewModel.country)
                            .foregroundColor(viewModel.country.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }

                // Terms Agreement
                HStack(spacing: 8) {
                    Button(action: {
                        viewModel.agreedToTerms.toggle()
                    }) {
                        Image(systemName: viewModel.agreedToTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(AppColor.primaryRed)
                    }

                    Text("I agree to the terms & conditions")
                        .font(.system(size: 14))
                }
                .padding(.top, 10)

                // Sign Up Button
                Button(action: {
                    viewModel.signUp()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColor.primaryRed)
                            .cornerRadius(10)
                    } else {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColor.primaryRed)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)

                // OR Divider
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("Or")
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }

                // Social Buttons
                VStack {
                    HStack(spacing: 10) {
                        Button(action: {
                            viewModel.signInWithGoogle()
                        }) {
                            Image("google-icon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        Button(action: {
                            viewModel.signInWithApple()
                        }) {
                            Image("facebook-icon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity) // Stretch to fill available width
                    .multilineTextAlignment(.center) // Optional if you're using text
                    .padding()
                    .background(Color.clear) // Optional
                }


                // Sign In Footer
                HStack(spacing: 4) {
                    Text("Already Have An Account?")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))

                    Button(action: {
                        viewModel.goToSignIn()
                    }) {
                        Text("Sign In")
                            .foregroundColor(AppColor.primaryRed)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Oops!"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    SignUpView()
}
