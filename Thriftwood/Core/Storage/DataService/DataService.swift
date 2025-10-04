//
//  DataService.swift
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
//  DataService.swift
//  Thriftwood
//
//  Service for managing SwiftData persistence operations
//  Provides CRUD operations for all models
//

import Foundation
import SwiftData
import Combine

/// Service for managing data persistence with SwiftData
@MainActor
final class DataService: DataServiceProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private let keychainService: any KeychainServiceProtocol
    
    init(modelContainer: ModelContainer, keychainService: any KeychainServiceProtocol) {
        self.modelContainer = modelContainer
        self.modelContext = modelContainer.mainContext
        self.keychainService = keychainService
    }
    
    // MARK: - Profile Operations
    
    /// Fetches all profiles ordered by name
    func fetchProfiles() throws -> [Profile] {
        let descriptor = FetchDescriptor<Profile>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Fetches the currently enabled profile
    func fetchEnabledProfile() throws -> Profile? {
        let descriptor = FetchDescriptor<Profile>(
            predicate: #Predicate { $0.isEnabled == true }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    /// Fetches a profile by name
    func fetchProfile(named name: String) throws -> Profile? {
        let descriptor = FetchDescriptor<Profile>(
            predicate: #Predicate { $0.name == name }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    /// Creates a new profile
    func createProfile(_ profile: Profile) throws {
        modelContext.insert(profile)
        try modelContext.save()
    }
    
    /// Updates an existing profile
    func updateProfile(_ profile: Profile) throws {
        profile.markAsUpdated()
        try modelContext.save()
    }
    
    /// Deletes a profile
    func deleteProfile(_ profile: Profile) throws {
        modelContext.delete(profile)
        try modelContext.save()
    }
    
    /// Switches the enabled profile (disables all others, enables the specified one)
    func switchToProfile(_ profile: Profile) throws {
        // Disable all profiles
        let allProfiles = try fetchProfiles()
        for p in allProfiles {
            p.isEnabled = false
        }
        
        // Enable the specified profile
        profile.isEnabled = true
        profile.markAsUpdated()
        
        try modelContext.save()
    }
    
    // MARK: - AppSettings Operations
    
    /// Fetches the app settings (singleton)
    func fetchAppSettings() throws -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()
        if let settings = try modelContext.fetch(descriptor).first {
            return settings
        } else {
            // Create default settings if none exist
            let defaultSettings = AppSettings.createDefault()
            modelContext.insert(defaultSettings)
            try modelContext.save()
            return defaultSettings
        }
    }
    
    /// Updates app settings
    func updateAppSettings(_ settings: AppSettings) throws {
        settings.markAsUpdated()
        try modelContext.save()
    }
    
    // MARK: - Service Configuration Operations
    
    /// Creates or updates a service configuration for a profile
    func updateServiceConfiguration<T>(_ configuration: T, for profile: Profile) throws where T: AnyObject {
        // SwiftData will automatically manage relationships
        // Just save the context
        try modelContext.save()
    }
    
    // MARK: - Credential Operations
    
    /// Saves API key for a service configuration to Keychain
    /// - Parameters:
    ///   - apiKey: The API key to store securely
    ///   - configuration: The service configuration
    func saveAPIKey(_ apiKey: String, for configuration: ServiceConfiguration) throws {
        try keychainService.saveAPIKey(apiKey, for: configuration.id)
    }
    
    /// Retrieves API key for a service configuration from Keychain
    /// - Parameter configuration: The service configuration
    /// - Returns: The API key if found, nil otherwise
    func getAPIKey(for configuration: ServiceConfiguration) -> String? {
        keychainService.getAPIKey(for: configuration.id)
    }
    
    /// Saves username and password for a service configuration to Keychain
    /// - Parameters:
    ///   - username: The username to store securely
    ///   - password: The password to store securely
    ///   - configuration: The service configuration
    func saveUsernamePassword(username: String, password: String, for configuration: ServiceConfiguration) throws {
        try keychainService.saveUsernamePassword(username: username, password: password, for: configuration.id)
    }
    
    /// Retrieves username and password for a service configuration from Keychain
    /// - Parameter configuration: The service configuration
    /// - Returns: Tuple of (username, password) if found, nil otherwise
    func getUsernamePassword(for configuration: ServiceConfiguration) -> (username: String, password: String)? {
        keychainService.getUsernamePassword(for: configuration.id)
    }
    
    /// Deletes all credentials for a service configuration from Keychain
    /// - Parameter configuration: The service configuration
    func deleteCredentials(for configuration: ServiceConfiguration) throws {
        try keychainService.deleteCredentials(for: configuration.id)
    }
    
    /// Validates a service configuration including credentials
    /// - Parameter configuration: The service configuration to validate
    /// - Returns: True if valid (including required credentials), false otherwise
    func validateServiceConfiguration(_ configuration: ServiceConfiguration) -> Bool {
        // First validate the basic configuration
        guard configuration.isValid() else { return false }
        
        // Skip credential validation if service is disabled
        guard configuration.isEnabled else { return true }
        
        // Check credentials based on authentication type
        switch configuration.authenticationType {
        case .apiKey:
            let apiKey = getAPIKey(for: configuration)
            return apiKey != nil && !apiKey!.isEmpty
        case .usernamePassword:
            let credentials = getUsernamePassword(for: configuration)
            return credentials != nil && !credentials!.username.isEmpty && !credentials!.password.isEmpty
        case .none:
            return true
        }
    }
    
    // MARK: - Indexer Operations
    
    /// Fetches all indexers ordered by display name
    func fetchIndexers() throws -> [Indexer] {
        let descriptor = FetchDescriptor<Indexer>(
            sortBy: [SortDescriptor(\.displayName)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Creates a new indexer
    func createIndexer(_ indexer: Indexer) throws {
        modelContext.insert(indexer)
        try modelContext.save()
    }
    
    /// Updates an existing indexer
    func updateIndexer(_ indexer: Indexer) throws {
        try modelContext.save()
    }
    
    /// Deletes an indexer
    func deleteIndexer(_ indexer: Indexer) throws {
        modelContext.delete(indexer)
        try modelContext.save()
    }
    
    // MARK: - External Module Operations
    
    /// Fetches all external modules ordered by display name
    func fetchExternalModules() throws -> [ExternalModule] {
        let descriptor = FetchDescriptor<ExternalModule>(
            sortBy: [SortDescriptor(\.displayName)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Creates a new external module
    func createExternalModule(_ module: ExternalModule) throws {
        modelContext.insert(module)
        try modelContext.save()
    }
    
    /// Updates an existing external module
    func updateExternalModule(_ module: ExternalModule) throws {
        try modelContext.save()
    }
    
    /// Deletes an external module
    func deleteExternalModule(_ module: ExternalModule) throws {
        modelContext.delete(module)
        try modelContext.save()
    }
    
    // MARK: - Bootstrap
    
    /// Bootstraps the database with default data on first launch
    func bootstrap() throws {
        // Check if default profile already exists
        if let _ = try fetchProfile(named: Profile.defaultProfileName) {
            return // Already bootstrapped
        }
        
        // Create default profile
        let defaultProfile = Profile.createDefault()
        try createProfile(defaultProfile)
        
        // Ensure default app settings exist
        _ = try fetchAppSettings()
    }
    
    // MARK: - Utility
    
    /// Saves the current context
    func save() throws {
        try modelContext.save()
    }
    
    /// Resets the entire database (for testing/debugging)
    func reset() throws {
        // Delete all profiles
        let profiles = try fetchProfiles()
        for profile in profiles {
            modelContext.delete(profile)
        }
        
        // Delete all indexers
        let indexers = try fetchIndexers()
        for indexer in indexers {
            modelContext.delete(indexer)
        }
        
        // Delete all external modules
        let modules = try fetchExternalModules()
        for module in modules {
            modelContext.delete(module)
        }
        
        // Delete app settings
        let descriptor = FetchDescriptor<AppSettings>()
        if let settings = try modelContext.fetch(descriptor).first {
            modelContext.delete(settings)
        }
        
        // Delete all credentials from Keychain
        try keychainService.deleteAllCredentials()
        
        try modelContext.save()
    }
}


extension DataService {
    /// Returns the current schema version from the database
    func currentSchemaVersion() -> SchemaVersion {
        return SchemaVersion.current
    }
    
    /// Checks if migration is needed
    func migrationNeeded() -> Bool {
        // SwiftData handles automatic migrations
        // This is for custom migration logic
        return false
    }
}
