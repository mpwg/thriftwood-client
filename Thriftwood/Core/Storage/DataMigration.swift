//
//  DataMigration.swift
//  Thriftwood
//
//  Schema versioning and migration support for SwiftData
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

// MARK: - Versioned Schema V1

/// Version 1 schema - Initial release
enum SchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        return Schema.Version(1, 0, 0)
    }
    
    static var models: [any PersistentModel.Type] {
        return [
            Profile.self,
            AppSettings.self,
            ServiceConfiguration.self,
            Indexer.self,
            ExternalModule.self
        ]
    }
}

// MARK: - Migration Plan

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

// MARK: - Legacy Data Migration

/// Service for migrating data from legacy Flutter/Hive database
@MainActor
struct LegacyDataMigration {
    private let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    /// Checks if legacy data exists and needs migration
    func needsMigration() -> Bool {
        // TODO: Implement detection of legacy Hive database files
        // Check for existence of legacy database path
        return false
    }
    
    /// Performs migration from legacy Hive database to SwiftData
    func migrate() async throws {
        // TODO: Implement legacy data migration
        // 1. Read legacy Hive boxes
        // 2. Convert to SwiftData models
        // 3. Import into new database
        // 4. Archive/delete legacy database
        
        throw ThriftwoodError.invalidConfiguration("Legacy migration not yet implemented")
    }
    
    /// Imports a profile from legacy JSON export
    func importLegacyProfile(from json: [String: Any]) throws -> Profile {
        // TODO: Implement JSON import from legacy app export
        throw ThriftwoodError.invalidConfiguration("Legacy profile import not yet implemented")
    }
}

// MARK: - Migration Utilities

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
