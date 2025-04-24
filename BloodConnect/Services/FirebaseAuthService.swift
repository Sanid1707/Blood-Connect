//
//  FirebaseAuthService.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 24/04/2025.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftData

@MainActor
class FirebaseAuthService: AuthService {
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    
    // MARK: - Initialization
    override init(networkManager: NetworkManager = NetworkManager(),
                  keychainService: KeychainService = KeychainService.shared,
                  dataService: DataServiceProtocol? = nil) {
        super.init(networkManager: networkManager, 
                  keychainService: keychainService,
                  dataService: dataService)
    }
    
    // MARK: - Authentication Methods
    
    /// Signs in a user with email and password using Firebase Auth
    override func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Task {
                do {
                    // Sign in with Firebase Auth
                    let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                    let firebaseUser = authResult.user
                    
                    // Save auth token to keychain
                    do {
                        let token = try await firebaseUser.getIDToken()
                        try self.keychainService.saveAuthToken(token)
                    } catch {
                        promise(.failure(AuthError.tokenStorageError))
                        return
                    }
                    
                    // Get user data from Firestore
                    do {
                        let user = try await self.fetchUserData(userId: firebaseUser.uid)
                        
                        // Save to SwiftData for offline access
                        self.dataService.createUser(user)
                            .sink(
                                receiveCompletion: { _ in },
                                receiveValue: { _ in }
                            )
                            .cancel()
                        
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs up a new user with email and password
    override func signUp(email: String, password: String, name: String, bloodType: String? = nil, country: String? = nil) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Task {
                do {
                    // Create the user in Firebase Auth
                    let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                    let firebaseUser = authResult.user
                    
                    // Save auth token to keychain
                    do {
                        let token = try await firebaseUser.getIDToken()
                        try self.keychainService.saveAuthToken(token)
                    } catch {
                        promise(.failure(AuthError.tokenStorageError))
                        return
                    }
                    
                    // Create user profile
                    let bloodTypeEnum = bloodType != nil ? BloodType(rawValue: bloodType!) : nil
                    let user = User(
                        id: firebaseUser.uid,
                        email: email,
                        name: name,
                        phoneNumber: nil,
                        bloodType: bloodTypeEnum,
                        lastDonationDate: nil,
                        donationCount: 0,
                        country: country
                    )
                    
                    // Save to Firestore
                    do {
                        try await self.saveUserToFirestore(user)
                        
                        // Save to SwiftData
                        self.dataService.createUser(user)
                            .sink(
                                receiveCompletion: { completion in
                                    if case .failure(let error) = completion {
                                        print("Error saving user to SwiftData: \(error)")
                                    }
                                },
                                receiveValue: { savedUser in
                                    promise(.success(savedUser))
                                }
                            )
                            .cancel()
                    } catch {
                        promise(.failure(error))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs in with Google
    override func signInWithGoogle() -> AnyPublisher<User, Error> {
        // For now, continue to use the mock implementation
        // In a real implementation, you would integrate with GoogleSignIn SDK
        return super.signInWithGoogle()
    }
    
    /// Signs in with Apple
    override func signInWithApple() -> AnyPublisher<User, Error> {
        // For now, continue to use the mock implementation
        // In a real implementation, you would integrate with Apple Sign In
        return super.signInWithApple()
    }
    
    /// Reset password using Firebase
    override func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            Task {
                do {
                    try await Auth.auth().sendPasswordReset(withEmail: email)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs out the current user
    override func signOut() {
        do {
            try Auth.auth().signOut()
            // Remove token from keychain
            try keychainService.deleteAuthToken()
            // Clear any user preferences
            UserDefaultsService.shared.clearLoginCredentials()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    /// Checks if the user is authenticated
    override func isAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    /// Gets the currently authenticated user
    override func getCurrentUser() -> AnyPublisher<User?, Error> {
        return Future<User?, Error> { promise in
            Task {
                if let firebaseUser = Auth.auth().currentUser {
                    do {
                        let user = try await self.fetchUserData(userId: firebaseUser.uid)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                } else {
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Helper Methods
    
    /// Fetches a user from Firestore by ID
    private func fetchUserData(userId: String) async throws -> User {
        let documentSnapshot = try await db.collection("users").document(userId).getDocument()
        
        guard documentSnapshot.exists, let data = documentSnapshot.data() else {
            throw AuthError.userStorageError
        }
        
        // Extract user data and create User object
        let email = data["email"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let phoneNumber = data["phoneNumber"] as? String
        let bloodTypeString = data["bloodType"] as? String
        let donationCount = data["donationCount"] as? Int ?? 0
        let country = data["country"] as? String
        
        var lastDonationDate: Date? = nil
        if let timestamp = data["lastDonationDate"] as? Timestamp {
            lastDonationDate = timestamp.dateValue()
        }
        
        let bloodType = bloodTypeString != nil ? BloodType(rawValue: bloodTypeString!) : nil
        
        return User(
            id: userId,
            email: email,
            name: name,
            phoneNumber: phoneNumber,
            bloodType: bloodType,
            lastDonationDate: lastDonationDate,
            donationCount: donationCount,
            country: country
        )
    }
    
    /// Saves a user to Firestore
    private func saveUserToFirestore(_ user: User) async throws {
        guard let userId = user.id else {
            throw AuthError.userStorageError
        }
        
        // Convert User to dictionary for Firestore
        var userData: [String: Any] = [
            "email": user.email,
            "name": user.name,
            "donationCount": user.donationCount,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        if let phoneNumber = user.phoneNumber {
            userData["phoneNumber"] = phoneNumber
        }
        
        if let bloodType = user.bloodType {
            userData["bloodType"] = bloodType.rawValue
        }
        
        if let lastDonationDate = user.lastDonationDate {
            userData["lastDonationDate"] = Timestamp(date: lastDonationDate)
        }
        
        if let country = user.country {
            userData["country"] = country
        }
        
        // Save to Firestore
        try await db.collection("users").document(userId).setData(userData)
    }
} 