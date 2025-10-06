//
//  MockUserPreferencesService.swift
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

/// Mock implementation of UserPreferencesServiceProtocol for testing
/// Stores all preferences in memory without requiring SwiftData
@MainActor
final class MockUserPreferencesService: UserPreferencesServiceProtocol {
    
    // MARK: - Profile Management
    
    var enabledProfileName: String = "default"
    
    // MARK: - Theme Settings
    
    var themeAMOLED: Bool = false
    var themeAMOLEDBorder: Bool = false
    var themeImageBackgroundOpacity: Int = 20
    
    // MARK: - Drawer/Navigation Settings
    
    var androidBackOpensDrawer: Bool = true
    var drawerAutomaticManage: Bool = true
    var drawerManualOrder: [String] = []
    
    // MARK: - Tab Bar Configuration
    
    var tabAutomaticManage: Bool = true
    var tabManualOrder: [String] = []
    var enabledTabs: [String] = ["dashboard", "services", "settings"]
    
    // MARK: - Networking Settings
    
    var networkingTLSValidation: Bool = false
    
    // MARK: - Quick Actions Settings
    
    var quickActionsLidarr: Bool = false
    var quickActionsRadarr: Bool = false
    var quickActionsSonarr: Bool = false
    var quickActionsNZBGet: Bool = false
    var quickActionsSABnzbd: Bool = false
    var quickActionsOverseerr: Bool = false
    var quickActionsTautulli: Bool = false
    var quickActionsSearch: Bool = false
    
    // MARK: - Display Settings
    
    var use24HourTime: Bool = false
    var enableInAppNotifications: Bool = true
    
    // MARK: - App Metadata
    
    var changelogLastBuildVersion: Int = 0
    var updatedAt = Date()
    
    // MARK: - Testing Support
    
    /// Tracks whether save() was called
    var saveCalled: Bool = false
    
    /// Tracks whether reload() was called
    var reloadCalled: Bool = false
    
    /// Tracks whether resetToDefaults() was called
    var resetToDefaultsCalled: Bool = false
    
    /// Error to throw on next operation (for testing error handling)
    var errorToThrow: (any Error)?
    
    // MARK: - Operations
    
    func reload() throws {
        reloadCalled = true
        if let error = errorToThrow {
            errorToThrow = nil // Clear after throwing
            throw error
        }
        // Mock implementation: reload resets to initial state
        resetToInitialState()
    }
    
    func save() throws {
        saveCalled = true
        if let error = errorToThrow {
            errorToThrow = nil // Clear after throwing
            throw error
        }
        updatedAt = Date()
    }
    
    func resetToDefaults() throws {
        resetToDefaultsCalled = true
        if let error = errorToThrow {
            errorToThrow = nil // Clear after throwing
            throw error
        }
        resetToInitialState()
    }
    
    // MARK: - Tab Configuration Helpers
    
    func getOrderedTabIDs() -> [String] {
        if tabAutomaticManage {
            // Return enabled tabs in alphabetical order
            return enabledTabs.sorted()
        } else {
            // Return tabs in manual order, filtered by enabled status
            return tabManualOrder.filter { enabledTabs.contains($0) }
        }
    }
    
    func toggleTabEnabled(_ tabID: String) {
        // Dashboard and Settings tabs cannot be disabled
        if tabID == "dashboard" || tabID == "settings" {
            return
        }
        
        if let index = enabledTabs.firstIndex(of: tabID) {
            enabledTabs.remove(at: index)
        } else {
            enabledTabs.append(tabID)
        }
    }
    
    func isTabEnabled(_ tabID: String) -> Bool {
        return enabledTabs.contains(tabID)
    }
    
    func updateTabOrder(_ tabIDs: [String]) {
        tabManualOrder = tabIDs
    }
    
    // MARK: - Testing Helpers
    
    /// Resets all preferences to their initial/default values
    func resetToInitialState() {
        enabledProfileName = "default"
        themeAMOLED = false
        themeAMOLEDBorder = false
        themeImageBackgroundOpacity = 20
        androidBackOpensDrawer = true
        drawerAutomaticManage = true
        drawerManualOrder = []
        tabAutomaticManage = true
        tabManualOrder = []
        enabledTabs = ["dashboard", "services", "settings"]
        networkingTLSValidation = false
        quickActionsLidarr = false
        quickActionsRadarr = false
        quickActionsSonarr = false
        quickActionsNZBGet = false
        quickActionsSABnzbd = false
        quickActionsOverseerr = false
        quickActionsTautulli = false
        quickActionsSearch = false
        use24HourTime = false
        enableInAppNotifications = true
        changelogLastBuildVersion = 0
        updatedAt = Date()
    }
    
    /// Resets all tracking flags
    func resetTrackingFlags() {
        saveCalled = false
        reloadCalled = false
        resetToDefaultsCalled = false
        errorToThrow = nil
    }
}
