//
//  UserPreferencesServiceProtocol.swift
//  Thriftwood
//
//  Protocol for user preferences service to enable dependency injection and testing
//

import Foundation
import Combine

/// Protocol defining user preferences operations
/// Allows for dependency injection and mock implementations in tests
/// All preferences are persisted in SwiftData (AppSettings model)
protocol UserPreferencesServiceProtocol: AnyObject {
    
    // MARK: - Profile Management
    
    /// Name of the currently enabled/active profile
    var enabledProfileName: String { get set }
    
    // MARK: - Theme Settings
    
    /// Whether AMOLED black theme is enabled (pure black for OLED screens)
    var themeAMOLED: Bool { get set }
    
    /// Whether to show borders in AMOLED mode
    var themeAMOLEDBorder: Bool { get set }
    
    /// Opacity for image backgrounds (0-100)
    var themeImageBackgroundOpacity: Int { get set }
    
    // MARK: - Drawer/Navigation Settings
    
    /// Whether Android back button opens drawer (mobile-specific)
    var androidBackOpensDrawer: Bool { get set }
    
    /// Whether to automatically manage drawer module order
    var drawerAutomaticManage: Bool { get set }
    
    /// Manual order of drawer modules (stored as array of module keys)
    var drawerManualOrder: [String] { get set }
    
    // MARK: - Networking Settings
    
    /// Whether to validate TLS/SSL certificates (disable for self-signed certs)
    var networkingTLSValidation: Bool { get set }
    
    // MARK: - Quick Actions Settings
    
    /// Whether Lidarr quick action is enabled
    var quickActionsLidarr: Bool { get set }
    
    /// Whether Radarr quick action is enabled
    var quickActionsRadarr: Bool { get set }
    
    /// Whether Sonarr quick action is enabled
    var quickActionsSonarr: Bool { get set }
    
    /// Whether NZBGet quick action is enabled
    var quickActionsNZBGet: Bool { get set }
    
    /// Whether SABnzbd quick action is enabled
    var quickActionsSABnzbd: Bool { get set }
    
    /// Whether Overseerr quick action is enabled
    var quickActionsOverseerr: Bool { get set }
    
    /// Whether Tautulli quick action is enabled
    var quickActionsTautulli: Bool { get set }
    
    /// Whether Search quick action is enabled
    var quickActionsSearch: Bool { get set }
    
    // MARK: - Display Settings
    
    /// Whether to use 24-hour time format (vs 12-hour AM/PM)
    var use24HourTime: Bool { get set }
    
    /// Whether to enable in-app notifications
    var enableInAppNotifications: Bool { get set }
    
    // MARK: - App Metadata
    
    /// Last build version shown in changelog (for tracking updates)
    var changelogLastBuildVersion: Int { get set }
    
    /// Timestamp when settings were last updated
    var updatedAt: Date { get }
    
    // MARK: - Operations
    
    /// Reloads preferences from storage (useful after external changes)
    func reload() throws
    
    /// Saves current preferences to storage
    func save() throws
    
    /// Resets all preferences to defaults
    func resetToDefaults() throws
}
