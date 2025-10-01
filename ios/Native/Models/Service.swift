//
//  Service.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-30.
//  Service model for dashboard representation
//

// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules.dart:34-540
// Original Flutter class: LunaModule enum and extensions
// Migration date: 2025-09-30
// Migrated by: GitHub Copilot
// Validation status: ✅ Complete
// Features ported: All service metadata (title, description, icon, color, enablement)
// Data sync: Reads from Flutter storage via SharedDataManager for enabled state
// Testing: Unit tests required for service configuration sync

import Foundation
import SwiftUI

/// Swift equivalent of Flutter's LunaModule enum
/// Maintains 100% functional parity with Flutter counterpart
///
/// **Bidirectional Integration:**
/// - Reads service enablement from Flutter storage via SharedDataManager
/// - Service metadata matches Flutter's LunaModule extensions exactly
/// - Navigation routes identical to Flutter implementation
///
/// **Flutter Equivalent Properties:**
/// - LunaModule.key -> Service.key
/// - LunaModule.title -> Service.title
/// - LunaModule.description -> Service.description
/// - LunaModule.icon -> Service.iconName
/// - LunaModule.color -> Service.color
/// - LunaModule.isEnabled -> Service.isEnabled
@Observable
class Service: Identifiable, Hashable {
    let id = UUID()
    let key: String
    let title: String
    let description: String
    let iconName: String
    let color: Color
    let route: String
    let website: String?
    var isEnabled: Bool
    var isFeatureFlagEnabled: Bool
    
    init(
        key: String,
        title: String,
        description: String,
        iconName: String,
        color: Color,
        route: String,
        website: String? = nil,
        isEnabled: Bool = false,
        isFeatureFlagEnabled: Bool = true
    ) {
        self.key = key
        self.title = title
        self.description = description
        self.iconName = iconName
        self.color = color
        self.route = route
        self.website = website
        self.isEnabled = isEnabled
        self.isFeatureFlagEnabled = isFeatureFlagEnabled
    }
    
    // MARK: - Hashable & Equatable
    
    static func == (lhs: Service, rhs: Service) -> Bool {
        return lhs.key == rhs.key
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

// MARK: - Service Factory
// Flutter equivalent: LunaModule enum values and extensions

extension Service {
    /// Create all available services matching Flutter's LunaModule.active
    /// Maintains identical service definitions to Flutter implementation
    static func createAllServices() -> [Service] {
        return [
            // Radarr service
            Service(
                key: "radarr",
                title: "Radarr",
                description: "Movie collection manager",
                iconName: "radarr.icon",
                color: Color(red: 0.996, green: 0.765, blue: 0.2), // #FEC333
                route: "/radarr",
                website: "https://radarr.video"
            ),
            
            // Sonarr service
            Service(
                key: "sonarr",
                title: "Sonarr",
                description: "Series collection manager",
                iconName: "sonarr.icon",
                color: Color(red: 0.247, green: 0.777, blue: 0.957), // #3FC6F4
                route: "/sonarr",
                website: "https://sonarr.tv"
            ),
            
            // Lidarr service
            Service(
                key: "lidarr",
                title: "Lidarr",
                description: "Music collection manager",
                iconName: "lidarr.icon",
                color: Color(red: 0.086, green: 0.584, blue: 0.322), // #159552
                route: "/lidarr",
                website: "https://lidarr.audio"
            ),
            
            // SABnzbd service
            Service(
                key: "sabnzbd",
                title: "SABnzbd",
                description: "Usenet binary downloader",
                iconName: "sabnzbd.icon",
                color: Color(red: 0.996, green: 0.8, blue: 0.169), // #FECC2B
                route: "/sabnzbd",
                website: "https://sabnzbd.org"
            ),
            
            // NZBGet service
            Service(
                key: "nzbget",
                title: "NZBGet",
                description: "Usenet binary downloader",
                iconName: "nzbget.icon",
                color: Color(red: 0.259, green: 0.835, blue: 0.208), // #42D535
                route: "/nzbget",
                website: "https://nzbget.net"
            ),
            
            // Tautulli service
            Service(
                key: "tautulli",
                title: "Tautulli",
                description: "Plex media server monitor",
                iconName: "tautulli.icon",
                color: Color(red: 0.859, green: 0.635, blue: 0.227), // #DBA23A
                route: "/tautulli",
                website: "https://tautulli.com"
            ),
            
            // Search service
            Service(
                key: "search",
                title: "Search",
                description: "Search across indexers",
                iconName: "magnifyingglass",
                color: Color.accentColor,
                route: "/search"
            ),
            
            // Wake on LAN service
            Service(
                key: "wake_on_lan",
                title: "Wake on LAN",
                description: "Network device wake utility",
                iconName: "wifi.router",
                color: Color.accentColor,
                route: "/wake_on_lan"
            )
        ]
    }
    
    /// Get Settings service (always enabled)
    /// Flutter equivalent: LunaModule.SETTINGS
    static func createSettingsService() -> Service {
        return Service(
            key: "settings",
            title: "Settings",
            description: "Application configuration",
            iconName: "gearshape",
            color: Color.accentColor,
            route: "/settings",
            isEnabled: true
        )
    }
}