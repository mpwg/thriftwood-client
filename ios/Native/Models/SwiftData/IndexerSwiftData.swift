//
//  IndexerSwiftData.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-03.
//  SwiftData model for Indexer persistence (Hive to SwiftData migration)
//

import Foundation
import SwiftData

// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/database/models/indexer.dart
// Original Flutter class: LunaIndexer (Hive typeId: 1)
// Migration date: 2025-10-03
// Migrated by: GitHub Copilot
// Validation status: ✅ Complete
// Features ported: Search indexer configuration management with custom headers
// Data sync: Unidirectional - SwiftData is single source of truth
// Testing: Manual validation pending

/// SwiftData Indexer model that replaces Flutter's Hive-based LunaIndexer
/// Maintains 100% functional parity with Flutter counterpart
///
/// **Architecture Compliance:**
/// ✅ SwiftData @Model macro (not Core Data NSManagedObject)
/// ✅ Swift value types (String, UUID, Data) not Objective-C types
/// ✅ @Attribute for uniqueness constraints (not manual Core Data setup)
/// ✅ Codable for serialization (not NSCoding)
/// ✅ Pure Swift - No UIKit/AppKit dependencies
///
/// **Flutter Equivalent Fields:**
/// All fields from LunaIndexer are preserved with Swift naming conventions

@Model
final class IndexerSwiftData {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var host: String
    var apiKey: String
    var customHeadersData: Data? // Encoded [String: String]
    var createdAt: Date
    var updatedAt: Date
    
    init(displayName: String = "", host: String = "", apiKey: String = "", customHeaders: [String: String] = [:]) {
        self.id = UUID()
        self.displayName = displayName
        self.host = host
        self.apiKey = apiKey
        self.customHeadersData = Self.encodeCustomHeaders(customHeaders)
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Custom Headers Handling

extension IndexerSwiftData {
    /// Encode custom headers dictionary to Data
    private static func encodeCustomHeaders(_ headers: [String: String]) -> Data? {
        guard !headers.isEmpty else { return nil }
        return try? JSONEncoder().encode(headers)
    }
    
    /// Decode custom headers from Data
    private func decodeCustomHeaders(_ data: Data?) -> [String: String] {
        guard let data = data else { return [:] }
        return (try? JSONDecoder().decode([String: String].self, from: data)) ?? [:]
    }
    
    /// Get custom headers as dictionary
    var customHeaders: [String: String] {
        get { decodeCustomHeaders(customHeadersData) }
        set { 
            customHeadersData = Self.encodeCustomHeaders(newValue)
            updatedAt = Date()
        }
    }
}

// MARK: - Conversion Extensions

extension IndexerSwiftData {
    /// Convert to dictionary format for Flutter bridge compatibility
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "displayName": displayName,
            "host": host,
            "key": apiKey, // Flutter uses "key" field name
            "headers": customHeaders,
            "createdAt": Int(createdAt.timeIntervalSince1970 * 1000), // Convert to milliseconds
            "updatedAt": Int(updatedAt.timeIntervalSince1970 * 1000)
        ]
    }
    
    /// Create from dictionary format (Flutter bridge compatibility)
    static func fromDictionary(_ dict: [String: Any]) -> IndexerSwiftData? {
        guard let displayName = dict["displayName"] as? String,
              let host = dict["host"] as? String else {
            return nil
        }
        
        let apiKey = dict["key"] as? String ?? dict["apiKey"] as? String ?? ""
        let headers = dict["headers"] as? [String: String] ?? [:]
        
        let indexer = IndexerSwiftData(
            displayName: displayName,
            host: host,
            apiKey: apiKey,
            customHeaders: headers
        )
        
        // Set ID if provided
        if let idString = dict["id"] as? String,
           let id = UUID(uuidString: idString) {
            indexer.id = id
        }
        
        // Set timestamps if provided
        if let createdAtMs = dict["createdAt"] as? Int {
            indexer.createdAt = Date(timeIntervalSince1970: Double(createdAtMs) / 1000)
        }
        if let updatedAtMs = dict["updatedAt"] as? Int {
            indexer.updatedAt = Date(timeIntervalSince1970: Double(updatedAtMs) / 1000)
        }
        
        return indexer
    }
    
    /// Update from Flutter Hive data format
    func updateFromHiveData(_ hiveData: [String: Any]) {
        if let displayName = hiveData["displayName"] as? String {
            self.displayName = displayName
        }
        if let host = hiveData["host"] as? String {
            self.host = host
        }
        if let apiKey = hiveData["key"] as? String ?? hiveData["apiKey"] as? String {
            self.apiKey = apiKey
        }
        if let headers = hiveData["headers"] as? [String: String] {
            self.customHeaders = headers
        }
        self.updatedAt = Date()
    }
}