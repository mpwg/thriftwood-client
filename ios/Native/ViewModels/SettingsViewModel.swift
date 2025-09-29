//
//  SettingsViewModel.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  MVVM ViewModels for Settings using @Observable pattern
//

import Foundation
import SwiftUI

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
    
    private func syncWithHiveStorage() async {
        // Sync settings with Flutter's Hive storage
        await dataManager.syncSettings(appSettings)
    }
    
    private func notifyFlutterOfProfileChange(_ profileName: String) async {
        // Notify Flutter of profile change through the bridge
        await dataManager.notifyProfileChange(profileName)
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
        // TODO: Implement actual connection testing
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network call
        
        isLoading = false
        
        // Simulate success/failure based on whether host and API key are provided
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