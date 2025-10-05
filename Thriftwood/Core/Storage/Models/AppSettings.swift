//
//  AppSettings.swift
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
//  AppSettings.swift
//  Thriftwood
//
//  SwiftData model for app-wide settings and preferences
//  Replaces Flutter/Hive thriftwoodDatabase settings and UserDefaults
//

import Foundation
import SwiftData

@Model
final class AppSettings {
    /// Unique identifier (singleton pattern - only one instance should exist)
    @Attribute(.unique) var id: UUID
    
    // MARK: - Profile Management
    
    /// Name of the currently enabled/active profile
    var enabledProfileName: String
    
    // MARK: - Theme Settings
    
    /// Whether AMOLED black theme is enabled (pure black for OLED screens)
    var themeAMOLED: Bool
    
    /// Whether to show borders in AMOLED mode
    var themeAMOLEDBorder: Bool
    
    /// Opacity for image backgrounds (0-100)
    var themeImageBackgroundOpacity: Int
    
    // MARK: - Drawer/Navigation Settings
    
    /// Whether Android back button opens drawer (mobile-specific)
    var androidBackOpensDrawer: Bool
    
    /// Whether to automatically manage drawer module order
    var drawerAutomaticManage: Bool
    
    /// Manual order of drawer modules (stored as array of module keys)
    var drawerManualOrder: [String]
    
    // MARK: - Tab Bar Configuration
    
    /// Whether to automatically manage tab bar order (alphabetical vs manual)
    var tabAutomaticManage: Bool
    
    /// Manual order of tabs (stored as array of tab IDs)
    var tabManualOrder: [String]
    
    /// Enabled tabs (tabs not in this list are hidden)
    var enabledTabs: [String]
    
    // MARK: - Networking Settings
    
    /// Whether to validate TLS/SSL certificates (disable for self-signed certs)
    var networkingTLSValidation: Bool
    
    // MARK: - Quick Actions Settings
    
    /// Whether Lidarr quick action is enabled
    var quickActionsLidarr: Bool
    
    /// Whether Radarr quick action is enabled
    var quickActionsRadarr: Bool
    
    /// Whether Sonarr quick action is enabled
    var quickActionsSonarr: Bool
    
    /// Whether NZBGet quick action is enabled
    var quickActionsNZBGet: Bool
    
    /// Whether SABnzbd quick action is enabled
    var quickActionsSABnzbd: Bool
    
    /// Whether Overseerr quick action is enabled
    var quickActionsOverseerr: Bool
    
    /// Whether Tautulli quick action is enabled
    var quickActionsTautulli: Bool
    
    /// Whether Search quick action is enabled
    var quickActionsSearch: Bool
    
    // MARK: - Display Settings
    
    /// Whether to use 24-hour time format (vs 12-hour AM/PM)
    var use24HourTime: Bool
    
    /// Whether to enable in-app notifications
    var enableInAppNotifications: Bool
    
    // MARK: - App Metadata
    
    /// Last build version shown in changelog (for tracking updates)
    var changelogLastBuildVersion: Int
    
    /// Timestamp when settings were last updated
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        enabledProfileName: String = Profile.defaultProfileName,
        themeAMOLED: Bool = false,
        themeAMOLEDBorder: Bool = false,
        themeImageBackgroundOpacity: Int = 20,
        androidBackOpensDrawer: Bool = true,
        drawerAutomaticManage: Bool = true,
        drawerManualOrder: [String] = [],
        tabAutomaticManage: Bool = true,
        tabManualOrder: [String] = [],
        enabledTabs: [String] = ["dashboard", "calendar", "services", "search", "settings"],
        networkingTLSValidation: Bool = false,
        quickActionsLidarr: Bool = false,
        quickActionsRadarr: Bool = false,
        quickActionsSonarr: Bool = false,
        quickActionsNZBGet: Bool = false,
        quickActionsSABnzbd: Bool = false,
        quickActionsOverseerr: Bool = false,
        quickActionsTautulli: Bool = false,
        quickActionsSearch: Bool = false,
        use24HourTime: Bool = false,
        enableInAppNotifications: Bool = true,
        changelogLastBuildVersion: Int = 0,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.enabledProfileName = enabledProfileName
        self.themeAMOLED = themeAMOLED
        self.themeAMOLEDBorder = themeAMOLEDBorder
        self.themeImageBackgroundOpacity = themeImageBackgroundOpacity
        self.androidBackOpensDrawer = androidBackOpensDrawer
        self.drawerAutomaticManage = drawerAutomaticManage
        self.drawerManualOrder = drawerManualOrder
        self.tabAutomaticManage = tabAutomaticManage
        self.tabManualOrder = tabManualOrder
        self.enabledTabs = enabledTabs
        self.networkingTLSValidation = networkingTLSValidation
        self.quickActionsLidarr = quickActionsLidarr
        self.quickActionsRadarr = quickActionsRadarr
        self.quickActionsSonarr = quickActionsSonarr
        self.quickActionsNZBGet = quickActionsNZBGet
        self.quickActionsSABnzbd = quickActionsSABnzbd
        self.quickActionsOverseerr = quickActionsOverseerr
        self.quickActionsTautulli = quickActionsTautulli
        self.quickActionsSearch = quickActionsSearch
        self.use24HourTime = use24HourTime
        self.enableInAppNotifications = enableInAppNotifications
        self.changelogLastBuildVersion = changelogLastBuildVersion
        self.updatedAt = updatedAt
    }
}

// MARK: - Default Settings

extension AppSettings {
    /// Creates default app settings on first launch
    static func createDefault() -> AppSettings {
        return AppSettings()
    }
    
    /// Updates the `updatedAt` timestamp
    func markAsUpdated() {
        self.updatedAt = Date()
    }
}
