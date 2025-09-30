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
    
    // External Modules Settings
    var externalModules: [ExternalModule]
    
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
        
        // External Modules defaults
        self.externalModules = []
        
        // Queue Settings defaults (matching Flutter)
        self.sonarrQueuePageSize = 50
        self.radarrQueuePageSize = 50
        
        // Tautulli Settings defaults
        self.tautulliRefreshRate = 15 // 15 seconds
        self.tautulliTerminationMessage = ""
        self.tautulliStatisticsCount = 10
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
