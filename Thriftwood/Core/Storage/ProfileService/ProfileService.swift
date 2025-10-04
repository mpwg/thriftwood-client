//
//  ProfileService.swift
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
import SwiftData

/// Service for managing profile operations including CRUD and export/import
@MainActor
final class ProfileService: ProfileServiceProtocol {
    
    // MARK: - Properties
    
    private let dataService: any DataServiceProtocol
    
    // MARK: - Initialization
    
    init(dataService: any DataServiceProtocol) {
        self.dataService = dataService
    }
    
    // MARK: - Profile CRUD Operations
    
    func fetchProfiles() throws -> [Profile] {
        return try dataService.fetchProfiles()
    }
    
    func fetchEnabledProfile() throws -> Profile? {
        return try dataService.fetchEnabledProfile()
    }
    
    func fetchProfile(named name: String) throws -> Profile? {
        return try dataService.fetchProfile(named: name)
    }
    
    func fetchProfile(id: UUID) throws -> Profile? {
        let profiles = try fetchProfiles()
        return profiles.first { $0.id == id }
    }
    
    func createProfile(name: String, enableImmediately: Bool) throws -> Profile {
        // Validate name is not empty
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ThriftwoodError.validation(message: "Profile name cannot be empty")
        }
        
        // Validate name is unique
        guard try isProfileNameAvailable(name, excluding: nil) else {
            throw ThriftwoodError.validation(message: "Profile name '\(name)' already exists")
        }
        
        // Create profile
        let profile = Profile(name: name, isEnabled: false)
        try dataService.createProfile(profile)
        
        // Enable immediately if requested
        if enableImmediately {
            try switchToProfile(profile)
        }
        
        return profile
    }
    
    func updateProfile(_ profile: Profile) throws {
        try dataService.updateProfile(profile)
    }
    
    func deleteProfile(_ profile: Profile) throws {
        // Validate deletion is allowed
        guard try canDeleteProfile(profile) else {
            throw ThriftwoodError.validation(message: "Cannot delete the last profile")
        }
        
        // If deleting the enabled profile, switch to another profile first
        if profile.isEnabled {
            let allProfiles = try fetchProfiles()
            if let nextProfile = allProfiles.first(where: { $0.id != profile.id }) {
                try switchToProfile(nextProfile)
            }
        }
        
        try dataService.deleteProfile(profile)
    }
    
    func renameProfile(_ profile: Profile, newName: String) throws {
        // Validate name is not empty
        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ThriftwoodError.validation(message: "Profile name cannot be empty")
        }
        
        // Validate name is unique (excluding current profile)
        guard try isProfileNameAvailable(newName, excluding: profile) else {
            throw ThriftwoodError.validation(message: "Profile name '\(newName)' already exists")
        }
        
        profile.name = newName
        try updateProfile(profile)
    }
    
    // MARK: - Profile Switching
    
    func switchToProfile(_ profile: Profile) throws {
        try dataService.switchToProfile(profile)
    }
    
    func switchToProfile(named name: String) throws {
        guard let profile = try fetchProfile(named: name) else {
            throw ThriftwoodError.notFound(message: "Profile named '\(name)' not found")
        }
        try switchToProfile(profile)
    }
    
    // MARK: - Profile Validation
    
    func canDeleteProfile(_ profile: Profile) throws -> Bool {
        let allProfiles = try fetchProfiles()
        // Can't delete if it's the only profile
        return allProfiles.count > 1
    }
    
    func isProfileNameAvailable(_ name: String, excluding: Profile?) throws -> Bool {
        let allProfiles = try fetchProfiles()
        let existingProfile = allProfiles.first { $0.name.lowercased() == name.lowercased() }
        
        // Name is available if it doesn't exist, or if it's the excluded profile
        if let existingProfile = existingProfile {
            return excluding?.id == existingProfile.id
        }
        return true
    }
    
    // MARK: - Service Configuration Management
    
    func attachServiceConfiguration<T: ServiceConfiguration>(_ configuration: T, to profile: Profile) throws {
        configuration.profile = profile
        try dataService.updateServiceConfiguration(configuration, for: profile)
    }
    
    func detachServiceConfiguration<T: ServiceConfiguration>(_ configuration: T, from profile: Profile) throws {
        configuration.profile = nil
        try dataService.updateServiceConfiguration(configuration, for: profile)
    }
    
    // MARK: - Export/Import Operations
    
    func exportProfile(_ profile: Profile) throws -> Data {
        let exportable = try convertToExportable(profile)
        let container = ExportableProfiles(
            version: "1.0",
            exportDate: Date(),
            profiles: [exportable]
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        return try encoder.encode(container)
    }
    
    func exportAllProfiles() throws -> Data {
        let profiles = try fetchProfiles()
        let exportables = try profiles.map { try convertToExportable($0) }
        
        let container = ExportableProfiles(
            version: "1.0",
            exportDate: Date(),
            profiles: exportables
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        return try encoder.encode(container)
    }
    
    func importProfile(from data: Data, overwriteExisting: Bool) throws -> Profile {
        let profiles = try importProfiles(from: data, overwriteExisting: overwriteExisting)
        guard let profile = profiles.first else {
            throw ThriftwoodError.data(message: "No profiles found in import data")
        }
        return profile
    }
    
    func importProfiles(from data: Data, overwriteExisting: Bool) throws -> [Profile] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let container = try decoder.decode(ExportableProfiles.self, from: data)
        
        var importedProfiles: [Profile] = []
        
        for exportable in container.profiles {
            // Check if profile with same name exists
            let existingProfile = try fetchProfile(named: exportable.name)
            
            let profile: Profile
            if let existing = existingProfile {
                if overwriteExisting {
                    // Update existing profile
                    existing.name = exportable.name
                    existing.markAsUpdated()
                    profile = existing
                } else {
                    // Skip this profile
                    continue
                }
            } else {
                // Create new profile
                profile = Profile(
                    name: exportable.name,
                    isEnabled: false, // Never auto-enable imported profiles
                    createdAt: exportable.createdAt,
                    updatedAt: exportable.updatedAt
                )
                try dataService.createProfile(profile)
            }
            
            // Import service configurations
            for exportableConfig in exportable.serviceConfigurations {
                let config = try convertFromExportable(exportableConfig)
                config.profile = profile
                try dataService.updateServiceConfiguration(config, for: profile)
            }
            
            importedProfiles.append(profile)
        }
        
        return importedProfiles
    }
    
    func validateImportData(_ data: Data) throws -> ProfileImportValidation {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let container = try decoder.decode(ExportableProfiles.self, from: data)
            
            let profileNames = container.profiles.map { $0.name }
            let allProfiles = try fetchProfiles()
            let existingNames = Set(allProfiles.map { $0.name })
            let conflictingNames = profileNames.filter { existingNames.contains($0) }
            
            return ProfileImportValidation(
                isValid: true,
                profileCount: container.profiles.count,
                profileNames: profileNames,
                conflictingNames: conflictingNames,
                errors: []
            )
        } catch {
            return ProfileImportValidation(
                isValid: false,
                profileCount: 0,
                profileNames: [],
                conflictingNames: [],
                errors: [error.localizedDescription]
            )
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func convertToExportable(_ profile: Profile) throws -> ExportableProfile {
        let configurations = profile.serviceConfigurations.map { config in
            ExportableServiceConfiguration(
                id: config.id,
                serviceType: config.serviceType.rawValue,
                isEnabled: config.isEnabled,
                host: config.host.isEmpty ? nil : config.host,
                port: nil, // Port is part of host URL
                customHeaders: config.headers,
                authenticationType: config.authenticationType.rawValue
            )
        }
        
        return ExportableProfile(
            id: profile.id,
            name: profile.name,
            isEnabled: profile.isEnabled,
            createdAt: profile.createdAt,
            updatedAt: profile.updatedAt,
            serviceConfigurations: configurations
        )
    }
    
    private func convertFromExportable(_ exportable: ExportableServiceConfiguration) throws -> ServiceConfiguration {
        guard let serviceType = ServiceType(rawValue: exportable.serviceType) else {
            throw ThriftwoodError.data(message: "Invalid service type: \(exportable.serviceType)")
        }
        
        guard let authType = AuthenticationType(rawValue: exportable.authenticationType) else {
            throw ThriftwoodError.data(message: "Invalid authentication type: \(exportable.authenticationType)")
        }
        
        return ServiceConfiguration(
            id: exportable.id,
            serviceType: serviceType,
            isEnabled: exportable.isEnabled,
            host: exportable.host ?? "",
            authenticationType: authType,
            headers: exportable.customHeaders
        )
    }
}
