//
//  KeychainServiceProtocol.swift
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
