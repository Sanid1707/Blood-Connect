//
//  LoginViewController.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import SwiftUI
import Combine

class LoginViewController {
    private let authService: AuthService
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        // Validate inputs
        guard !email.isEmpty else {
            return Fail(error: AuthError.emptyEmail).eraseToAnyPublisher()
        }
        
        guard !password.isEmpty else {
            return Fail(error: AuthError.emptyPassword).eraseToAnyPublisher()
        }
        
        // Call auth service
        return authService.signIn(email: email, password: password)
    }
    
    func signInWithGoogle() -> AnyPublisher<User, Error> {
        return authService.signInWithGoogle()
    }
    
    func signInWithApple() -> AnyPublisher<User, Error> {
        return authService.signInWithApple()
    }
    
    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        guard !email.isEmpty else {
            return Fail(error: AuthError.emptyEmail).eraseToAnyPublisher()
        }
        
        return authService.resetPassword(email: email)
    }
}

enum AuthError: Error, LocalizedError {
    case emptyEmail
    case emptyPassword
    case invalidCredentials
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Please enter your email address"
        case .emptyPassword:
            return "Please enter your password"
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error. Please try again"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
