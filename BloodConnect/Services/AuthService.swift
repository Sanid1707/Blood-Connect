//
//  AuthService.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import Foundation
import Combine

class AuthService {
    // MARK: - Properties
    private let networkManager: NetworkManager
    
    // MARK: - Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: - Authentication Methods
    
    /// Signs in a user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        // In a real app, this would make a network request to your authentication API
        // For now, we'll simulate a successful login with a delay
        
        return Future<User, Error> { promise in
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Validate credentials (this is just a simple example)
                if email.lowercased() == "test@example.com" && password == "password" {
                    // Create a mock user
                    let user = User(
                        id: "user123",
                        email: email,
                        name: "Test User",
                        phoneNumber: "+1234567890",
                        bloodType: .aPositive,
                        lastDonationDate: Date().addingTimeInterval(-60*60*24*30), // 30 days ago
                        donationCount: 5
                    )
                    promise(.success(user))
                } else {
                    promise(.failure(AuthError.invalidCredentials))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs in a user with Google
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signInWithGoogle() -> AnyPublisher<User, Error> {
        // In a real app, this would integrate with Google Sign-In SDK
        // For now, we'll simulate a successful login with a delay
        
        return Future<User, Error> { promise in
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Create a mock user
                let user = User(
                    id: "google123",
                    email: "google@example.com",
                    name: "Google User",
                    phoneNumber: nil,
                    bloodType: .bPositive,
                    lastDonationDate: nil,
                    donationCount: 0
                )
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs in a user with Apple
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signInWithApple() -> AnyPublisher<User, Error> {
        // In a real app, this would integrate with Apple Sign In
        // For now, we'll simulate a successful login with a delay
        
        return Future<User, Error> { promise in
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Create a mock user
                let user = User(
                    id: "apple456",
                    email: "apple@example.com",
                    name: "Apple User",
                    phoneNumber: nil,
                    bloodType: nil,
                    lastDonationDate: nil,
                    donationCount: 0
                )
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Sends a password reset email to the specified email address
    /// - Parameter email: The email address to send the reset link to
    /// - Returns: A publisher that completes on success or emits an Error on failure
    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        // In a real app, this would make a network request to your authentication API
        // For now, we'll simulate a successful password reset with a delay
        
        return Future<Void, Error> { promise in
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Validate email (this is just a simple example)
                if email.contains("@") {
                    promise(.success(()))
                } else {
                    promise(.failure(AuthError.invalidEmail))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs up a new user
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - name: User's full name
    /// - Returns: A publisher that emits a User on success or an Error on failure
    func signUp(email: String, password: String, name: String) -> AnyPublisher<User, Error> {
        // In a real app, this would make a network request to your authentication API
        // For now, we'll simulate a successful signup with a delay
        
        return Future<User, Error> { promise in
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Create a mock user
                let user = User(
                    id: "new789",
                    email: email,
                    name: name,
                    phoneNumber: nil,
                    bloodType: nil,
                    lastDonationDate: nil,
                    donationCount: 0
                )
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs out the current user
    func signOut() {
        // In a real app, this would clear tokens and session data
        print("User signed out")
    }
}

// Additional auth-related error types
extension AuthError {
    static let invalidEmail = NSError(domain: "AuthError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid email format"])
}
