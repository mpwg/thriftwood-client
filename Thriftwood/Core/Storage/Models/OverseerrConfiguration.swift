//
//  OverseerrConfiguration.swift
//  Thriftwood
//
//  SwiftData model for Overseerr (media request management) service configuration
//  Replaces Flutter/Hive profile.overseerr* fields
//

import Foundation
import SwiftData

@Model
final class OverseerrConfiguration: ServiceConfigurationProtocol {
    /// Unique identifier
    var id: UUID
    
    /// Whether Overseerr is enabled for this profile
    var isEnabled: Bool
    
    /// Overseerr base URL (e.g., "https://overseerr.example.com")
    var host: String
    
    /// Overseerr API key for authentication
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

extension OverseerrConfiguration: ServiceConfigurationProtocol {
    func isValid() -> Bool {
        return isEnabled && isHostValid() && !apiKey.isEmpty
    }
}
