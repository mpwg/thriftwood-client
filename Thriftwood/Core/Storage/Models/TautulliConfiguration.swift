//
//  TautulliConfiguration.swift
//  Thriftwood
//
//  SwiftData model for Tautulli (Plex statistics) service configuration
//  Replaces Flutter/Hive profile.tautulli* fields
//

import Foundation
import SwiftData

@Model
final class TautulliConfiguration: ServiceConfigurationProtocol {
    /// Unique identifier
    var id: UUID
    
    /// Whether Tautulli is enabled for this profile
    var isEnabled: Bool
    
    /// Tautulli base URL (e.g., "https://tautulli.example.com")
    var host: String
    
    /// Tautulli API key for authentication
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

extension TautulliConfiguration: ServiceConfigurationProtocol {
    func isValid() -> Bool {
        return isEnabled && isHostValid() && !apiKey.isEmpty
    }
}
