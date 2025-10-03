//
//  ThriftwoodAppSettings.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

/// App-wide settings model
@Observable
class ThriftwoodAppSettings: Codable {
    var selectedTheme: AppTheme
    var enabledProfile: String
    var profiles: [String: ThriftwoodProfile]
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case enableImageHeaders
        case enableCustomHeaders
        case enableBiometrics
        case requireBiometricsOnLaunch
        case requireBiometricsOnUnlock
        case enableBackups
        case backupOnProfileChange
        case backupFrequency
        case enableNotifications
        case enableBroadcastNotifications
        case appName
        case enableAdvancedSettings
        case enableErrorReporting
        case enableAnalytics
        case dashboardRefreshInterval
        case enableCalendarView
        case calendarDaysAhead
        case calendarStartingDay
        case calendarStartingType
        case drawerAutoExpand
        case drawerGroupModules
        case drawerShowVersion
        case enableQuickActions
        case quickActionItems
        case enableSearchHistory
        case maxSearchHistory
        case defaultSearchCategory
        case enableTorrentSearching
        case enableUsenetSearching
        case searchIndexers
        case sonarrQueuePageSize
        case radarrQueuePageSize
        case tautulliRefreshRate
        case tautulliTerminationMessage
        case tautulliStatisticsCount
    }
    
    // UI Settings
    var enableImageHeaders: Bool
    var enableCustomHeaders: Bool
    
    // Security Settings  
    var enableBiometrics: Bool
    var requireBiometricsOnLaunch: Bool
    var requireBiometricsOnUnlock: Bool
    
    // Backup Settings
    var enableBackups: Bool
    var backupOnProfileChange: Bool
    var backupFrequency: BackupFrequency
    
    // Notification Settings
    var enableNotifications: Bool
    var enableBroadcastNotifications: Bool
    
    // General Settings
    var appName: String
    var enableAdvancedSettings: Bool
    var enableErrorReporting: Bool
    var enableAnalytics: Bool
    
    // Dashboard Settings
    var dashboardRefreshInterval: Int // seconds
    var enableCalendarView: Bool
    var calendarDaysAhead: Int
    var calendarStartingDay: CalendarStartDay
    var calendarStartingType: CalendarStartType
    
    // Drawer Settings
    var drawerAutoExpand: Bool
    var drawerGroupModules: Bool
    var drawerShowVersion: Bool
    
    // Quick Actions Settings
    var enableQuickActions: Bool
    var quickActionItems: [QuickActionItem]
    
    // Search Settings
    var enableSearchHistory: Bool
    var maxSearchHistory: Int
    var defaultSearchCategory: String
    var enableTorrentSearching: Bool
    var enableUsenetSearching: Bool
    var searchIndexers: [SearchIndexer]
    
    // Queue Settings (matching Flutter database tables)
    var sonarrQueuePageSize: Int
    var radarrQueuePageSize: Int
    
    // Tautulli Settings
    var tautulliRefreshRate: Int // seconds
    var tautulliTerminationMessage: String
    var tautulliStatisticsCount: Int
    
    init() {
        self.selectedTheme = .system
        self.enabledProfile = "default"
        self.profiles = ["default": ThriftwoodProfile(name: "default")]
        self.enableImageHeaders = true
        self.enableCustomHeaders = false
        self.enableBiometrics = false
        self.requireBiometricsOnLaunch = false
        self.requireBiometricsOnUnlock = false
        self.enableBackups = false
        self.backupOnProfileChange = false
        self.backupFrequency = .daily
        self.enableNotifications = true
        self.enableBroadcastNotifications = false
        
        // General Settings defaults
        self.appName = "Thriftwood"
        self.enableAdvancedSettings = false
        self.enableErrorReporting = true
        self.enableAnalytics = false
        
        // Dashboard Settings defaults
        self.dashboardRefreshInterval = 300 // 5 minutes
        self.enableCalendarView = true
        self.calendarDaysAhead = 14
        self.calendarStartingDay = .monday
        self.calendarStartingType = .today
        
        // Drawer Settings defaults
        self.drawerAutoExpand = false
        self.drawerGroupModules = true
        self.drawerShowVersion = true
        
        // Quick Actions defaults
        self.enableQuickActions = true
        self.quickActionItems = []
        
        // Search Settings defaults
        self.enableSearchHistory = true
        self.maxSearchHistory = 50
        self.defaultSearchCategory = "all"
        self.enableTorrentSearching = true
        self.enableUsenetSearching = true
        self.searchIndexers = []
        
        // Queue Settings defaults (matching Flutter)
        self.sonarrQueuePageSize = 50
        self.radarrQueuePageSize = 50
        
        // Tautulli Settings defaults
        self.tautulliRefreshRate = 15 // 15 seconds
        self.tautulliTerminationMessage = ""
        self.tautulliStatisticsCount = 10
    }
    
    // MARK: - Robust Codable Implementation with Fallback to Defaults
    required init(from decoder: Decoder) throws {
        // Initialize with defaults first
        self.selectedTheme = .system
        self.enabledProfile = "default"
        self.profiles = ["default": ThriftwoodProfile(name: "default")]
        self.enableImageHeaders = true
        self.enableCustomHeaders = false
        self.enableBiometrics = false
        self.requireBiometricsOnLaunch = false
        self.requireBiometricsOnUnlock = false
        self.enableBackups = false
        self.backupOnProfileChange = false
        self.backupFrequency = .daily
        self.enableNotifications = true
        self.enableBroadcastNotifications = false
        self.appName = "Thriftwood"
        self.enableAdvancedSettings = false
        self.enableErrorReporting = true
        self.enableAnalytics = false
        self.dashboardRefreshInterval = 300
        self.enableCalendarView = true
        self.calendarDaysAhead = 14
        self.calendarStartingDay = .monday
        self.calendarStartingType = .today
        self.drawerAutoExpand = false
        self.drawerGroupModules = true
        self.drawerShowVersion = true
        self.enableQuickActions = true
        self.quickActionItems = []
        self.enableSearchHistory = true
        self.maxSearchHistory = 50
        self.defaultSearchCategory = "all"
        self.enableTorrentSearching = true
        self.enableUsenetSearching = true
        self.searchIndexers = []
        self.sonarrQueuePageSize = 50
        self.radarrQueuePageSize = 50
        self.tautulliRefreshRate = 15
        self.tautulliTerminationMessage = ""
        self.tautulliStatisticsCount = 10
        
        // Now try to decode and override defaults with stored values
        // Handle both regular keys and @Observable underscore-prefixed keys
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Try to decode each value, falling back to defaults if it fails
            if let theme = try? container.decode(AppTheme.self, forKey: .selectedTheme) {
                self.selectedTheme = theme
            }
            
            if let profile = try? container.decode(String.self, forKey: .enabledProfile) {
                self.enabledProfile = profile
            }
            
            if let profiles = try? container.decode([String: ThriftwoodProfile].self, forKey: .profiles) {
                self.profiles = profiles
            }
            
            // Continue with all other properties using safe decoding
            self.enableImageHeaders = (try? container.decode(Bool.self, forKey: .enableImageHeaders)) ?? self.enableImageHeaders
            self.enableCustomHeaders = (try? container.decode(Bool.self, forKey: .enableCustomHeaders)) ?? self.enableCustomHeaders
            self.enableBiometrics = (try? container.decode(Bool.self, forKey: .enableBiometrics)) ?? self.enableBiometrics
            self.requireBiometricsOnLaunch = (try? container.decode(Bool.self, forKey: .requireBiometricsOnLaunch)) ?? self.requireBiometricsOnLaunch
            self.requireBiometricsOnUnlock = (try? container.decode(Bool.self, forKey: .requireBiometricsOnUnlock)) ?? self.requireBiometricsOnUnlock
            self.enableBackups = (try? container.decode(Bool.self, forKey: .enableBackups)) ?? self.enableBackups
            self.backupOnProfileChange = (try? container.decode(Bool.self, forKey: .backupOnProfileChange)) ?? self.backupOnProfileChange
            self.backupFrequency = (try? container.decode(BackupFrequency.self, forKey: .backupFrequency)) ?? self.backupFrequency
            self.enableNotifications = (try? container.decode(Bool.self, forKey: .enableNotifications)) ?? self.enableNotifications
            self.enableBroadcastNotifications = (try? container.decode(Bool.self, forKey: .enableBroadcastNotifications)) ?? self.enableBroadcastNotifications
            self.appName = (try? container.decode(String.self, forKey: .appName)) ?? self.appName
            self.enableAdvancedSettings = (try? container.decode(Bool.self, forKey: .enableAdvancedSettings)) ?? self.enableAdvancedSettings
            self.enableErrorReporting = (try? container.decode(Bool.self, forKey: .enableErrorReporting)) ?? self.enableErrorReporting
            self.enableAnalytics = (try? container.decode(Bool.self, forKey: .enableAnalytics)) ?? self.enableAnalytics
            self.dashboardRefreshInterval = (try? container.decode(Int.self, forKey: .dashboardRefreshInterval)) ?? self.dashboardRefreshInterval
            self.enableCalendarView = (try? container.decode(Bool.self, forKey: .enableCalendarView)) ?? self.enableCalendarView
            self.calendarDaysAhead = (try? container.decode(Int.self, forKey: .calendarDaysAhead)) ?? self.calendarDaysAhead
            self.calendarStartingDay = (try? container.decode(CalendarStartDay.self, forKey: .calendarStartingDay)) ?? self.calendarStartingDay
            self.calendarStartingType = (try? container.decode(CalendarStartType.self, forKey: .calendarStartingType)) ?? self.calendarStartingType
            self.drawerAutoExpand = (try? container.decode(Bool.self, forKey: .drawerAutoExpand)) ?? self.drawerAutoExpand
            self.drawerGroupModules = (try? container.decode(Bool.self, forKey: .drawerGroupModules)) ?? self.drawerGroupModules
            self.drawerShowVersion = (try? container.decode(Bool.self, forKey: .drawerShowVersion)) ?? self.drawerShowVersion
            self.enableQuickActions = (try? container.decode(Bool.self, forKey: .enableQuickActions)) ?? self.enableQuickActions
            self.quickActionItems = (try? container.decode([QuickActionItem].self, forKey: .quickActionItems)) ?? self.quickActionItems
            self.enableSearchHistory = (try? container.decode(Bool.self, forKey: .enableSearchHistory)) ?? self.enableSearchHistory
            self.maxSearchHistory = (try? container.decode(Int.self, forKey: .maxSearchHistory)) ?? self.maxSearchHistory
            self.defaultSearchCategory = (try? container.decode(String.self, forKey: .defaultSearchCategory)) ?? self.defaultSearchCategory
            self.enableTorrentSearching = (try? container.decode(Bool.self, forKey: .enableTorrentSearching)) ?? self.enableTorrentSearching
            self.enableUsenetSearching = (try? container.decode(Bool.self, forKey: .enableUsenetSearching)) ?? self.enableUsenetSearching
            self.searchIndexers = (try? container.decode([SearchIndexer].self, forKey: .searchIndexers)) ?? self.searchIndexers
            self.sonarrQueuePageSize = (try? container.decode(Int.self, forKey: .sonarrQueuePageSize)) ?? self.sonarrQueuePageSize
            self.radarrQueuePageSize = (try? container.decode(Int.self, forKey: .radarrQueuePageSize)) ?? self.radarrQueuePageSize
            self.tautulliRefreshRate = (try? container.decode(Int.self, forKey: .tautulliRefreshRate)) ?? self.tautulliRefreshRate
            self.tautulliTerminationMessage = (try? container.decode(String.self, forKey: .tautulliTerminationMessage)) ?? self.tautulliTerminationMessage
            self.tautulliStatisticsCount = (try? container.decode(Int.self, forKey: .tautulliStatisticsCount)) ?? self.tautulliStatisticsCount
            
        } catch {
            // If regular decoding fails, try fallback for @Observable underscore keys
            print("⚠️ ThriftwoodAppSettings: Regular decoding failed, trying @Observable fallback keys: \(error)")
            
            do {
                let fallbackContainer = try decoder.container(keyedBy: FallbackCodingKeys.self)
                
                // Only try to decode the most common problematic keys
                if let theme = try? fallbackContainer.decode(AppTheme.self, forKey: ._selectedTheme) {
                    self.selectedTheme = theme
                }
                
                if let profile = try? fallbackContainer.decode(String.self, forKey: ._enabledProfile) {
                    self.enabledProfile = profile
                }
                
                if let profiles = try? fallbackContainer.decode([String: ThriftwoodProfile].self, forKey: ._profiles) {
                    self.profiles = profiles
                }
                
                print("✅ ThriftwoodAppSettings: Successfully decoded using @Observable fallback keys")
            } catch {
                print("⚠️ ThriftwoodAppSettings: Fallback decoding also failed, using defaults: \(error)")
                // Already have defaults, so we're good
            }
        }
        
        // Ensure we always have at least one profile
        if profiles.isEmpty {
            self.profiles["default"] = ThriftwoodProfile(name: "default")
            self.enabledProfile = "default"
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(selectedTheme, forKey: .selectedTheme)
        try container.encode(enabledProfile, forKey: .enabledProfile)
        try container.encode(profiles, forKey: .profiles)
        try container.encode(enableImageHeaders, forKey: .enableImageHeaders)
        try container.encode(enableCustomHeaders, forKey: .enableCustomHeaders)
        try container.encode(enableBiometrics, forKey: .enableBiometrics)
        try container.encode(requireBiometricsOnLaunch, forKey: .requireBiometricsOnLaunch)
        try container.encode(requireBiometricsOnUnlock, forKey: .requireBiometricsOnUnlock)
        try container.encode(enableBackups, forKey: .enableBackups)
        try container.encode(backupOnProfileChange, forKey: .backupOnProfileChange)
        try container.encode(backupFrequency, forKey: .backupFrequency)
        try container.encode(enableNotifications, forKey: .enableNotifications)
        try container.encode(enableBroadcastNotifications, forKey: .enableBroadcastNotifications)
        try container.encode(appName, forKey: .appName)
        try container.encode(enableAdvancedSettings, forKey: .enableAdvancedSettings)
        try container.encode(enableErrorReporting, forKey: .enableErrorReporting)
        try container.encode(enableAnalytics, forKey: .enableAnalytics)
        try container.encode(dashboardRefreshInterval, forKey: .dashboardRefreshInterval)
        try container.encode(enableCalendarView, forKey: .enableCalendarView)
        try container.encode(calendarDaysAhead, forKey: .calendarDaysAhead)
        try container.encode(calendarStartingDay, forKey: .calendarStartingDay)
        try container.encode(calendarStartingType, forKey: .calendarStartingType)
        try container.encode(drawerAutoExpand, forKey: .drawerAutoExpand)
        try container.encode(drawerGroupModules, forKey: .drawerGroupModules)
        try container.encode(drawerShowVersion, forKey: .drawerShowVersion)
        try container.encode(enableQuickActions, forKey: .enableQuickActions)
        try container.encode(quickActionItems, forKey: .quickActionItems)
        try container.encode(enableSearchHistory, forKey: .enableSearchHistory)
        try container.encode(maxSearchHistory, forKey: .maxSearchHistory)
        try container.encode(defaultSearchCategory, forKey: .defaultSearchCategory)
        try container.encode(enableTorrentSearching, forKey: .enableTorrentSearching)
        try container.encode(enableUsenetSearching, forKey: .enableUsenetSearching)
        try container.encode(searchIndexers, forKey: .searchIndexers)
        try container.encode(sonarrQueuePageSize, forKey: .sonarrQueuePageSize)
        try container.encode(radarrQueuePageSize, forKey: .radarrQueuePageSize)
        try container.encode(tautulliRefreshRate, forKey: .tautulliRefreshRate)
        try container.encode(tautulliTerminationMessage, forKey: .tautulliTerminationMessage)
        try container.encode(tautulliStatisticsCount, forKey: .tautulliStatisticsCount)
    }
    
    // Fallback keys for the most common @Observable underscore-prefixed properties
    private enum FallbackCodingKeys: String, CodingKey {
        case _selectedTheme
        case _enabledProfile
        case _profiles
    }
}

// MARK: - Model Extensions for Dictionary Conversion

extension ThriftwoodAppSettings {
    func toDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw HiveDataError.encodingError("Failed to convert to dictionary")
        }
        
        return dictionary
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) throws -> ThriftwoodAppSettings {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        let decoder = JSONDecoder()
        return try decoder.decode(ThriftwoodAppSettings.self, from: data)
    }
}
