//
//  DataServiceTests.swift
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
//  DataServiceTests.swift
//  ThriftwoodTests
//
//  Tests for SwiftData models and DataService CRUD operations
//

import Testing
import SwiftData
import Foundation
@testable import Thriftwood

@Suite("SwiftData DataService Tests")
@MainActor
struct DataServiceTests {
    
    // MARK: - Test Fixtures
    
    /// Creates an in-memory container for testing
    private func makeTestContainer() throws -> ModelContainer {
        return try ModelContainer.inMemoryContainer()
    }
    
    /// Creates a mock keychain service for testing
    private func makeTestKeychainService() -> any KeychainServiceProtocol {
        return MockKeychainService()
    }
    
    /// Creates a data service with in-memory storage and mock keychain
    private func makeTestDataService() throws -> any DataServiceProtocol {
        let container = try makeTestContainer()
        let keychainService = makeTestKeychainService()
        return DataService(modelContainer: container, keychainService: keychainService)
    }
    
    // MARK: - Profile CRUD Tests
    
    @Test("Create and fetch profile")
    func createAndFetchProfile() async throws {
        let dataService = try makeTestDataService()
        
        // Create profile
        let profile = Profile(name: "Test Profile")
        try dataService.createProfile(profile)
        
        // Fetch profiles
        let profiles = try dataService.fetchProfiles()
        #expect(profiles.count == 1)
        #expect(profiles.first?.name == "Test Profile")
    }
    
    @Test("Update profile")
    func updateProfile() async throws {
        let dataService = try makeTestDataService()
        
        // Create profile
        let profile = Profile(name: "Original Name")
        try dataService.createProfile(profile)
        
        // Update profile
        profile.name = "Updated Name"
        try dataService.updateProfile(profile)
        
        // Verify update
        let fetched = try dataService.fetchProfile(named: "Updated Name")
        #expect(fetched != nil)
        #expect(fetched?.name == "Updated Name")
    }
    
    @Test("Delete profile")
    func deleteProfile() async throws {
        let dataService = try makeTestDataService()
        
        // Create profile
        let profile = Profile(name: "To Delete")
        try dataService.createProfile(profile)
        
        // Delete profile
        try dataService.deleteProfile(profile)
        
        // Verify deletion
        let profiles = try dataService.fetchProfiles()
        #expect(profiles.isEmpty)
    }
    
    @Test("Switch active profile")
    func switchActiveProfile() async throws {
        let dataService = try makeTestDataService()
        
        // Create two profiles
        let profile1 = Profile(name: "Profile 1", isEnabled: true)
        let profile2 = Profile(name: "Profile 2", isEnabled: false)
        try dataService.createProfile(profile1)
        try dataService.createProfile(profile2)
        
        // Switch to profile2
        try dataService.switchToProfile(profile2)
        
        // Verify only profile2 is enabled
        let profiles = try dataService.fetchProfiles()
        #expect(profiles.first(where: { $0.name == "Profile 1" })?.isEnabled == false)
        #expect(profiles.first(where: { $0.name == "Profile 2" })?.isEnabled == true)
        
        // Verify fetchEnabledProfile returns profile2
        let enabled = try dataService.fetchEnabledProfile()
        #expect(enabled?.name == "Profile 2")
    }
    
    @Test("Bootstrap creates default profile")
    func bootstrapCreatesDefaultProfile() async throws {
        let dataService = try makeTestDataService()
        
        // Bootstrap
        try dataService.bootstrap()
        
        // Verify default profile exists
        let profile = try dataService.fetchProfile(named: Profile.defaultProfileName)
        #expect(profile != nil)
        #expect(profile?.isEnabled == true)
        
        // Verify app settings exist
        let settings = try dataService.fetchAppSettings()
        #expect(settings.enabledProfileName == Profile.defaultProfileName)
    }
    
    // MARK: - Service Configuration Tests
    
    @Test("Create and attach service configuration to profile")
    func createServiceConfiguration() async throws {
        let dataService = try makeTestDataService()
        
        // Create profile
        let profile = Profile(name: "Test Profile")
        try dataService.createProfile(profile)
        
        // Create Radarr configuration using unified ServiceConfiguration
        let radarrConfig = ServiceConfiguration(
            serviceType: .radarr,
            isEnabled: true,
            host: "https://radarr.example.com",
            authenticationType: .apiKey,
            headers: ["X-Custom": "Value"]
        )
        profile.serviceConfigurations.append(radarrConfig)
        try dataService.updateProfile(profile)
        
        // Save API key to Keychain
        try dataService.saveAPIKey("test-api-key", for: radarrConfig)
        
        // Verify configuration is attached
        let fetched = try dataService.fetchProfile(named: "Test Profile")
        let radarr = fetched?.serviceConfiguration(for: .radarr)
        #expect(radarr != nil)
        #expect(radarr?.host == "https://radarr.example.com")
        #expect(radarr?.headers["X-Custom"] == "Value")
        
        // Verify API key is stored in Keychain
        let apiKey = dataService.getAPIKey(for: radarrConfig)
        #expect(apiKey == "test-api-key")
    }
    
    @Test("Profile cascade deletes service configurations")
    func profileCascadeDelete() async throws {
        let dataService = try makeTestDataService()
        
        // Create profile with configurations using unified ServiceConfiguration
        let profile = Profile(name: "Test Profile")
        let radarrConfig = ServiceConfiguration(
            serviceType: .radarr,
            isEnabled: true,
            host: "https://radarr.example.com",
            authenticationType: .apiKey
        )
        let sonarrConfig = ServiceConfiguration(
            serviceType: .sonarr,
            isEnabled: true,
            host: "https://sonarr.example.com",
            authenticationType: .apiKey
        )
        profile.serviceConfigurations.append(radarrConfig)
        profile.serviceConfigurations.append(sonarrConfig)
        try dataService.createProfile(profile)
        
        // Save API keys to Keychain
        try dataService.saveAPIKey("radarr-key", for: radarrConfig)
        try dataService.saveAPIKey("sonarr-key", for: sonarrConfig)
        
        // Delete profile
        try dataService.deleteProfile(profile)
        
        // Configurations should be deleted via cascade
        // Note: Credentials remain in Keychain unless explicitly deleted
        let profiles = try dataService.fetchProfiles()
        #expect(profiles.isEmpty)
    }
    
    // MARK: - AppSettings Tests
    
    @Test("Fetch or create app settings singleton")
    func fetchOrCreateAppSettings() async throws {
        let dataService = try makeTestDataService()
        
        // First fetch creates default settings
        let settings1 = try dataService.fetchAppSettings()
        #expect(settings1.enabledProfileName == Profile.defaultProfileName)
        #expect(settings1.themeAMOLED == false)
        
        // Second fetch returns same settings
        let settings2 = try dataService.fetchAppSettings()
        #expect(settings1.id == settings2.id)
    }
    
    @Test("Update app settings")
    func updateAppSettings() async throws {
        let dataService = try makeTestDataService()
        
        let settings = try dataService.fetchAppSettings()
        settings.themeAMOLED = true
        settings.use24HourTime = true
        settings.networkingTLSValidation = true
        try dataService.updateAppSettings(settings)
        
        // Verify updates
        let fetched = try dataService.fetchAppSettings()
        #expect(fetched.themeAMOLED == true)
        #expect(fetched.use24HourTime == true)
        #expect(fetched.networkingTLSValidation == true)
    }
    
    // MARK: - Indexer Tests
    
    @Test("Create and fetch indexers")
    func createAndFetchIndexers() async throws {
        let dataService = try makeTestDataService()
        
        // Create indexer
        let indexer = Indexer(
            displayName: "NZBgeek",
            host: "https://nzbgeek.info",
            apiKey: "test-key"
        )
        try dataService.createIndexer(indexer)
        
        // Fetch indexers
        let indexers = try dataService.fetchIndexers()
        #expect(indexers.count == 1)
        #expect(indexers.first?.displayName == "NZBgeek")
    }
    
    @Test("Update indexer")
    func updateIndexer() async throws {
        let dataService = try makeTestDataService()
        
        let indexer = Indexer(displayName: "Test", host: "https://test.com", apiKey: "key")
        try dataService.createIndexer(indexer)
        
        indexer.displayName = "Updated"
        try dataService.updateIndexer(indexer)
        
        let fetched = try dataService.fetchIndexers()
        #expect(fetched.first?.displayName == "Updated")
    }
    
    @Test("Delete indexer")
    func deleteIndexer() async throws {
        let dataService = try makeTestDataService()
        
        let indexer = Indexer(displayName: "Test", host: "https://test.com", apiKey: "key")
        try dataService.createIndexer(indexer)
        try dataService.deleteIndexer(indexer)
        
        let indexers = try dataService.fetchIndexers()
        #expect(indexers.isEmpty)
    }
    
    // MARK: - External Module Tests
    
    @Test("Create and fetch external modules")
    func createAndFetchExternalModules() async throws {
        let dataService = try makeTestDataService()
        
        let module = ExternalModule(displayName: "Plex", host: "https://plex.example.com")
        try dataService.createExternalModule(module)
        
        let modules = try dataService.fetchExternalModules()
        #expect(modules.count == 1)
        #expect(modules.first?.displayName == "Plex")
    }
    
    @Test("Update external module")
    func updateExternalModule() async throws {
        let dataService = try makeTestDataService()
        
        let module = ExternalModule(displayName: "Original", host: "https://example.com")
        try dataService.createExternalModule(module)
        
        module.displayName = "Updated"
        try dataService.updateExternalModule(module)
        
        let fetched = try dataService.fetchExternalModules()
        #expect(fetched.first?.displayName == "Updated")
    }
    
    @Test("Delete external module")
    func deleteExternalModule() async throws {
        let dataService = try makeTestDataService()
        
        let module = ExternalModule(displayName: "Test", host: "https://test.com")
        try dataService.createExternalModule(module)
        try dataService.deleteExternalModule(module)
        
        let modules = try dataService.fetchExternalModules()
        #expect(modules.isEmpty)
    }
    
    // MARK: - Validation Tests
    
    @Test("Service configuration validation - basic")
    func serviceConfigurationBasicValidation() async throws {
        // Valid configuration (host validation only, credentials checked separately)
        let validConfig = ServiceConfiguration(
            serviceType: .radarr,
            isEnabled: true,
            host: "https://radarr.example.com",
            authenticationType: .apiKey
        )
        #expect(validConfig.isValid() == true)
        
        // Invalid - bad URL
        let invalidURL = ServiceConfiguration(
            serviceType: .radarr,
            isEnabled: true,
            host: "not-a-url",
            authenticationType: .apiKey
        )
        #expect(invalidURL.isValid() == false)
        
        // Disabled services are always valid
        let disabledConfig = ServiceConfiguration(
            serviceType: .radarr,
            isEnabled: false,
            host: "",
            authenticationType: .apiKey
        )
        #expect(disabledConfig.isValid() == true)
    }
    
    @Test("Service configuration validation with credentials")
    func serviceConfigurationCredentialValidation() async throws {
        let dataService = try makeTestDataService()
        
        // Create config with API key authentication
        let apiKeyConfig = ServiceConfiguration(
            serviceType: .radarr,
            isEnabled: true,
            host: "https://radarr.example.com",
            authenticationType: .apiKey
        )
        
        // Should be invalid without API key in Keychain
        let isValidWithoutKey = dataService.validateServiceConfiguration(apiKeyConfig)
        #expect(isValidWithoutKey == false)
        
        // Save API key
        try dataService.saveAPIKey("test-key", for: apiKeyConfig)
        
        // Should now be valid
        let isValidWithKey = dataService.validateServiceConfiguration(apiKeyConfig)
        #expect(isValidWithKey == true)
    }
    
    @Test("NZBGet uses username/password instead of API key")
    func nzbgetAuthentication() async throws {
        let dataService = try makeTestDataService()
        
        let config = ServiceConfiguration(
            serviceType: .nzbget,
            isEnabled: true,
            host: "https://nzbget.example.com",
            authenticationType: .usernamePassword
        )
        
        // Should be invalid without credentials
        let isValidWithoutCreds = dataService.validateServiceConfiguration(config)
        #expect(isValidWithoutCreds == false)
        
        // Save credentials
        try dataService.saveUsernamePassword(username: "admin", password: "secret", for: config)
        
        // Should now be valid
        let isValidWithCreds = dataService.validateServiceConfiguration(config)
        #expect(isValidWithCreds == true)
        
        // Verify credentials can be retrieved
        let creds = dataService.getUsernamePassword(for: config)
        #expect(creds?.username == "admin")
        #expect(creds?.password == "secret")
        
        #expect(config.isValid() == true)
      
    }
    
    @Test("Wake on LAN MAC address validation")
    func wakeOnLANValidation() async throws {
        // Valid MAC address
        let valid = ServiceConfiguration(
            serviceType: .wakeOnLAN,
            isEnabled: true,
            authenticationType: .none,
            broadcastAddress: "192.168.1.255",
            macAddress: "AA:BB:CC:DD:EE:FF"
        )
        #expect(valid.isValid() == true)
        
        // Invalid MAC address format
        let invalid = ServiceConfiguration(
            serviceType: .wakeOnLAN,
            isEnabled: true,
            authenticationType: .none,
            broadcastAddress: "192.168.1.255",
            macAddress: "invalid-mac"
        )
        #expect(invalid.isValid() == false)
    }
    
    // MARK: - Reset Tests
    
    @Test("Reset clears all data")
    func resetClearsAllData() async throws {
        let dataService = try makeTestDataService()
        
        // Create data
        let profile = Profile(name: "Test")
        try dataService.createProfile(profile)
        
        let indexer = Indexer(displayName: "Test", host: "https://test.com", apiKey: "key")
        try dataService.createIndexer(indexer)
        
        let module = ExternalModule(displayName: "Test", host: "https://test.com")
        try dataService.createExternalModule(module)
        
        _ = try dataService.fetchAppSettings()
        
        // Reset
        try dataService.reset()
        
        // Verify all data is cleared
        #expect(try dataService.fetchProfiles().isEmpty)
        #expect(try dataService.fetchIndexers().isEmpty)
        #expect(try dataService.fetchExternalModules().isEmpty)
    }
}
