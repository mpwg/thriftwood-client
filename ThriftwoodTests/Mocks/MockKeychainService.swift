//
//  MockKeychainService.swift
//  ThriftwoodTests
//
//  Mock implementation of KeychainServiceProtocol for testing
//  Stores credentials in memory (non-persistent) to avoid keychain entitlement issues
//

import Foundation
@testable import Thriftwood

/// Mock keychain service that stores credentials in memory for testing
/// Does not require keychain entitlements and provides clean state for each test
@MainActor
final class MockKeychainService: KeychainServiceProtocol {
    
    // MARK: - Properties
    
    /// In-memory storage for API keys
    private var apiKeys: [String: String] = [:]
    
    /// In-memory storage for usernames
    private var usernames: [String: String] = [:]
    
    /// In-memory storage for passwords
    private var passwords: [String: String] = [:]
    
    // MARK: - Initialization
    
    init() {
        // Empty init for clean state
    }
    
    // MARK: - API Key Storage
    
    func saveAPIKey(_ apiKey: String, for configurationId: UUID) throws {
        let key = "apikey_\(configurationId.uuidString)"
        apiKeys[key] = apiKey
    }
    
    func getAPIKey(for configurationId: UUID) -> String? {
        let key = "apikey_\(configurationId.uuidString)"
        return apiKeys[key]
    }
    
    // MARK: - Username/Password Storage
    
    func saveUsernamePassword(username: String, password: String, for configurationId: UUID) throws {
        let usernameKey = "username_\(configurationId.uuidString)"
        let passwordKey = "password_\(configurationId.uuidString)"
        
        usernames[usernameKey] = username
        passwords[passwordKey] = password
    }
    
    func getUsernamePassword(for configurationId: UUID) -> (username: String, password: String)? {
        let usernameKey = "username_\(configurationId.uuidString)"
        let passwordKey = "password_\(configurationId.uuidString)"
        
        guard let username = usernames[usernameKey],
              let password = passwords[passwordKey] else {
            return nil
        }
        
        return (username, password)
    }
    
    // MARK: - Deletion
    
    func deleteCredentials(for configurationId: UUID) throws {
        let apiKeyKey = "apikey_\(configurationId.uuidString)"
        let usernameKey = "username_\(configurationId.uuidString)"
        let passwordKey = "password_\(configurationId.uuidString)"
        
        apiKeys.removeValue(forKey: apiKeyKey)
        usernames.removeValue(forKey: usernameKey)
        passwords.removeValue(forKey: passwordKey)
    }
    
    func deleteAllCredentials() throws {
        apiKeys.removeAll()
        usernames.removeAll()
        passwords.removeAll()
    }
    
    // MARK: - Testing Helpers
    
    /// Returns the count of stored API keys (useful for testing)
    var apiKeyCount: Int {
        apiKeys.count
    }
    
    /// Returns the count of stored credentials (useful for testing)
    var credentialCount: Int {
        usernames.count
    }
}
