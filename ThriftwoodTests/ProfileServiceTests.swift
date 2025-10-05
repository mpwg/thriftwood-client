//
//  ProfileServiceTests.swift
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

import Testing
import Foundation
import SwiftData
@testable import Thriftwood

// MARK: - Profile Service Tests

@Suite("ProfileService Tests")
@MainActor
struct ProfileServiceTests {
    
    // MARK: - Test Setup
    
    func makeTestService() throws -> ProfileService {
        let container = try ModelContainer.inMemoryContainer()
        let keychainService = MockKeychainService()
        let dataService: any DataServiceProtocol = DataService(modelContainer: container, keychainService: keychainService)
        return ProfileService(dataService: dataService)
    }
    
    // MARK: - Profile CRUD Tests
    
    @Test("Profile Service - Fetch Profiles")
    func testFetchProfiles() async throws {
        let service = try makeTestService()
        
        // Create some profiles
        _ = try service.createProfile(name: "Profile 1", enableImmediately: false)
        _ = try service.createProfile(name: "Profile 2", enableImmediately: false)
        
        let profiles = try service.fetchProfiles()
        #expect(profiles.count == 2)
        #expect(profiles[0].name == "Profile 1")
        #expect(profiles[1].name == "Profile 2")
    }
    
    @Test("Profile Service - Fetch Enabled Profile")
    func testFetchEnabledProfile() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "Profile 1", enableImmediately: false)
        _ = try service.createProfile(name: "Profile 2", enableImmediately: true)
        
        let enabledProfile = try service.fetchEnabledProfile()
        #expect(enabledProfile != nil)
        #expect(enabledProfile?.name == "Profile 2")
    }
    
    @Test("Profile Service - Fetch Profile by Name")
    func testFetchProfileByName() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "TestProfile", enableImmediately: false)
        
        let profile = try service.fetchProfile(named: "TestProfile")
        #expect(profile != nil)
        #expect(profile?.name == "TestProfile")
    }
    
    @Test("Profile Service - Fetch Profile by ID")
    func testFetchProfileByID() async throws {
        let service = try makeTestService()
        
        let created = try service.createProfile(name: "TestProfile", enableImmediately: false)
        
        let profile = try service.fetchProfile(id: created.id)
        #expect(profile != nil)
        #expect(profile?.id == created.id)
    }
    
    @Test("Profile Service - Create Profile")
    func testCreateProfile() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "NewProfile", enableImmediately: false)
        
        #expect(profile.name == "NewProfile")
        #expect(!profile.isEnabled)
        
        let fetched = try service.fetchProfile(named: "NewProfile")
        #expect(fetched != nil)
    }
    
    @Test("Profile Service - Create Profile with Enable")
    func testCreateProfileWithEnable() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "EnabledProfile", enableImmediately: true)
        
        #expect(profile.name == "EnabledProfile")
        #expect(profile.isEnabled)
        
        let enabled = try service.fetchEnabledProfile()
        #expect(enabled?.id == profile.id)
    }
    
    @Test("Profile Service - Create Profile with Empty Name Fails")
    func testCreateProfileWithEmptyNameFails() async throws {
        let service = try makeTestService()
        
        #expect(throws: (any Error).self) {
            try service.createProfile(name: "", enableImmediately: false)
        }
        
        #expect(throws: (any Error).self) {
            try service.createProfile(name: "   ", enableImmediately: false)
        }
    }
    
    @Test("Profile Service - Create Duplicate Profile Name Fails")
    func testCreateDuplicateProfileNameFails() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "Duplicate", enableImmediately: false)
        
        #expect(throws: (any Error).self) {
            try service.createProfile(name: "Duplicate", enableImmediately: false)
        }
    }
    
    @Test("Profile Service - Update Profile")
    func testUpdateProfile() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "UpdateTest", enableImmediately: false)
        let originalUpdatedAt = profile.updatedAt
        
        // Wait a bit to ensure timestamp changes
        try await Task.sleep(for: .milliseconds(10))
        
        profile.name = "UpdatedName"
        try service.updateProfile(profile)
        
        let fetched = try service.fetchProfile(id: profile.id)
        #expect(fetched?.name == "UpdatedName")
        #expect(fetched!.updatedAt > originalUpdatedAt)
    }
    
    @Test("Profile Service - Delete Profile")
    func testDeleteProfile() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "Profile1", enableImmediately: false)
        let profile2 = try service.createProfile(name: "Profile2", enableImmediately: false)
        
        try service.deleteProfile(profile2)
        
        let profiles = try service.fetchProfiles()
        #expect(profiles.count == 1)
        #expect(profiles[0].name == "Profile1")
    }
    
    @Test("Profile Service - Cannot Delete Last Profile")
    func testCannotDeleteLastProfile() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "OnlyProfile", enableImmediately: false)
        
        #expect(throws: (any Error).self) {
            try service.deleteProfile(profile)
        }
        
        let profiles = try service.fetchProfiles()
        #expect(profiles.count == 1)
    }
    
    @Test("Profile Service - Delete Enabled Profile Switches to Another")
    func testDeleteEnabledProfileSwitchesToAnother() async throws {
        let service = try makeTestService()
        
        let profile1 = try service.createProfile(name: "Profile1", enableImmediately: true)
        _ = try service.createProfile(name: "Profile2", enableImmediately: false)
        
        try service.deleteProfile(profile1)
        
        let enabled = try service.fetchEnabledProfile()
        #expect(enabled != nil)
        #expect(enabled?.name == "Profile2")
    }
    
    @Test("Profile Service - Rename Profile")
    func testRenameProfile() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "OldName", enableImmediately: false)
        
        try service.renameProfile(profile, newName: "NewName")
        
        let fetched = try service.fetchProfile(id: profile.id)
        #expect(fetched?.name == "NewName")
    }
    
    @Test("Profile Service - Rename Profile with Empty Name Fails")
    func testRenameProfileWithEmptyNameFails() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "OriginalName", enableImmediately: false)
        
        #expect(throws: (any Error).self) {
            try service.renameProfile(profile, newName: "")
        }
    }
    
    @Test("Profile Service - Rename Profile to Duplicate Name Fails")
    func testRenameProfileToDuplicateNameFails() async throws {
        let service = try makeTestService()
        
        let profile1 = try service.createProfile(name: "Profile1", enableImmediately: false)
        _ = try service.createProfile(name: "Profile2", enableImmediately: false)
        
        #expect(throws: (any Error).self) {
            try service.renameProfile(profile1, newName: "Profile2")
        }
    }
    
    // MARK: - Profile Switching Tests
    
    @Test("Profile Service - Switch to Profile")
    func testSwitchToProfile() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "Profile1", enableImmediately: true)
        let profile2 = try service.createProfile(name: "Profile2", enableImmediately: false)
        
        try service.switchToProfile(profile2)
        
        let enabled = try service.fetchEnabledProfile()
        #expect(enabled?.id == profile2.id)
        
        // Verify only one profile is enabled
        let profiles = try service.fetchProfiles()
        let enabledCount = profiles.filter { $0.isEnabled }.count
        #expect(enabledCount == 1)
    }
    
    @Test("Profile Service - Switch to Profile by Name")
    func testSwitchToProfileByName() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "Profile1", enableImmediately: true)
        _ = try service.createProfile(name: "Profile2", enableImmediately: false)
        
        try service.switchToProfile(named: "Profile2")
        
        let enabled = try service.fetchEnabledProfile()
        #expect(enabled?.name == "Profile2")
    }
    
    @Test("Profile Service - Switch to Non-Existent Profile Fails")
    func testSwitchToNonExistentProfileFails() async throws {
        let service = try makeTestService()
        
        #expect(throws: (any Error).self) {
            try service.switchToProfile(named: "NonExistent")
        }
    }
    
    // MARK: - Validation Tests
    
    @Test("Profile Service - Can Delete Profile Check")
    func testCanDeleteProfileCheck() async throws {
        let service = try makeTestService()
        
        let profile1 = try service.createProfile(name: "Profile1", enableImmediately: false)
        
        // Can't delete when it's the only profile
        let canDelete1 = try service.canDeleteProfile(profile1)
        #expect(!canDelete1)
        
        let profile2 = try service.createProfile(name: "Profile2", enableImmediately: false)
        
        // Can delete when there are multiple profiles
        let canDelete2 = try service.canDeleteProfile(profile2)
        #expect(canDelete2)
    }
    
    @Test("Profile Service - Is Profile Name Available")
    func testIsProfileNameAvailable() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "ExistingProfile", enableImmediately: false)
        
        // Name is not available
        let isAvailable1 = try service.isProfileNameAvailable("ExistingProfile", excluding: nil)
        #expect(!isAvailable1)
        
        // Name is available
        let isAvailable2 = try service.isProfileNameAvailable("NewProfile", excluding: nil)
        #expect(isAvailable2)
    }
    
    @Test("Profile Service - Is Profile Name Available Excluding Self")
    func testIsProfileNameAvailableExcludingSelf() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "TestProfile", enableImmediately: false)
        
        // Same name is available when excluding self
        let isAvailable = try service.isProfileNameAvailable("TestProfile", excluding: profile)
        #expect(isAvailable)
    }
    
    // MARK: - Export Tests
    
    @Test("Profile Service - Export Profile")
    func testExportProfile() async throws {
        let service = try makeTestService()
        
        let profile = try service.createProfile(name: "ExportTest", enableImmediately: false)
        
        let data = try service.exportProfile(profile)
        #expect(!data.isEmpty)
        
        // Verify JSON structure
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let container = try decoder.decode(ExportableProfiles.self, from: data)
        
        #expect(container.version == "1.0")
        #expect(container.profiles.count == 1)
        #expect(container.profiles[0].name == "ExportTest")
    }
    
    @Test("Profile Service - Export All Profiles")
    func testExportAllProfiles() async throws {
        let service = try makeTestService()
        
        _ = try service.createProfile(name: "Profile1", enableImmediately: false)
        _ = try service.createProfile(name: "Profile2", enableImmediately: false)
        
        let data = try service.exportAllProfiles()
        #expect(!data.isEmpty)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let container = try decoder.decode(ExportableProfiles.self, from: data)
        
        #expect(container.profiles.count == 2)
    }
    
    // MARK: - Import Tests
    
    @Test("Profile Service - Import Profile")
    func testImportProfile() async throws {
        let service = try makeTestService()
        
        // Create and export a profile
        let original = try service.createProfile(name: "OriginalProfile", enableImmediately: false)
        let exportData = try service.exportProfile(original)
        
        // Delete the profile
        _ = try service.createProfile(name: "Temp", enableImmediately: false)
        try service.deleteProfile(original)
        
        // Import it back
        let imported = try service.importProfile(from: exportData, overwriteExisting: false)
        
        #expect(imported.name == "OriginalProfile")
        
        let profiles = try service.fetchProfiles()
        let found = profiles.first { $0.name == "OriginalProfile" }
        #expect(found != nil)
    }
    
    @Test("Profile Service - Import Multiple Profiles")
    func testImportMultipleProfiles() async throws {
        let service = try makeTestService()
        
        // Create and export multiple profiles
        _ = try service.createProfile(name: "Profile1", enableImmediately: false)
        _ = try service.createProfile(name: "Profile2", enableImmediately: false)
        let exportData = try service.exportAllProfiles()
        
        // Clear all profiles except the first (need to keep at least one)
        let allProfiles = try service.fetchProfiles()
        for profile in allProfiles.dropFirst() {
            try service.deleteProfile(profile)
        }
        
        // Before import, should have just 1 profile
        let beforeImport = try service.fetchProfiles()
        #expect(beforeImport.count == 1)
        
        // Import them back (should skip the one that conflicts and add the new one)
        let imported = try service.importProfiles(from: exportData, overwriteExisting: false)
        
        // Should import successfully (excluding conflicts)
        #expect(imported.count >= 1)
        
        let profiles = try service.fetchProfiles()
        #expect(profiles.count >= 2)
    }
    
    @Test("Profile Service - Import Profile with Overwrite")
    func testImportProfileWithOverwrite() async throws {
        let service = try makeTestService()
        
        // Create a profile
        let original = try service.createProfile(name: "TestProfile", enableImmediately: false)
        let exportData = try service.exportProfile(original)
        
        // Modify the profile
        try service.renameProfile(original, newName: "ModifiedProfile")
        
        // Import with overwrite
        let imported = try service.importProfile(from: exportData, overwriteExisting: true)
        
        #expect(imported.name == "TestProfile")
    }
    
    @Test("Profile Service - Import Profile without Overwrite Skips Existing")
    func testImportProfileWithoutOverwriteSkipsExisting() async throws {
        let service = try makeTestService()
        
        // Create a profile
        let original = try service.createProfile(name: "ExistingProfile", enableImmediately: false)
        let exportData = try service.exportProfile(original)
        
        // Import without overwrite
        #expect(throws: (any Error).self) {
            try service.importProfile(from: exportData, overwriteExisting: false)
        }
    }
    
    @Test("Profile Service - Validate Import Data")
    func testValidateImportData() async throws {
        let service = try makeTestService()
        
        // Create and export a profile
        _ = try service.createProfile(name: "TestProfile", enableImmediately: false)
        let exportData = try service.exportAllProfiles()
        
        // Validate the export data
        let validation = try service.validateImportData(exportData)
        
        #expect(validation.isValid)
        #expect(validation.profileCount == 1)
        #expect(validation.profileNames.contains("TestProfile"))
        #expect(validation.conflictingNames.contains("TestProfile"))
        #expect(validation.errors.isEmpty)
    }
    
    @Test("Profile Service - Validate Invalid Import Data")
    func testValidateInvalidImportData() async throws {
        let service = try makeTestService()
        
        let invalidData = "not valid json".data(using: .utf8)!
        
        let validation = try service.validateImportData(invalidData)
        
        #expect(!validation.isValid)
        #expect(validation.profileCount == 0)
        #expect(!validation.errors.isEmpty)
    }
    
    // MARK: - DI Container Tests
    
    @Test("Profile Service - DI Container Resolution")
    @MainActor
    func testDIContainerResolution() async throws {
        let container = DIContainer.shared
        
        // Resolve ProfileService via protocol
        let service = container.resolve((any ProfileServiceProtocol).self)
        
        #expect(service is ProfileService)
    }
}

// MARK: - Mock Profile Service Tests

@Suite("MockProfileService Tests")
@MainActor
struct MockProfileServiceTests {
    
    @Test("Mock Profile Service - Initialization")
    func testMockInitialization() async throws {
        let mock = MockProfileService()
        
        // Should start with default profile
        let profiles = try mock.fetchProfiles()
        #expect(profiles.count == 1)
        #expect(profiles[0].name == Profile.defaultProfileName)
    }
    
    @Test("Mock Profile Service - Call Tracking")
    func testMockCallTracking() async throws {
        let mock = MockProfileService()
        
        _ = try mock.fetchProfiles()
        #expect(mock.fetchProfilesCalled)
        
        _ = try mock.fetchEnabledProfile()
        #expect(mock.fetchEnabledProfileCalled)
        
        _ = try mock.createProfile(name: "Test", enableImmediately: false)
        #expect(mock.createProfileCalled)
        #expect(mock.lastCreatedProfileName == "Test")
    }
    
    @Test("Mock Profile Service - Error Injection")
    func testMockErrorInjection() async throws {
        let mock = MockProfileService()
        
        mock.shouldThrowError = true
        mock.errorToThrow = ThriftwoodError.serviceUnavailable
        
        #expect(throws: (any Error).self) {
            try mock.fetchProfiles()
        }
    }
    
    @Test("Mock Profile Service - Reset")
    func testMockReset() async throws {
        let mock = MockProfileService()
        
        _ = try mock.createProfile(name: "Test", enableImmediately: false)
        #expect(mock.createProfileCalled)
        
        mock.resetCallTracking()
        #expect(!mock.createProfileCalled)
        
        mock.reset()
        let profiles = try mock.fetchProfiles()
        #expect(profiles.isEmpty)
    }
}
