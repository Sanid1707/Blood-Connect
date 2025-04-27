////
////  AuthService.swift
////  BloodConnect
////
////  Created by Sanidhya Pandey on 14/03/2025.
////
//
//import Foundation
//import Combine
//import SwiftData
//
//enum AuthError: Error {
//    case invalidCredentials
//    case invalidEmail
//    case networkError
//    case tokenStorageError
//    case userStorageError
//    case unauthorized
//}
//
//@MainActor
//class AuthService {
//    // MARK: - Properties
//    private let networkManager: NetworkManager
//    internal let keychainService: KeychainService
//    internal let dataService: DataServiceProtocol
//    
//    // MARK: - Initialization
//    init(networkManager: NetworkManager = NetworkManager(),
//         keychainService: KeychainService = KeychainService.shared,
//         dataService: DataServiceProtocol? = nil) {
//        self.networkManager = networkManager
//        self.keychainService = keychainService
//        
//        if let dataService = dataService {
//            self.dataService = dataService
//        } else {
//            // Create default data service on the MainActor
//            let modelContext = DatabaseManager.shared.mainContext
//            self.dataService = SwiftDataService(modelContext: modelContext)
//        }
//    }
//    
//    // MARK: - Authentication Methods
//    
//    /// Signs in a user with email and password
//    /// - Parameters:
//    ///   - email: User's email address
//    ///   - password: User's password
//    /// - Returns: A publisher that emits a User on success or an Error on failure
//    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
//        // In a real app, this would make a network request to your authentication API
//        // For now, we'll simulate a successful login with a delay
//        
//        return Future<User, Error> { promise in
//            // Simulate network delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                // Validate credentials (this is just a simple example)
//                if email.lowercased() == "test@example.com" && password == "password" {
//                    // Create a mock user
//                    let user = User(
//                        id: "user123",
//                        email: email,
//                        name: "Test User",
//                        phoneNumber: "+1234567890",
//                        bloodType: .aPositive,
//                        lastDonationDate: Date().addingTimeInterval(-60*60*24*30), // 30 days ago
//                        donationCount: 5,
//                        county: "Louth",
//                        userType: "donor",
//                        availability: "Weekends",
//                        address: nil,
//                        latitude: nil,
//                        longitude: nil
//                    )
//                    
//                    // Save mock token to keychain
//                    do {
//                        try self.keychainService.saveAuthToken("mock_token_\(user.id ?? "unknown")")
//                    } catch {
//                        promise(.failure(AuthError.tokenStorageError))
//                        return
//                    }
//                    
//                    // Save user to SwiftData
//                    self.dataService.createUser(user)
//                        .sink(
//                            receiveCompletion: { completion in
//                                if case .failure = completion {
//                                    // If we can't save the user, continue anyway since we have the token
//                                    print("Warning: Failed to save user to database")
//                                }
//                            },
//                            receiveValue: { _ in }
//                        )
//                        .cancel()
//                    
//                    promise(.success(user))
//                } else {
//                    promise(.failure(AuthError.invalidCredentials))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Signs in a user with Google
//    /// - Returns: A publisher that emits a User on success or an Error on failure
//    func signInWithGoogle() -> AnyPublisher<User, Error> {
//        // In a real app, this would integrate with Google Sign-In SDK
//        // For now, we'll simulate a successful login with a delay
//        
//        return Future<User, Error> { promise in
//            // Simulate network delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                // Create a mock user
//                let user = User(
//                    id: "google123",
//                    email: "google@example.com",
//                    name: "Google User",
//                    phoneNumber: nil,
//                    bloodType: .bPositive,
//                    lastDonationDate: nil,
//                    donationCount: 0,
//                    county: "Dublin",
//                    userType: "donor",
//                    availability: "Weekdays",
//                    address: nil,
//                    latitude: nil,
//                    longitude: nil
//                )
//                
//                // Save mock token to keychain
//                do {
//                    try self.keychainService.saveAuthToken("mock_google_token_\(user.id ?? "unknown")")
//                } catch {
//                    promise(.failure(AuthError.tokenStorageError))
//                    return
//                }
//                
//                // Save user to SwiftData
//                self.dataService.createUser(user)
//                    .sink(
//                        receiveCompletion: { completion in
//                            if case .failure = completion {
//                                // If we can't save the user, continue anyway since we have the token
//                                print("Warning: Failed to save user to database")
//                            }
//                        },
//                        receiveValue: { _ in }
//                    )
//                    .cancel()
//                
//                promise(.success(user))
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Signs in a user with Apple
//    /// - Returns: A publisher that emits a User on success or an Error on failure
//    func signInWithApple() -> AnyPublisher<User, Error> {
//        // In a real app, this would integrate with Apple Sign In
//        // For now, we'll simulate a successful login with a delay
//        
//        return Future<User, Error> { promise in
//            // Simulate network delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                // Create a mock user
//                let user = User(
//                    id: "apple456",
//                    email: "apple@example.com",
//                    name: "Apple User",
//                    phoneNumber: nil,
//                    bloodType: nil,
//                    lastDonationDate: nil,
//                    donationCount: 0,
//                    county: "Meath",
//                    userType: "donor",
//                    availability: "Evenings",
//                    address: nil,
//                    latitude: nil,
//                    longitude: nil
//                )
//                
//                // Save mock token to keychain
//                do {
//                    try self.keychainService.saveAuthToken("mock_apple_token_\(user.id ?? "unknown")")
//                } catch {
//                    promise(.failure(AuthError.tokenStorageError))
//                    return
//                }
//                
//                // Save user to SwiftData
//                self.dataService.createUser(user)
//                    .sink(
//                        receiveCompletion: { completion in
//                            if case .failure = completion {
//                                // If we can't save the user, continue anyway since we have the token
//                                print("Warning: Failed to save user to database")
//                            }
//                        },
//                        receiveValue: { _ in }
//                    )
//                    .cancel()
//                
//                promise(.success(user))
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Sends a password reset email to the specified email address
//    /// - Parameter email: The email address to send the reset link to
//    /// - Returns: A publisher that completes on success or emits an Error on failure
//    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
//        // In a real app, this would make a network request to your authentication API
//        // For now, we'll simulate a successful password reset with a delay
//        
//        return Future<Void, Error> { promise in
//            // Simulate network delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                // Validate email (this is just a simple example)
//                if email.contains("@") {
//                    promise(.success(()))
//                } else {
//                    promise(.failure(AuthError.invalidEmail))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Signs up a new user
//    /// - Parameters:
//    ///   - email: User's email address
//    ///   - password: User's password
//    ///   - name: User's full name
//    /// - Returns: A publisher that emits a User on success or an Error on failure
//    func signUp(
//        name: String,
//        email: String,
//        password: String,
//        bloodType: String? = nil,
//        county: String? = nil,
//        userType: String,
//        availability: String? = nil,
//        address: String? = nil,
//        latitude: Double? = nil,
//        longitude: Double? = nil,
//        phoneNumber: String? = nil,
//        organizationDescription: String? = nil,
//        workingHours: String? = nil,
//        eircode: String? = nil
//    ) -> AnyPublisher<User, Error> {
//        // In a real app, this would make a network request to your authentication API
//        // For now, we'll simulate a successful signup with a delay
//        
//        return Future<User, Error> { promise in
//            // Simulate network delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                // Create a mock user
//                let bloodTypeEnum = bloodType != nil ? BloodType(rawValue: bloodType!) : nil
//                let user = User(
//                    id: "new_\(UUID().uuidString)",
//                    email: email,
//                    name: name,
//                    phoneNumber: phoneNumber,
//                    bloodType: bloodTypeEnum,
//                    lastDonationDate: nil,
//                    donationCount: 0,
//                    county: county,
//                    userType: userType,
//                    availability: availability,
//                    address: address,
//                    latitude: latitude,
//                    longitude: longitude,
//                    organizationDescription: organizationDescription,
//                    workingHours: workingHours,
//                    eircode: eircode
//                )
//                
//                // Save mock token to keychain
//                do {
//                    try self.keychainService.saveAuthToken("new_user_token_\(user.id ?? "unknown")")
//                } catch {
//                    promise(.failure(AuthError.tokenStorageError))
//                    return
//                }
//                
//                // Save user to SwiftData
//                self.dataService.createUser(user)
//                    .sink(
//                        receiveCompletion: { completion in
//                            if case .failure(let error) = completion {
//                                promise(.failure(error))
//                            }
//                        },
//                        receiveValue: { savedUser in
//                            promise(.success(savedUser))
//                        }
//                    )
//                    .cancel()
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /// Signs out the current user
//    func signOut() {
//        // Delete token from keychain
//        try? keychainService.deleteAuthToken()
//        
//        // Clear any user preferences if needed
//        UserDefaultsService.shared.clearLoginCredentials()
//    }
//    
//    /// Checks if the user is authenticated
//    /// - Returns: True if authenticated, false otherwise
//    func isAuthenticated() -> Bool {
//        return keychainService.authTokenExists()
//    }
//    
//    /// Gets the currently authenticated user
//    /// - Returns: A publisher that emits the current User or nil if not authenticated
//    func getCurrentUser() -> AnyPublisher<User?, Error> {
//        guard isAuthenticated() else {
//            return Just(nil)
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//        
//        // In a real app, you would get the user ID from the token or make an API call
//        // For this example, we'll return a mock user
//        return Just(User(
//            id: "current_user",
//            email: "current@example.com",
//            name: "Current User",
//            phoneNumber: "+1234567890",
//            bloodType: .aPositive,
//            lastDonationDate: Date().addingTimeInterval(-60*60*24*30),
//            donationCount: 3,
//            county: "Westmeath",
//            userType: "donor",
//            availability: "Weekends",
//            address: nil,
//            latitude: nil,
//            longitude: nil
//        ))
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher()
//    }
//}


import Foundation
import Combine
import SwiftData

enum AuthError: Error {
    case invalidCredentials
    case invalidEmail
    case networkError
    case tokenStorageError
    case userStorageError
    case unauthorized
}

@MainActor
class AuthService {
    private let networkManager: NetworkManager
    internal let keychainService: KeychainService
    internal let dataService: DataServiceProtocol

    init(networkManager: NetworkManager = NetworkManager(),
         keychainService: KeychainService = KeychainService.shared,
         dataService: DataServiceProtocol? = nil) {
        self.networkManager = networkManager
        self.keychainService = keychainService

        if let dataService = dataService {
            self.dataService = dataService
        } else {
            let modelContext = DatabaseManager.shared.mainContext
            self.dataService = SwiftDataService(modelContext: modelContext)
        }
    }

    func signUp(
        name: String,
        email: String,
        password: String,
        bloodType: String? = nil,
        county: String? = nil,
        userType: String,
        availability: String? = nil,
        address: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        phoneNumber: String? = nil,
        organizationDescription: String? = nil,
        workingHours: String? = nil,
        eircode: String? = nil
    ) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let bloodTypeEnum = bloodType != nil ? BloodType(rawValue: bloodType!) : nil
                let user = User(
                    id: "new_\(UUID().uuidString)",
                    email: email,
                    name: name,
                    phoneNumber: phoneNumber,
                    bloodType: bloodTypeEnum,
                    lastDonationDate: nil,
                    donationCount: 0,
                    county: county,
                    userType: userType,
                    availability: availability,
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                    organizationDescription: organizationDescription,
                    workingHours: workingHours,
                    eircode: eircode
                )

                do {
                    try self.keychainService.saveAuthToken("new_user_token_\(user.id ?? "unknown")")
                } catch {
                    promise(.failure(AuthError.tokenStorageError))
                    return
                }

                self.dataService.createUser(user)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                promise(.failure(error))
                            }
                        },
                        receiveValue: { savedUser in
                            promise(.success(savedUser))
                        }
                    )
                    .cancel()
            }
        }
        .eraseToAnyPublisher()
    }

    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if email.lowercased() == "test@example.com" && password == "password" {
                    let user = User(
                        id: "user123",
                        email: email,
                        name: "Test User",
                        phoneNumber: "+1234567890",
                        bloodType: .aPositive,
                        lastDonationDate: Date().addingTimeInterval(-60*60*24*30),
                        donationCount: 5,
                        county: "Louth",
                        userType: "donor",
                        availability: "Weekends",
                        address: nil,
                        latitude: nil,
                        longitude: nil
                    )

                    do {
                        try self.keychainService.saveAuthToken("mock_token_\(user.id ?? "unknown")")
                    } catch {
                        promise(.failure(AuthError.tokenStorageError))
                        return
                    }

                    self.dataService.createUser(user)
                        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                        .cancel()

                    promise(.success(user))
                } else {
                    promise(.failure(AuthError.invalidCredentials))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func signInWithGoogle() -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let user = User(
                    id: "google123",
                    email: "google@example.com",
                    name: "Google User",
                    phoneNumber: nil,
                    bloodType: .bPositive,
                    lastDonationDate: nil,
                    donationCount: 0,
                    county: "Dublin",
                    userType: "donor",
                    availability: "Weekdays",
                    address: nil,
                    latitude: nil,
                    longitude: nil
                )

                do {
                    try self.keychainService.saveAuthToken("mock_google_token_\(user.id ?? "unknown")")
                } catch {
                    promise(.failure(AuthError.tokenStorageError))
                    return
                }

                self.dataService.createUser(user)
                    .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                    .cancel()

                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }

    func signInWithApple() -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let user = User(
                    id: "apple456",
                    email: "apple@example.com",
                    name: "Apple User",
                    phoneNumber: nil,
                    bloodType: nil,
                    lastDonationDate: nil,
                    donationCount: 0,
                    county: "Meath",
                    userType: "donor",
                    availability: "Evenings",
                    address: nil,
                    latitude: nil,
                    longitude: nil
                )

                do {
                    try self.keychainService.saveAuthToken("mock_apple_token_\(user.id ?? "unknown")")
                } catch {
                    promise(.failure(AuthError.tokenStorageError))
                    return
                }

                self.dataService.createUser(user)
                    .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                    .cancel()

                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }

    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if email.contains("@") {
                    promise(.success(()))
                } else {
                    promise(.failure(AuthError.invalidEmail))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func signOut() {
        try? keychainService.deleteAuthToken()
        UserDefaultsService.shared.clearLoginCredentials()
    }

    func isAuthenticated() -> Bool {
        return keychainService.authTokenExists()
    }

    func getCurrentUser() -> AnyPublisher<User?, Error> {
        guard isAuthenticated() else {
            return Just(nil)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return Just(User(
            id: "current_user",
            email: "current@example.com",
            name: "Current User",
            phoneNumber: "+1234567890",
            bloodType: .aPositive,
            lastDonationDate: Date().addingTimeInterval(-60*60*24*30),
            donationCount: 3,
            county: "Westmeath",
            userType: "donor",
            availability: "Weekends",
            address: nil,
            latitude: nil,
            longitude: nil
        ))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
