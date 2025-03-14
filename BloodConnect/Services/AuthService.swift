//
//  AuthService.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import Foundation

class AuthService {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        // e.g., use URLSession or Alamofire
        // On success: completion(.success(User(...)))
        // On failure: completion(.failure(error))
    }
}
