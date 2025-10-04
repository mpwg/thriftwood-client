//
//  KeychainServiceProtocol.swift
//  Thriftwood
//
//  Protocol for keychain service to enable dependency injection and testing
//

import Foundation

/// Protocol defining keychain service operations
/// Allows for dependency injection and mock implementations in tests
protocol KeychainServiceProtocol {
    
    // MARK: - API Key Storage
    
    /// Saves API key for a service configuration
    /// - Parameters:
    ///   - apiKey: The API key to store
    ///   - configurationId: The unique ID of the service configuration
    /// - Throws: Error if the operation fails
    func saveAPIKey(_ apiKey: String, for configurationId: UUID) throws
    
    /// Retrieves API key for a service configuration
    /// - Parameter configurationId: The unique ID of the service configuration
    /// - Returns: The API key if found, nil otherwise
    func getAPIKey(for configurationId: UUID) -> String?
    
    // MARK: - Username/Password Storage
    
    /// Saves username and password for a service configuration
    /// - Parameters:
    ///   - username: The username to store
    ///   - password: The password to store
    ///   - configurationId: The unique ID of the service configuration
    /// - Throws: Error if the operation fails
    func saveUsernamePassword(username: String, password: String, for configurationId: UUID) throws
    
    /// Retrieves username and password for a service configuration
    /// - Parameter configurationId: The unique ID of the service configuration
    /// - Returns: Tuple of (username, password) if found, nil otherwise
    func getUsernamePassword(for configurationId: UUID) -> (username: String, password: String)?
    
    // MARK: - Deletion
    
    /// Deletes credentials for a service configuration
    /// - Parameter configurationId: The unique ID of the service configuration
    /// - Throws: Error if the operation fails
    func deleteCredentials(for configurationId: UUID) throws
    
    /// Deletes all credentials (useful for testing/reset)
    /// - Throws: Error if the operation fails
    func deleteAllCredentials() throws
}
