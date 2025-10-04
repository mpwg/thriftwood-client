//
//  ExternalModule.swift
//  Thriftwood
//
//  SwiftData model for external web modules/links
//  Replaces Flutter/Hive LunaExternalModule
//

import Foundation
import SwiftData

@Model
final class ExternalModule {
    /// Unique identifier
    @Attribute(.unique) var id: UUID
    
    /// Display name for the module (e.g., "Plex", "Portainer")
    var displayName: String
    
    /// URL to the external module
    var host: String
    
    /// Timestamp when created
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        displayName: String = "",
        host: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.host = host
        self.createdAt = createdAt
    }
}

// MARK: - Validation

extension ExternalModule {
    func isValid() -> Bool {
        guard !displayName.isEmpty, !host.isEmpty else { return false }
        guard let url = URL(string: host) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}
