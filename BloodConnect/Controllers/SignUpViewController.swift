//
//  SignUpViewController.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import Foundation
import Combine

@MainActor
class SignUpViewController {
    // MARK: - Properties
    let authService: AuthService
    
    // MARK: - Initialization
    init(authService: AuthService? = nil) {
        if let authService = authService {
            self.authService = authService
        } else {
            // Use Firebase Auth Service by default
            self.authService = FirebaseAuthService()
        }
    }
    
    // MARK: - Authentication Methods
    
    /// Signs up a new user
    /// - Parameters:
    ///   - name: User's name
    ///   - email: User's email address
    ///   - password: User's password
    ///   - bloodType: User's blood type (optional)
    ///   - country: User's country (optional)
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signUp(name: String, email: String, password: String, bloodType: String? = nil, country: String? = nil) -> AnyPublisher<User, Error> {
        return authService.signUp(email: email, password: password, name: name, bloodType: bloodType, country: country)
    }
    
    /// Signs in a user with Google
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signInWithGoogle() -> AnyPublisher<User, Error> {
        return authService.signInWithGoogle()
    }
    
    /// Signs in a user with Apple
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signInWithApple() -> AnyPublisher<User, Error> {
        return authService.signInWithApple()
    }
    
    /// Check if the user is authenticated
    /// - Returns: True if authenticated, false otherwise
    func isAuthenticated() -> Bool {
        return authService.isAuthenticated()
    }
    
    /// Gets the currently authenticated user, if any
    /// - Returns: A publisher that emits the current User or nil
    func getCurrentUser() -> AnyPublisher<User?, Error> {
        return authService.getCurrentUser()
    }
}

