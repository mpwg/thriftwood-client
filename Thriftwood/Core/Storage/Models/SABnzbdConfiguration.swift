//
//  SABnzbdConfiguration.swift
//  Thriftwood
//
//  SwiftData model for SABnzbd (download client) service configuration
//  Replaces Flutter/Hive profile.sabnzbd* fields
//

import Foundation
import SwiftData

@Model
final class SABnzbdConfiguration: ServiceConfigurationProtocol {
    /// Unique identifier
    var id: UUID
    
    /// Whether SABnzbd is enabled for this profile
    var isEnabled: Bool
    
    /// SABnzbd base URL (e.g., "https://sabnzbd.example.com")
    var host: String
    
    /// SABnzbd API key for authentication
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

extension SABnzbdConfiguration: ServiceConfigurationProtocol {
    func isValid() -> Bool {
        return isEnabled && isHostValid() && !apiKey.isEmpty
    }
}
