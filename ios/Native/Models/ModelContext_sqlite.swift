//
//  ModelContext_sqlite.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 03.10.25.
//

import Foundation
import SwiftData
import os.log

// from https://www.hackingwithswift.com/quick-start/swiftdata/how-to-read-the-contents-of-a-swiftdata-database-store
// print(modelContext.sqliteCommand)

extension ModelContext {
    /// Get SQLite database path and log it (returns first configuration for compatibility)
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            let command = "sqlite3 \"\(url)\""
            
            // Log the SQLite database folder location
            let logger = Logger(subsystem: "com.thriftwood.app", category: "SwiftData")
            logger.info("SwiftData SQLite database location: \(url)")
            print("📁 SwiftData SQLite database location: \(url)")
            
            return command
        } else {
            print("❌ No SQLite database found.")
            return "No SQLite database found."
        }
    }
    
    /// Log all SwiftData database configurations and locations
    func logDatabaseLocation() {
        let logger = Logger(subsystem: "com.thriftwood.app", category: "SwiftData")
        let configurations = container.configurations
        
        if configurations.isEmpty {
            logger.warning("No SwiftData configurations found")
            print("❌ No SQLite database configurations found")
            return
        }
        
        logger.info("Found \(configurations.count) SwiftData configuration(s)")
        print("📊 Found \(configurations.count) SwiftData configuration(s)")
        
        for (index, configuration) in configurations.enumerated() {
            let configNumber = index + 1
            let url = configuration.url.path(percentEncoded: false)
            let folderPath = configuration.url.deletingLastPathComponent().path
            
            // Log each configuration
            logger.info("Configuration \(configNumber):")
            logger.info("  Database folder: \(folderPath)")
            logger.info("  Database file: \(url)")
            logger.info("  SQLite command: sqlite3 \"\(url)\"")
            
            print("📁 Configuration \(configNumber):")
            print("   📂 Database folder: \(folderPath)")
            print("   📄 Database file: \(url)")
            print("   💻 SQLite command: sqlite3 \"\(url)\"")
            
            // Log any additional configuration details
            if configuration.isStoredInMemoryOnly {
                logger.info("  Storage: In-memory only")
                print("   💾 Storage: In-memory only")
            } else {
                logger.info("  Storage: Persistent on disk")
                print("   💾 Storage: Persistent on disk")
            }
            
            if configuration.allowsSave {
                logger.info("  Write access: Enabled")
                print("   ✅ Write access: Enabled")
            } else {
                logger.info("  Write access: Read-only")
                print("   🔒 Write access: Read-only")
            }
            
            print("") // Empty line for readability
        }
        
        // Log the models registered in this container
        let schema = container.schema
        let modelNames = schema.entities.map { $0.name }
        logger.info("Registered models: \(modelNames.joined(separator: ", "))")
        print("📋 Registered models: \(modelNames.joined(separator: ", "))")
    }
}