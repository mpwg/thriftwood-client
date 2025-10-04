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
            
            // Service configurations
            RadarrConfiguration.self,
            SonarrConfiguration.self,
            LidarrConfiguration.self,
            SABnzbdConfiguration.self,
            NZBGetConfiguration.self,
            TautulliConfiguration.self,
            OverseerrConfiguration.self,
            WakeOnLANConfiguration.self,
            
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
            RadarrConfiguration.self,
            SonarrConfiguration.self,
            LidarrConfiguration.self,
            SABnzbdConfiguration.self,
            NZBGetConfiguration.self,
            TautulliConfiguration.self,
            OverseerrConfiguration.self,
            WakeOnLANConfiguration.self,
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
