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
    
    // MARK: - Service Configurations (One-to-Many Relationship)
    
    /// All service configurations for this profile
    @Relationship(deleteRule: .cascade, inverse: \ServiceConfiguration.profile)
    var serviceConfigurations: [ServiceConfiguration]
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        name: String,
        isEnabled: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        serviceConfigurations: [ServiceConfiguration] = []
    ) {
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.serviceConfigurations = serviceConfigurations
    }
    
    // MARK: - Convenience Methods
    
    /// Updates the `updatedAt` timestamp to the current date
    func markAsUpdated() {
        self.updatedAt = Date()
    }
    
    /// Returns true if any service is configured and enabled in this profile
    func hasAnyServiceEnabled() -> Bool {
        return serviceConfigurations.contains { $0.isEnabled }
    }
    
    /// Get a specific service configuration by type
    func serviceConfiguration(for type: ServiceType) -> ServiceConfiguration? {
        return serviceConfigurations.first { $0.serviceType == type }
    }
    
    /// Get all enabled service configurations
    func enabledServices() -> [ServiceConfiguration] {
        return serviceConfigurations.filter { $0.isEnabled }
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
