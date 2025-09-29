//
//  ThriftwoodProfile.swift
//  Thriftwood
//
//  SwiftData profile model for multi-configuration support
//

import Foundation
import SwiftData

/// Profile model matching Flutter's LunaProfile system
@Model
final class ThriftwoodProfile {
    
    // MARK: - Profile Information
    
    @Attribute(.unique) var name: String
    var isDefault: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    // MARK: - Radarr Configuration
    
    var radarrEnabled: Bool = false
    var radarrHost: String = ""
    var radarrApiKey: String = ""
    var radarrHeaders: [String: String] = [:]
    var radarrPort: Int = 7878
    var radarrUseSSL: Bool = false
    
    // MARK: - Sonarr Configuration
    
    var sonarrEnabled: Bool = false
    var sonarrHost: String = ""
    var sonarrApiKey: String = ""
    var sonarrHeaders: [String: String] = [:]
    var sonarrPort: Int = 8989
    var sonarrUseSSL: Bool = false
    
    // MARK: - Lidarr Configuration
    
    var lidarrEnabled: Bool = false
    var lidarrHost: String = ""
    var lidarrApiKey: String = ""
    var lidarrHeaders: [String: String] = [:]
    var lidarrPort: Int = 8686
    var lidarrUseSSL: Bool = false
    
    // MARK: - NZBGet Configuration
    
    var nzbgetEnabled: Bool = false
    var nzbgetHost: String = ""
    var nzbgetUsername: String = ""
    var nzbgetPassword: String = ""
    var nzbgetHeaders: [String: String] = [:]
    var nzbgetPort: Int = 6789
    var nzbgetUseSSL: Bool = false
    
    // MARK: - SABnzbd Configuration
    
    var sabnzbdEnabled: Bool = false
    var sabnzbdHost: String = ""
    var sabnzbdApiKey: String = ""
    var sabnzbdHeaders: [String: String] = [:]
    var sabnzbdPort: Int = 8080
    var sabnzbdUseSSL: Bool = false
    
    // MARK: - Tautulli Configuration
    
    var tautulliEnabled: Bool = false
    var tautulliHost: String = ""
    var tautulliApiKey: String = ""
    var tautulliHeaders: [String: String] = [:]
    var tautulliPort: Int = 8181
    var tautulliUseSSL: Bool = false
    
    // MARK: - Search Configuration
    
    var searchEnabled: Bool = false
    var indexers: [String] = []
    
    // MARK: - Wake-on-LAN Configuration
    
    var wakeOnLANEnabled: Bool = false
    var wakeOnLANMacAddress: String = ""
    var wakeOnLANBroadcastAddress: String = ""
    
    // MARK: - Initialization
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // MARK: - Computed Properties
    
    /// Number of enabled services
    var enabledServicesCount: Int {
        var count = 0
        if radarrEnabled { count += 1 }
        if sonarrEnabled { count += 1 }
        if lidarrEnabled { count += 1 }
        if nzbgetEnabled { count += 1 }
        if sabnzbdEnabled { count += 1 }
        if tautulliEnabled { count += 1 }
        if searchEnabled { count += 1 }
        if wakeOnLANEnabled { count += 1 }
        return count
    }
    
    /// Check if profile has any configured services
    var hasConfiguredServices: Bool {
        return enabledServicesCount > 0
    }
    
    // MARK: - Service URL Builders
    
    func radarrURL() -> URL? {
        guard radarrEnabled, !radarrHost.isEmpty else { return nil }
        let scheme = radarrUseSSL ? "https" : "http"
        return URL(string: "\(scheme)://\(radarrHost):\(radarrPort)")
    }
    
    func sonarrURL() -> URL? {
        guard sonarrEnabled, !sonarrHost.isEmpty else { return nil }
        let scheme = sonarrUseSSL ? "https" : "http"
        return URL(string: "\(scheme)://\(sonarrHost):\(sonarrPort)")
    }
    
    func lidarrURL() -> URL? {
        guard lidarrEnabled, !lidarrHost.isEmpty else { return nil }
        let scheme = lidarrUseSSL ? "https" : "http"
        return URL(string: "\(scheme)://\(lidarrHost):\(lidarrPort)")
    }
    
    func nzbgetURL() -> URL? {
        guard nzbgetEnabled, !nzbgetHost.isEmpty else { return nil }
        let scheme = nzbgetUseSSL ? "https" : "http"
        return URL(string: "\(scheme)://\(nzbgetHost):\(nzbgetPort)")
    }
    
    func sabnzbdURL() -> URL? {
        guard sabnzbdEnabled, !sabnzbdHost.isEmpty else { return nil }
        let scheme = sabnzbdUseSSL ? "https" : "http"
        return URL(string: "\(scheme)://\(sabnzbdHost):\(sabnzbdPort)")
    }
    
    func tautulliURL() -> URL? {
        guard tautulliEnabled, !tautulliHost.isEmpty else { return nil }
        let scheme = tautulliUseSSL ? "https" : "http"
        return URL(string: "\(scheme)://\(tautulliHost):\(tautulliPort)")
    }
    
    // MARK: - Validation
    
    /// Validate service configuration
    func validateService(_ service: ServiceType) -> ValidationResult {
        switch service {
        case .radarr:
            return validateRadarr()
        case .sonarr:
            return validateSonarr()
        case .lidarr:
            return validateLidarr()
        case .nzbget:
            return validateNZBGet()
        case .sabnzbd:
            return validateSABnzbd()
        case .tautulli:
            return validateTautulli()
        }
    }
    
    private func validateRadarr() -> ValidationResult {
        guard radarrEnabled else { return .disabled }
        guard !radarrHost.isEmpty else { return .invalid("Host is required") }
        guard !radarrApiKey.isEmpty else { return .invalid("API key is required") }
        guard radarrURL() != nil else { return .invalid("Invalid URL configuration") }
        return .valid
    }
    
    private func validateSonarr() -> ValidationResult {
        guard sonarrEnabled else { return .disabled }
        guard !sonarrHost.isEmpty else { return .invalid("Host is required") }
        guard !sonarrApiKey.isEmpty else { return .invalid("API key is required") }
        guard sonarrURL() != nil else { return .invalid("Invalid URL configuration") }
        return .valid
    }
    
    private func validateLidarr() -> ValidationResult {
        guard lidarrEnabled else { return .disabled }
        guard !lidarrHost.isEmpty else { return .invalid("Host is required") }
        guard !lidarrApiKey.isEmpty else { return .invalid("API key is required") }
        guard lidarrURL() != nil else { return .invalid("Invalid URL configuration") }
        return .valid
    }
    
    private func validateNZBGet() -> ValidationResult {
        guard nzbgetEnabled else { return .disabled }
        guard !nzbgetHost.isEmpty else { return .invalid("Host is required") }
        guard !nzbgetUsername.isEmpty else { return .invalid("Username is required") }
        guard !nzbgetPassword.isEmpty else { return .invalid("Password is required") }
        guard nzbgetURL() != nil else { return .invalid("Invalid URL configuration") }
        return .valid
    }
    
    private func validateSABnzbd() -> ValidationResult {
        guard sabnzbdEnabled else { return .disabled }
        guard !sabnzbdHost.isEmpty else { return .invalid("Host is required") }
        guard !sabnzbdApiKey.isEmpty else { return .invalid("API key is required") }
        guard sabnzbdURL() != nil else { return .invalid("Invalid URL configuration") }
        return .valid
    }
    
    private func validateTautulli() -> ValidationResult {
        guard tautulliEnabled else { return .disabled }
        guard !tautulliHost.isEmpty else { return .invalid("Host is required") }
        guard !tautulliApiKey.isEmpty else { return .invalid("API key is required") }
        guard tautulliURL() != nil else { return .invalid("Invalid URL configuration") }
        return .valid
    }
    
    // MARK: - Updates
    
    /// Mark profile as updated
    func markAsUpdated() {
        updatedAt = Date()
    }
}

// MARK: - Supporting Types

enum ServiceType: String, CaseIterable, Sendable {
    case radarr = "radarr"
    case sonarr = "sonarr"
    case lidarr = "lidarr"
    case nzbget = "nzbget"
    case sabnzbd = "sabnzbd"
    case tautulli = "tautulli"
    
    var displayName: String {
        switch self {
        case .radarr: return "Radarr"
        case .sonarr: return "Sonarr"
        case .lidarr: return "Lidarr"
        case .nzbget: return "NZBGet"
        case .sabnzbd: return "SABnzbd"
        case .tautulli: return "Tautulli"
        }
    }
    
    var iconName: String {
        switch self {
        case .radarr: return "film"
        case .sonarr: return "tv"
        case .lidarr: return "music.note"
        case .nzbget, .sabnzbd: return "arrow.down.circle"
        case .tautulli: return "chart.bar"
        }
    }
}

enum ValidationResult: Sendable {
    case valid
    case invalid(String)
    case disabled
    
    var isValid: Bool {
        switch self {
        case .valid: return true
        case .invalid, .disabled: return false
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .valid, .disabled: return nil
        case .invalid(let message): return message
        }
    }
}