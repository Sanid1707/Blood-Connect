//
//  LoginViewController.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let authService = AuthService()
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        authService.login(email: email, password: password) { result in
            switch result {
            case .success(let user):
                // Navigate to next screen
                print("Logged in as \(user.name)")
            case .failure(let error):
                // Show error
                print("Login failed: \(error)")
            }
        }
    }
}
