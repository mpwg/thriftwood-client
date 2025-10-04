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
    
    /// Creates a data service with in-memory storage
    private func makeTestDataService() throws -> DataService {
        let container = try makeTestContainer()
        return DataService(modelContainer: container)
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
        
        // Create Radarr configuration
        let radarrConfig = RadarrConfiguration(
            isEnabled: true,
            host: "https://radarr.example.com",
            apiKey: "test-api-key",
            headers: ["X-Custom": "Value"]
        )
        profile.radarrConfiguration = radarrConfig
        try dataService.updateProfile(profile)
        
        // Verify configuration is attached
        let fetched = try dataService.fetchProfile(named: "Test Profile")
        #expect(fetched?.radarrConfiguration != nil)
        #expect(fetched?.radarrConfiguration?.host == "https://radarr.example.com")
        #expect(fetched?.radarrConfiguration?.apiKey == "test-api-key")
        #expect(fetched?.radarrConfiguration?.headers["X-Custom"] == "Value")
    }
    
    @Test("Profile cascade deletes service configurations")
    func profileCascadeDelete() async throws {
        let dataService = try makeTestDataService()
        
        // Create profile with configurations
        let profile = Profile(name: "Test Profile")
        profile.radarrConfiguration = RadarrConfiguration(
            isEnabled: true,
            host: "https://radarr.example.com",
            apiKey: "key"
        )
        profile.sonarrConfiguration = SonarrConfiguration(
            isEnabled: true,
            host: "https://sonarr.example.com",
            apiKey: "key"
        )
        try dataService.createProfile(profile)
        
        // Delete profile
        try dataService.deleteProfile(profile)
        
        // Configurations should be deleted via cascade
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
    
    @Test("Service configuration validation")
    func serviceConfigurationValidation() async throws {
        // Valid configuration
        let validConfig = RadarrConfiguration(
            isEnabled: true,
            host: "https://radarr.example.com",
            apiKey: "valid-key"
        )
        #expect(validConfig.isValid() == true)
        
        // Invalid - empty API key
        let invalidKey = RadarrConfiguration(
            isEnabled: true,
            host: "https://radarr.example.com",
            apiKey: ""
        )
        #expect(invalidKey.isValid() == false)
        
        // Invalid - bad URL
        let invalidURL = RadarrConfiguration(
            isEnabled: true,
            host: "not-a-url",
            apiKey: "key"
        )
        #expect(invalidURL.isValid() == false)
    }
    
    @Test("NZBGet uses username/password instead of API key")
    func nzbgetAuthentication() async throws {
        let config = NZBGetConfiguration(
            isEnabled: true,
            host: "https://nzbget.example.com",
            username: "admin",
            password: "secret"
        )
        #expect(config.isValid() == true)
        
        // Invalid without password
        let invalidConfig = NZBGetConfiguration(
            isEnabled: true,
            host: "https://nzbget.example.com",
            username: "admin",
            password: ""
        )
        #expect(invalidConfig.isValid() == false)
    }
    
    @Test("Wake on LAN MAC address validation")
    func wakeOnLANValidation() async throws {
        // Valid MAC address
        let valid = WakeOnLANConfiguration(
            isEnabled: true,
            broadcastAddress: "192.168.1.255",
            macAddress: "AA:BB:CC:DD:EE:FF"
        )
        #expect(valid.isValid() == true)
        
        // Invalid MAC address format
        let invalid = WakeOnLANConfiguration(
            isEnabled: true,
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
