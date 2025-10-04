//
//  ExternalModule.swift
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
