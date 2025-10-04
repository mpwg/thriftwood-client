//
//  ThriftwoodMigrationPlan.swift
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