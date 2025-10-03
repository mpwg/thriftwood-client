//
//  ExternalModule.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-03.
//  External module model for Thriftwood application
//

import Foundation
import Observation

/// External module configuration model
/// Used for managing custom module integrations
@Observable
class ExternalModule: Identifiable, Codable {
    let id: UUID
    var name: String        // Internal identifier
    var displayName: String // User-facing display name
    var host: String        // Module host URL
    var isEnabled: Bool     // Module activation state
    
    init(name: String, displayName: String, host: String, isEnabled: Bool = true) {
        self.id = UUID()
        self.name = name
        self.displayName = displayName
        self.host = host
        self.isEnabled = isEnabled
    }
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case id, name, displayName, host, isEnabled
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.host = try container.decode(String.self, forKey: .host)
        self.isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(host, forKey: .host)
        try container.encode(isEnabled, forKey: .isEnabled)
    }
}

// MARK: - Hashable conformance for SwiftUI
extension ExternalModule: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ExternalModule, rhs: ExternalModule) -> Bool {
        lhs.id == rhs.id
    }
}