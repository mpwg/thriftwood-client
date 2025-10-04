//
//  DictionaryTransformer.swift
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
