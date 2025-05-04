import SwiftUI

struct NewSignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var showPassword = false
    @State private var showBloodTypeMenu = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, email, password, eircode, availability, phone, address, description, workingHours
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // MARK: - Header with Back Button and Logo
                        HStack {
                            // Back Button
                            Button(action: {
                                if viewModel.userType == .organization && viewModel.organizationSignUpStep == 2 {
                                    viewModel.backToBasicInfo()
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        authViewModel.showSignUp(false)
                                    }
                                }
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
                        
                        Text("Create Account")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 16)
                        
                        Text("Join BloodConnect to help save lives")
                            .font(.body)
                            .foregroundColor(Color.gray)
                            .padding(.top, 4)
                            .padding(.bottom, 16)
                        
                        // Main content based on user type and step
                        if viewModel.userType == .donor || viewModel.organizationSignUpStep == 1 {
                            basicInfoView(geometry: geometry)
                        } else if viewModel.userType == .organization && viewModel.organizationSignUpStep == 2 {
                            organizationDetailsView(geometry: geometry)
                        }
                        
                        // Add padding at the bottom for the fixed button area
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "FAF9F9"))
                
                // MARK: - Fixed Button Area
                VStack(spacing: 8) {
                    // MARK: - Submit/Next/Create Account Button
                    Button(action: viewModel.signUp) {
                        ZStack {
                            Rectangle()
                                .fill(Color(hex: "E6134C"))
                                .frame(height: 56)
                                .cornerRadius(12)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(viewModel.userType == .donor ? "Submit" : 
                                        (viewModel.userType == .organization && viewModel.organizationSignUpStep == 1) ? "Next" : "Create Account")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(viewModel.isLoading)
                    
                    // Already have an account - only show on step 1
                    if (viewModel.userType == .donor || viewModel.organizationSignUpStep == 1) {
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    authViewModel.showSignUp(false)
                                }
                            }) {
                                Text("Sign In")
                                    .foregroundColor(Color(hex: "E6134C"))
                                    .font(.system(size: 15, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .background(
                    Rectangle()
                        .fill(Color(hex: "FAF9F9"))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -4)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Basic Info View (Step 1)
    private func basicInfoView(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - User Type Selection
            HStack(spacing: 10) {
                // Donor Button
                Button(action: {
                    withAnimation {
                        viewModel.userType = .donor
                    }
                }) {
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(viewModel.userType == .donor ? .white : Color(hex: "E6134C"))
                            .font(.system(size: 16))
                        Text("Blood Donor")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(viewModel.userType == .donor ? Color(hex: "E6134C") : .white)
                    .foregroundColor(viewModel.userType == .donor ? .white : .black)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: viewModel.userType == .donor ? 0 : 1)
                    )
                }
                
                // Organization Button
                Button(action: {
                    withAnimation {
                        viewModel.userType = .organization
                    }
                }) {
                    HStack {
                        Image(systemName: "building.2")
                            .foregroundColor(viewModel.userType == .organization ? .white : Color(hex: "E6134C"))
                            .font(.system(size: 16))
                        Text("Organization")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(viewModel.userType == .organization ? Color(hex: "E6134C") : .white)
                    .foregroundColor(viewModel.userType == .organization ? .white : .black)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: viewModel.userType == .organization ? 0 : 1)
                    )
                }
            }
            .padding(.bottom, 16)
            
            // Full Name
            Text("Full Name")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                    .font(.system(size: 18))
                
                TextField("", text: $viewModel.name)
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .font(.system(size: 16))
                    .focused($focusedField, equals: .name)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.bottom, 16)
            
            // Email
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
                    .focused($focusedField, equals: .email)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.bottom, 16)
            
            // Password
            Text("Password (minimum 8 characters)")
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
                        .focused($focusedField, equals: .password)
                } else {
                    SecureField("", text: $viewModel.password)
                        .foregroundColor(.black)
                        .padding(.vertical, 16)
                        .font(.system(size: 16))
                        .focused($focusedField, equals: .password)
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
            
            // Eircode
            Text("Eircode")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            HStack {
                TextField("A65 F4E2", text: $viewModel.eircode)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .font(.system(size: 16))
                    .background(Color.white)
                    .textContentType(.postalCode)
                    .autocapitalization(.allCharacters)
                    .focused($focusedField, equals: .eircode)
                
                Button(action: viewModel.validateEircode) {
                    Text("Validate")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(hex: "E6134C"))
                        .cornerRadius(8)
                }
                .padding(.trailing, 12)
                .disabled(viewModel.eircode.isEmpty || viewModel.isProcessingEircode)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.bottom, 8)
            
            // Show address from Eircode if validated
            if viewModel.eircodeValidated && !viewModel.address.isEmpty {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.green)
                        .font(.system(size: 12))
                    
                    Text(viewModel.address)
                        .font(.caption)
                        .foregroundColor(.black)
                        .lineLimit(2)
                }
                .padding(.top, 4)
                .padding(.bottom, 12)
            } else {
                Spacer().frame(height: 6)
            }
            
            // Blood Type (only for donors)
            if viewModel.userType == .donor {
                Text("Blood Type")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
                Menu {
                    ForEach(BloodType.allCases, id: \.self) { type in
                        Button(action: {
                            viewModel.bloodType = type
                        }) {
                            Text(type.displayName)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.bloodType.displayName)
                            .foregroundColor(.black)
                            .padding(.leading, 16)
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                            .padding(.trailing, 16)
                            .font(.system(size: 18))
                    }
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.bottom, 16)
                
                // Availability for donors
                Text("Availability")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
                HStack {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .font(.system(size: 18))
                    
                    TextField("e.g., Weekends, Evenings, Anytime", text: $viewModel.availability)
                        .foregroundColor(.black)
                        .padding(.vertical, 16)
                        .font(.system(size: 16))
                        .focused($focusedField, equals: .availability)
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.bottom, 16)
            }
            
            // Terms and conditions
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    viewModel.agreedToTerms.toggle()
                }
            }) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(viewModel.agreedToTerms ? Color(hex: "E6134C") : Color.gray.opacity(0.5), lineWidth: 1.5)
                            .frame(width: 20, height: 20)
                        
                        if viewModel.agreedToTerms {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: "E6134C"))
                                .frame(width: 20, height: 20)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text("I agree to the Terms and Conditions")
                        .foregroundColor(.black)
                        .font(.subheadline)
                }
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Organization Details View (Step 2)
    private func organizationDetailsView(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Organization Phone Number
            Text("Organization Phone Number")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "phone")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                    .font(.system(size: 18))
                
                TextField("", text: $viewModel.phoneNumber)
                    .foregroundColor(.black)
                    .keyboardType(.phonePad)
                    .padding(.vertical, 16)
                    .font(.system(size: 16))
                    .focused($focusedField, equals: .phone)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.bottom, 16)
            
            // Organization Address
            Text("Organization Address")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "building.2")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                    .font(.system(size: 18))
                
                TextField("", text: $viewModel.address)
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .font(.system(size: 16))
                    .focused($focusedField, equals: .address)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .disabled(viewModel.eircodeValidated)
            .padding(.bottom, 16)
            
            // Organization Description
            Text("Organization Description")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            VStack {
                TextEditor(text: $viewModel.organizationDescription)
                    .foregroundColor(.black)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color(hex: "FFFFFF"))
                    .font(.system(size: 16))
                    .focused($focusedField, equals: .description)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.bottom, 16)
            
            // Working Hours
            Text("Working Hours")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                    .font(.system(size: 18))
                
                TextField("e.g., Mon-Fri 9:00 AM - 5:00 PM", text: $viewModel.workingHours)
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .font(.system(size: 16))
                    .focused($focusedField, equals: .workingHours)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.bottom, 16)
        }
    }
}
