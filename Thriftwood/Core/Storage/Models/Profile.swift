//
//  Profile.swift
//  Thriftwood
//
//  SwiftData model for user profiles
//  Replaces Flutter/Hive LunaProfile
//

import Foundation
import SwiftData

/// A profile contains all service configurations and acts as a container for multi-instance support.
/// Users can create multiple profiles to manage different sets of services.
@Model
final class Profile {
    /// Unique identifier for the profile
    @Attribute(.unique) var id: UUID
    
    /// Human-readable profile name (e.g., "Home", "Remote", "Work")
    var name: String
    
    /// Whether this profile is currently active/selected
    var isEnabled: Bool
    
    /// Timestamp when the profile was created
    var createdAt: Date
    
    /// Timestamp when the profile was last modified
    var updatedAt: Date
    
    // MARK: - Service Configurations (One-to-One Relationships)
    
    /// Radarr (movie management) configuration
    @Relationship(deleteRule: .cascade, inverse: \RadarrConfiguration.profile)
    var radarrConfiguration: RadarrConfiguration?
    
    /// Sonarr (TV show management) configuration
    @Relationship(deleteRule: .cascade, inverse: \SonarrConfiguration.profile)
    var sonarrConfiguration: SonarrConfiguration?
    
    /// Lidarr (music management) configuration
    @Relationship(deleteRule: .cascade, inverse: \LidarrConfiguration.profile)
    var lidarrConfiguration: LidarrConfiguration?
    
    /// SABnzbd (download client) configuration
    @Relationship(deleteRule: .cascade, inverse: \SABnzbdConfiguration.profile)
    var sabnzbdConfiguration: SABnzbdConfiguration?
    
    /// NZBGet (download client) configuration
    @Relationship(deleteRule: .cascade, inverse: \NZBGetConfiguration.profile)
    var nzbgetConfiguration: NZBGetConfiguration?
    
    /// Tautulli (Plex statistics) configuration
    @Relationship(deleteRule: .cascade, inverse: \TautulliConfiguration.profile)
    var tautulliConfiguration: TautulliConfiguration?
    
    /// Overseerr (media request management) configuration
    @Relationship(deleteRule: .cascade, inverse: \OverseerrConfiguration.profile)
    var overseerrConfiguration: OverseerrConfiguration?
    
    /// Wake on LAN configuration
    @Relationship(deleteRule: .cascade, inverse: \WakeOnLANConfiguration.profile)
    var wakeOnLANConfiguration: WakeOnLANConfiguration?
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        name: String,
        isEnabled: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Convenience Methods
    
    /// Updates the `updatedAt` timestamp to the current date
    func markAsUpdated() {
        self.updatedAt = Date()
    }
    
    /// Returns true if any service is configured and enabled in this profile
    func hasAnyServiceEnabled() -> Bool {
        return (radarrConfiguration?.isEnabled ?? false) ||
               (sonarrConfiguration?.isEnabled ?? false) ||
               (lidarrConfiguration?.isEnabled ?? false) ||
               (sabnzbdConfiguration?.isEnabled ?? false) ||
               (nzbgetConfiguration?.isEnabled ?? false) ||
               (tautulliConfiguration?.isEnabled ?? false) ||
               (overseerrConfiguration?.isEnabled ?? false)
    }
}

// MARK: - Default Profile Creation

extension Profile {
    /// The name of the default profile created on first launch
    static let defaultProfileName = "default"
    
    /// Creates a default profile with no services configured
    static func createDefault() -> Profile {
        return Profile(name: defaultProfileName, isEnabled: true)
    }
}
