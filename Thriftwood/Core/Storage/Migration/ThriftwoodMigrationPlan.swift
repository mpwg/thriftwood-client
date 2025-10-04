//
//  ThriftwoodMigrationPlan.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation
import SwiftData

/// Migration plan for handling schema changes between versions
enum ThriftwoodMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        return [SchemaV1.self]
    }
    
    static var stages: [MigrationStage] {
        return [
            // Future migrations will be added here
            // Example:
            // migrateV1toV2
        ]
    }
    
    // MARK: - Future Migration Stages
    
    // Example migration stage for future use:
    // static let migrateV1toV2 = MigrationStage.custom(
    //     fromVersion: SchemaV1.self,
    //     toVersion: SchemaV2.self,
    //     willMigrate: { context in
    //         // Pre-migration logic
    //     },
    //     didMigrate: { context in
    //         // Post-migration logic
    //     }
    // )
}