//
//  KeychainService.swift
//  Thriftwood
//
//  Service for managing secure credential storage in Keychain
//  Uses Square's Valet for simplified and secure Keychain access
//

import Foundation
import Valet

/// Service for managing secure credential storage
/// Stores API keys, passwords, and other sensitive data in the iOS/macOS Keychain
@MainActor
final class KeychainService: KeychainServiceProtocol {
    
    // MARK: - Properties
    
    /// The underlying Valet instance for API keys
    private let apiKeyValet: Valet
    
    /// The underlying Valet instance for username/password pairs
    private let credentialValet: Valet
    
    // MARK: - Initialization
    
    /// Creates a new KeychainService instance
    /// - Parameter identifier: The identifier for keychain isolation (default: "com.thriftwood.credentials")
    init(identifier: String = "com.thriftwood.credentials") {
        // Create Valet instances with appropriate accessibility
        // .afterFirstUnlock allows background access after device unlock
        self.apiKeyValet = Valet.valet(
            with: Identifier(nonEmpty: "\(identifier).apikeys")!,
            accessibility: .afterFirstUnlock
        )
        self.credentialValet = Valet.valet(
            with: Identifier(nonEmpty: "\(identifier).credentials")!,
            accessibility: .afterFirstUnlock
        )
    }
    
    // MARK: - API Key Storage
    
    /// Saves API key for a service configuration
    /// - Parameters:
    ///   - apiKey: The API key to store
    ///   - configurationId: The unique ID of the service configuration
    /// - Throws: Error if the operation fails
    func saveAPIKey(_ apiKey: String, for configurationId: UUID) throws {
        let key = "apikey_\(configurationId.uuidString)"
        try apiKeyValet.setString(apiKey, forKey: key)
    }
    
    /// Retrieves API key for a service configuration
    /// - Parameter configurationId: The unique ID of the service configuration
    /// - Returns: The API key if found, nil otherwise
    func getAPIKey(for configurationId: UUID) -> String? {
        let key = "apikey_\(configurationId.uuidString)"
        return try? apiKeyValet.string(forKey: key)
    }
    
    // MARK: - Username/Password Storage
    
    /// Saves username and password for a service configuration
    /// - Parameters:
    ///   - username: The username to store
    ///   - password: The password to store
    ///   - configurationId: The unique ID of the service configuration
    /// - Throws: Error if the operation fails
    func saveUsernamePassword(username: String, password: String, for configurationId: UUID) throws {
        let usernameKey = "username_\(configurationId.uuidString)"
        let passwordKey = "password_\(configurationId.uuidString)"
        
        try credentialValet.setString(username, forKey: usernameKey)
        try credentialValet.setString(password, forKey: passwordKey)
    }
    
    /// Retrieves username and password for a service configuration
    /// - Parameter configurationId: The unique ID of the service configuration
    /// - Returns: Tuple of (username, password) if found, nil otherwise
    func getUsernamePassword(for configurationId: UUID) -> (username: String, password: String)? {
        let usernameKey = "username_\(configurationId.uuidString)"
        let passwordKey = "password_\(configurationId.uuidString)"
        
        guard let username = try? credentialValet.string(forKey: usernameKey),
              let password = try? credentialValet.string(forKey: passwordKey) else {
            return nil
        }
        
        return (username, password)
    }
    
    // MARK: - Deletion
    
    /// Deletes credentials for a service configuration
    /// - Parameter configurationId: The unique ID of the service configuration
    /// - Throws: Error if the operation fails
    func deleteCredentials(for configurationId: UUID) throws {
        let apiKeyKey = "apikey_\(configurationId.uuidString)"
        let usernameKey = "username_\(configurationId.uuidString)"
        let passwordKey = "password_\(configurationId.uuidString)"
        
        // Valet doesn't throw if key doesn't exist, so we can safely try to remove all
        try? apiKeyValet.removeObject(forKey: apiKeyKey)
        try? credentialValet.removeObject(forKey: usernameKey)
        try? credentialValet.removeObject(forKey: passwordKey)
    }
    
    /// Deletes all credentials (useful for testing/reset)
    /// - Throws: Error if the operation fails
    func deleteAllCredentials() throws {
        try apiKeyValet.removeAllObjects()
        try credentialValet.removeAllObjects()
    }
}
