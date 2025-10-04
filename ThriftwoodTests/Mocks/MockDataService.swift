//
//  MockDataService.swift
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

import Foundation
@testable import Thriftwood

/// Mock implementation of DataServiceProtocol for testing
@MainActor
final class MockDataService: DataServiceProtocol {
    
    // MARK: - Mock Storage
    
    private var profiles: [Profile] = []
    private var appSettings: AppSettings = AppSettings.createDefault()
    private var indexers: [Indexer] = []
    private var externalModules: [ExternalModule] = []
    private var credentials: [UUID: (apiKey: String?, username: String?, password: String?)] = [:]
    
    // MARK: - Profile Operations
    
    func fetchProfiles() throws -> [Profile] {
        return profiles.sorted { $0.name < $1.name }
    }
    
    func fetchEnabledProfile() throws -> Profile? {
        return profiles.first { $0.isEnabled }
    }
    
    func fetchProfile(named name: String) throws -> Profile? {
        return profiles.first { $0.name == name }
    }
    
    func createProfile(_ profile: Profile) throws {
        profiles.append(profile)
    }
    
    func updateProfile(_ profile: Profile) throws {
        // Profile is already in array, just mark as updated
        profile.markAsUpdated()
    }
    
    func deleteProfile(_ profile: Profile) throws {
        profiles.removeAll { $0.id == profile.id }
    }
    
    func switchToProfile(_ profile: Profile) throws {
        for p in profiles {
            p.isEnabled = false
        }
        profile.isEnabled = true
        profile.markAsUpdated()
    }
    
    // MARK: - AppSettings Operations
    
    func fetchAppSettings() throws -> AppSettings {
        return appSettings
    }
    
    func updateAppSettings(_ settings: AppSettings) throws {
        self.appSettings = settings
        settings.markAsUpdated()
    }
    
    // MARK: - Service Configuration Operations
    
    func updateServiceConfiguration<T>(_ configuration: T, for profile: Profile) throws where T: AnyObject {
        // Mock implementation - no-op
    }
    
    // MARK: - Credential Operations
    
    func saveAPIKey(_ apiKey: String, for configuration: ServiceConfiguration) throws {
        var cred = credentials[configuration.id] ?? (nil, nil, nil)
        cred.apiKey = apiKey
        credentials[configuration.id] = cred
    }
    
    func getAPIKey(for configuration: ServiceConfiguration) -> String? {
        return credentials[configuration.id]?.apiKey
    }
    
    func saveUsernamePassword(username: String, password: String, for configuration: ServiceConfiguration) throws {
        var cred = credentials[configuration.id] ?? (nil, nil, nil)
        cred.username = username
        cred.password = password
        credentials[configuration.id] = cred
    }
    
    func getUsernamePassword(for configuration: ServiceConfiguration) -> (username: String, password: String)? {
        guard let cred = credentials[configuration.id],
              let username = cred.username,
              let password = cred.password else {
            return nil
        }
        return (username, password)
    }
    
    func deleteCredentials(for configuration: ServiceConfiguration) throws {
        credentials.removeValue(forKey: configuration.id)
    }
    
    func validateServiceConfiguration(_ configuration: ServiceConfiguration) -> Bool {
        guard configuration.isValid() else { return false }
        guard configuration.isEnabled else { return true }
        
        switch configuration.authenticationType {
        case .apiKey:
            let apiKey = getAPIKey(for: configuration)
            return apiKey != nil && !apiKey!.isEmpty
        case .usernamePassword:
            let creds = getUsernamePassword(for: configuration)
            return creds != nil && !creds!.username.isEmpty && !creds!.password.isEmpty
        case .none:
            return true
        }
    }
    
    // MARK: - Indexer Operations
    
    func fetchIndexers() throws -> [Indexer] {
        return indexers.sorted { $0.displayName < $1.displayName }
    }
    
    func createIndexer(_ indexer: Indexer) throws {
        indexers.append(indexer)
    }
    
    func updateIndexer(_ indexer: Indexer) throws {
        // Indexer is already in array, no-op
    }
    
    func deleteIndexer(_ indexer: Indexer) throws {
        indexers.removeAll { $0.id == indexer.id }
    }
    
    // MARK: - External Module Operations
    
    func fetchExternalModules() throws -> [ExternalModule] {
        return externalModules.sorted { $0.displayName < $1.displayName }
    }
    
    func createExternalModule(_ module: ExternalModule) throws {
        externalModules.append(module)
    }
    
    func updateExternalModule(_ module: ExternalModule) throws {
        // Module is already in array, no-op
    }
    
    func deleteExternalModule(_ module: ExternalModule) throws {
        externalModules.removeAll { $0.id == module.id }
    }
    
    // MARK: - Bootstrap
    
    func bootstrap() throws {
        if try fetchProfile(named: Profile.defaultProfileName) == nil {
            let defaultProfile = Profile.createDefault()
            try createProfile(defaultProfile)
        }
    }
    
    // MARK: - Utility
    
    func save() throws {
        // Mock implementation - no-op
    }
    
    func reset() throws {
        profiles.removeAll()
        indexers.removeAll()
        externalModules.removeAll()
        credentials.removeAll()
        appSettings = AppSettings.createDefault()
    }
    
    func currentSchemaVersion() -> SchemaVersion {
        return SchemaVersion.current
    }
    
    func migrationNeeded() -> Bool {
        return false
    }
}
