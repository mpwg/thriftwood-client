//
//  DataService.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation
import SwiftData

extension DataService {
    /// Returns the current schema version from the database
    func currentSchemaVersion() -> SchemaVersion {
        return SchemaVersion.current
    }
    
    /// Checks if migration is needed
    func migrationNeeded() -> Bool {
        // SwiftData handles automatic migrations
        // This is for custom migration logic
        return false
    }
}