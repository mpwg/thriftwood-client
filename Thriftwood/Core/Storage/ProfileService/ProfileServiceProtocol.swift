//
//  ProfileServiceProtocol.swift
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

/// Protocol defining profile management operations
/// Enables dependency injection and testing
@MainActor
protocol ProfileServiceProtocol {
    
    // MARK: - Profile CRUD Operations
    
    /// Fetches all profiles ordered by name
    func fetchProfiles() throws -> [Profile]
    
    /// Fetches the currently enabled profile
    func fetchEnabledProfile() throws -> Profile?
    
    /// Fetches a profile by name
    func fetchProfile(named name: String) throws -> Profile?
    
    /// Fetches a profile by ID
    func fetchProfile(id: UUID) throws -> Profile?
    
    /// Creates a new profile
    func createProfile(name: String, enableImmediately: Bool) throws -> Profile
    
    /// Updates an existing profile
    func updateProfile(_ profile: Profile) throws
    
    /// Deletes a profile (with validation)
    func deleteProfile(_ profile: Profile) throws
    
    /// Renames a profile
    func renameProfile(_ profile: Profile, newName: String) throws
    
    // MARK: - Profile Switching
    
    /// Switches to a different profile (disables all others)
    func switchToProfile(_ profile: Profile) throws
    
    /// Switches to a profile by name
    func switchToProfile(named name: String) throws
    
    // MARK: - Profile Validation
    
    /// Validates a profile can be deleted (e.g., not the last profile)
    func canDeleteProfile(_ profile: Profile) throws -> Bool
    
    /// Validates a profile name is unique
    func isProfileNameAvailable(_ name: String, excluding: Profile?) throws -> Bool
    
    // MARK: - Service Configuration Management
    
    /// Attaches a service configuration to a profile
    func attachServiceConfiguration<T: ServiceConfiguration>(_ configuration: T, to profile: Profile) throws
    
    /// Detaches a service configuration from a profile
    func detachServiceConfiguration<T: ServiceConfiguration>(_ configuration: T, from profile: Profile) throws
    
    // MARK: - Export/Import Operations
    
    /// Exports a profile to JSON format
    /// Includes all service configurations but NOT credentials (for security)
    func exportProfile(_ profile: Profile) throws -> Data
    
    /// Exports all profiles to JSON format
    func exportAllProfiles() throws -> Data
    
    /// Imports a profile from JSON data
    /// - Parameters:
    ///   - data: JSON data containing profile information
    ///   - overwriteExisting: Whether to overwrite if profile with same name exists
    /// - Returns: The imported profile
    func importProfile(from data: Data, overwriteExisting: Bool) throws -> Profile
    
    /// Imports multiple profiles from JSON data
    func importProfiles(from data: Data, overwriteExisting: Bool) throws -> [Profile]
    
    /// Validates import data before importing
    func validateImportData(_ data: Data) throws -> ProfileImportValidation
}

// MARK: - Supporting Types

/// Result of import data validation
struct ProfileImportValidation {
    /// Whether the data is valid for import
    let isValid: Bool
    
    /// Number of profiles found in the data
    let profileCount: Int
    
    /// Profile names found in the data
    let profileNames: [String]
    
    /// Names that conflict with existing profiles
    let conflictingNames: [String]
    
    /// Validation errors (if any)
    let errors: [String]
}

/// Exportable profile data structure
struct ExportableProfile: Codable {
    let id: UUID
    let name: String
    let isEnabled: Bool
    let createdAt: Date
    let updatedAt: Date
    let serviceConfigurations: [ExportableServiceConfiguration]
}

/// Exportable service configuration data structure
struct ExportableServiceConfiguration: Codable {
    let id: UUID
    let serviceType: String
    let isEnabled: Bool
    let host: String?
    let port: Int?
    let customHeaders: [String: String]
    let authenticationType: String
    
    // Note: Credentials (API keys, passwords) are NOT included for security
}

/// Container for multiple profile exports
struct ExportableProfiles: Codable {
    let version: String
    let exportDate: Date
    let profiles: [ExportableProfile]
}
