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
        address: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        phoneNumber: String? = nil,
        organizationDescription: String? = nil,
        workingHours: String? = nil,
        eircode: String? = nil
    ) -> AnyPublisher<User, Error> {
        return authService.signUp(
            name: name,
            email: email,
            password: password,
            bloodType: bloodType,
            county: county,
            userType: userType,
            availability: availability,
            address: address,
            latitude: latitude,
            longitude: longitude,
            phoneNumber: phoneNumber,
            organizationDescription: organizationDescription,
            workingHours: workingHours,
            eircode: eircode
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
