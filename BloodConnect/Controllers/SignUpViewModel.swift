import SwiftUI
import Combine
import CoreLocation


enum UserType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case donor = "donor"
    case organization = "organization"
}

@MainActor
class SignUpViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var bloodType: BloodType = .bPositive
    @Published var county: String = ""
    @Published var eircode: String = ""
    @Published var isProcessingEircode: Bool = false
    @Published var eircodeValidated: Bool = false
    @Published var agreedToTerms: Bool = false
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var userType: UserType = .donor
    @Published var availability: String = ""
    @Published var address: String = ""
    @Published var phoneNumber: String = ""
    @Published var organizationDescription: String = ""
    @Published var workingHours: String = ""
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var organizationSignUpStep: Int = 1 // 1 = basic info, 2 = organization details

    // MARK: - Private
    private let controller: SignUpViewController
    private let userDefaultsService: UserDefaultsService
    private let eircodeService = EircodeService.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(controller: SignUpViewController? = nil,
         userDefaultsService: UserDefaultsService = UserDefaultsService.shared) {
        self.userDefaultsService = userDefaultsService
        
        if let controller = controller {
            self.controller = controller
        } else {
            self.controller = SignUpViewController()
        }
        
        // Check if already authenticated
        Task {
            if self.controller.isAuthenticated() {
                self.isAuthenticated = true
            }
        }
    }

    // Validate and process Eircode
    func validateEircode() {
        // Skip if Eircode is empty
        guard !eircode.isEmpty else {
            return
        }
        
        // Skip if already processing
        guard !isProcessingEircode else {
            return
        }
        
        // Format Eircode if needed (add space after first 3 characters if missing)
        let formattedEircode = formatEircode(eircode)
        if formattedEircode != eircode {
            eircode = formattedEircode
        }
        
        // Basic format validation
        guard eircodeService.isValidEircode(eircode) else {
            showAlertWith("Please enter a valid Eircode format (e.g., A65 F4E2)")
            return
        }
        
        isProcessingEircode = true
        
        eircodeService.geocodeEircode(eircode)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isProcessingEircode = false
                    if case .failure(let error) = completion {
                        self?.showAlertWith("Could not find address for this Eircode: \(error.localizedDescription)")
                        self?.eircodeValidated = false
                    }
                },
                receiveValue: { [weak self] result in
                    self?.isProcessingEircode = false
                    self?.eircodeValidated = true
                    
                    // Set address and coordinates
                    self?.address = result.address
                    self?.latitude = result.coordinates.latitude
                    self?.longitude = result.coordinates.longitude
                    
                    // Try to extract county from the address
                    if self?.county.isEmpty ?? true {
                        let addressComponents = result.address.components(separatedBy: ", ")
                        if let countyComponent = addressComponents.last(where: { 
                            ["Louth", "Dublin", "Cork", "Galway", "Limerick", "Waterford", "Kerry", "Wicklow", "Meath", "Kildare", "Tipperary", "Clare", "Kilkenny", "Wexford", "Sligo", "Donegal", "Cavan", "Monaghan", "Laois", "Offaly", "Longford", "Westmeath", "Leitrim", "Roscommon", "Mayo", "Carlow"].contains($0) 
                        }) {
                            self?.county = countyComponent
                        }
                    }
                    
                    print("Eircode validated: \(result.address)")
                }
            )
            .store(in: &cancellables)
    }
    
    // Format an Eircode to standard format (XXX XXXX)
    private func formatEircode(_ code: String) -> String {
        // Remove any existing spaces
        let cleaned = code.replacingOccurrences(of: " ", with: "").uppercased()
        
        // Make sure it's at least 7 characters
        guard cleaned.count >= 7 else {
            return code
        }
        
        // Insert space after first 3 characters
        let index = cleaned.index(cleaned.startIndex, offsetBy: 3)
        return cleaned[..<index] + " " + cleaned[index...]
    }

    // MARK: - Actions
    func signUp() {
        if userType == .organization && organizationSignUpStep == 1 {
            advanceToOrganizationDetails()
            return
        }
        
        // For individual users or organizations at step 2
        if userType == .donor {
            guard validateBasicInfo() else {
                return
            }
            
            guard !availability.isEmpty else {
                showAlertWith("Please enter your availability")
                return
            }
        } else { // organization at step 2
            guard !phoneNumber.isEmpty else {
                showAlertWith("Please enter a contact phone number")
                return
            }
            
            guard !address.isEmpty else {
                showAlertWith("Please enter your organization address")
                return
            }
            
            guard !organizationDescription.isEmpty else {
                showAlertWith("Please enter a brief description of your organization")
                return
            }
            
            guard !workingHours.isEmpty else {
                showAlertWith("Please enter your organization's working hours")
                return
            }
        }
        
        proceedWithSignUp()
    }

    func signInWithGoogle() {
        isLoading = true

        Task {
            let publisher = controller.signInWithGoogle()
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.showAlertWith(error.localizedDescription)
                        }
                    },
                    receiveValue: { [weak self] user in
                        print("Signed up with Google: \(user.name)")
                        self?.isAuthenticated = true
                        
                        // Update last open date in UserDefaults
                        self?.userDefaultsService.lastOpenDate = Date()
                        
                        // Set onboarding as incomplete for new user
                        self?.userDefaultsService.onboardingCompleted = false
                    }
                )
                .store(in: &cancellables)
        }
    }

    func signInWithApple() {
        isLoading = true

        Task {
            let publisher = controller.signInWithApple()
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.showAlertWith(error.localizedDescription)
                        }
                    },
                    receiveValue: { [weak self] user in
                        print("Signed up with Apple: \(user.name)")
                        self?.isAuthenticated = true
                        
                        // Update last open date in UserDefaults
                        self?.userDefaultsService.lastOpenDate = Date()
                        
                        // Set onboarding as incomplete for new user
                        self?.userDefaultsService.onboardingCompleted = false
                    }
                )
                .store(in: &cancellables)
        }
    }

    func goToSignIn() {
        print("Navigate to sign in")
    }
    
    func signOut() {
        Task {
            controller.authService.signOut()
            isAuthenticated = false
        }
    }

    // MARK: - Helpers
    private func showAlertWith(_ message: String) {
        alertMessage = message
        showAlert = true
    }

    // MARK: - Helper methods
    func setAuthViewModel(_ authViewModel: AuthViewModel) {
        // This allows the view to pass its EnvironmentObject to the view model
        _authViewModel = authViewModel
    }
    
    // Reference to the parent AuthViewModel
    private var _authViewModel: AuthViewModel?
    
    private func getAuthViewModel() -> AuthViewModel? {
        return _authViewModel
    }

    private func proceedWithSignUp() {
        isLoading = true
        
        Task {
            let publisher = controller.signUp(
                name: name,
                email: email,
                password: password,
                bloodType: bloodType.rawValue,
                county: county,
                userType: userType.rawValue,
                availability: userType == .donor ? availability : nil,
                address: address,
                latitude: latitude,
                longitude: longitude,
                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                organizationDescription: userType == .organization ? organizationDescription : nil,
                workingHours: userType == .organization ? workingHours : nil,
                eircode: eircode
            )
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.showAlertWith(error.localizedDescription)
                        }
                    },
                    receiveValue: { [weak self] user in
                        print("User signed up: \(user.name)")
                        self?.isAuthenticated = true
                        
                        // Update last open date in UserDefaults
                        self?.userDefaultsService.lastOpenDate = Date()
                        
                        // Set onboarding as incomplete for new user
                        self?.userDefaultsService.onboardingCompleted = false
                        
                        // Notify the AuthViewModel that we're authenticated
                        if let authViewModel = self?.getAuthViewModel() {
                            authViewModel.authenticate()
                        }
                    }
                )
                .store(in: &cancellables)
        }
    }

    // Function to advance to the next organization sign-up step
    func advanceToOrganizationDetails() {
        guard validateBasicInfo() else {
            return
        }
        
        organizationSignUpStep = 2
    }
    
    // Validate basic information (common for both user types)
    private func validateBasicInfo() -> Bool {
        guard !name.isEmpty else {
            showAlertWith("Please enter your name")
            return false
        }
        
        guard !email.isEmpty else {
            showAlertWith("Please enter your email")
            return false
        }
        
        guard email.isValidEmail() else {
            showAlertWith("Please enter a valid email")
            return false
        }
        
        guard !password.isEmpty else {
            showAlertWith("Please enter a password")
            return false
        }
        
        guard password.count >= 8 else {
            showAlertWith("Password must be at least 8 characters")
            return false
        }
        
        guard !eircode.isEmpty else {
            showAlertWith("Please enter your Eircode")
            return false
        }
        
        guard agreedToTerms else {
            showAlertWith("Please agree to the terms and conditions")
            return false
        }
        
        // If Eircode validation is pending, trigger it
        if !eircodeValidated && !isProcessingEircode {
            validateEircode()
            return false
        }
        
        return true
    }

    // Add a function to go back to step 1 for organizations
    func backToBasicInfo() {
        if userType == .organization && organizationSignUpStep == 2 {
            organizationSignUpStep = 1
        }
    }
}
