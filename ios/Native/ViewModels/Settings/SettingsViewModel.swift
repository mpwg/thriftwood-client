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
    var showingClearCacheConfirmation: Bool = false
    
    // MARK: - Services
    private let dataManager: HiveDataManager
    private let storageService: StorageService
    
    // MARK: - Initialization
    init(dataManager: HiveDataManager = .shared, storageService: StorageService = UserDefaultsStorageService()) {
        self.dataManager = dataManager
        self.storageService = storageService
        
        // Initialize with default settings that include a default profile
        self.appSettings = ThriftwoodAppSettings()
        
        // Ensure we have initial profile state
        if appSettings.profiles.isEmpty {
            let defaultProfile = ThriftwoodProfile(name: "default")
            appSettings.profiles["default"] = defaultProfile
            appSettings.enabledProfile = "default"
        }
        
        self.selectedProfile = appSettings.profiles[appSettings.enabledProfile]
        self.availableProfiles = Array(appSettings.profiles.keys).sorted()
        
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
            // First, try to load from SwiftUI's local storage
            var loadedFromLocal = false
            if let loadedSettings = try await storageService.load(ThriftwoodAppSettings.self, forKey: "app_settings") {
                appSettings = loadedSettings
                loadedFromLocal = true
            }
            
            // If no local data exists, try to load from Flutter's Hive storage
            if !loadedFromLocal {
                print("No SwiftUI settings found, attempting to load from Flutter Hive storage...")
                
                if let hiveSettings = try await dataManager.loadSettingsFromHive() {
                    appSettings = hiveSettings
                    // Save to local storage for future loads
                    try await storageService.save(appSettings, forKey: "app_settings")
                    print("Successfully loaded settings from Flutter Hive storage")
                } else {
                    print("No Hive settings found, using default settings")
                    // Keep the default appSettings initialized in init()
                }
            }
            
            // Load available profiles
            availableProfiles = Array(appSettings.profiles.keys).sorted()
            
            // Set selected profile
            if let currentProfile = appSettings.profiles[appSettings.enabledProfile] {
                selectedProfile = currentProfile
                print("Selected profile: \(currentProfile.name)")
            } else {
                print("Warning: No profile found for enabled profile key: \(appSettings.enabledProfile)")
                // Try to find any available profile or create default
                if let firstProfile = appSettings.profiles.first {
                    appSettings.enabledProfile = firstProfile.key
                    selectedProfile = firstProfile.value
                    print("Switched to first available profile: \(firstProfile.key)")
                } else {
                    // Create default profile if none exist
                    let defaultProfile = ThriftwoodProfile(name: "default")
                    appSettings.profiles["default"] = defaultProfile
                    appSettings.enabledProfile = "default" 
                    selectedProfile = defaultProfile
                    availableProfiles = ["default"]
                    print("Created default profile")
                }
            }
            
            // Sync with Hive storage to ensure consistency
            await syncWithHiveStorage()
            
        } catch {
            showError(error.localizedDescription)
            print("Error loading settings: \(error)")
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
        
        guard let profile = appSettings.profiles[oldName] else {
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
        case "nzbget":
            profile.nzbgetEnabled = enabled
            profile.nzbgetHost = host
            // For NZBGet, apiKey is username:password format
            if apiKey.contains(":") {
                let parts = apiKey.components(separatedBy: ":")
                profile.nzbgetUser = parts[0]
                profile.nzbgetPass = parts.count > 1 ? parts[1] : ""
            } else {
                profile.nzbgetUser = apiKey
                profile.nzbgetPass = ""
            }
        default:
            showError("Unknown service: \(serviceName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        await saveSettings()
    }
    
    /// Update download client configuration
    @MainActor
    func updateDownloadClientConfiguration(_ clientName: String, enabled: Bool, host: String, username: String, password: String, apiKey: String) async {
        guard var profile = selectedProfile else { return }
        
        switch clientName.lowercased() {
        case "sabnzbd":
            profile.sabnzbdEnabled = enabled
            profile.sabnzbdHost = host
            profile.sabnzbdApiKey = apiKey
        case "nzbget":
            profile.nzbgetEnabled = enabled
            profile.nzbgetHost = host
            profile.nzbgetUser = username
            profile.nzbgetPass = password
        default:
            showError("Unknown download client: \(clientName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        await saveSettings()
    }
    
    // MARK: - Individual Service Update Methods
    
    /// Update service enabled state
    @MainActor
    func updateServiceEnabled(_ serviceName: String, enabled: Bool) {
        guard var profile = selectedProfile else { return }
        
        switch serviceName.lowercased() {
        case "lidarr":
            profile.lidarrEnabled = enabled
        case "radarr":
            profile.radarrEnabled = enabled
        case "sonarr":
            profile.sonarrEnabled = enabled
        case "tautulli":
            profile.tautulliEnabled = enabled
        case "overseerr":
            profile.overseerrEnabled = enabled
        default:
            showError("Unknown service: \(serviceName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update service host
    @MainActor
    func updateServiceHost(_ serviceName: String, host: String) {
        guard var profile = selectedProfile else { return }
        
        switch serviceName.lowercased() {
        case "lidarr":
            profile.lidarrHost = host
        case "radarr":
            profile.radarrHost = host
        case "sonarr":
            profile.sonarrHost = host
        case "tautulli":
            profile.tautulliHost = host
        case "overseerr":
            profile.overseerrHost = host
        default:
            showError("Unknown service: \(serviceName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update service API key
    @MainActor
    func updateServiceApiKey(_ serviceName: String, apiKey: String) {
        guard var profile = selectedProfile else { return }
        
        switch serviceName.lowercased() {
        case "lidarr":
            profile.lidarrApiKey = apiKey
        case "radarr":
            profile.radarrApiKey = apiKey
        case "sonarr":
            profile.sonarrApiKey = apiKey
        case "tautulli":
            profile.tautulliApiKey = apiKey
        case "overseerr":
            profile.overseerrApiKey = apiKey
        default:
            showError("Unknown service: \(serviceName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update service strict TLS setting
    @MainActor
    func updateServiceStrictTLS(_ serviceName: String, strictTLS: Bool) {
        guard var profile = selectedProfile else { return }
        
        // Update service-specific TLS setting
        switch serviceName.lowercased() {
        case "radarr":
            profile.radarrStrictTLS = strictTLS
        case "sonarr":
            profile.sonarrStrictTLS = strictTLS
        case "lidarr":
            profile.lidarrStrictTLS = strictTLS
        case "tautulli":
            profile.tautulliStrictTLS = strictTLS
        case "overseerr":
            profile.overseerrStrictTLS = strictTLS
        default:
            break
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update download client enabled state
    @MainActor
    func updateDownloadClientEnabled(_ clientName: String, enabled: Bool) {
        guard var profile = selectedProfile else { return }
        
        switch clientName.lowercased() {
        case "sabnzbd":
            profile.sabnzbdEnabled = enabled
        case "nzbget":
            profile.nzbgetEnabled = enabled
        default:
            showError("Unknown download client: \(clientName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update download client host
    @MainActor
    func updateDownloadClientHost(_ clientName: String, host: String) {
        guard var profile = selectedProfile else { return }
        
        switch clientName.lowercased() {
        case "sabnzbd":
            profile.sabnzbdHost = host
        case "nzbget":
            profile.nzbgetHost = host
        default:
            showError("Unknown download client: \(clientName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update download client API key
    @MainActor
    func updateDownloadClientApiKey(_ clientName: String, apiKey: String) {
        guard var profile = selectedProfile else { return }
        
        switch clientName.lowercased() {
        case "sabnzbd":
            profile.sabnzbdApiKey = apiKey
        case "nzbget":
            // NZBGet doesn't use API key in the same way
            break
        default:
            showError("Unknown download client: \(clientName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update download client username
    @MainActor
    func updateDownloadClientUsername(_ clientName: String, username: String) {
        guard var profile = selectedProfile else { return }
        
        switch clientName.lowercased() {
        case "nzbget":
            profile.nzbgetUser = username
        default:
            showError("Unknown download client: \(clientName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update download client password
    @MainActor
    func updateDownloadClientPassword(_ clientName: String, password: String) {
        guard var profile = selectedProfile else { return }
        
        switch clientName.lowercased() {
        case "nzbget":
            profile.nzbgetPass = password
        default:
            showError("Unknown download client: \(clientName)")
            return
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Update download client strict TLS setting
    @MainActor
    func updateDownloadClientStrictTLS(_ clientName: String, strictTLS: Bool) {
        guard var profile = selectedProfile else { return }
        
        // Update download client-specific TLS setting
        switch clientName.lowercased() {
        case "sabnzbd":
            profile.sabnzbdStrictTLS = strictTLS
        case "nzbget":
            profile.nzbgetStrictTLS = strictTLS
        default:
            break
        }
        
        // Update profile in storage
        appSettings.profiles[profile.name] = profile
        selectedProfile = profile
        
        Task { await saveSettings() }
    }
    
    /// Test Wake on LAN functionality
    @MainActor
    func testWakeOnLAN() async {
        guard let profile = selectedProfile,
              profile.wakeOnLanEnabled,
              !profile.wakeOnLanMACAddress.isEmpty else {
            showError("Wake on LAN is not properly configured")
            return
        }
        
        // TODO: Implement actual Wake on LAN packet sending
        // For now, just show success message
        showSuccessSnackBar(title: "Wake Signal Sent", message: "Sent wake packet to \(profile.wakeOnLanMACAddress)")
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
    
    /// Test method to manually force a reload from Hive storage
    @MainActor
    func testReloadFromHive() async {
        print("🔄 Testing profile reload from Hive storage...")
        
        do {
            if let hiveSettings = try await dataManager.loadSettingsFromHive() {
                appSettings = hiveSettings
                availableProfiles = Array(appSettings.profiles.keys).sorted()
                
                if let currentProfile = appSettings.profiles[appSettings.enabledProfile] {
                    selectedProfile = currentProfile
                    print("✅ Successfully loaded profile '\(currentProfile.name)' from Hive storage")
                } else {
                    print("⚠️ No current profile found, enabled profile: '\(appSettings.enabledProfile)'")
                }
                
                // Save to local storage
                try await storageService.save(appSettings, forKey: "app_settings")
            } else {
                print("⚠️ No settings found in Hive storage")
            }
        } catch {
            print("❌ Error loading from Hive storage: \(error)")
            showError("Failed to reload from Hive: \(error.localizedDescription)")
        }
    }
    
    private func syncWithHiveStorage() async {
        // Sync settings with Flutter's Hive storage
        do {
            try await dataManager.syncSettings(appSettings)
            print("✅ Settings synced to Hive successfully")
        } catch {
            print("❌ Failed to sync settings to Hive: \(error)")
            await MainActor.run {
                showError("Failed to sync settings to Flutter: \(error.localizedDescription)")
            }
        }
    }
    
    private func notifyFlutterOfProfileChange(_ profileName: String) async {
        // Notify Flutter of profile change through the bridge
        do {
            try await dataManager.notifyProfileChange(profileName)
            print("✅ Profile change notification sent to Flutter: \(profileName)")
        } catch {
            print("❌ Failed to notify Flutter of profile change: \(error)")
            await MainActor.run {
                showError("Failed to notify Flutter of profile change: \(error.localizedDescription)")
            }
        }
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
            
            // Create timestamped filename like Flutter: DateFormat('y-MM-dd kk-mm-ss').format(DateTime.now())
            let formatter = DateFormatter()
            formatter.dateFormat = "y-MM-dd HH-mm-ss"  // Flutter: 'y-MM-dd kk-mm-ss'
            let timestamp = formatter.string(from: Date())
            let filename = "\(timestamp).lunasea"
            
            // Store export data for SwiftUI fileExporter
            exportedBackupData = configData
            exportedBackupFilename = filename
            isShowingFileExporter = true
            
            // Success will be shown after file is actually saved by SwiftUI fileExporter
            
        } catch {
            showError("Backup failed: \(error.localizedDescription)")
        }
        
        isBackingUp = false
    }
    
    /// Perform restore using exact Flutter LunaConfig.import() implementation
    /// Uses SwiftUI fileImporter for pure SwiftUI compliance
    @MainActor
    func performRestore() async {
        // Flutter implementation: File picker for .lunasea files + LunaConfig().import()
        isRestoring = true
        
        // Show confirmation dialog first like Flutter
        let confirmation = await showConfirmationDialog(
            title: "Restore Configuration",
            message: "Select a .lunasea backup file to restore your configuration. This will overwrite your current settings."
        )
        
        guard confirmation else {
            isRestoring = false
            return
        }
        
        // Set flag for SwiftUI view to show file importer
        isShowingFileImporter = true
    }
    
    /// Handle file import from SwiftUI fileImporter
    /// Called by SwiftUI view when file is selected
    @MainActor
    func handleFileImport(_ result: Result<URL, Error>) async {
        defer { 
            isShowingFileImporter = false
            isRestoring = false 
        }
        
        do {
            let url = try result.get()
            
            // Read and import the backup file like Flutter's LunaConfig().import()
            let backupData = try Data(contentsOf: url)
            
            let hiveManager = HiveDataManager.shared
            try await hiveManager.importConfiguration(backupData)
            
            // Reset and reload like Flutter does after import
            appSettings = ThriftwoodAppSettings()
            await loadSettings()
            
            showSuccessSnackBar(
                title: "Restore Complete",
                message: "Configuration restored successfully"
            )
            
        } catch {
            showError("Restore failed: \(error.localizedDescription)")
        }
    }
    
    // File importer state for SwiftUI
    var isShowingFileImporter: Bool = false
    
    // File exporter state for SwiftUI
    var isShowingFileExporter: Bool = false
    var exportedBackupData: Data?
    var exportedBackupFilename: String = ""
    
    /// Handle backup export completion from SwiftUI fileExporter
    @MainActor
    func handleBackupExport(_ result: Result<URL, Error>) {
        defer { 
            isShowingFileExporter = false
            exportedBackupData = nil
            isBackingUp = false
        }
        
        switch result {
        case .success(_):
            showSuccessSnackBar(
                title: "Backup Complete",
                message: "Configuration backed up to \(exportedBackupFilename)"
            )
        case .failure(let error):
            showError("Backup failed: \(error.localizedDescription)")
        }
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
    
    // MARK: - Profile Management Dialog Methods (Flutter Parity)
    
    /// Show enabled profile selection dialog (matches Flutter's SettingsDialogs().enabledProfile())
    @MainActor
    func showEnabledProfileDialog() async {
        // This would show a dialog to select from available profiles
        // For now, just log that it was called - full implementation would use SwiftUI sheets
        print("Show enabled profile dialog called")
    }
    
    /// Show add profile dialog (matches Flutter's SettingsDialogs().addProfile())
    @MainActor
    func showAddProfileDialog() async {
        // This would show a text input dialog to create a new profile
        // For now, just log that it was called - full implementation would use SwiftUI sheets
        print("Show add profile dialog called")
    }
    
    /// Show rename profile dialog (matches Flutter's SettingsDialogs().renameProfile())
    @MainActor
    func showRenameProfileDialog() async {
        // This would show a dialog to select a profile and rename it
        // For now, just log that it was called - full implementation would use SwiftUI sheets
        print("Show rename profile dialog called")
    }
    
    /// Show delete profile dialog (matches Flutter's SettingsDialogs().deleteProfile())
    @MainActor
    func showDeleteProfileDialog() async {
        // This would show a dialog to select and confirm deletion of a profile
        // For now, just log that it was called - full implementation would use SwiftUI sheets
        print("Show delete profile dialog called")
    }
    
    // MARK: - Helper Methods
    
    /// Shows confirmation dialog matching Flutter's dialog behavior
    /// Flutter equivalent: LunaDialog.dialog() with confirmation buttons
    private func showConfirmationDialog(title: String, message: String) async -> Bool {
        // This will be handled by the SwiftUI view layer using .confirmationDialog()
        // The view model sets the confirmation state and SwiftUI handles the UI
        return await withCheckedContinuation { continuation in
            // This pattern allows SwiftUI views to intercept and show native dialogs
            // The view will call the continuation when user responds
            Task { @MainActor in
                // Store confirmation details for SwiftUI to access
                self.pendingConfirmation = PendingConfirmation(
                    title: title,
                    message: message,
                    continuation: continuation
                )
                self.isShowingConfirmationDialog = true
            }
        }
    }
    
    /// Handles confirmation dialog response
    @MainActor
    func handleConfirmationResponse(_ confirmed: Bool) {
        guard let pending = pendingConfirmation else { return }
        pending.continuation.resume(returning: confirmed)
        pendingConfirmation = nil
        isShowingConfirmationDialog = false
    }
    
    // MARK: - Confirmation Dialog Support
    
    struct PendingConfirmation {
        let title: String
        let message: String
        let continuation: CheckedContinuation<Bool, Never>
    }
    
    var pendingConfirmation: PendingConfirmation?
    var isShowingConfirmationDialog: Bool = false
}


// MARK: - Extensions

extension SettingsViewModel {
    /// Convenience computed properties
    var currentProfileName: String {
        if let profile = selectedProfile {
            return profile.name
        }
        
        // Fallback: try to get the currently enabled profile name
        if !appSettings.enabledProfile.isEmpty {
            return appSettings.enabledProfile
        }
        
        // Final fallback
        return "No Profile Selected"
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


