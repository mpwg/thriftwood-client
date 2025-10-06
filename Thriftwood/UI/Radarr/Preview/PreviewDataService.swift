//
//  PreviewDataService.swift
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

/// Simple preview service for SwiftUI previews
///
/// This service provides minimal implementations for preview purposes only.
/// It should NOT be used in production code or tests - use MockDataService instead.
///
/// **Purpose**: Allows SwiftUI previews to compile without complex dependencies,
/// maintaining separation of concerns for preview-only scenarios.
final class PreviewDataService: DataServiceProtocol, @unchecked Sendable {
    // MARK: - Profile Operations
    
    func fetchProfiles() throws -> [Profile] { [] }
    
    func fetchEnabledProfile() throws -> Profile? { nil }
    
    func fetchProfile(named name: String) throws -> Profile? { nil }
    
    func createProfile(_ profile: Profile) throws {}
    
    func updateProfile(_ profile: Profile) throws {}
    
    func deleteProfile(_ profile: Profile) throws {}
    
    func switchToProfile(_ profile: Profile) throws {}
    
    // MARK: - AppSettings Operations
    
    func fetchAppSettings() throws -> AppSettings {
        AppSettings()
    }
    
    func updateAppSettings(_ settings: AppSettings) throws {}
    
    // MARK: - Service Configuration Operations
    
    func updateServiceConfiguration<T>(_ configuration: T, for profile: Profile) throws where T: AnyObject {}
    
    // MARK: - Credential Operations
    
    func saveAPIKey(_ apiKey: String, for configuration: ServiceConfiguration) throws {}
    
    func getAPIKey(for configuration: ServiceConfiguration) -> String? { nil }
    
    func saveUsernamePassword(username: String, password: String, for configuration: ServiceConfiguration) throws {}
    
    func getUsernamePassword(for configuration: ServiceConfiguration) -> (username: String, password: String)? { nil }
    
    func deleteCredentials(for configuration: ServiceConfiguration) throws {}
    
    func validateServiceConfiguration(_ configuration: ServiceConfiguration) -> Bool { true }
    
    // MARK: - Indexer Operations
    
    func fetchIndexers() throws -> [Indexer] { [] }
    
    func createIndexer(_ indexer: Indexer) throws {}
    
    func updateIndexer(_ indexer: Indexer) throws {}
    
    func deleteIndexer(_ indexer: Indexer) throws {}
    
    // MARK: - External Module Operations
    
    func fetchExternalModules() throws -> [ExternalModule] { [] }
    
    func createExternalModule(_ module: ExternalModule) throws {}
    
    func updateExternalModule(_ module: ExternalModule) throws {}
    
    func deleteExternalModule(_ module: ExternalModule) throws {}
    
    // MARK: - Bootstrap
    
    func bootstrap() throws {}
    
    // MARK: - Utility
    
    func save() throws {}
    
    func reset() throws {}
    
    func currentSchemaVersion() -> SchemaVersion { SchemaVersion.v1 }
    
    func migrationNeeded() -> Bool { false }
}
