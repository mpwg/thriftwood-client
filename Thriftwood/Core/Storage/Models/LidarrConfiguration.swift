//
//  LidarrConfiguration.swift
//  Thriftwood
//
//  SwiftData model for Lidarr (music management) service configuration
//  Replaces Flutter/Hive profile.lidarr* fields
//

import Foundation
import SwiftData

@Model
final class LidarrConfiguration: ServiceConfigurationProtocol {
    /// Unique identifier
    var id: UUID
    
    /// Whether Lidarr is enabled for this profile
    var isEnabled: Bool
    
    /// Lidarr base URL (e.g., "https://lidarr.example.com")
    var host: String
    
    /// Lidarr API key for authentication
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

extension LidarrConfiguration: ServiceConfigurationProtocol {
    func isValid() -> Bool {
        return isEnabled && isHostValid() && !apiKey.isEmpty
    }
}
