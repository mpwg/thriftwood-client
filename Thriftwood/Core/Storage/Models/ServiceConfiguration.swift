//
//  ServiceConfiguration.swift
//  Thriftwood
//
//  Base protocol for service configurations
//

import Foundation

/// Common protocol for all service configurations
protocol ServiceConfigurationProtocol {
    /// Whether this service is enabled
    var isEnabled: Bool { get set }
    
    /// Base URL for the service API
    var host: String { get set }
    
    /// Custom HTTP headers for requests
    var headers: [String: String] { get set }
    
    /// Validates the configuration
    func isValid() -> Bool
}

/// Common validation logic
extension ServiceConfigurationProtocol {
    /// Base validation: checks if host is a valid URL
    func isHostValid() -> Bool {
        guard !host.isEmpty else { return false }
        guard let url = URL(string: host) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}
