import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var bloodType: BloodType = .bPositive
    @Published var country: String = ""
    @Published var agreedToTerms: Bool = false
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    // MARK: - Private
    private let controller: SignUpViewController
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(controller: SignUpViewController = SignUpViewController()) {
        self.controller = controller
    }

    // MARK: - Actions
    func signUp() {
        guard !name.isEmpty else {
            showAlertWith("Please enter your name.")
            return
        }

        guard !email.isEmpty, email.contains("@") else {
            showAlertWith("Please enter a valid email address.")
            return
        }

        guard password.count >= 6 else {
            showAlertWith("Password must be at least 6 characters.")
            return
        }

        guard !country.isEmpty else {
            showAlertWith("Please select your country.")
            return
        }

        guard agreedToTerms else {
            showAlertWith("Please agree to the terms and conditions.")
            return
        }

        isLoading = true

        controller.signUp(
            name: name,
            email: email,
            password: password,
            bloodType: bloodType.rawValue,
            country: country
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.showAlertWith(error.localizedDescription)
                }
            },
            receiveValue: { user in
                print("User signed up: \(user.name)")
                // Navigate to next screen or show success
            }
        )
        .store(in: &cancellables)
    }

    func signInWithGoogle() {
        isLoading = true

        controller.signInWithGoogle()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.showAlertWith(error.localizedDescription)
                    }
                },
                receiveValue: { user in
                    print("Signed up with Google: \(user.name)")
                }
            )
            .store(in: &cancellables)
    }

    func signInWithApple() {
        isLoading = true

        controller.signInWithApple()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.showAlertWith(error.localizedDescription)
                    }
                },
                receiveValue: { user in
                    print("Signed up with Apple: \(user.name)")
                }
            )
            .store(in: &cancellables)
    }

    func goToSignIn() {
        print("Navigate to sign in")
    }

    // MARK: - Helpers
    private func showAlertWith(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}
