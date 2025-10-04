//
//  DataServiceProtocol.swift
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

import Foundation

/// Protocol defining data persistence operations
/// Enables dependency injection and mock implementations in tests
/// Protocol for data persistence service to enable dependency injection and testing
@MainActor
protocol DataServiceProtocol {
    
    // MARK: - Profile Operations
    
    /// Fetches all profiles ordered by name
    func fetchProfiles() throws -> [Profile]
    
    /// Fetches the currently enabled profile
    func fetchEnabledProfile() throws -> Profile?
    
    /// Fetches a profile by name
    func fetchProfile(named name: String) throws -> Profile?
    
    /// Creates a new profile
    func createProfile(_ profile: Profile) throws
    
    /// Updates an existing profile
    func updateProfile(_ profile: Profile) throws
    
    /// Deletes a profile
    func deleteProfile(_ profile: Profile) throws
    
    /// Switches the enabled profile (disables all others, enables the specified one)
    func switchToProfile(_ profile: Profile) throws
    
    // MARK: - AppSettings Operations
    
    /// Fetches the app settings (singleton)
    func fetchAppSettings() throws -> AppSettings
    
    /// Updates app settings
    func updateAppSettings(_ settings: AppSettings) throws
    
    // MARK: - Service Configuration Operations
    
    /// Creates or updates a service configuration for a profile
    func updateServiceConfiguration<T>(_ configuration: T, for profile: Profile) throws where T: AnyObject
    
    // MARK: - Credential Operations
    
    /// Saves API key for a service configuration to Keychain
    /// - Parameters:
    ///   - apiKey: The API key to store securely
    ///   - configuration: The service configuration
    func saveAPIKey(_ apiKey: String, for configuration: ServiceConfiguration) throws
    
    /// Retrieves API key for a service configuration from Keychain
    /// - Parameter configuration: The service configuration
    /// - Returns: The API key if found, nil otherwise
    func getAPIKey(for configuration: ServiceConfiguration) -> String?
    
    /// Saves username and password for a service configuration to Keychain
    /// - Parameters:
    ///   - username: The username to store securely
    ///   - password: The password to store securely
    ///   - configuration: The service configuration
    func saveUsernamePassword(username: String, password: String, for configuration: ServiceConfiguration) throws
    
    /// Retrieves username and password for a service configuration from Keychain
    /// - Parameter configuration: The service configuration
    /// - Returns: Tuple of (username, password) if found, nil otherwise
    func getUsernamePassword(for configuration: ServiceConfiguration) -> (username: String, password: String)?
    
    /// Deletes all credentials for a service configuration from Keychain
    /// - Parameter configuration: The service configuration
    func deleteCredentials(for configuration: ServiceConfiguration) throws
    
    /// Validates a service configuration including credentials
    /// - Parameter configuration: The service configuration to validate
    /// - Returns: True if valid (including required credentials), false otherwise
    func validateServiceConfiguration(_ configuration: ServiceConfiguration) -> Bool
    
    // MARK: - Indexer Operations
    
    /// Fetches all indexers ordered by display name
    func fetchIndexers() throws -> [Indexer]
    
    /// Creates a new indexer
    func createIndexer(_ indexer: Indexer) throws
    
    /// Updates an existing indexer
    func updateIndexer(_ indexer: Indexer) throws
    
    /// Deletes an indexer
    func deleteIndexer(_ indexer: Indexer) throws
    
    // MARK: - External Module Operations
    
    /// Fetches all external modules ordered by display name
    func fetchExternalModules() throws -> [ExternalModule]
    
    /// Creates a new external module
    func createExternalModule(_ module: ExternalModule) throws
    
    /// Updates an existing external module
    func updateExternalModule(_ module: ExternalModule) throws
    
    /// Deletes an external module
    func deleteExternalModule(_ module: ExternalModule) throws
    
    // MARK: - Bootstrap
    
    /// Bootstraps the database with default data on first launch
    func bootstrap() throws
    
    // MARK: - Utility
    
    /// Saves the current context
    func save() throws
    
    /// Resets the entire database (for testing/debugging)
    func reset() throws
    
    /// Returns the current schema version from the database
    func currentSchemaVersion() -> SchemaVersion
    
    /// Checks if migration is needed
    func migrationNeeded() -> Bool
}
