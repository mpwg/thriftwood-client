//
//  NZBGetConfiguration.swift
//  Thriftwood
//
//  SwiftData model for NZBGet (download client) service configuration
//  Replaces Flutter/Hive profile.nzbget* fields
//

import Foundation
import SwiftData

@Model
final class NZBGetConfiguration: ServiceConfigurationProtocol {
    /// Unique identifier
    var id: UUID
    
    /// Whether NZBGet is enabled for this profile
    var isEnabled: Bool
    
    /// NZBGet base URL (e.g., "https://nzbget.example.com")
    var host: String
    
    /// NZBGet username for basic authentication
    var username: String
    
    /// NZBGet password for basic authentication
    var password: String
    
    /// Custom HTTP headers
    var headers: [String: String]
    
    /// Back-reference to parent profile
    var profile: Profile?
    
    init(
        id: UUID = UUID(),
        isEnabled: Bool = false,
        host: String = "",
        username: String = "",
        password: String = "",
        headers: [String: String] = [:]
    ) {
        self.id = id
        self.isEnabled = isEnabled
        self.host = host
        self.username = username
        self.password = password
        self.headers = headers
    }
}

// MARK: - Validation

extension NZBGetConfiguration: ServiceConfigurationProtocol {
    func isValid() -> Bool {
        return isEnabled && isHostValid() && !username.isEmpty && !password.isEmpty
    }
}
