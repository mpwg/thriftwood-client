//
//  UserPreferencesServiceTests.swift
//  ThriftwoodTests
//
//  Swift Testing tests for UserPreferencesService
//

import Testing
import SwiftData
import Foundation
@testable import Thriftwood

@Suite("UserPreferencesService Tests")
@MainActor
struct UserPreferencesServiceTests {
    
    // MARK: - Test Fixtures
    
    /// Creates a test data service with in-memory storage
    private func makeTestDataService() throws -> DataService {
        let container = try ModelContainer.inMemoryContainer()
        let keychainService = MockKeychainService()
        return DataService(modelContainer: container, keychainService: keychainService)
    }
    
    /// Creates a preferences service for testing
    private func makeTestPreferencesService() throws -> UserPreferencesService {
        let dataService = try makeTestDataService()
        return try UserPreferencesService(dataService: dataService)
    }
    
    // MARK: - Initialization Tests
    
    @Test("Initialize preferences service with defaults")
    func initializeWithDefaults() async throws {
        let service = try makeTestPreferencesService()
        
        // Verify default values match AppSettings defaults
        #expect(service.enabledProfileName == "default")
        #expect(service.themeAMOLED == false)
        #expect(service.themeAMOLEDBorder == false)
        #expect(service.themeImageBackgroundOpacity == 20)
        #expect(service.androidBackOpensDrawer == true)
        #expect(service.drawerAutomaticManage == true)
        #expect(service.drawerManualOrder.isEmpty)
        #expect(service.networkingTLSValidation == false)
        #expect(service.use24HourTime == false)
        #expect(service.enableInAppNotifications == true)
        #expect(service.changelogLastBuildVersion == 0)
    }
    
    // MARK: - Theme Settings Tests
    
    @Test("Update AMOLED theme setting")
    func updateAMOLEDTheme() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.themeAMOLED == false)
        
        service.themeAMOLED = true
        #expect(service.themeAMOLED == true)
        
        // Verify persistence by reloading
        try service.reload()
        #expect(service.themeAMOLED == true)
    }
    
    @Test("Update AMOLED border setting")
    func updateAMOLEDBorder() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.themeAMOLEDBorder == false)
        
        service.themeAMOLEDBorder = true
        #expect(service.themeAMOLEDBorder == true)
        
        try service.reload()
        #expect(service.themeAMOLEDBorder == true)
    }
    
    @Test("Update image background opacity")
    func updateImageBackgroundOpacity() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.themeImageBackgroundOpacity == 20)
        
        service.themeImageBackgroundOpacity = 50
        #expect(service.themeImageBackgroundOpacity == 50)
        
        try service.reload()
        #expect(service.themeImageBackgroundOpacity == 50)
    }
    
    // MARK: - Drawer/Navigation Settings Tests
    
    @Test("Update drawer automatic manage setting")
    func updateDrawerAutomaticManage() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.drawerAutomaticManage == true)
        
        service.drawerAutomaticManage = false
        #expect(service.drawerAutomaticManage == false)
        
        try service.reload()
        #expect(service.drawerAutomaticManage == false)
    }
    
    @Test("Update drawer manual order")
    func updateDrawerManualOrder() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.drawerManualOrder.isEmpty)
        
        let order = ["dashboard", "radarr", "sonarr"]
        service.drawerManualOrder = order
        #expect(service.drawerManualOrder == order)
        
        try service.reload()
        #expect(service.drawerManualOrder == order)
    }
    
    @Test("Update Android back opens drawer")
    func updateAndroidBackOpensDrawer() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.androidBackOpensDrawer == true)
        
        service.androidBackOpensDrawer = false
        #expect(service.androidBackOpensDrawer == false)
        
        try service.reload()
        #expect(service.androidBackOpensDrawer == false)
    }
    
    // MARK: - Networking Settings Tests
    
    @Test("Update TLS validation setting")
    func updateTLSValidation() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.networkingTLSValidation == false)
        
        service.networkingTLSValidation = true
        #expect(service.networkingTLSValidation == true)
        
        try service.reload()
        #expect(service.networkingTLSValidation == true)
    }
    
    // MARK: - Quick Actions Tests
    
    @Test("Update all quick action settings")
    func updateAllQuickActions() async throws {
        let service = try makeTestPreferencesService()
        
        // Verify all quick actions start disabled
        #expect(service.quickActionsLidarr == false)
        #expect(service.quickActionsRadarr == false)
        #expect(service.quickActionsSonarr == false)
        #expect(service.quickActionsNZBGet == false)
        #expect(service.quickActionsSABnzbd == false)
        #expect(service.quickActionsOverseerr == false)
        #expect(service.quickActionsTautulli == false)
        #expect(service.quickActionsSearch == false)
        
        // Enable all quick actions
        service.quickActionsLidarr = true
        service.quickActionsRadarr = true
        service.quickActionsSonarr = true
        service.quickActionsNZBGet = true
        service.quickActionsSABnzbd = true
        service.quickActionsOverseerr = true
        service.quickActionsTautulli = true
        service.quickActionsSearch = true
        
        // Verify all enabled
        #expect(service.quickActionsLidarr == true)
        #expect(service.quickActionsRadarr == true)
        #expect(service.quickActionsSonarr == true)
        #expect(service.quickActionsNZBGet == true)
        #expect(service.quickActionsSABnzbd == true)
        #expect(service.quickActionsOverseerr == true)
        #expect(service.quickActionsTautulli == true)
        #expect(service.quickActionsSearch == true)
        
        // Verify persistence
        try service.reload()
        #expect(service.quickActionsLidarr == true)
        #expect(service.quickActionsRadarr == true)
        #expect(service.quickActionsSonarr == true)
    }
    
    @Test("Update individual quick action - Radarr")
    func updateQuickActionRadarr() async throws {
        let service = try makeTestPreferencesService()
        
        service.quickActionsRadarr = true
        #expect(service.quickActionsRadarr == true)
        
        // Verify others remain false
        #expect(service.quickActionsLidarr == false)
        #expect(service.quickActionsSonarr == false)
    }
    
    // MARK: - Display Settings Tests
    
    @Test("Update 24-hour time format setting")
    func update24HourTime() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.use24HourTime == false)
        
        service.use24HourTime = true
        #expect(service.use24HourTime == true)
        
        try service.reload()
        #expect(service.use24HourTime == true)
    }
    
    @Test("Update in-app notifications setting")
    func updateInAppNotifications() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.enableInAppNotifications == true)
        
        service.enableInAppNotifications = false
        #expect(service.enableInAppNotifications == false)
        
        try service.reload()
        #expect(service.enableInAppNotifications == false)
    }
    
    // MARK: - App Metadata Tests
    
    @Test("Update changelog last build version")
    func updateChangelogVersion() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.changelogLastBuildVersion == 0)
        
        service.changelogLastBuildVersion = 123
        #expect(service.changelogLastBuildVersion == 123)
        
        try service.reload()
        #expect(service.changelogLastBuildVersion == 123)
    }
    
    @Test("UpdatedAt timestamp changes on save")
    func updatedAtTimestamp() async throws {
        let service = try makeTestPreferencesService()
        
        let initialTimestamp = service.updatedAt
        
        // Wait a bit to ensure timestamp difference
        try await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        
        service.themeAMOLED = true
        
        let newTimestamp = service.updatedAt
        #expect(newTimestamp > initialTimestamp)
    }
    
    // MARK: - Profile Management Tests
    
    @Test("Update enabled profile name")
    func updateEnabledProfile() async throws {
        let service = try makeTestPreferencesService()
        
        #expect(service.enabledProfileName == "default")
        
        service.enabledProfileName = "work"
        #expect(service.enabledProfileName == "work")
        
        try service.reload()
        #expect(service.enabledProfileName == "work")
    }
    
    // MARK: - Operations Tests
    
    @Test("Save preferences explicitly")
    func saveExplicitly() async throws {
        let service = try makeTestPreferencesService()
        
        service.themeAMOLED = true
        service.use24HourTime = true
        
        try service.save()
        
        // Reload to verify save worked
        try service.reload()
        #expect(service.themeAMOLED == true)
        #expect(service.use24HourTime == true)
    }
    
    @Test("Reset to defaults")
    func resetToDefaults() async throws {
        let service = try makeTestPreferencesService()
        
        // Change some values
        service.themeAMOLED = true
        service.themeImageBackgroundOpacity = 75
        service.use24HourTime = true
        service.quickActionsRadarr = true
        service.enabledProfileName = "custom"
        
        // Verify changes
        #expect(service.themeAMOLED == true)
        #expect(service.themeImageBackgroundOpacity == 75)
        
        // Reset to defaults
        try service.resetToDefaults()
        
        // Verify reset to defaults
        #expect(service.themeAMOLED == false)
        #expect(service.themeImageBackgroundOpacity == 20)
        #expect(service.use24HourTime == false)
        #expect(service.quickActionsRadarr == false)
        #expect(service.enabledProfileName == "default")
    }
    
    @Test("Reload preferences after external changes")
    func reloadAfterExternalChanges() async throws {
        let dataService = try makeTestDataService()
        let service = try UserPreferencesService(dataService: dataService)
        
        // Change via service
        service.themeAMOLED = true
        
        // Simulate external change to AppSettings
        let settings = try dataService.fetchAppSettings()
        settings.themeAMOLED = false
        settings.use24HourTime = true
        try dataService.updateAppSettings(settings)
        
        // Reload should pick up external changes
        try service.reload()
        #expect(service.themeAMOLED == false)
        #expect(service.use24HourTime == true)
    }
    
    // MARK: - Mock Service Tests
    
    @Test("Mock service behaves correctly")
    func mockServiceBehavior() async throws {
        let mockService = MockUserPreferencesService()
        
        // Verify initial state
        #expect(mockService.themeAMOLED == false)
        #expect(mockService.saveCalled == false)
        
        // Change value
        mockService.themeAMOLED = true
        #expect(mockService.themeAMOLED == true)
        
        // Test save tracking
        try mockService.save()
        #expect(mockService.saveCalled == true)
        
        // Test reload tracking
        try mockService.reload()
        #expect(mockService.reloadCalled == true)
        
        // Test reset tracking
        try mockService.resetToDefaults()
        #expect(mockService.resetToDefaultsCalled == true)
        #expect(mockService.themeAMOLED == false) // Reset to default
    }
    
    @Test("Mock service error handling")
    func mockServiceErrorHandling() async throws {
        let mockService = MockUserPreferencesService()
        
        // Set error to throw
        let testError = NSError(domain: "test", code: 1)
        mockService.errorToThrow = testError
        
        // Verify error is thrown
        var thrownError: Error?
        do {
            try mockService.save()
        } catch {
            thrownError = error
        }
        
        #expect(thrownError != nil)
        #expect((thrownError as? NSError)?.code == 1)
    }
    
    // MARK: - DI Resolution Test
    
    @Test("Resolve UserPreferencesService from DI container")
    func resolvefromDIContainer() async throws {
        let container = DIContainer.shared
        
        // Resolve the service
        let service = container.resolve((any UserPreferencesServiceProtocol).self)
        
        // Verify it works
        #expect(service.themeAMOLED == false)
        service.themeAMOLED = true
        #expect(service.themeAMOLED == true)
    }
}
