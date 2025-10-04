//
//  Indexer.swift
//  Thriftwood
//
//  SwiftData model for search indexers (Newznab/Torznab providers)
//  Replaces Flutter/Hive LunaIndexer
//

import Foundation
import SwiftData

@Model
final class Indexer {
    /// Unique identifier
    @Attribute(.unique) var id: UUID
    
    /// Display name for the indexer (e.g., "NZBgeek", "DrunkenSlug")
    var displayName: String
    
    /// Indexer base URL
    var host: String
    
    /// API key for authentication
    var apiKey: String
    
    /// Custom HTTP headers
    var headers: [String: String]
    
    /// Timestamp when created
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        displayName: String = "",
        host: String = "",
        apiKey: String = "",
        headers: [String: String] = [:],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.host = host
        self.apiKey = apiKey
        self.headers = headers
        self.createdAt = createdAt
    }
}

// MARK: - Validation

extension Indexer {
    func isValid() -> Bool {
        guard !displayName.isEmpty, !host.isEmpty, !apiKey.isEmpty else { return false }
        guard let url = URL(string: host) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}
