//
//  LoginViewController.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import Foundation
import Combine

@MainActor
class LoginViewController {
    // MARK: - Properties
    let authService: AuthService
    
    // MARK: - Initialization
    init(authService: AuthService? = nil) {
        if let authService = authService {
            self.authService = authService
        } else {
            self.authService = AuthService()
        }
    }
    
    // MARK: - Authentication Methods
    
    /// Signs in a user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return authService.signIn(email: email, password: password)
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
    
    /// Sends a password reset email to the specified email address
    /// - Parameter email: The email address to send the reset link to
    /// - Returns: A publisher that completes on success or emits an Error on failure
    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        return authService.resetPassword(email: email)
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
