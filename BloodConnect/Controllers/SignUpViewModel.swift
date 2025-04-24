import SwiftUI
import Combine


enum UserType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case donor = "Donor"
    case center = "Donation Center"
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
    @Published var agreedToTerms: Bool = false
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var userType: UserType = .donor
    @Published var workingHours: String = ""
    @Published var availability: String = ""
    @Published var address: String = ""
    @Published var latitude: Double?
    @Published var longitude: Double?

    // MARK: - Private
    private let controller: SignUpViewController
    private let userDefaultsService: UserDefaultsService
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

    // MARK: - Actions
    func signUp() {
        guard !name.isEmpty else {
            showAlertWith("Please enter your name.")
            return
        }

        guard !email.isEmpty, email.contains("@") else {
            showAlertWith("Please enter a valid email address.")
            return
        }

        guard password.count >= 6 else {
            showAlertWith("Password must be at least 6 characters.")
            return
        }

        guard !county.isEmpty else {
            showAlertWith("Please select your county.")
            return
        }

        guard agreedToTerms else {
            showAlertWith("Please agree to the terms and conditions.")
            return
        }
        
        if userType == .donor {
                   guard !availability.isEmpty else {
                       showAlertWith("Please enter your availability.")
                       return
                   }
               } else {
                   guard !workingHours.isEmpty else {
                       showAlertWith("Please enter the center's working hours.")
                       return
                   }

                   guard !address.isEmpty else {
                       showAlertWith("Please enter the center's address.")
                       return
                   }
               }
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
                workingHours: userType == .center ? workingHours : nil,
                address: userType == .center ? address : nil
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
}
