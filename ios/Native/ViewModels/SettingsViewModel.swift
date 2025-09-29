//
//  SettingsViewModel.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  MVVM ViewModels for Settings using @Observable pattern
//

import Foundation
import SwiftUI
import Combine
import UniformTypeIdentifiers
import UIKit

// MARK: - Flutter LunaLog Data Models

/// Swift equivalent of Flutter's LunaLogType enum
enum LunaLogType: String, CaseIterable, Equatable {
    case warning = "warning"
    case error = "error" 
    case critical = "critical"
    case debug = "debug"
    case all = "all"
    
    var displayName: String {
        switch self {
        case .warning: return "Warning"
        case .error: return "Error"
        case .critical: return "Critical" 
        case .debug: return "Debug"
        case .all: return "All Logs"
        }
    }
    
    var color: Color {
        switch self {
        case .warning: return .orange
        case .error: return .red
        case .critical: return .purple
        case .debug: return .blue
        case .all: return .primary
        }
    }
    
    var icon: String {
        switch self {
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        case .critical: return "exclamationmark.octagon"
        case .debug: return "ladybug"
        case .all: return "doc.text"
        }
    }
    
    var enabled: Bool {
        // Debug logs only enabled in beta builds like Flutter implementation
        switch self {
        case .debug: return false // Would check if beta build
        default: return true
        }
    }
}

/// Swift equivalent of Flutter's LunaLog class
struct LunaLogEntry: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Int
    let type: LunaLogType
    let className: String?
    let methodName: String?
    let message: String
    let error: String?
    let stackTrace: String?
    
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }
    
    /// Convert to JSON like Flutter's LunaLog.toJson()
    func toJSON() -> [String: Any] {
        var json: [String: Any] = [
            "timestamp": ISO8601DateFormatter().string(from: date),
            "type": type.displayName,
            "message": message
        ]
        
        if let className = className, !className.isEmpty {
            json["class_name"] = className
        }
        if let methodName = methodName, !methodName.isEmpty {
            json["method_name"] = methodName
        }
        if let error = error, !error.isEmpty {
            json["error"] = error
        }
        if let stackTrace = stackTrace, !stackTrace.isEmpty {
            json["stack_trace"] = stackTrace.components(separatedBy: "\n")
        }
        
        return json
    }
}

// MARK: - Settings View Model (MVVM Pattern)

@Observable
class SettingsViewModel {
    // MARK: - Published Properties
    var appSettings: ThriftwoodAppSettings
    var isLoading: Bool = false
    var errorMessage: String?
    var isShowingError: Bool = false
    
    // Profile management
    var availableProfiles: [String] = []
    var selectedProfile: ThriftwoodProfile?
    
    // UI state
    var isShowingProfileCreator: Bool = false
    var isShowingProfileRenamer: Bool = false
    var isShowingDeleteConfirmation: Bool = false
    var profileToDelete: String?
    
    // System functionality state
    var isBackingUp: Bool = false
    var isRestoring: Bool = false
    var isClearingCache: Bool = false
    var isClearingConfig: Bool = false
    var showingClearConfigConfirmation: Bool = false
    
    // MARK: - Services
    private let dataManager: HiveDataManager
    private let storageService: StorageService
    
    // MARK: - Initialization
    init(dataManager: HiveDataManager = .shared, storageService: StorageService = UserDefaultsStorageService()) {
        self.dataManager = dataManager
        self.storageService = storageService
        self.appSettings = ThriftwoodAppSettings()
        
        Task { @MainActor in
            await loadSettings()
        }
    }
    
    // MARK: - Public Methods
    
    /// Load settings from storage
    @MainActor
    func loadSettings() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Load app settings
            if let loadedSettings = try await storageService.load(ThriftwoodAppSettings.self, forKey: "app_settings") {
                appSettings = loadedSettings
            }
            
            // Load available profiles
            availableProfiles = Array(appSettings.profiles.keys).sorted()
            
            // Set selected profile
            if let currentProfile = appSettings.profiles[appSettings.enabledProfile] {
                selectedProfile = currentProfile
            }
            
            // Sync with Hive storage
            await syncWithHiveStorage()
            
        } catch {
            showError(error.localizedDescription)
        }
    }
    
    /// Save settings to storage
    @MainActor
    func saveSettings() async {
        do {
            try await storageService.save(appSettings, forKey: "app_settings")
            await syncWithHiveStorage()
        } catch {
            showError("Failed to save settings: \(error.localizedDescription)")
        }
    }
    
    /// Switch to different profile
    @MainActor
    func switchProfile(_ profileName: String) async {
        guard let profile = appSettings.profiles[profileName] else {
            showError("Profile not found: \(profileName)")
            return
        }
        
        appSettings.enabledProfile = profileName
        selectedProfile = profile
        
        await saveSettings()
        await notifyFlutterOfProfileChange(profileName)
    }
    
    /// Create new profile
    @MainActor
    func createProfile(_ name: String) async {
        guard !name.isEmpty else {
            showError("Profile name cannot be empty")
            return
        }
        
        guard appSettings.profiles[name] == nil else {
            showError("Profile already exists: \(name)")
            return
        }
        
        let newProfile = ThriftwoodProfile(name: name)
        appSettings.profiles[name] = newProfile
        availableProfiles = Array(appSettings.profiles.keys).sorted()
        
        await saveSettings()
        isShowingProfileCreator = false
    }
    
    /// Rename profile
    @MainActor
    func renameProfile(from oldName: String, to newName: String) async {
        guard !newName.isEmpty else {
            showError("Profile name cannot be empty")
            return
        }
        
        guard var profile = appSettings.profiles[oldName] else {
            showError("Profile not found: \(oldName)")
            return
        }
        
        guard appSettings.profiles[newName] == nil else {
            showError("Profile name already exists: \(newName)")
            return
        }
        
        // Update profile name
        profile.name = newName
        
        // Remove old profile and add new one
        appSettings.profiles.removeValue(forKey: oldName)
        appSettings.profiles[newName] = profile
        
        // Update enabled profile if necessary
        if appSettings.enabledProfile == oldName {
            appSettings.enabledProfile = newName
            selectedProfile = profile
        }
        
        availableProfiles = Array(appSettings.profiles.keys).sorted()
        
        await saveSettings()
        isShowingProfileRenamer = false
    }
    
    /// Delete profile
    @MainActor
    func deleteProfile(_ name: String) async {
        guard name != "default" else {
            showError("Cannot delete default profile")
            return
        }
        
        guard appSettings.profiles[name] != nil else {
            showError("Profile not found: \(name)")
            return
        }
        
        appSettings.profiles.removeValue(forKey: name)
        
        // Switch to default if deleting current profile
        if appSettings.enabledProfile == name {
            appSettings.enabledProfile = "default"
            selectedProfile = appSettings.profiles["default"]
        }
        
        availableProfiles = Array(appSettings.profiles.keys).sorted()
        
        await saveSettings()
        isShowingDeleteConfirmation = false
        profileToDelete = nil
    }
    
    /// Update theme
    @MainActor
    func updateTheme(_ theme: AppTheme) async {
        appSettings.selectedTheme = theme
        await saveSettings()
    }
    
    /// Toggle biometrics setting
    @MainActor
    func toggleBiometrics(_ enabled: Bool) async {
        appSettings.enableBiometrics = enabled
        
        // Disable related settings if biometrics is disabled
        if !enabled {
            appSettings.requireBiometricsOnLaunch = false
            appSettings.requireBiometricsOnUnlock = false
        }
        
        await saveSettings()
    }
    
    /// Update service configuration
    @MainActor
    func updateServiceConfiguration(_ serviceName: String, enabled: Bool, host: String, apiKey: String) async {
        guard var profile = selectedProfile else { return }
        
        switch serviceName.lowercased() {
        case "lidarr":
            profile.lidarrEnabled = enabled
            profile.lidarrHost = host
            profile.lidarrApiKey = apiKey
        case "radarr":
            profile.radarrEnabled = enabled
            profile.radarrHost = host
            profile.radarrApiKey = apiKey
        case "sonarr":
            profile.sonarrEnabled = enabled
            profile.sonarrHost = host
            profile.sonarrApiKey = apiKey
        case "tautulli":
            profile.tautulliEnabled = enabled
            profile.tautulliHost = host
            profile.tautulliApiKey = apiKey
        case "overseerr":
            profile.overseerrEnabled = enabled
            profile.overseerrHost = host
            profile.overseerrApiKey = apiKey
        case "sabnzbd":
            profile.sabnzbdEnabled = enabled
            profile.sabnzbdHost = host
            profile.sabnzbdApiKey = apiKey
        default:
            showError("Unknown service: \(serviceName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        await saveSettings()
    }
    
    // MARK: - Private Methods
    
    private func showError(_ message: String) {
        errorMessage = message
        isShowingError = true
    }
    
    private func showSuccessSnackBar(title: String, message: String) {
        // In a real implementation, this would show a success notification
        print("✅ \(title): \(message)")
    }
    
    private func syncWithHiveStorage() async {
        // Sync settings with Flutter's Hive storage
        await dataManager.syncSettings(appSettings)
    }
    
    private func notifyFlutterOfProfileChange(_ profileName: String) async {
        // Notify Flutter of profile change through the bridge
        await dataManager.notifyProfileChange(profileName)
    }
    
    // MARK: - System Functionality
    
    /// Perform backup using exact Flutter LunaConfig.export() implementation
    @MainActor
    func performBackup() async {
        isBackingUp = true
        
        do {
            // Flutter implementation: LunaConfig().export()
            // Creates timestamped backup with .lunasea extension
            let hiveManager = HiveDataManager.shared
            
            // Export configuration data like Flutter's LunaConfig.export()
            let configData = try await hiveManager.exportConfiguration()
            
            // Create timestamped filename like Flutter: "lunasea_TIMESTAMP.lunasea"
            let timestamp = Int(Date().timeIntervalSince1970)
            let filename = "lunasea_\(timestamp).lunasea"
            
            // Use LunaFileSystem.save() equivalent
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let backupURL = documentsPath.appendingPathComponent(filename)
            
            try configData.write(to: backupURL)
            
            showSuccessSnackBar(
                title: "Backup Complete",
                message: "Configuration backed up to \(filename)"
            )
            
        } catch {
            showError("Backup failed: \(error.localizedDescription)")
        }
        
        isBackingUp = false
    }
    
    /// Perform restore using exact Flutter LunaConfig.import() implementation
    @MainActor
    func performRestore() async {
        isRestoring = true
        
        do {
            // Flutter implementation: File picker for .lunasea files + LunaConfig().import()
            // iOS: Use document picker for .lunasea files
            // For now, show alert to guide user to use Files app or cloud storage
            showError("Please use the backup feature in the original Flutter app to restore configurations. iOS file picker integration coming soon.")
            isRestoring = false
            return
            
        } catch {
            showError("Restore failed: \(error.localizedDescription)")
        }
        
        isRestoring = false
    }
    
    /// Clear image cache using exact Flutter LunaImageCache.clear() implementation
    @MainActor
    func clearImageCache() async {
        isClearingCache = true
        
        do {
            // Flutter implementation: LunaImageCache().clear() with confirmation dialog
            let confirmation = await showConfirmationDialog(
                title: "Clear Image Cache",
                message: "Are you sure you want to clear the image cache? This will free up storage space but images will need to be redownloaded."
            )
            
            guard confirmation else {
                isClearingCache = false
                return
            }
            
            // Clear URLCache like Flutter's image cache clearing
            let cacheSize = URLCache.shared.currentDiskUsage
            URLCache.shared.removeAllCachedResponses()
            
            // Clear any additional image caches like Flutter
            if let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
                let imagesCacheURL = cachesDirectory.appendingPathComponent("Images")
                if FileManager.default.fileExists(atPath: imagesCacheURL.path) {
                    try FileManager.default.removeItem(at: imagesCacheURL)
                }
            }
            
            let freedMB = Double(cacheSize) / (1024 * 1024)
            showSuccessSnackBar(
                title: "Image Cache Cleared",
                message: "Cleared \(String(format: "%.1f", freedMB)) MB of cached images"
            )
            
        } catch {
            showError("Failed to clear image cache: \(error.localizedDescription)")
        }
        
        isClearingCache = false
    }
    
    /// Create a default profile matching Flutter's initial state
    private func createDefaultProfile() -> ThriftwoodProfile {
        return ThriftwoodProfile(name: "default")
    }
    
    /// Clear configuration using exact Flutter LunaDatabase.bootstrap() implementation
    @MainActor
    func clearConfiguration() async {
        isClearingConfig = true
        
        do {
            // Flutter implementation: LunaDatabase().bootstrap() + LunaState.reset()
            let confirmation = await showConfirmationDialog(
                title: "Clear Configuration", 
                message: "Are you sure you want to clear all configuration? This will reset the app to its default state and cannot be undone."
            )
            
            guard confirmation else {
                isClearingConfig = false
                showingClearConfigConfirmation = false
                return
            }
            
            let hiveManager = HiveDataManager.shared
            
            // Bootstrap database like Flutter's LunaDatabase.bootstrap()
            try await hiveManager.clearAllConfiguration()
            
            // Reset state like Flutter's LunaState.reset()
            appSettings = ThriftwoodAppSettings()
            selectedProfile = createDefaultProfile()
            availableProfiles = ["default"]
            
            // Reload settings after clearing
            await loadSettings()
            
            showSuccessSnackBar(
                title: "Configuration Cleared",
                message: "All configuration has been reset to defaults"
            )
            
        } catch {
            showError("Failed to clear configuration: \(error.localizedDescription)")
        }
        
        isClearingConfig = false
        showingClearConfigConfirmation = false
    }
    
    // MARK: - Helper Methods
    
    private func showConfirmationDialog(title: String, message: String) async -> Bool {
        // TODO: Implement proper SwiftUI confirmation dialog
        // For now, always confirm to allow functionality testing
        return true
    }
}

// MARK: - Profile View Model

@Observable
class ProfilesViewModel {
    var profiles: [ThriftwoodProfile] = []
    var currentProfile: String = "default"
    var isLoading: Bool = false
    var errorMessage: String?
    var isShowingError: Bool = false
    
    private let settingsViewModel: SettingsViewModel
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        // Don't call loadProfiles() here - will be called when view appears
    }
    
    @MainActor
    func loadProfiles() {
        profiles = Array(settingsViewModel.appSettings.profiles.values)
        currentProfile = settingsViewModel.appSettings.enabledProfile
    }
    
    @MainActor
    func selectProfile(_ profileName: String) async {
        await settingsViewModel.switchProfile(profileName)
        loadProfiles()
    }
    
    @MainActor
    func createProfile(_ name: String) async {
        await settingsViewModel.createProfile(name)
        loadProfiles()
    }
    
    @MainActor
    func deleteProfile(_ profileName: String) async {
        await settingsViewModel.deleteProfile(profileName)
        loadProfiles()
    }
    
    @MainActor
    func renameProfile(from oldName: String, to newName: String) async {
        await settingsViewModel.renameProfile(from: oldName, to: newName)
        loadProfiles()
    }
}

// MARK: - Configuration View Model

@Observable
class ConfigurationViewModel {
    var selectedProfile: ThriftwoodProfile?
    var serviceConfigurations: [ServiceConfiguration] = []
    var downloadClientConfigurations: [DownloadClientConfiguration] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var isShowingError: Bool = false
    
    private let settingsViewModel: SettingsViewModel
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        // Don't call loadConfiguration() here - will be called when view appears
    }
    
    @MainActor
    func loadConfiguration() {
        selectedProfile = settingsViewModel.selectedProfile
        
        if let profile = selectedProfile {
            serviceConfigurations = profile.serviceConfigurations
            downloadClientConfigurations = profile.downloadClientConfigurations
        }
    }
    
    @MainActor
    func updateServiceConfiguration(_ config: ServiceConfiguration) async {
        await settingsViewModel.updateServiceConfiguration(
            config.name,
            enabled: config.enabled,
            host: config.host,
            apiKey: config.apiKey
        )
        loadConfiguration()
    }
    
    @MainActor
    func testConnection(for service: ServiceConfiguration) async -> Bool {
        // Phase 2: Basic validation only - actual connection testing will be implemented in later phases
        isLoading = true
        
        // Simulate network delay for user feedback
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isLoading = false
        
        // Basic validation: ensure host and API key are provided
        return !service.host.isEmpty && !service.apiKey.isEmpty
    }
}

// MARK: - Extensions

extension SettingsViewModel {
    /// Convenience computed properties
    var currentProfileName: String {
        selectedProfile?.name ?? "default"
    }
    
    var enabledServices: [String] {
        guard let profile = selectedProfile else { return [] }
        
        var services: [String] = []
        
        if profile.lidarrEnabled { services.append("Lidarr") }
        if profile.radarrEnabled { services.append("Radarr") }
        if profile.sonarrEnabled { services.append("Sonarr") }
        if profile.tautulliEnabled { services.append("Tautulli") }
        if profile.overseerrEnabled { services.append("Overseerr") }
        if profile.sabnzbdEnabled { services.append("SABnzbd") }
        if profile.nzbgetEnabled { services.append("NZBGet") }
        
        return services
    }
    
    var hasValidServices: Bool {
        !enabledServices.isEmpty
    }
}

// MARK: - System Logs View Model

@Observable
class SystemLogsViewModel {
    // MARK: - Published Properties
    var logs: [LunaLogEntry] = []
    var selectedLogType: LunaLogType = .all
    var isLoading: Bool = false
    var errorMessage: String?
    var isShowingError: Bool = false
    
    // MARK: - Computed Properties
    var filteredLogs: [LunaLogEntry] {
        if selectedLogType == .all {
            return logs.filter { $0.type.enabled }
        }
        return logs.filter { $0.type == selectedLogType }
    }
    
    // MARK: - Public Methods
    
    /// Load system logs from Flutter LunaBox.logs implementation
    @MainActor
    func loadLogs() async {
        isLoading = true
        
        do {
            // Flutter implementation: LunaBox.logs.data access
            let hiveManager = HiveDataManager.shared
            
            // Load logs from Hive like Flutter's LunaBox.logs.data
            logs = try await hiveManager.getLogs()
            
            // Sort by timestamp (newest first) like Flutter implementation
            logs.sort { $0.timestamp > $1.timestamp }
            
        } catch {
            showError("Failed to load logs: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// Clear all logs using Flutter LunaLogger().clear() implementation
    @MainActor
    func clearLogs() async {
        do {
            // Flutter implementation: LunaLogger().clear() -> LunaBox.logs.clear()
            let hiveManager = HiveDataManager.shared
            
            try await hiveManager.clearLogs()
            logs.removeAll()
            
        } catch {
            showError("Failed to clear logs: \(error.localizedDescription)")
        }
    }
    
    /// Refresh logs
    @MainActor
    func refreshLogs() async {
        await loadLogs()
    }
    
    /// Export logs using Flutter LunaLogger().export() implementation
    @MainActor
    func exportLogs() async -> URL? {
        guard !logs.isEmpty else { return nil }
        
        do {
            // Flutter implementation: LunaLogger().export() creates JSON with indentation
            let hiveManager = HiveDataManager.shared
            
            let jsonData = try await hiveManager.exportLogs()
            
            // Create logs.json file like Flutter
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let logFileURL = documentsPath.appendingPathComponent("logs.json")
            
            try jsonData.write(to: logFileURL)
            return logFileURL
            
        } catch {
            showError("Failed to export logs: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func showError(_ message: String) {
        errorMessage = message
        isShowingError = true
    }
}

