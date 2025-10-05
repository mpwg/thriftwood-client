//
//  UserPreferencesService.swift
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
//  UserPreferencesService.swift
//  Thriftwood
//
//  Service for managing user preferences stored in SwiftData
//  Provides type-safe access to AppSettings with SwiftUI observation support
//

import Foundation
import SwiftData
import Observation

/// Service for managing user preferences
/// All preferences are persisted in SwiftData via AppSettings model
/// Thread-safe and @Observable for SwiftUI integration
@MainActor
@Observable
final class UserPreferencesService: UserPreferencesServiceProtocol {
    
    // MARK: - Properties
    
    private let dataService: DataService
    private var settings: AppSettings
    
    // MARK: - Initialization
    
    /// Creates a new UserPreferencesService instance
    /// - Parameter dataService: The data service for persistence operations
    init(dataService: DataService) throws {
        self.dataService = dataService
        self.settings = try dataService.fetchAppSettings()
    }
    
    // MARK: - Profile Management
    
    var enabledProfileName: String {
        get { settings.enabledProfileName }
        set {
            settings.enabledProfileName = newValue
            try? saveInternal()
        }
    }
    
    // MARK: - Theme Settings
    
    var themeAMOLED: Bool {
        get { settings.themeAMOLED }
        set {
            settings.themeAMOLED = newValue
            try? saveInternal()
        }
    }
    
    var themeAMOLEDBorder: Bool {
        get { settings.themeAMOLEDBorder }
        set {
            settings.themeAMOLEDBorder = newValue
            try? saveInternal()
        }
    }
    
    var themeImageBackgroundOpacity: Int {
        get { settings.themeImageBackgroundOpacity }
        set {
            settings.themeImageBackgroundOpacity = newValue
            try? saveInternal()
        }
    }
    
    // MARK: - Drawer/Navigation Settings
    
    var androidBackOpensDrawer: Bool {
        get { settings.androidBackOpensDrawer }
        set {
            settings.androidBackOpensDrawer = newValue
            try? saveInternal()
        }
    }
    
    var drawerAutomaticManage: Bool {
        get { settings.drawerAutomaticManage }
        set {
            settings.drawerAutomaticManage = newValue
            try? saveInternal()
        }
    }
    
    var drawerManualOrder: [String] {
        get { settings.drawerManualOrder }
        set {
            settings.drawerManualOrder = newValue
            try? saveInternal()
        }
    }
    
    // MARK: - Tab Bar Configuration
    
    var tabAutomaticManage: Bool {
        get { settings.tabAutomaticManage }
        set {
            settings.tabAutomaticManage = newValue
            try? saveInternal()
        }
    }
    
    var tabManualOrder: [String] {
        get { settings.tabManualOrder }
        set {
            settings.tabManualOrder = newValue
            try? saveInternal()
        }
    }
    
    var enabledTabs: [String] {
        get { settings.enabledTabs }
        set {
            settings.enabledTabs = newValue
            try? saveInternal()
        }
    }
    
    // MARK: - Networking Settings
    
    var networkingTLSValidation: Bool {
        get { settings.networkingTLSValidation }
        set {
            settings.networkingTLSValidation = newValue
            try? saveInternal()
        }
    }
    
    // MARK: - Quick Actions Settings
    
    var quickActionsLidarr: Bool {
        get { settings.quickActionsLidarr }
        set {
            settings.quickActionsLidarr = newValue
            try? saveInternal()
        }
    }
    
    var quickActionsRadarr: Bool {
        get { settings.quickActionsRadarr }
        set {
            settings.quickActionsRadarr = newValue
            try? saveInternal()
        }
    }
    
    var quickActionsSonarr: Bool {
        get { settings.quickActionsSonarr }
        set {
            settings.quickActionsSonarr = newValue
            try? saveInternal()
        }
    }
    
    var quickActionsNZBGet: Bool {
        get { settings.quickActionsNZBGet }
        set {
            settings.quickActionsNZBGet = newValue
            try? saveInternal()
        }
    }
    
    var quickActionsSABnzbd: Bool {
        get { settings.quickActionsSABnzbd }
        set {
            settings.quickActionsSABnzbd = newValue
            try? saveInternal()
        }
    }
    
    var quickActionsOverseerr: Bool {
        get { settings.quickActionsOverseerr }
        set {
            settings.quickActionsOverseerr = newValue
            try? saveInternal()
        }
    }
    
    var quickActionsTautulli: Bool {
        get { settings.quickActionsTautulli }
        set {
            settings.quickActionsTautulli = newValue
            try? saveInternal()
        }
    }
    
    var quickActionsSearch: Bool {
        get { settings.quickActionsSearch }
        set {
            settings.quickActionsSearch = newValue
            try? saveInternal()
        }
    }
    
    // MARK: - Display Settings
    
    var use24HourTime: Bool {
        get { settings.use24HourTime }
        set {
            settings.use24HourTime = newValue
            try? saveInternal()
        }
    }
    
    var enableInAppNotifications: Bool {
        get { settings.enableInAppNotifications }
        set {
            settings.enableInAppNotifications = newValue
            try? saveInternal()
        }
    }
    
    // MARK: - App Metadata
    
    var changelogLastBuildVersion: Int {
        get { settings.changelogLastBuildVersion }
        set {
            settings.changelogLastBuildVersion = newValue
            try? saveInternal()
        }
    }
    
    var updatedAt: Date {
        settings.updatedAt
    }
    
    // MARK: - Operations
    
    /// Reloads preferences from storage (useful after external changes)
    func reload() throws {
        self.settings = try dataService.fetchAppSettings()
    }
    
    /// Saves current preferences to storage
    func save() throws {
        try saveInternal()
    }
    
    /// Resets all preferences to defaults
    func resetToDefaults() throws {
        // Use DataService's reset functionality
        // This will delete all data including AppSettings
        try dataService.reset()
        
        // Bootstrap will recreate default settings
        try dataService.bootstrap()
        
        // Reload the new default settings
        self.settings = try dataService.fetchAppSettings()
    }
    
    // MARK: - Private Helpers
    
    /// Internal save that updates timestamp and persists to storage
    private func saveInternal() throws {
        settings.markAsUpdated()
        try dataService.updateAppSettings(settings)
    }
    
    // MARK: - Tab Configuration Helpers
    
    /// Get ordered tab configurations based on current settings
    /// Returns tabs in automatic (alphabetical) or manual order, filtered by enabled status
    /// - Returns: Array of tab IDs in the configured order
    func getOrderedTabIDs() -> [String] {
        let allTabIDs = ["dashboard", "calendar", "services", "search", "settings"]
        let enabledTabIDs = enabledTabs
        
        // Filter to only enabled tabs
        var orderedTabs = allTabIDs.filter { enabledTabIDs.contains($0) }
        
        if tabAutomaticManage {
            // Automatic: alphabetical order
            orderedTabs.sort()
        } else {
            // Manual: use configured order
            let manualOrder = tabManualOrder
            orderedTabs.sort { tabA, tabB in
                let indexA = manualOrder.firstIndex(of: tabA) ?? Int.max
                let indexB = manualOrder.firstIndex(of: tabB) ?? Int.max
                return indexA < indexB
            }
        }
        
        return orderedTabs
    }
    
    /// Toggle whether a tab is enabled/disabled
    /// - Parameter tabID: The tab identifier to toggle
    /// - Note: Dashboard and Settings tabs cannot be disabled
    func toggleTabEnabled(_ tabID: String) {
        // Dashboard and Settings cannot be disabled
        guard tabID != "dashboard" && tabID != "settings" else {
            return
        }
        
        var updatedEnabledTabs = enabledTabs
        if updatedEnabledTabs.contains(tabID) {
            updatedEnabledTabs.removeAll { $0 == tabID }
        } else {
            updatedEnabledTabs.append(tabID)
        }
        enabledTabs = updatedEnabledTabs
    }
    
    /// Check if a specific tab is enabled
    /// - Parameter tabID: The tab identifier to check
    /// - Returns: true if the tab is enabled
    func isTabEnabled(_ tabID: String) -> Bool {
        return enabledTabs.contains(tabID)
    }
    
    /// Update the manual tab order
    /// - Parameter tabIDs: Array of tab IDs in desired order
    func updateTabOrder(_ tabIDs: [String]) {
        tabManualOrder = tabIDs
    }
}
