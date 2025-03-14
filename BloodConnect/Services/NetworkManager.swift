//
//  NetworkManager.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import Foundation
import Combine

class NetworkManager {
    // MARK: - Properties
    private let session: URLSession
    private let baseURL: URL
    
    // MARK: - Initialization
    init(session: URLSession = .shared, baseURL: URL = URL(string: "https://api.bloodconnect.com")!) {
        self.session = session
        self.baseURL = baseURL
    }
    
    // MARK: - Network Methods
    
    /// Performs a network request and decodes the response
    /// - Parameters:
    ///   - endpoint: The API endpoint
    ///   - method: HTTP method (GET, POST, etc.)
    ///   - parameters: Request parameters
    ///   - headers: HTTP headers
    /// - Returns: A publisher that emits the decoded response or an error
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) -> AnyPublisher<T, Error> {
        // Build URL
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        // Add parameters
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                return Fail(error: NetworkError.encodingFailed).eraseToAnyPublisher()
            }
        }
        
        // Perform request
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.statusCode(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingFailed
                } else {
                    return NetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Supporting Types

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case encodingFailed
    case decodingFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .statusCode(let code):
            return "HTTP error: \(code)"
        case .encodingFailed:
            return "Failed to encode request parameters"
        case .decodingFailed:
            return "Failed to decode response"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
