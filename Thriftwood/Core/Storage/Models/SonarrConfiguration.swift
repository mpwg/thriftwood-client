//
//  SonarrConfiguration.swift
//  Thriftwood
//
//  SwiftData model for Sonarr (TV show management) service configuration
//  Replaces Flutter/Hive profile.sonarr* fields
//

import Foundation
import SwiftData

@Model
final class SonarrConfiguration: ServiceConfigurationProtocol {
    /// Unique identifier
    var id: UUID
    
    /// Whether Sonarr is enabled for this profile
    var isEnabled: Bool
    
    /// Sonarr base URL (e.g., "https://sonarr.example.com")
    var host: String
    
    /// Sonarr API key for authentication
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

extension SonarrConfiguration: ServiceConfigurationProtocol {
    func isValid() -> Bool {
        return isEnabled && isHostValid() && !apiKey.isEmpty
    }
}
