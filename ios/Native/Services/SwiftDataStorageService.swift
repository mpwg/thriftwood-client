//
//  SwiftDataStorageService.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-01
//  SwiftData-based storage service for permanent SwiftUI architecture
//

import Foundation
import SwiftData

/// SwiftData-based storage service for permanent SwiftUI architecture
/// Accesses ProfileSwiftData and AppSettingsSwiftData models
/// This replaces SharedDataManager for pure SwiftUI services
class SwiftDataStorageService {
    static let shared = SwiftDataStorageService()
    
    private var modelContext: ModelContext?
    
    private init() {}
    
    /// Initialize with SwiftData model context
    @MainActor
    func initialize(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Profile Data Access
    
    /// Get current active profile
    func getCurrentProfile() throws -> ProfileSwiftData? {
        guard let context = modelContext else {
            throw SwiftDataStorageError.contextNotInitialized
        }
        
        // First get the active profile name from settings
        let settings = try getCurrentSettings()
        let activeProfileName = settings?.enabledProfile ?? "default"
        
        // Find the profile with that name
        let descriptor = FetchDescriptor<ProfileSwiftData>(
            predicate: #Predicate { $0.name == activeProfileName }
        )
        
        return try context.fetch(descriptor).first
    }
    
    /// Get app settings
    func getCurrentSettings() throws -> AppSettingsSwiftData? {
        guard let context = modelContext else {
            throw SwiftDataStorageError.contextNotInitialized
        }
        
        let descriptor = FetchDescriptor<AppSettingsSwiftData>()
        return try context.fetch(descriptor).first
    }
    
    // MARK: - Service Configuration Access
    
    /// Check if a service is enabled in the current profile
    func isServiceEnabled(_ service: ServiceType) throws -> Bool {
        guard let profile = try getCurrentProfile() else { return false }
        
        switch service {
        case .lidarr:
            return profile.lidarrEnabled
        case .radarr:
            return profile.radarrEnabled
        case .sonarr:
            return profile.sonarrEnabled
        case .sabnzbd:
            return profile.sabnzbdEnabled
        case .nzbget:
            return profile.nzbgetEnabled
        case .overseerr:
            return profile.overseerrEnabled
        case .tautulli:
            return profile.tautulliEnabled
        }
    }
    
    /// Get service configuration for API calls
    func getServiceConfig(_ service: ServiceType) throws -> ServiceConfig? {
        guard let profile = try getCurrentProfile() else { return nil }
        
        switch service {
        case .lidarr:
            guard profile.lidarrEnabled else { return nil }
            return ServiceConfig(
                host: profile.lidarrHost,
                apiKey: profile.lidarrApiKey,
                strictTLS: profile.lidarrStrictTLS
            )
        case .radarr:
            guard profile.radarrEnabled else { return nil }
            return ServiceConfig(
                host: profile.radarrHost,
                apiKey: profile.radarrApiKey,
                strictTLS: profile.radarrStrictTLS
            )
        case .sonarr:
            guard profile.sonarrEnabled else { return nil }
            return ServiceConfig(
                host: profile.sonarrHost,
                apiKey: profile.sonarrApiKey,
                strictTLS: profile.sonarrStrictTLS
            )
        case .sabnzbd:
            guard profile.sabnzbdEnabled else { return nil }
            return ServiceConfig(
                host: profile.sabnzbdHost,
                apiKey: profile.sabnzbdApiKey,
                strictTLS: profile.sabnzbdStrictTLS
            )
        case .nzbget:
            guard profile.nzbgetEnabled else { return nil }
            return ServiceConfig(
                host: profile.nzbgetHost,
                apiKey: profile.nzbgetUser, // NZBGet uses username as API key
                strictTLS: profile.nzbgetStrictTLS
            )
        case .overseerr:
            guard profile.overseerrEnabled else { return nil }
            return ServiceConfig(
                host: profile.overseerrHost,
                apiKey: profile.overseerrApiKey,
                strictTLS: profile.overseerrStrictTLS
            )
        case .tautulli:
            guard profile.tautulliEnabled else { return nil }
            return ServiceConfig(
                host: profile.tautulliHost,
                apiKey: profile.tautulliApiKey,
                strictTLS: profile.tautulliStrictTLS
            )
        }
    }
    
    // MARK: - Dashboard Calendar Settings
    
    /// Check if service is enabled for dashboard calendar
    /// Note: Calendar preferences are not yet in SwiftData model, defaulting to true
    func isCalendarServiceEnabled(_ service: ServiceType) throws -> Bool {
        // TODO: Add calendar settings to AppSettingsSwiftData model
        // For now, return true if service is enabled (calendar follows service enablement)
        return try isServiceEnabled(service)
    }
}

// MARK: - Supporting Types

enum SwiftDataStorageError: LocalizedError {
    case contextNotInitialized
    case profileNotFound
    case settingsNotFound
    
    var errorDescription: String? {
        switch self {
        case .contextNotInitialized:
            return "SwiftData model context not initialized"
        case .profileNotFound:
            return "Active profile not found"
        case .settingsNotFound:
            return "App settings not found"
        }
    }
}

enum ServiceType {
    case lidarr
    case radarr
    case sonarr
    case sabnzbd
    case nzbget
    case overseerr
    case tautulli
}

struct ServiceConfig {
    let host: String
    let apiKey: String
    let strictTLS: Bool
}