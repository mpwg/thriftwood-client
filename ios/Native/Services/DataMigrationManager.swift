//
//  DataMigrationManager.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-01.
//  Manages bidirectional data synchronization between Flutter Hive and SwiftData
//  Implements Phase 4.1 Data Persistence Migration from migration.md
//

import Foundation
import SwiftData
import Flutter

// MARK: - Data Migration Manager

/// Manages bidirectional synchronization between Flutter's Hive storage and SwiftData
///
/// **Responsibilities:**
/// - Sync data from Hive to SwiftData when SwiftUI mode is enabled
/// - Sync data from SwiftData back to Hive to maintain Flutter compatibility
/// - Handle automatic migration when toggle changes
/// - Ensure data consistency across both storage systems
///
/// **Usage:**
/// ```swift
/// let manager = DataMigrationManager(modelContext: context, methodChannel: channel)
/// try await manager.syncFromHive() // Initial sync from Flutter
/// try await manager.syncToHive()   // Sync changes back to Flutter
/// ```
@Observable
class DataMigrationManager {
    private let modelContext: ModelContext
    private let methodChannel: FlutterMethodChannel?
    
    /// Initialize with SwiftData context and Flutter method channel
    init(modelContext: ModelContext, methodChannel: FlutterMethodChannel?) {
        self.modelContext = modelContext
        self.methodChannel = methodChannel
    }
    
    // MARK: - Hive → SwiftData Migration
    
    /// Sync all data from Flutter's Hive storage to SwiftData
    /// Called when user enables SwiftUI mode or on first launch with SwiftUI enabled
    func syncFromHive() async throws {
        guard let methodChannel = methodChannel else {
            throw DataMigrationError.channelNotInitialized
        }
        
        // Get all settings from Hive
        let hiveData = try await getHiveSettings()
        
        // Sync app settings
        try await syncAppSettingsFromHive(hiveData)
        
        // Sync all profiles
        try await syncProfilesFromHive(hiveData)
        
        // Save all changes
        try modelContext.save()
        
        print("✅ DataMigrationManager: Successfully synced all data from Hive to SwiftData")
    }
    
    /// Get settings from Hive via method channel
    private func getHiveSettings() async throws -> [String: Any] {
        guard let methodChannel = methodChannel else {
            throw DataMigrationError.channelNotInitialized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel.invokeMethod("getHiveSettings", arguments: nil) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: DataMigrationError.flutterError(
                            "Failed to get Hive settings: \(error.message ?? "Unknown error")"
                        ))
                    } else if let settings = result as? [String: Any] {
                        continuation.resume(returning: settings)
                    } else {
                        continuation.resume(throwing: DataMigrationError.invalidData(
                            "Unexpected result type from getHiveSettings"
                        ))
                    }
                }
            }
        }
    }
    
    /// Sync app settings from Hive data
    private func syncAppSettingsFromHive(_ hiveData: [String: Any]) async throws {
        // Check if app settings already exist in SwiftData
        let descriptor = FetchDescriptor<AppSettingsSwiftData>()
        let existingSettings = try modelContext.fetch(descriptor)
        
        let appSettings: AppSettingsSwiftData
        if let existing = existingSettings.first {
            appSettings = existing
        } else {
            appSettings = AppSettingsSwiftData()
            modelContext.insert(appSettings)
        }
        
        // Update from Hive data
        if let enabledProfile = hiveData["enabledProfile"] as? String {
            appSettings.enabledProfile = enabledProfile
        }
        
        if let drawerAutoExpand = hiveData["drawerAutoExpand"] as? Bool {
            appSettings.drawerAutomaticManage = drawerAutoExpand
        }
        
        // Quick actions
        if let quickActionsData = hiveData["quickActionItems"] as? [[String: Any]] {
            // Parse quick actions and set flags accordingly
            appSettings.quickActionsLidarr = quickActionsData.contains { ($0["module"] as? String) == "lidarr" }
            appSettings.quickActionsRadarr = quickActionsData.contains { ($0["module"] as? String) == "radarr" }
            appSettings.quickActionsSonarr = quickActionsData.contains { ($0["module"] as? String) == "sonarr" }
        }
        
        if let use24Hour = hiveData["use24HourTime"] as? Bool {
            appSettings.use24HourTime = use24Hour
        }
        
        if let enableNotifications = hiveData["enableInAppNotifications"] as? Bool {
            appSettings.enableInAppNotifications = enableNotifications
        }
        
        print("✅ DataMigrationManager: Synced app settings from Hive")
    }
    
    /// Sync all profiles from Hive data
    private func syncProfilesFromHive(_ hiveData: [String: Any]) async throws {
        guard let profilesDict = hiveData["profiles"] as? [String: [String: Any]] else {
            print("⚠️ DataMigrationManager: No profiles found in Hive data")
            return
        }
        
        // Get existing profiles in SwiftData
        let descriptor = FetchDescriptor<ProfileSwiftData>()
        let existingProfiles = try modelContext.fetch(descriptor)
        let existingProfilesByName = Dictionary(uniqueKeysWithValues: existingProfiles.map { ($0.name, $0) })
        
        // Sync each profile
        for (profileName, profileData) in profilesDict {
            let profile: ProfileSwiftData
            if let existing = existingProfilesByName[profileName] {
                profile = existing
            } else {
                profile = ProfileSwiftData(name: profileName)
                modelContext.insert(profile)
            }
            
            // Update profile fields from Hive data
            updateProfileFromHiveData(profile, data: profileData)
        }
        
        print("✅ DataMigrationManager: Synced \(profilesDict.count) profiles from Hive")
    }
    
    /// Update a profile from Hive data dictionary
    private func updateProfileFromHiveData(_ profile: ProfileSwiftData, data: [String: Any]) {
        // Lidarr
        if let enabled = data["lidarrEnabled"] as? Bool {
            profile.lidarrEnabled = enabled
        }
        if let host = data["lidarrHost"] as? String {
            profile.lidarrHost = host
        }
        if let apiKey = data["lidarrApiKey"] as? String {
            profile.lidarrApiKey = apiKey
        }
        
        // Radarr
        if let enabled = data["radarrEnabled"] as? Bool {
            profile.radarrEnabled = enabled
        }
        if let host = data["radarrHost"] as? String {
            profile.radarrHost = host
        }
        if let apiKey = data["radarrApiKey"] as? String {
            profile.radarrApiKey = apiKey
        }
        
        // Sonarr
        if let enabled = data["sonarrEnabled"] as? Bool {
            profile.sonarrEnabled = enabled
        }
        if let host = data["sonarrHost"] as? String {
            profile.sonarrHost = host
        }
        if let apiKey = data["sonarrApiKey"] as? String {
            profile.sonarrApiKey = apiKey
        }
        
        // SABnzbd
        if let enabled = data["sabnzbdEnabled"] as? Bool {
            profile.sabnzbdEnabled = enabled
        }
        if let host = data["sabnzbdHost"] as? String {
            profile.sabnzbdHost = host
        }
        if let apiKey = data["sabnzbdApiKey"] as? String {
            profile.sabnzbdApiKey = apiKey
        }
        
        // NZBGet
        if let enabled = data["nzbgetEnabled"] as? Bool {
            profile.nzbgetEnabled = enabled
        }
        if let host = data["nzbgetHost"] as? String {
            profile.nzbgetHost = host
        }
        if let user = data["nzbgetUser"] as? String {
            profile.nzbgetUser = user
        }
        if let pass = data["nzbgetPass"] as? String {
            profile.nzbgetPass = pass
        }
        
        // Tautulli
        if let enabled = data["tautulliEnabled"] as? Bool {
            profile.tautulliEnabled = enabled
        }
        if let host = data["tautulliHost"] as? String {
            profile.tautulliHost = host
        }
        if let apiKey = data["tautulliApiKey"] as? String {
            profile.tautulliApiKey = apiKey
        }
        
        // Overseerr
        if let enabled = data["overseerrEnabled"] as? Bool {
            profile.overseerrEnabled = enabled
        }
        if let host = data["overseerrHost"] as? String {
            profile.overseerrHost = host
        }
        if let apiKey = data["overseerrApiKey"] as? String {
            profile.overseerrApiKey = apiKey
        }
        
        // Wake on LAN
        if let enabled = data["wakeOnLanEnabled"] as? Bool {
            profile.wakeOnLanEnabled = enabled
        }
        if let mac = data["wakeOnLanMACAddress"] as? String {
            profile.wakeOnLanMACAddress = mac
        }
        if let broadcast = data["wakeOnLanBroadcastAddress"] as? String {
            profile.wakeOnLanBroadcastAddress = broadcast
        }
    }
    
    // MARK: - SwiftData → Hive Migration
    
    /// Sync all SwiftData changes back to Flutter's Hive storage
    /// Called whenever data is modified in SwiftUI mode
    func syncToHive() async throws {
        guard let methodChannel = methodChannel else {
            throw DataMigrationError.channelNotInitialized
        }
        
        // Get all data from SwiftData
        let appSettings = try await getAppSettings()
        let profiles = try await getAllProfiles()
        
        // Convert to Hive format
        let hiveData = try buildHiveDataDictionary(appSettings: appSettings, profiles: profiles)
        
        // Send to Flutter via method channel
        try await updateHiveSettings(hiveData)
        
        print("✅ DataMigrationManager: Successfully synced all data from SwiftData to Hive")
    }
    
    /// Get app settings from SwiftData
    private func getAppSettings() async throws -> AppSettingsSwiftData {
        let descriptor = FetchDescriptor<AppSettingsSwiftData>()
        let settings = try modelContext.fetch(descriptor)
        
        guard let appSettings = settings.first else {
            throw DataMigrationError.noData("No app settings found in SwiftData")
        }
        
        return appSettings
    }
    
    /// Get all profiles from SwiftData
    private func getAllProfiles() async throws -> [ProfileSwiftData] {
        let descriptor = FetchDescriptor<ProfileSwiftData>()
        return try modelContext.fetch(descriptor)
    }
    
    /// Build Hive data dictionary from SwiftData models
    private func buildHiveDataDictionary(
        appSettings: AppSettingsSwiftData,
        profiles: [ProfileSwiftData]
    ) throws -> [String: Any] {
        var hiveData: [String: Any] = [:]
        
        // App settings
        hiveData["enabledProfile"] = appSettings.enabledProfile
        hiveData["drawerAutoExpand"] = appSettings.drawerAutomaticManage
        hiveData["use24HourTime"] = appSettings.use24HourTime
        hiveData["enableInAppNotifications"] = appSettings.enableInAppNotifications
        
        // Profiles
        var profilesDict: [String: [String: Any]] = [:]
        for profile in profiles {
            profilesDict[profile.name] = try buildProfileDictionary(profile)
        }
        hiveData["profiles"] = profilesDict
        
        return hiveData
    }
    
    /// Build profile dictionary from SwiftData model
    private func buildProfileDictionary(_ profile: ProfileSwiftData) throws -> [String: Any] {
        var profileDict: [String: Any] = [:]
        
        // Lidarr
        profileDict["lidarrEnabled"] = profile.lidarrEnabled
        profileDict["lidarrHost"] = profile.lidarrHost
        profileDict["lidarrApiKey"] = profile.lidarrApiKey
        
        // Radarr
        profileDict["radarrEnabled"] = profile.radarrEnabled
        profileDict["radarrHost"] = profile.radarrHost
        profileDict["radarrApiKey"] = profile.radarrApiKey
        
        // Sonarr
        profileDict["sonarrEnabled"] = profile.sonarrEnabled
        profileDict["sonarrHost"] = profile.sonarrHost
        profileDict["sonarrApiKey"] = profile.sonarrApiKey
        
        // SABnzbd
        profileDict["sabnzbdEnabled"] = profile.sabnzbdEnabled
        profileDict["sabnzbdHost"] = profile.sabnzbdHost
        profileDict["sabnzbdApiKey"] = profile.sabnzbdApiKey
        
        // NZBGet
        profileDict["nzbgetEnabled"] = profile.nzbgetEnabled
        profileDict["nzbgetHost"] = profile.nzbgetHost
        profileDict["nzbgetUser"] = profile.nzbgetUser
        profileDict["nzbgetPass"] = profile.nzbgetPass
        
        // Tautulli
        profileDict["tautulliEnabled"] = profile.tautulliEnabled
        profileDict["tautulliHost"] = profile.tautulliHost
        profileDict["tautulliApiKey"] = profile.tautulliApiKey
        
        // Overseerr
        profileDict["overseerrEnabled"] = profile.overseerrEnabled
        profileDict["overseerrHost"] = profile.overseerrHost
        profileDict["overseerrApiKey"] = profile.overseerrApiKey
        
        // Wake on LAN
        profileDict["wakeOnLanEnabled"] = profile.wakeOnLanEnabled
        profileDict["wakeOnLanMACAddress"] = profile.wakeOnLanMACAddress
        profileDict["wakeOnLanBroadcastAddress"] = profile.wakeOnLanBroadcastAddress
        
        return profileDict
    }
    
    /// Update Hive settings via method channel
    private func updateHiveSettings(_ settings: [String: Any]) async throws {
        guard let methodChannel = methodChannel else {
            throw DataMigrationError.channelNotInitialized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel.invokeMethod("updateHiveSettings", arguments: [
                    "settings": settings
                ]) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: DataMigrationError.flutterError(
                            "Failed to update Hive settings: \(error.message ?? "Unknown error")"
                        ))
                    } else {
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    // MARK: - Individual Sync Methods
    
    /// Sync a single profile to Hive
    func syncProfileToHive(_ profile: ProfileSwiftData) async throws {
        guard let methodChannel = methodChannel else {
            throw DataMigrationError.channelNotInitialized
        }
        
        let profileDict = try buildProfileDictionary(profile)
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel.invokeMethod("updateHiveProfile", arguments: [
                    "profileName": profile.name,
                    "profile": profileDict
                ]) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: DataMigrationError.flutterError(
                            "Failed to sync profile to Hive: \(error.message ?? "Unknown error")"
                        ))
                    } else {
                        continuation.resume()
                    }
                }
            }
        }
    }
}

// MARK: - Error Types

enum DataMigrationError: LocalizedError {
    case channelNotInitialized
    case flutterError(String)
    case invalidData(String)
    case noData(String)
    
    var errorDescription: String? {
        switch self {
        case .channelNotInitialized:
            return "Flutter method channel not initialized"
        case .flutterError(let message):
            return "Flutter error: \(message)"
        case .invalidData(let message):
            return "Invalid data: \(message)"
        case .noData(let message):
            return "No data found: \(message)"
        }
    }
}
