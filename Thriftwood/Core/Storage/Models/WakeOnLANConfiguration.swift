//
//  WakeOnLANConfiguration.swift
//  Thriftwood
//
//  SwiftData model for Wake on LAN configuration
//  Replaces Flutter/Hive profile.wakeOnLAN* fields
//

import Foundation
import SwiftData

@Model
final class WakeOnLANConfiguration {
    /// Unique identifier
    var id: UUID
    
    /// Whether Wake on LAN is enabled for this profile
    var isEnabled: Bool
    
    /// Broadcast address for WOL magic packet (e.g., "192.168.1.255")
    var broadcastAddress: String
    
    /// Target MAC address to wake (e.g., "AA:BB:CC:DD:EE:FF")
    var macAddress: String
    
    /// Back-reference to parent profile
    var profile: Profile?
    
    init(
        id: UUID = UUID(),
        isEnabled: Bool = false,
        broadcastAddress: String = "",
        macAddress: String = ""
    ) {
        self.id = id
        self.isEnabled = isEnabled
        self.broadcastAddress = broadcastAddress
        self.macAddress = macAddress
    }
}

// MARK: - Validation

extension WakeOnLANConfiguration {
    /// Validates MAC address format (XX:XX:XX:XX:XX:XX)
    func isValid() -> Bool {
        guard isEnabled else { return true }
        guard !broadcastAddress.isEmpty, !macAddress.isEmpty else { return false }
        
        // Basic MAC address validation
        let macComponents = macAddress.split(separator: ":")
        return macComponents.count == 6 && macComponents.allSatisfy { $0.count == 2 }
    }
}
