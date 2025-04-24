import Foundation
import Security

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)
}

class KeychainService {
    
    // MARK: - Singleton
    static let shared = KeychainService()
    private init() {}
    
    // MARK: - Constants
    private let service = "com.bloodconnect.app"
    
    // MARK: - Save Methods
    
    /// Saves a string value to the keychain
    /// - Parameters:
    ///   - value: The string value to save
    ///   - key: The key to associate with the value
    func saveString(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        
        try saveData(data, forKey: key)
    }
    
    /// Saves a data value to the keychain
    /// - Parameters:
    ///   - data: The data to save
    ///   - key: The key to associate with the data
    func saveData(_ data: Data, forKey key: String) throws {
        // Create query dictionary
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // Delete any existing item first
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    // MARK: - Retrieval Methods
    
    /// Retrieves a string value from the keychain
    /// - Parameter key: The key associated with the value
    /// - Returns: The string value if found, nil otherwise
    func getString(forKey key: String) throws -> String {
        let data = try getData(forKey: key)
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        
        return string
    }
    
    /// Retrieves data from the keychain
    /// - Parameter key: The key associated with the data
    /// - Returns: The data if found
    func getData(forKey key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return data
    }
    
    // MARK: - Update Methods
    
    /// Updates a string value in the keychain
    /// - Parameters:
    ///   - value: The new string value
    ///   - key: The key associated with the value
    func updateString(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        
        try updateData(data, forKey: key)
    }
    
    /// Updates data in the keychain
    /// - Parameters:
    ///   - data: The new data
    ///   - key: The key associated with the data
    func updateData(_ data: Data, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else {
            // Item not found, save it instead
            try saveData(data, forKey: key)
            return
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    // MARK: - Delete Methods
    
    /// Deletes a value from the keychain
    /// - Parameter key: The key associated with the value
    func deleteValue(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    // MARK: - Existence Check
    
    /// Checks if a value exists in the keychain
    /// - Parameter key: The key to check
    /// - Returns: True if the value exists, false otherwise
    func valueExists(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // MARK: - Application-Specific Methods
    
    /// Saves an authentication token to the keychain
    /// - Parameter token: The token to save
    func saveAuthToken(_ token: String) throws {
        try saveString(token, forKey: "authToken")
    }
    
    /// Retrieves the authentication token from the keychain
    /// - Returns: The authentication token if found
    func getAuthToken() throws -> String {
        return try getString(forKey: "authToken")
    }
    
    /// Deletes the authentication token from the keychain
    func deleteAuthToken() throws {
        try deleteValue(forKey: "authToken")
    }
    
    /// Checks if an authentication token exists
    /// - Returns: True if the token exists, false otherwise
    func authTokenExists() -> Bool {
        return valueExists(forKey: "authToken")
    }
} 