//
//  LoginViewModel.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isAuthenticated: Bool = false
    
    // MARK: - Private Properties
    private let controller: LoginViewController
    private let userDefaultsService: UserDefaultsService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(controller: LoginViewController? = nil,
         userDefaultsService: UserDefaultsService = UserDefaultsService.shared) {
        if let controller = controller {
            self.controller = controller
        } else {
            self.controller = LoginViewController()
        }
        
        self.userDefaultsService = userDefaultsService
        
        // Load saved email if "Remember Me" was checked
        self.rememberMe = userDefaultsService.rememberMe
        if rememberMe, let savedEmail = userDefaultsService.savedEmail {
            self.email = savedEmail
            print("DEBUG - LoginViewModel: Loaded saved email: \(savedEmail)")
        }
        
        // Check if already authenticated
        Task {
            print("DEBUG - LoginViewModel: Checking authentication status")
            let isAuth = self.controller.isAuthenticated()
            print("DEBUG - LoginViewModel: isAuthenticated = \(isAuth)")
            
            if isAuth {
                print("DEBUG - LoginViewModel: User is authenticated, updating UI")
                self.isAuthenticated = true
            } else {
                print("DEBUG - LoginViewModel: User is NOT authenticated")
            }
        }
    }
    
    // MARK: - Public Methods
    func signIn() {
        isLoading = true
        
        Task {
            do {
                let publisher = controller.signIn(email: email, password: password)
                
                publisher
                    .receive(on: DispatchQueue.main)
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            self?.isLoading = false
                            
                            if case .failure(let error) = completion {
                                self?.showAlert = true
                                self?.alertMessage = error.localizedDescription
                            }
                        },
                        receiveValue: { [weak self] user in
                            self?.isLoading = false
                            // Handle successful login
                            print("User logged in: \(user.name)")
                            
                            // Save user credentials if remember me is checked
                            if let self = self {
                                if self.rememberMe {
                                    self.saveCredentials()
                                } else {
                                    self.userDefaultsService.clearLoginCredentials()
                                }
                            }
                            
                            self?.isAuthenticated = true
                            
                            // Notify the parent AuthViewModel that we're authenticated
                            if let authViewModel = self?.getAuthViewModel() {
                                authViewModel.authenticate()
                            }
                        }
                    )
                    .store(in: &cancellables)
            } catch {
                self.isLoading = false
                self.showAlert = true
                self.alertMessage = error.localizedDescription
            }
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
                            self?.showAlert = true
                            self?.alertMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { [weak self] user in
                        self?.isLoading = false
                        // Handle successful Google login
                        print("User logged in with Google: \(user.name)")
                        self?.isAuthenticated = true
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
                            self?.showAlert = true
                            self?.alertMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { [weak self] user in
                        self?.isLoading = false
                        // Handle successful Apple login
                        print("User logged in with Apple: \(user.name)")
                        self?.isAuthenticated = true
                    }
                )
                .store(in: &cancellables)
        }
    }
    
    func forgotPassword() {
        guard !email.isEmpty else {
            showAlert = true
            alertMessage = "Please enter your email address to reset your password"
            return
        }
        
        isLoading = true
        
        Task {
            let publisher = controller.resetPassword(email: email)
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        
                        if case .failure(let error) = completion {
                            self?.showAlert = true
                            self?.alertMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { [weak self] _ in
                        self?.isLoading = false
                        self?.showAlert = true
                        self?.alertMessage = "Password reset instructions have been sent to your email"
                    }
                )
                .store(in: &cancellables)
        }
    }
    
    func goToSignUp() {
        // This will be handled by the parent AuthView
        print("Navigate to sign up")
    }
    
    func goBack() {
        // Navigate back
        print("Navigate back")
    }
    
    func signOut() {
        Task {
            controller.authService.signOut()
            isAuthenticated = false
        }
    }
    
    // MARK: - Private Methods
    private func saveCredentials() {
        userDefaultsService.saveLoginCredentials(email: email)
    }
    
    // MARK: - Helper methods
    
    func setAuthViewModel(_ authViewModel: AuthViewModel) {
        // This allows the view to pass its EnvironmentObject to the view model
        print("LoginViewModel - setAuthViewModel called")
        _authViewModel = authViewModel
    }
    
    // Reference to the parent AuthViewModel
    private var _authViewModel: AuthViewModel?
    
    private func getAuthViewModel() -> AuthViewModel? {
        return _authViewModel
    }
}
