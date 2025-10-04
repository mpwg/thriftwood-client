//
//  KeychainServiceTests.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//
//  KeychainServiceTests.swift
//  ThriftwoodTests
//
//  Swift Testing tests for KeychainService
//

import Testing
import Foundation
@testable import Thriftwood

@Suite("KeychainService Tests")
@MainActor
struct KeychainServiceTests {
    
    /// Test keychain service instance (using mock for testing)
    let keychainService: any KeychainServiceProtocol
    
    init() {
        // Use mock implementation to avoid keychain entitlement issues in tests
        self.keychainService = MockKeychainService()
    }
    
    // MARK: - API Key Tests
    
    @Test("Save and retrieve API key")
    func saveAndRetrieveAPIKey() async throws {
        // Given
        let configId = UUID()
        let apiKey = "test-api-key-12345"
        
        // When
        try keychainService.saveAPIKey(apiKey, for: configId)
        let retrieved = keychainService.getAPIKey(for: configId)
        
        // Then
        #expect(retrieved == apiKey)
        
        // Cleanup
        try keychainService.deleteCredentials(for: configId)
    }
    
    @Test("Retrieve non-existent API key returns nil")
    func retrieveNonExistentAPIKey() {
        // Given
        let nonExistentId = UUID()
        
        // When
        let result = keychainService.getAPIKey(for: nonExistentId)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Update existing API key")
    func updateAPIKey() async throws {
        // Given
        let configId = UUID()
        let originalKey = "original-key"
        let updatedKey = "updated-key"
        
        // When
        try keychainService.saveAPIKey(originalKey, for: configId)
        try keychainService.saveAPIKey(updatedKey, for: configId)
        let retrieved = keychainService.getAPIKey(for: configId)
        
        // Then
        #expect(retrieved == updatedKey)
        
        // Cleanup
        try keychainService.deleteCredentials(for: configId)
    }
    
    @Test("Delete API key")
    func deleteAPIKey() async throws {
        // Given
        let configId = UUID()
        let apiKey = "test-api-key"
        try keychainService.saveAPIKey(apiKey, for: configId)
        
        // When
        try keychainService.deleteCredentials(for: configId)
        let retrieved = keychainService.getAPIKey(for: configId)
        
        // Then
        #expect(retrieved == nil)
    }
    
    // MARK: - Username/Password Tests
    
    @Test("Save and retrieve username/password")
    func saveAndRetrieveUsernamePassword() async throws {
        // Given
        let configId = UUID()
        let username = "testuser"
        let password = "testpass123"
        
        // When
        try keychainService.saveUsernamePassword(username: username, password: password, for: configId)
        let retrieved = keychainService.getUsernamePassword(for: configId)
        
        // Then
        #expect(retrieved != nil)
        #expect(retrieved?.username == username)
        #expect(retrieved?.password == password)
        
        // Cleanup
        try keychainService.deleteCredentials(for: configId)
    }
    
    @Test("Retrieve non-existent credentials returns nil")
    func retrieveNonExistentCredentials() {
        // Given
        let nonExistentId = UUID()
        
        // When
        let result = keychainService.getUsernamePassword(for: nonExistentId)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Update existing username/password")
    func updateUsernamePassword() async throws {
        // Given
        let configId = UUID()
        let originalUsername = "user1"
        let originalPassword = "pass1"
        let updatedUsername = "user2"
        let updatedPassword = "pass2"
        
        // When
        try keychainService.saveUsernamePassword(
            username: originalUsername,
            password: originalPassword,
            for: configId
        )
        try keychainService.saveUsernamePassword(
            username: updatedUsername,
            password: updatedPassword,
            for: configId
        )
        let retrieved = keychainService.getUsernamePassword(for: configId)
        
        // Then
        #expect(retrieved?.username == updatedUsername)
        #expect(retrieved?.password == updatedPassword)
        
        // Cleanup
        try keychainService.deleteCredentials(for: configId)
    }
    
    @Test("Delete username/password credentials")
    func deleteUsernamePassword() async throws {
        // Given
        let configId = UUID()
        try keychainService.saveUsernamePassword(username: "user", password: "pass", for: configId)
        
        // When
        try keychainService.deleteCredentials(for: configId)
        let retrieved = keychainService.getUsernamePassword(for: configId)
        
        // Then
        #expect(retrieved == nil)
    }
    
    // MARK: - Multiple Credentials Tests
    
    @Test("Store multiple API keys for different configurations")
    func multipleAPIKeys() async throws {
        // Given
        let config1 = UUID()
        let config2 = UUID()
        let apiKey1 = "key1"
        let apiKey2 = "key2"
        
        // When
        try keychainService.saveAPIKey(apiKey1, for: config1)
        try keychainService.saveAPIKey(apiKey2, for: config2)
        
        let retrieved1 = keychainService.getAPIKey(for: config1)
        let retrieved2 = keychainService.getAPIKey(for: config2)
        
        // Then
        #expect(retrieved1 == apiKey1)
        #expect(retrieved2 == apiKey2)
        
        // Cleanup
        try keychainService.deleteCredentials(for: config1)
        try keychainService.deleteCredentials(for: config2)
    }
    
    @Test("Store multiple username/password pairs for different configurations")
    func multipleUsernamePasswords() async throws {
        // Given
        let config1 = UUID()
        let config2 = UUID()
        
        // When
        try keychainService.saveUsernamePassword(username: "user1", password: "pass1", for: config1)
        try keychainService.saveUsernamePassword(username: "user2", password: "pass2", for: config2)
        
        let retrieved1 = keychainService.getUsernamePassword(for: config1)
        let retrieved2 = keychainService.getUsernamePassword(for: config2)
        
        // Then
        #expect(retrieved1?.username == "user1")
        #expect(retrieved1?.password == "pass1")
        #expect(retrieved2?.username == "user2")
        #expect(retrieved2?.password == "pass2")
        
        // Cleanup
        try keychainService.deleteCredentials(for: config1)
        try keychainService.deleteCredentials(for: config2)
    }
    
    // MARK: - Bulk Operations
    
    @Test("Delete all credentials")
    func deleteAllCredentials() async throws {
        // Given
        let config1 = UUID()
        let config2 = UUID()
        try keychainService.saveAPIKey("key1", for: config1)
        try keychainService.saveUsernamePassword(username: "user2", password: "pass2", for: config2)
        
        // When
        try keychainService.deleteAllCredentials()
        
        // Then
        let retrieved1 = keychainService.getAPIKey(for: config1)
        let retrieved2 = keychainService.getUsernamePassword(for: config2)
        
        #expect(retrieved1 == nil)
        #expect(retrieved2 == nil)
    }
    
    // MARK: - Edge Cases
    
    @Test("Store empty string as API key")
    func emptyAPIKey() async throws {
        // Given
        let configId = UUID()
        let emptyKey = ""
        
        // When
        try keychainService.saveAPIKey(emptyKey, for: configId)
        let retrieved = keychainService.getAPIKey(for: configId)
        
        // Then - Valet should store even empty strings
        #expect(retrieved == emptyKey)
        
        // Cleanup
        try keychainService.deleteCredentials(for: configId)
    }
    
    @Test("Store special characters in credentials")
    func specialCharactersInCredentials() async throws {
        // Given
        let configId = UUID()
        let username = "user@example.com"
        let password = "p@$$w0rd!#%&*()[]{}:;\"'<>?/"
        
        // When
        try keychainService.saveUsernamePassword(username: username, password: password, for: configId)
        let retrieved = keychainService.getUsernamePassword(for: configId)
        
        // Then
        #expect(retrieved?.username == username)
        #expect(retrieved?.password == password)
        
        // Cleanup
        try keychainService.deleteCredentials(for: configId)
    }
    
    @Test("Store very long API key")
    func longAPIKey() async throws {
        // Given
        let configId = UUID()
        let longKey = String(repeating: "a", count: 1000)
        
        // When
        try keychainService.saveAPIKey(longKey, for: configId)
        let retrieved = keychainService.getAPIKey(for: configId)
        
        // Then
        #expect(retrieved == longKey)
        
        // Cleanup
        try keychainService.deleteCredentials(for: configId)
    }
}
