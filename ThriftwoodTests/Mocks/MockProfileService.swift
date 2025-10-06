//
//  MockProfileService.swift
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

/// Mock implementation of ProfileServiceProtocol for testing
@MainActor
final class MockProfileService: ProfileServiceProtocol {
    
    // MARK: - Properties
    
    var profiles: [Profile] = []
    var shouldThrowError = false
    var errorToThrow: any Error = NSError(domain: "MockProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Call Tracking
    
    var fetchProfilesCalled = false
    var fetchEnabledProfileCalled = false
    var createProfileCalled = false
    var updateProfileCalled = false
    var deleteProfileCalled = false
    var renameProfileCalled = false
    var switchToProfileCalled = false
    var exportProfileCalled = false
    var exportAllProfilesCalled = false
    var importProfileCalled = false
    var importProfilesCalled = false
    var validateImportDataCalled = false
    
    var lastCreatedProfileName: String?
    var lastDeletedProfile: Profile?
    var lastRenamedProfile: Profile?
    var lastNewName: String?
    var lastSwitchedProfile: Profile?
    var lastExportedProfile: Profile?
    var lastImportData: Data?
    var lastOverwriteExisting: Bool?
    
    // MARK: - Initialization
    
    init() {
        // Start with a default profile
        let defaultProfile = Profile.createDefault()
        profiles = [defaultProfile]
    }
    
    // MARK: - Reset Methods
    
    func reset() {
        profiles = []
        resetCallTracking()
        resetErrorState()
    }
    
    func resetCallTracking() {
        fetchProfilesCalled = false
        fetchEnabledProfileCalled = false
        createProfileCalled = false
        updateProfileCalled = false
        deleteProfileCalled = false
        renameProfileCalled = false
        switchToProfileCalled = false
        exportProfileCalled = false
        exportAllProfilesCalled = false
        importProfileCalled = false
        importProfilesCalled = false
        validateImportDataCalled = false
        
        lastCreatedProfileName = nil
        lastDeletedProfile = nil
        lastRenamedProfile = nil
        lastNewName = nil
        lastSwitchedProfile = nil
        lastExportedProfile = nil
        lastImportData = nil
        lastOverwriteExisting = nil
    }
    
    func resetErrorState() {
        shouldThrowError = false
        errorToThrow = NSError(domain: "MockProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    }
    
    // MARK: - ProfileServiceProtocol Implementation
    
    func fetchProfiles() throws -> [Profile] {
        fetchProfilesCalled = true
        if shouldThrowError { throw errorToThrow }
        return profiles.sorted { $0.name < $1.name }
    }
    
    func fetchEnabledProfile() throws -> Profile? {
        fetchEnabledProfileCalled = true
        if shouldThrowError { throw errorToThrow }
        return profiles.first { $0.isEnabled }
    }
    
    func fetchProfile(named name: String) throws -> Profile? {
        if shouldThrowError { throw errorToThrow }
        return profiles.first { $0.name == name }
    }
    
    func fetchProfile(id: UUID) throws -> Profile? {
        if shouldThrowError { throw errorToThrow }
        return profiles.first { $0.id == id }
    }
    
    func createProfile(name: String, enableImmediately: Bool) throws -> Profile {
        createProfileCalled = true
        lastCreatedProfileName = name
        if shouldThrowError { throw errorToThrow }
        
        let profile = Profile(name: name, isEnabled: false)
        profiles.append(profile)
        
        if enableImmediately {
            try switchToProfile(profile)
        }
        
        return profile
    }
    
    func updateProfile(_ profile: Profile) throws {
        updateProfileCalled = true
        if shouldThrowError { throw errorToThrow }
        profile.markAsUpdated()
    }
    
    func deleteProfile(_ profile: Profile) throws {
        deleteProfileCalled = true
        lastDeletedProfile = profile
        if shouldThrowError { throw errorToThrow }
        
        guard try canDeleteProfile(profile) else {
            throw ThriftwoodError.validation(message: "Cannot delete the last profile")
        }
        
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles.remove(at: index)
        }
    }
    
    func renameProfile(_ profile: Profile, newName: String) throws {
        renameProfileCalled = true
        lastRenamedProfile = profile
        lastNewName = newName
        if shouldThrowError { throw errorToThrow }
        
        profile.name = newName
        try updateProfile(profile)
    }
    
    func switchToProfile(_ profile: Profile) throws {
        switchToProfileCalled = true
        lastSwitchedProfile = profile
        if shouldThrowError { throw errorToThrow }
        
        for existingProfile in profiles {
            existingProfile.isEnabled = false
        }
        profile.isEnabled = true
        profile.markAsUpdated()
    }
    
    func switchToProfile(named name: String) throws {
        if shouldThrowError { throw errorToThrow }
        guard let profile = try fetchProfile(named: name) else {
            throw ThriftwoodError.notFound(message: "Profile named '\(name)' not found")
        }
        try switchToProfile(profile)
    }
    
    func canDeleteProfile(_ profile: Profile) throws -> Bool {
        if shouldThrowError { throw errorToThrow }
        return profiles.count > 1
    }
    
    func isProfileNameAvailable(_ name: String, excluding: Profile?) throws -> Bool {
        if shouldThrowError { throw errorToThrow }
        let existingProfile = profiles.first { $0.name.lowercased() == name.lowercased() }
        
        if let existingProfile = existingProfile {
            return excluding?.id == existingProfile.id
        }
        return true
    }
    
    func attachServiceConfiguration<T: ServiceConfiguration>(_ configuration: T, to profile: Profile) throws {
        if shouldThrowError { throw errorToThrow }
        configuration.profile = profile
    }
    
    func detachServiceConfiguration<T: ServiceConfiguration>(_ configuration: T, from profile: Profile) throws {
        if shouldThrowError { throw errorToThrow }
        configuration.profile = nil
    }
    
    func exportProfile(_ profile: Profile) throws -> Data {
        exportProfileCalled = true
        lastExportedProfile = profile
        if shouldThrowError { throw errorToThrow }
        
        let exportable = ExportableProfile(
            id: profile.id,
            name: profile.name,
            isEnabled: profile.isEnabled,
            createdAt: profile.createdAt,
            updatedAt: profile.updatedAt,
            serviceConfigurations: []
        )
        
        let container = ExportableProfiles(
            version: "1.0",
            exportDate: Date(),
            profiles: [exportable]
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(container)
    }
    
    func exportAllProfiles() throws -> Data {
        exportAllProfilesCalled = true
        if shouldThrowError { throw errorToThrow }
        
        let exportables = profiles.map { profile in
            ExportableProfile(
                id: profile.id,
                name: profile.name,
                isEnabled: profile.isEnabled,
                createdAt: profile.createdAt,
                updatedAt: profile.updatedAt,
                serviceConfigurations: []
            )
        }
        
        let container = ExportableProfiles(
            version: "1.0",
            exportDate: Date(),
            profiles: exportables
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(container)
    }
    
    func importProfile(from data: Data, overwriteExisting: Bool) throws -> Profile {
        importProfileCalled = true
        lastImportData = data
        lastOverwriteExisting = overwriteExisting
        if shouldThrowError { throw errorToThrow }
        
        let imported = try importProfiles(from: data, overwriteExisting: overwriteExisting)
        guard let profile = imported.first else {
            throw ThriftwoodError.data(message: "No profiles found in import data")
        }
        return profile
    }
    
    func importProfiles(from data: Data, overwriteExisting: Bool) throws -> [Profile] {
        importProfilesCalled = true
        lastImportData = data
        lastOverwriteExisting = overwriteExisting
        if shouldThrowError { throw errorToThrow }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let container = try decoder.decode(ExportableProfiles.self, from: data)
        
        var importedProfiles: [Profile] = []
        
        for exportable in container.profiles {
            let existingProfile = try fetchProfile(named: exportable.name)
            
            if let existing = existingProfile {
                if overwriteExisting {
                    existing.name = exportable.name
                    existing.markAsUpdated()
                    importedProfiles.append(existing)
                }
            } else {
                let profile = Profile(
                    name: exportable.name,
                    isEnabled: false,
                    createdAt: exportable.createdAt,
                    updatedAt: exportable.updatedAt
                )
                profiles.append(profile)
                importedProfiles.append(profile)
            }
        }
        
        return importedProfiles
    }
    
    func validateImportData(_ data: Data) throws -> ProfileImportValidation {
        validateImportDataCalled = true
        if shouldThrowError { throw errorToThrow }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let container = try decoder.decode(ExportableProfiles.self, from: data)
            
            let profileNames = container.profiles.map { $0.name }
            let existingNames = Set(profiles.map { $0.name })
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
}
