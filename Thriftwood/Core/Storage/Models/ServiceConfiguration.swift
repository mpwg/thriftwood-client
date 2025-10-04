//
//  ServiceConfiguration.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
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
    // Note: apiKey, username, and password are stored in Keychain, not SwiftData
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
        broadcastAddress: String = "",
        macAddress: String = "",
        headers: [String: String] = [:]
    ) {
        self.id = id
        self.serviceType = serviceType
        self.isEnabled = isEnabled
        self.host = host
        self.authenticationType = authenticationType
        self.broadcastAddress = broadcastAddress
        self.macAddress = macAddress
        self.headers = headers
    }
}

extension ServiceConfiguration {
    /// Validates the configuration (excluding credentials which are in Keychain)
    /// - Note: Credential validation should be done separately via KeychainService
    func isValid() -> Bool {
        guard isEnabled else { return true }
        switch serviceType {
        case .radarr, .sonarr, .lidarr, .sabnzbd, .tautulli, .overseerr:
            return isHostValid()
        case .nzbget:
            return isHostValid()
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
