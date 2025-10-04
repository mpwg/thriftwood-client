//
//  ServiceConfiguration.swift
//  Thriftwood
//
//  Unified SwiftData model for all service configurations
//

import Foundation
import SwiftData

enum ServiceType: String, Codable {
    case radarr
    case sonarr
    case lidarr
    case sabnzbd
    case nzbget
    case tautulli
    case overseerr
    case wakeOnLAN
}

enum AuthenticationType: String, Codable {
    case apiKey
    case usernamePassword
    case none
}

@Model
final class ServiceConfiguration {
    var id: UUID
    var serviceType: ServiceType
    var isEnabled: Bool
    var host: String
    var authenticationType: AuthenticationType
    var apiKey: String
    var username: String
    var password: String
    var broadcastAddress: String
    var macAddress: String
    var headers: [String: String]
    var profile: Profile?
    
    init(
        id: UUID = UUID(),
        serviceType: ServiceType,
        isEnabled: Bool = false,
        host: String = "",
        authenticationType: AuthenticationType = .apiKey,
        apiKey: String = "",
        username: String = "",
        password: String = "",
        broadcastAddress: String = "",
        macAddress: String = "",
        headers: [String: String] = [:]
    ) {
        self.id = id
        self.serviceType = serviceType
        self.isEnabled = isEnabled
        self.host = host
        self.authenticationType = authenticationType
        self.apiKey = apiKey
        self.username = username
        self.password = password
        self.broadcastAddress = broadcastAddress
        self.macAddress = macAddress
        self.headers = headers
    }
}

extension ServiceConfiguration {
    func isValid() -> Bool {
        guard isEnabled else { return true }
        switch serviceType {
        case .radarr, .sonarr, .lidarr, .sabnzbd, .tautulli, .overseerr:
            return isHostValid() && !apiKey.isEmpty
        case .nzbget:
            return isHostValid() && !username.isEmpty && !password.isEmpty
        case .wakeOnLAN:
            return !broadcastAddress.isEmpty && !macAddress.isEmpty && isMACAddressValid()
        }
    }
    
    private func isHostValid() -> Bool {
        guard !host.isEmpty else { return false }
        guard let url = URL(string: host) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
    
    private func isMACAddressValid() -> Bool {
        let components = macAddress.split(separator: ":")
        return components.count == 6 && components.allSatisfy { $0.count == 2 }
    }
}
