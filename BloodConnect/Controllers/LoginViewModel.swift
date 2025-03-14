//
//  LoginViewModel.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // MARK: - Private Properties
    private let controller: LoginViewController
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(controller: LoginViewController = LoginViewController()) {
        self.controller = controller
    }
    
    // MARK: - Public Methods
    func signIn() {
        isLoading = true
        
        controller.signIn(email: email, password: password)
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
                    if self?.rememberMe == true {
                        self?.saveCredentials()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func signInWithGoogle() {
        isLoading = true
        
        controller.signInWithGoogle()
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
                }
            )
            .store(in: &cancellables)
    }
    
    func signInWithApple() {
        isLoading = true
        
        controller.signInWithApple()
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
                }
            )
            .store(in: &cancellables)
    }
    
    func forgotPassword() {
        guard !email.isEmpty else {
            showAlert = true
            alertMessage = "Please enter your email address to reset your password"
            return
        }
        
        isLoading = true
        
        controller.resetPassword(email: email)
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
    
    func goToSignUp() {
        // Navigate to sign up screen
        print("Navigate to sign up")
    }
    
    func goBack() {
        // Navigate back
        print("Navigate back")
    }
    
    // MARK: - Private Methods
    private func saveCredentials() {
        // Save credentials to UserDefaults or Keychain
        print("Saving credentials for \(email)")
    }
}
