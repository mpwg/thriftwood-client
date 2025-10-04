//
//  RadarrConfiguration.swift
//  Thriftwood
//
//  SwiftData model for Radarr (movie management) service configuration
//  Replaces Flutter/Hive profile.radarr* fields
//

import Foundation
import SwiftData

@Model
final class RadarrConfiguration: ServiceConfigurationProtocol {
    /// Unique identifier
    var id: UUID
    
    /// Whether Radarr is enabled for this profile
    var isEnabled: Bool
    
    /// Radarr base URL (e.g., "https://radarr.example.com")
    var host: String
    
    /// Radarr API key for authentication
    var apiKey: String
    
    /// Custom HTTP headers
    var headers: [String: String]
    
    /// Back-reference to parent profile
    var profile: Profile?
    
    init(
        id: UUID = UUID(),
        isEnabled: Bool = false,
        host: String = "",
        apiKey: String = "",
        headers: [String: String] = [:]
    ) {
        self.id = id
        self.isEnabled = isEnabled
        self.host = host
        self.apiKey = apiKey
        self.headers = headers
    }
}

// MARK: - Validation

extension RadarrConfiguration {
    func isValid() -> Bool {
        return isEnabled && isHostValid() && !apiKey.isEmpty
    }
}
