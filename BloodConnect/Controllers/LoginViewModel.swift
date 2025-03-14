//
//  LoginViewModel.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginError: String?

    private let authService = AuthService()  // or whatever service you use

    func login(email: String, password: String) {
        self.isLoading = true
        self.loginError = nil

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let user):
                    print("Logged in user: \(user)")
                    // Possibly set some user state, or navigate
                case .failure(let error):
                    self.loginError = error.localizedDescription
                }
            }
        }
    }
}
