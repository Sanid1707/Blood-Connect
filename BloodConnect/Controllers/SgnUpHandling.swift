import Foundation
import Combine

protocol SignUpHandling {
    func signUp(
        name: String,
        email: String,
        password: String,
        bloodType: String?,
        county: String,
        userType: String,
        availability: String?,
        workingHours: String?,
        address: String?,
        latitude : Double ,
        longitude :Double
    ) -> AnyPublisher<User, Error>

    func signInWithGoogle() -> AnyPublisher<User, Error>
    func signInWithApple() -> AnyPublisher<User, Error>
}
