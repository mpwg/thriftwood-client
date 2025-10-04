//
//  SchemaVersion.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation
import SwiftData

/// Schema version enum for tracking data model versions
enum SchemaVersion: Int, CaseIterable {
    case v1 = 1 // Initial schema
    
    /// The current schema version
    static var current: SchemaVersion {
        return .v1
    }
}
