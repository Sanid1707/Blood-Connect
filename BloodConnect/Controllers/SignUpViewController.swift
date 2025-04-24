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
    func signUp(
        name: String,
        email: String,
        password: String,
        bloodType: String? = nil,
        county: String,
        userType: String,
        availability: String? = nil,
        workingHours: String? = nil,
        address: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) -> AnyPublisher<User, Error> {
        return authService.signUp(
            email: email,
            password: password,
            name: name,
            bloodType: bloodType,
            county: county,
            userType: userType,
            workingHours: workingHours,
            availability: availability,
            address: address,
            latitude: latitude,
            longitude: longitude
        )
    }

    /// Signs in a user with Google
    func signInWithGoogle() -> AnyPublisher<User, Error> {
        return authService.signInWithGoogle()
    }

    /// Signs in a user with Apple
    func signInWithApple() -> AnyPublisher<User, Error> {
        return authService.signInWithApple()
    }

    /// Check if the user is authenticated
    func isAuthenticated() -> Bool {
        return authService.isAuthenticated()
    }

    /// Gets the currently authenticated user, if any
    func getCurrentUser() -> AnyPublisher<User?, Error> {
        return authService.getCurrentUser()
    }
}
