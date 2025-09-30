//
//  ThriftwoodModels.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  Data models that mirror Flutter's LunaProfile and settings structure
//  Uses @Observable for iOS 17+ compatibility
//

import Foundation
import SwiftUI

// MARK: - Profile Models

/// Profile model that mirrors Flutter's LunaProfile structure
@Observable
class ThriftwoodProfile: Codable, Identifiable {
    let id = UUID()
    var name: String
    var isDefault: Bool
    
    // Service configurations
    var lidarrEnabled: Bool
    var lidarrHost: String
    var lidarrApiKey: String
    var lidarrCustomHeaders: [String: String]
    var lidarrStrictTLS: Bool
    
    var radarrEnabled: Bool
    var radarrHost: String
    var radarrApiKey: String
    var radarrCustomHeaders: [String: String]
    var radarrStrictTLS: Bool
    
    var sonarrEnabled: Bool
    var sonarrHost: String
    var sonarrApiKey: String
    var sonarrCustomHeaders: [String: String]
    var sonarrStrictTLS: Bool
    
    var sabnzbdEnabled: Bool
    var sabnzbdHost: String
    var sabnzbdApiKey: String
    var sabnzbdCustomHeaders: [String: String]
    var sabnzbdStrictTLS: Bool
    
    var nzbgetEnabled: Bool
    var nzbgetHost: String
    var nzbgetUser: String
    var nzbgetPass: String
    var nzbgetCustomHeaders: [String: String]
    var nzbgetStrictTLS: Bool
    
    var tautulliEnabled: Bool
    var tautulliHost: String
    var tautulliApiKey: String
    var tautulliCustomHeaders: [String: String]
    var tautulliStrictTLS: Bool
    
    var overseerrEnabled: Bool
    var overseerrHost: String
    var overseerrApiKey: String
    var overseerrCustomHeaders: [String: String]
    var overseerrStrictTLS: Bool
    
    // Wake on LAN configuration
    var wakeOnLanEnabled: Bool
    var wakeOnLanMACAddress: String
    var wakeOnLanBroadcastAddress: String
    
    init(name: String = "default") {
        self.name = name
        self.isDefault = name == "default"
        
        // Initialize with default values matching Flutter implementation
        self.lidarrEnabled = false
        self.lidarrHost = ""
        self.lidarrApiKey = ""
        self.lidarrCustomHeaders = [:]
        self.lidarrStrictTLS = true
        
        self.radarrEnabled = false
        self.radarrHost = ""
        self.radarrApiKey = ""
        self.radarrCustomHeaders = [:]
        self.radarrStrictTLS = true
        
        self.sonarrEnabled = false
        self.sonarrHost = ""
        self.sonarrApiKey = ""
        self.sonarrCustomHeaders = [:]
        self.sonarrStrictTLS = true
        
        self.sabnzbdEnabled = false
        self.sabnzbdHost = ""
        self.sabnzbdApiKey = ""
        self.sabnzbdCustomHeaders = [:]
        self.sabnzbdStrictTLS = true
        
        self.nzbgetEnabled = false
        self.nzbgetHost = ""
        self.nzbgetUser = ""
        self.nzbgetPass = ""
        self.nzbgetCustomHeaders = [:]
        self.nzbgetStrictTLS = true
        
        self.tautulliEnabled = false
        self.tautulliHost = ""
        self.tautulliApiKey = ""
        self.tautulliCustomHeaders = [:]
        self.tautulliStrictTLS = true
        
        self.overseerrEnabled = false
        self.overseerrHost = ""
        self.overseerrApiKey = ""
        self.overseerrCustomHeaders = [:]
        self.overseerrStrictTLS = true
        
        self.wakeOnLanEnabled = false
        self.wakeOnLanMACAddress = ""
        self.wakeOnLanBroadcastAddress = ""
    }
}

// MARK: - App Settings Models

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
    
    // External Modules Settings
    var externalModules: [ExternalModule]
    
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
        
        // External Modules defaults
        self.externalModules = []
    }
}

// MARK: - Enums

enum AppTheme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

enum BackupFrequency: String, CaseIterable, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case manual = "manual"
    
    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly" 
        case .monthly: return "Monthly"
        case .manual: return "Manual Only"
        }
    }
}

enum CalendarStartDay: String, CaseIterable, Codable {
    case sunday = "sunday"
    case monday = "monday"
    
    var displayName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        }
    }
}

enum CalendarStartType: String, CaseIterable, Codable {
    case today = "today"
    case thisWeek = "thisWeek"
    case thisMonth = "thisMonth"
    
    var displayName: String {
        switch self {
        case .today: return "Today"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        }
    }
}

// MARK: - Quick Actions

struct QuickActionItem: Codable, Identifiable {
    let id = UUID()
    var title: String
    var icon: String
    var route: String
    var isEnabled: Bool
    
    init(title: String, icon: String, route: String, isEnabled: Bool = true) {
        self.title = title
        self.icon = icon
        self.route = route
        self.isEnabled = isEnabled
    }
}

// MARK: - External Modules

struct ExternalModule: Codable, Identifiable {
    let id = UUID()
    var name: String
    var displayName: String
    var host: String
    var icon: String
    var isEnabled: Bool
    
    init(name: String, displayName: String, host: String, icon: String = "globe", isEnabled: Bool = true) {
        self.name = name
        self.displayName = displayName
        self.host = host
        self.icon = icon
        self.isEnabled = isEnabled
    }
}

// MARK: - Service Configuration Models

@Observable
class ServiceConfiguration: Codable, Identifiable {
    let id = UUID()
    var name: String
    var enabled: Bool
    var host: String
    var apiKey: String
    var customHeaders: [String: String]
    var strictTLS: Bool
    
    init(name: String) {
        self.name = name
        self.enabled = false
        self.host = ""
        self.apiKey = ""
        self.customHeaders = [:]
        self.strictTLS = true
    }
}

@Observable
class DownloadClientConfiguration: Codable, Identifiable {
    let id = UUID()
    var name: String
    var enabled: Bool
    var host: String
    var username: String
    var password: String
    var apiKey: String
    var customHeaders: [String: String]
    var strictTLS: Bool
    
    init(name: String) {
        self.name = name
        self.enabled = false
        self.host = ""
        self.username = ""
        self.password = ""
        self.apiKey = ""
        self.customHeaders = [:]
        self.strictTLS = true
    }
}

// MARK: - Extensions

extension ThriftwoodProfile {
    /// Get all service configurations as an array
    var serviceConfigurations: [ServiceConfiguration] {
        var configs: [ServiceConfiguration] = []
        
        // Lidarr
        let lidarr = ServiceConfiguration(name: "Lidarr")
        lidarr.enabled = lidarrEnabled
        lidarr.host = lidarrHost
        lidarr.apiKey = lidarrApiKey
        lidarr.customHeaders = lidarrCustomHeaders
        lidarr.strictTLS = lidarrStrictTLS
        configs.append(lidarr)
        
        // Radarr
        let radarr = ServiceConfiguration(name: "Radarr")
        radarr.enabled = radarrEnabled
        radarr.host = radarrHost
        radarr.apiKey = radarrApiKey
        radarr.customHeaders = radarrCustomHeaders
        radarr.strictTLS = radarrStrictTLS
        configs.append(radarr)
        
        // Sonarr
        let sonarr = ServiceConfiguration(name: "Sonarr")
        sonarr.enabled = sonarrEnabled
        sonarr.host = sonarrHost
        sonarr.apiKey = sonarrApiKey
        sonarr.customHeaders = sonarrCustomHeaders
        sonarr.strictTLS = sonarrStrictTLS
        configs.append(sonarr)
        
        // Tautulli
        let tautulli = ServiceConfiguration(name: "Tautulli")
        tautulli.enabled = tautulliEnabled
        tautulli.host = tautulliHost
        tautulli.apiKey = tautulliApiKey
        tautulli.customHeaders = tautulliCustomHeaders
        tautulli.strictTLS = tautulliStrictTLS
        configs.append(tautulli)
        
        // Overseerr
        let overseerr = ServiceConfiguration(name: "Overseerr")
        overseerr.enabled = overseerrEnabled
        overseerr.host = overseerrHost
        overseerr.apiKey = overseerrApiKey
        overseerr.customHeaders = overseerrCustomHeaders
        overseerr.strictTLS = overseerrStrictTLS
        configs.append(overseerr)
        
        return configs
    }
    
    /// Get download client configurations
    var downloadClientConfigurations: [DownloadClientConfiguration] {
        var configs: [DownloadClientConfiguration] = []
        
        // SABnzbd
        let sabnzbd = DownloadClientConfiguration(name: "SABnzbd")
        sabnzbd.enabled = sabnzbdEnabled
        sabnzbd.host = sabnzbdHost
        sabnzbd.apiKey = sabnzbdApiKey
        sabnzbd.customHeaders = sabnzbdCustomHeaders
        sabnzbd.strictTLS = sabnzbdStrictTLS
        configs.append(sabnzbd)
        
        // NZBGet
        let nzbget = DownloadClientConfiguration(name: "NZBGet")
        nzbget.enabled = nzbgetEnabled
        nzbget.host = nzbgetHost
        nzbget.username = nzbgetUser
        nzbget.password = nzbgetPass
        nzbget.customHeaders = nzbgetCustomHeaders
        nzbget.strictTLS = nzbgetStrictTLS
        configs.append(nzbget)
        
        return configs
    }
}