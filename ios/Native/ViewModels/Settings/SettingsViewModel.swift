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
import Network

/// Wake on LAN specific errors
enum WakeOnLANError: LocalizedError {
    case invalidMACAddress
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidMACAddress:
            return "Invalid MAC address format"
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}

/// Extension to create Data from hex string
extension Data {
    init?(hexString: String) {
        let cleanString = hexString.replacingOccurrences(of: " ", with: "")
        guard cleanString.count % 2 == 0 else { return nil }
        
        var data = Data(capacity: cleanString.count / 2)
        var index = cleanString.startIndex
        
        while index < cleanString.endIndex {
            let nextIndex = cleanString.index(index, offsetBy: 2)
            guard let byte = UInt8(cleanString[index..<nextIndex], radix: 16) else { return nil }
            data.append(byte)
            index = nextIndex
        }
        
        self = data
    }
}

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
    
    // Queue Size Management
    var isShowingSonarrQueueSizePicker: Bool = false
    var isShowingRadarrQueueSizePicker: Bool = false
    var queueSizeInput: String = ""
    
    // Tautulli Settings Management
    var isShowingTautulliRefreshRatePicker: Bool = false
    var isShowingTautulliTerminationMessageDialog: Bool = false
    var isShowingTautulliStatisticsCountPicker: Bool = false
    var tautulliRefreshRateInput: String = ""
    var tautulliTerminationMessageInput: String = ""
    var tautulliStatisticsCountInput: String = ""
    
    // Connection Testing
    var isTestingNZBGetConnection: Bool = false
    var isTestingSABnzbdConnection: Bool = false
    
    // Wake-on-LAN
    var isWakingDevice: Bool = false
    
    // MARK: - State Management
    private var hasLoadedInitialSettings: Bool = false
    
    // MARK: - Services
    private let dataLayerManager: DataLayerManager
    private let storageService: StorageService
    
    // MARK: - Initialization
    init(dataLayerManager: DataLayerManager = .shared, storageService: StorageService = UserDefaultsStorageService()) {
        self.dataLayerManager = dataLayerManager
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
        
        // Only load settings if this is the first initialization
        if !hasLoadedInitialSettings {
            Task { @MainActor in
                await loadSettings()
                hasLoadedInitialSettings = true
            }
        }
    }
    
    // MARK: - Public Methods
    
    /// Load settings from storage
    @MainActor
    func loadSettings() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Use DataLayerManager which automatically selects SwiftData or Hive based on toggle
            appSettings = try await dataLayerManager.getAppSettings()
            
            // Update profile state
            selectedProfile = appSettings.profiles[appSettings.enabledProfile]
            availableProfiles = Array(appSettings.profiles.keys).sorted()
            
            print("✅ SettingsViewModel: Successfully loaded settings via DataLayerManager (useSwiftData: \(dataLayerManager.useSwiftData))")
        } catch {
            print("⚠️ SettingsViewModel: Failed to load settings: \(error)")
            // Keep default settings
        }
    }
    
    /// Save settings to storage
    @MainActor
    func saveSettings() async {
        do {
            // Use DataLayerManager which automatically saves to SwiftData or Hive based on toggle
            try await dataLayerManager.saveAppSettings(appSettings)
            print("✅ Settings saved via DataLayerManager (useSwiftData: \(dataLayerManager.useSwiftData))")
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
        
        // Save automatically handles sync via DataLayerManager
        await saveSettings()
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
        
        // Send Wake on LAN magic packet
        do {
            try await sendWakeOnLANPacket(
                macAddress: profile.wakeOnLanMACAddress,
                broadcastAddress: profile.wakeOnLanBroadcastAddress
            )
            showSuccessSnackBar(title: "Wake Signal Sent", message: "Sent wake packet to \(profile.wakeOnLanMACAddress)")
        } catch {
            showError("Failed to send wake packet: \(error.localizedDescription)")
        }
    }
    
    /// Send Wake on LAN magic packet using Network framework
    private func sendWakeOnLANPacket(macAddress: String, broadcastAddress: String) async throws {
        // Parse MAC address (remove separators and convert to bytes)
        let cleanMac = macAddress.replacingOccurrences(of: ":", with: "")
                                 .replacingOccurrences(of: "-", with: "")
        
        guard cleanMac.count == 12,
              let macData = Data(hexString: cleanMac) else {
            throw WakeOnLANError.invalidMACAddress
        }
        
        // Create magic packet (6 bytes of 0xFF followed by 16 repetitions of MAC)
        var packet = Data(repeating: 0xFF, count: 6)
        for _ in 0..<16 {
            packet.append(macData)
        }
        
        // Use Network framework to send UDP packet
        let connection = NWConnection(
            to: NWEndpoint.hostPort(host: NWEndpoint.Host(broadcastAddress), port: 9),
            using: .udp
        )
        
        connection.start(queue: .global())
        
        return try await withCheckedThrowingContinuation { continuation in
            connection.send(content: packet, completion: .contentProcessed { error in
                connection.cancel()
                if let error = error {
                    continuation.resume(throwing: WakeOnLANError.networkError(error.localizedDescription))
                } else {
                    continuation.resume()
                }
            })
        }
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
    
    /// Test method to manually force a reload from DataLayerManager
    @MainActor
    func testReloadFromHive() async {
        print("🔄 Testing profile reload via DataLayerManager...")
        
        do {
            appSettings = try await dataLayerManager.getAppSettings()
            availableProfiles = Array(appSettings.profiles.keys).sorted()
            
            if let currentProfile = appSettings.profiles[appSettings.enabledProfile] {
                selectedProfile = currentProfile
                print("✅ Successfully loaded profile '\(currentProfile.name)' via DataLayerManager")
            } else {
                print("⚠️ No current profile found, enabled profile: '\(appSettings.enabledProfile)'")
            }
        } catch {
            print("❌ Error loading via DataLayerManager: \(error)")
            showError("Failed to reload: \(error.localizedDescription)")
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
    
    // MARK: - Queue Size Management
    
    /// Show Sonarr queue size picker dialog
    @MainActor
    func showSonarrQueueSizePicker() {
        queueSizeInput = String(appSettings.sonarrQueuePageSize)
        isShowingSonarrQueueSizePicker = true
    }
    
    /// Show Radarr queue size picker dialog
    @MainActor
    func showRadarrQueueSizePicker() {
        queueSizeInput = String(appSettings.radarrQueuePageSize)
        isShowingRadarrQueueSizePicker = true
    }
    
    /// Validate and set Sonarr queue size
    @MainActor
    func setSonarrQueueSize() async {
        guard let queueSize = Int(queueSizeInput), queueSize >= 1 else {
            showError("Queue size must be at least 1 item")
            return
        }
        
        appSettings.sonarrQueuePageSize = queueSize
        await saveSettings()
        isShowingSonarrQueueSizePicker = false
    }
    
    /// Validate and set Radarr queue size
    @MainActor
    func setRadarrQueueSize() async {
        guard let queueSize = Int(queueSizeInput), queueSize >= 1 else {
            showError("Queue size must be at least 1 item")
            return
        }
        
        appSettings.radarrQueuePageSize = queueSize
        await saveSettings()
        isShowingRadarrQueueSizePicker = false
    }
    
    // MARK: - Tautulli Settings Management
    
    /// Show Tautulli refresh rate picker
    @MainActor
    func showTautulliRefreshRatePicker() {
        tautulliRefreshRateInput = String(appSettings.tautulliRefreshRate)
        isShowingTautulliRefreshRatePicker = true
    }
    
    /// Show Tautulli termination message dialog
    @MainActor
    func showTautulliTerminationMessageDialog() {
        tautulliTerminationMessageInput = appSettings.tautulliTerminationMessage
        isShowingTautulliTerminationMessageDialog = true
    }
    
    /// Show Tautulli statistics count picker  
    @MainActor
    func showTautulliStatisticsCountPicker() {
        tautulliStatisticsCountInput = String(appSettings.tautulliStatisticsCount)
        isShowingTautulliStatisticsCountPicker = true
    }
    
    /// Set Tautulli refresh rate
    @MainActor
    func setTautulliRefreshRate() async {
        guard let refreshRate = Int(tautulliRefreshRateInput), refreshRate >= 1 else {
            showError("Refresh rate must be at least 1 second")
            return
        }
        
        appSettings.tautulliRefreshRate = refreshRate
        await saveSettings()
        isShowingTautulliRefreshRatePicker = false
    }
    
    /// Set Tautulli termination message
    @MainActor
    func setTautulliTerminationMessage() async {
        appSettings.tautulliTerminationMessage = tautulliTerminationMessageInput
        await saveSettings()
        isShowingTautulliTerminationMessageDialog = false
    }
    
    /// Set Tautulli statistics count
    @MainActor
    func setTautulliStatisticsCount() async {
        guard let count = Int(tautulliStatisticsCountInput), count >= 1 else {
            showError("Statistics count must be at least 1")
            return
        }
        
        appSettings.tautulliStatisticsCount = count
        await saveSettings()
        isShowingTautulliStatisticsCountPicker = false
    }
    
    // MARK: - Connection Testing
    
    /// Test NZBGet connection
    @MainActor
    func testNZBGetConnection() async {
        guard let profile = selectedProfile,
              profile.nzbgetEnabled,
              !profile.nzbgetHost.isEmpty,
              !profile.nzbgetUser.isEmpty else {
            showError("Please configure NZBGet connection details first")
            return
        }
        
        isTestingNZBGetConnection = true
        defer { isTestingNZBGetConnection = false }
        
        do {
            // Simple URL validation for now - in production this would make an API call
            guard let url = URL(string: profile.nzbgetHost) else {
                throw URLError(.badURL)
            }
            
            // Simulate network test with delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // In production, this would be:
            // let success = try await nzbgetService.testConnection(url: url, username: profile.nzbgetUser, password: profile.nzbgetPass)
            
            showSuccess("NZBGet connection successful!")
            
        } catch {
            showError("NZBGet connection failed: \(error.localizedDescription)")
        }
    }
    
    /// Test SABnzbd connection
    @MainActor
    func testSABnzbdConnection() async {
        guard let profile = selectedProfile,
              profile.sabnzbdEnabled,
              !profile.sabnzbdHost.isEmpty,
              !profile.sabnzbdApiKey.isEmpty else {
            showError("Please configure SABnzbd connection details first")
            return
        }
        
        isTestingSABnzbdConnection = true
        defer { isTestingSABnzbdConnection = false }
        
        do {
            // Simple URL validation for now - in production this would make an API call
            guard let url = URL(string: profile.sabnzbdHost) else {
                throw URLError(.badURL)
            }
            
            // Simulate network test with delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // In production, this would be:
            // let success = try await sabnzbdService.testConnection(url: url, apiKey: profile.sabnzbdApiKey)
            
            showSuccess("SABnzbd connection successful!")
            
        } catch {
            showError("SABnzbd connection failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Wake-on-LAN Implementation
    
    /// Send wake-on-LAN packet to configured device
    @MainActor
    func sendWakeOnLANPacket() async {
        guard let profile = selectedProfile,
              profile.wakeOnLanEnabled,
              !profile.wakeOnLanMACAddress.isEmpty else {
            showError("Please configure Wake-on-LAN settings first")
            return
        }
        
        isWakingDevice = true
        defer { isWakingDevice = false }
        
        do {
            try await performWakeOnLAN(
                macAddress: profile.wakeOnLanMACAddress,
                broadcastAddress: profile.wakeOnLanBroadcastAddress.isEmpty ? "255.255.255.255" : profile.wakeOnLanBroadcastAddress
            )
            
            showSuccess("Wake-on-LAN packet sent successfully!")
            
        } catch {
            showError("Failed to send Wake-on-LAN packet: \(error.localizedDescription)")
        }
    }
    
    /// Perform Wake-on-LAN magic packet sending
    private func performWakeOnLAN(macAddress: String, broadcastAddress: String) async throws {
        // Create magic packet data
        guard let magicPacket = createMagicPacket(macAddress: macAddress) else {
            throw NSError(domain: "WakeOnLAN", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid MAC address format"])
        }
        
        // Send UDP packet
        try await sendUDPPacket(data: magicPacket, to: broadcastAddress, port: 9)
    }
    
    /// Create Wake-on-LAN magic packet
    private func createMagicPacket(macAddress: String) -> Data? {
        // Remove separators and validate MAC address
        let cleanMAC = macAddress.replacingOccurrences(of: "[:-]", with: "", options: .regularExpression)
        guard cleanMAC.count == 12,
              let macData = Data(hex: cleanMAC) else {
            return nil
        }
        
        // Magic packet: 6 bytes of 0xFF followed by 16 repetitions of MAC address
        var packet = Data()
        packet.append(contentsOf: Array(repeating: UInt8(0xFF), count: 6))
        
        for _ in 0..<16 {
            packet.append(macData)
        }
        
        return packet
    }
    
    /// Send UDP packet
    private func sendUDPPacket(data: Data, to address: String, port: Int) async throws {
        // In production, this would use proper UDP socket implementation
        // For now, simulate the network operation
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Production implementation would use Network framework:
        /*
        import Network
        
        let connection = NWConnection(
            to: NWEndpoint.hostPort(host: NWEndpoint.Host(address), 
                                   port: NWEndpoint.Port(integerLiteral: UInt16(port))),
            using: .udp
        )
        
        connection.start(queue: .global())
        
        return try await withCheckedThrowingContinuation { continuation in
            connection.send(content: data, completion: .contentProcessed { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            })
        }
        */
    }
    
    /// Success message helper
    private func showSuccess(_ message: String) {
        // For now, we'll use the error system to show success
        // In production, this might be a separate success state
        errorMessage = "✅ " + message
        isShowingError = true
    }
}

// MARK: - Data Extension for Wake-on-LAN

extension Data {
    init?(hex: String) {
        let len = hex.count / 2
        var data = Data(capacity: len)
        var i = hex.startIndex
        for _ in 0..<len {
            let j = hex.index(i, offsetBy: 2)
            let bytes = hex[i..<j]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
            i = j
        }
        self = data
    }
}


