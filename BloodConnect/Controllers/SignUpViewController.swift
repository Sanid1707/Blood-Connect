import Foundation
import Combine

class SignUpViewController: SignUpHandling {
    
    func signUp(name: String, email: String, password: String, bloodType: String, country: String) -> AnyPublisher<User, Error> {
        // Simulate a successful sign-up response with mock data
        let user = User(
            id: UUID().uuidString,
            email: email,
            name: name,
            phoneNumber: nil,
            bloodType: BloodType(rawValue: bloodType),
            lastDonationDate: nil,
            donationCount: 0,
            country: country
        )
        
        return Just(user)
            .setFailureType(to: Error.self)
            .delay(for: 1.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func signInWithGoogle() -> AnyPublisher<User, Error> {
        let user = User(
            id: UUID().uuidString,
            email: "google.user@example.com",
            name: "Google User",
            phoneNumber: nil,
            bloodType: .oPositive,
            lastDonationDate: nil,
            donationCount: 1,
            country: "Ireland"
        )
        
        return Just(user)
            .setFailureType(to: Error.self)
            .delay(for: 1.0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func signInWithApple() -> AnyPublisher<User, Error> {
        let user = User(
            id: UUID().uuidString,
            email: "apple.user@example.com",
            name: "Apple User",
            phoneNumber: nil,
            bloodType: .abNegative,
            lastDonationDate: nil,
            donationCount: 2,
            country: "UK"
        )
        
        return Just(user)
            .setFailureType(to: Error.self)
            .delay(for: 1.0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

