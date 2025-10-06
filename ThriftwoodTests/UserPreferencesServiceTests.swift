//
//  UserPreferencesServiceTests.swift
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
//  Swift Testing tests for UserPreferencesService

import Testing
import SwiftData
import Foundation
@testable import Thriftwood

// MARK: - Test Error

enum TestError: Error {
    case setupFailed(String)
}

@Suite("UserPreferencesService Tests")
@MainActor
struct UserPreferencesServiceTests {
    
    // MARK: - Test Fixtures
    
    /// Creates a mock preferences service for testing
    /// Uses in-memory storage without requiring SwiftData or DataService
    private func makeMockPreferencesService() -> MockUserPreferencesService {
        let mock = MockUserPreferencesService()
        mock.resetToInitialState()
        mock.resetTrackingFlags()
        return mock
    }
    
    /// Creates a test data service with in-memory storage (for integration tests)
    private func makeTestDataService() throws -> any DataServiceProtocol {
        let container = try ModelContainer.inMemoryContainer()
        let keychainService = MockKeychainService()
        return DataService(modelContainer: container, keychainService: keychainService)
    }
    
    /// Creates a real preferences service for integration testing
    private func makeTestPreferencesService() throws -> UserPreferencesService {
        let dataService = try makeTestDataService()
        guard let concreteDataService = dataService as? DataService else {
            throw TestError.setupFailed("DataService is not of expected concrete type")
        }
        return try UserPreferencesService(dataService: concreteDataService)
    }
    
    // MARK: - Initialization Tests
    
    @Test("Initialize preferences service with defaults")
    func initializeWithDefaults() async throws {
        let service = makeMockPreferencesService()
        
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
        let service = makeMockPreferencesService()
        
        #expect(service.themeAMOLED == false)
        
        service.themeAMOLED = true
        #expect(service.themeAMOLED == true)
        
        // Mock service holds values in memory
        #expect(service.themeAMOLED == true)
    }
    
    @Test("Update AMOLED border setting")
    func updateAMOLEDBorder() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.themeAMOLEDBorder == false)
        
        service.themeAMOLEDBorder = true
        #expect(service.themeAMOLEDBorder == true)
    }
    
    @Test("Update image background opacity")
    func updateImageBackgroundOpacity() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.themeImageBackgroundOpacity == 20)
        
        service.themeImageBackgroundOpacity = 50
        #expect(service.themeImageBackgroundOpacity == 50)
    }
    
    // MARK: - Drawer/Navigation Settings Tests
    
    @Test("Update drawer automatic manage setting")
    func updateDrawerAutomaticManage() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.drawerAutomaticManage == true)
        
        service.drawerAutomaticManage = false
        #expect(service.drawerAutomaticManage == false)
    }
    
    @Test("Update drawer manual order")
    func updateDrawerManualOrder() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.drawerManualOrder.isEmpty)
        
        let order = ["dashboard", "radarr", "sonarr"]
        service.drawerManualOrder = order
        #expect(service.drawerManualOrder == order)
    }
    
    @Test("Update Android back opens drawer")
    func updateAndroidBackOpensDrawer() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.androidBackOpensDrawer == true)
        
        service.androidBackOpensDrawer = false
        #expect(service.androidBackOpensDrawer == false)
    }
    
    // MARK: - Networking Settings Tests
    
    @Test("Update TLS validation setting")
    func updateTLSValidation() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.networkingTLSValidation == false)
        
        service.networkingTLSValidation = true
        #expect(service.networkingTLSValidation == true)
    }
    
    // MARK: - Quick Actions Tests
    
    @Test("Update all quick action settings")
    func updateAllQuickActions() async throws {
        let service = makeMockPreferencesService()
        
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
    }
    
    @Test("Update individual quick action - Radarr")
    func updateQuickActionRadarr() async throws {
        let service = makeMockPreferencesService()
        
        service.quickActionsRadarr = true
        #expect(service.quickActionsRadarr == true)
        
        // Verify others remain false
        #expect(service.quickActionsLidarr == false)
        #expect(service.quickActionsSonarr == false)
    }
    
    // MARK: - Display Settings Tests
    
    @Test("Update 24-hour time format setting")
    func update24HourTime() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.use24HourTime == false)
        
        service.use24HourTime = true
        #expect(service.use24HourTime == true)
    }
    
    @Test("Update in-app notifications setting")
    func updateInAppNotifications() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.enableInAppNotifications == true)
        
        service.enableInAppNotifications = false
        #expect(service.enableInAppNotifications == false)
    }
    
    // MARK: - App Metadata Tests
    
    @Test("Update changelog last build version")
    func updateChangelogVersion() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.changelogLastBuildVersion == 0)
        
        service.changelogLastBuildVersion = 123
        #expect(service.changelogLastBuildVersion == 123)
    }
    
    @Test("UpdatedAt timestamp changes on save")
    func updatedAtTimestamp() async throws {
        let service = makeMockPreferencesService()
        
        let initialTimestamp = service.updatedAt
        
        // Wait a bit to ensure timestamp difference
        try await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        
        try service.save()
        
        let newTimestamp = service.updatedAt
        #expect(newTimestamp > initialTimestamp)
    }
    
    // MARK: - Profile Management Tests
    
    @Test("Update enabled profile name")
    func updateEnabledProfile() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.enabledProfileName == "default")
        
        service.enabledProfileName = "work"
        #expect(service.enabledProfileName == "work")
    }
    
    // MARK: - Operations Tests
    
    @Test("Save preferences explicitly")
    func saveExplicitly() async throws {
        let service = makeMockPreferencesService()
        
        service.themeAMOLED = true
        service.use24HourTime = true
        
        try service.save()
        
        // Verify save was called
        #expect(service.saveCalled == true)
    }
    
    @Test("Reset to defaults")
    func resetToDefaults() async throws {
        let service = makeMockPreferencesService()
        
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
        #expect(service.resetToDefaultsCalled == true)
    }
    
    @Test("Reload preferences tracking")
    func reloadTracking() async throws {
        let service = makeMockPreferencesService()
        
        #expect(service.reloadCalled == false)
        
        try service.reload()
        
        #expect(service.reloadCalled == true)
    }
    
    // MARK: - Mock Service Tests
    
    @Test("Mock service behaves correctly")
    func mockServiceBehavior() async throws {
        let mockService = makeMockPreferencesService()
        
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
        let mockService = makeMockPreferencesService()
        
        // Set error to throw
        let testError = NSError(domain: "test", code: 1)
        mockService.errorToThrow = testError
        
        // Verify error is thrown
        var thrownError: (any Error)?
        do {
            try mockService.save()
        } catch {
            thrownError = error
        }
        
        #expect(thrownError != nil)
        #expect((thrownError as? NSError)?.code == 1)
    }
    
    @Test("Mock service reset tracking flags")
    func mockServiceResetTrackingFlags() async throws {
        let mockService = makeMockPreferencesService()
        
        // Call operations to set tracking flags
        try mockService.save()
        try mockService.reload()
        try mockService.resetToDefaults()
        
        #expect(mockService.saveCalled == true)
        #expect(mockService.reloadCalled == true)
        #expect(mockService.resetToDefaultsCalled == true)
        
        // Reset tracking flags
        mockService.resetTrackingFlags()
        
        #expect(mockService.saveCalled == false)
        #expect(mockService.reloadCalled == false)
        #expect(mockService.resetToDefaultsCalled == false)
    }
    
    // MARK: - Integration Tests (Real Service with SwiftData)
    
    @Test("Integration: Real service persists data via SwiftData")
    func integrationRealServicePersistence() async throws {
        let service = try makeTestPreferencesService()
        
        // Change values
        service.themeAMOLED = true
        service.use24HourTime = true
        service.enabledProfileName = "test-profile"
        
        // Explicitly save
        try service.save()
        
        // Reload from database
        try service.reload()
        
        // Verify persistence
        #expect(service.themeAMOLED == true)
        #expect(service.use24HourTime == true)
        #expect(service.enabledProfileName == "test-profile")
    }
    
    @Test("Integration: Reload after external changes")
    func integrationReloadAfterExternalChanges() async throws {
        let dataService = try makeTestDataService()
        guard let concreteDataService = dataService as? DataService else {
            throw TestError.setupFailed("DataService is not of expected concrete type")
        }
        let service = try UserPreferencesService(dataService: concreteDataService)
        
        // Change via service
        service.themeAMOLED = true
        try service.save()
        
        // Simulate external change to AppSettings directly via DataService
        let settings = try dataService.fetchAppSettings()
        settings.themeAMOLED = false
        settings.use24HourTime = true
        try dataService.updateAppSettings(settings)
        
        // Reload should pick up external changes
        try service.reload()
        #expect(service.themeAMOLED == false)
        #expect(service.use24HourTime == true)
    }
    
    @Test("Integration: Reset to defaults via real service")
    func integrationResetToDefaults() async throws {
        let service = try makeTestPreferencesService()
        
        // Change values
        service.themeAMOLED = true
        service.themeImageBackgroundOpacity = 99
        service.enabledProfileName = "custom"
        try service.save()
        
        // Reset
        try service.resetToDefaults()
        
        // Verify defaults restored
        #expect(service.themeAMOLED == false)
        #expect(service.themeImageBackgroundOpacity == 20)
        #expect(service.enabledProfileName == "default")
    }
}
