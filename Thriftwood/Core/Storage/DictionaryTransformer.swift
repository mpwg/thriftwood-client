//
//  DictionaryTransformer.swift
//  Thriftwood
//
//  Helper for storing [String: String] dictionaries in SwiftData
//  Note: SwiftData natively supports Codable types, so dictionaries work directly
//

import Foundation

/// Helper functions for dictionary encoding/decoding if needed for custom transformations
enum DictionaryTransformer {
    /// Encodes a dictionary to Data
    static func encode(_ dictionary: [String: String]) -> Data? {
        return try? JSONEncoder().encode(dictionary)
    }
    
    /// Decodes Data to a dictionary
    static func decode(_ data: Data) -> [String: String]? {
        return try? JSONDecoder().decode([String: String].self, from: data)
    }
}
