//
//  ModelContainer+Thriftwood.swift
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
//  ModelContainer+Thriftwood.swift
//  Thriftwood
//
//  SwiftData model container configuration
//

import Foundation
import SwiftData

extension ModelContainer {
    /// Creates the main model container for Thriftwood with all schemas
    static func thriftwoodContainer() throws -> ModelContainer {
        let schema = Schema([
            // Core models
            Profile.self,
            AppSettings.self,
            
            // Unified service configuration
            ServiceConfiguration.self,
            
            // Search and external modules
            Indexer.self,
            ExternalModule.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )
        
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    }
    
    /// Creates an in-memory container for testing
    static func inMemoryContainer() throws -> ModelContainer {
        let schema = Schema([
            Profile.self,
            AppSettings.self,
            ServiceConfiguration.self,
            Indexer.self,
            ExternalModule.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    }
}
