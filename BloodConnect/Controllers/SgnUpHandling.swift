import Foundation
import Combine

protocol SignUpHandling {
    func signUp(name: String, email: String, password: String, bloodType: String, country: String) -> AnyPublisher<User, Error>
    func signInWithGoogle() -> AnyPublisher<User, Error>
    func signInWithApple() -> AnyPublisher<User, Error>
}
