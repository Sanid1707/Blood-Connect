//
//  LoginView.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)

            if viewModel.isLoading {
                ProgressView("Logging in...")
            }

            Button("Login") {
                viewModel.login(email: email, password: password)
            }

            if let error = viewModel.loginError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
