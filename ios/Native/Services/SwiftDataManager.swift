//
//  SwiftDataManager.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-03.
//  Pure Swift SwiftData manager for native iOS architecture
//

import Foundation
import SwiftData
import os.log

/// Pure Swift SwiftData manager that handles the main ModelContainer
/// This is the single source of truth for SwiftData setup
/// Bridge components should access this, not create their own containers
class SwiftDataManager {
    @MainActor static let shared = SwiftDataManager()
    
    // MARK: - Properties
    
    /// The main ModelContainer for the application
    private(set) var container: ModelContainer?
    
    /// The main ModelContext for database operations
    private(set) var context: ModelContext?
    
    /// Logger for SwiftData operations
    private let logger = Logger(subsystem: "com.thriftwood.app", category: "SwiftData")
    
    // MARK: - Initialization
    
    private init() {
        setupSwiftData()
    }
    
    // MARK: - SwiftData Setup
    
    /// Setup the main SwiftData container and context
    /// This should be called once at app startup
    private func setupSwiftData() {
        do {
            // Create the main ModelContainer with all models
            let container = try ModelContainer(
                for: ProfileSwiftData.self, 
                     AppSettingsSwiftData.self, 
                     IndexerSwiftData.self
            )
            
            self.container = container
            self.context = ModelContext(container)
            
            // Log the database configuration
            context?.logDatabaseLocation()
            
            logger.info("SwiftDataManager: Main ModelContainer initialized successfully")
            
            // Initialize dependent services
            initializeDependentServices()
            
        } catch {
            logger.error("SwiftDataManager: Failed to initialize ModelContainer - \(error.localizedDescription)")
            fatalError("SwiftData initialization failed: \(error)")
        }
    }
    
    /// Initialize services that depend on SwiftData
    private func initializeDependentServices() {
        guard let context = context else {
            logger.error("SwiftDataManager: Cannot initialize dependent services - no context available")
            return
        }
        
        // Initialize SwiftDataStorageService on main actor
        Task { @MainActor in
            SwiftDataStorageService.shared.initialize(context)
            logger.info("SwiftDataManager: SwiftDataStorageService initialized")
        }
        
        // Note: Bridge components should get context from here, not create their own
    }
    
    // MARK: - Public Access
    
    /// Get the main ModelContext for database operations
    /// This is the single source of truth for SwiftData access
    func getContext() -> ModelContext? {
        return context
    }
    
    /// Get the main ModelContainer
    /// Bridge components should use this instead of creating their own
    func getContainer() -> ModelContainer? {
        return container
    }
    
    /// Perform a save operation on the main context
    func save() throws {
        guard let context = context else {
            throw SwiftDataError.contextNotAvailable
        }
        
        try context.save()
        logger.debug("SwiftDataManager: Context saved successfully")
    }
    
    // MARK: - Health Check
    
    /// Verify SwiftData is properly initialized
    func isInitialized() -> Bool {
        return container != nil && context != nil
    }
    
    /// Get status information for debugging
    func getStatus() -> [String: Any] {
        return [
            "containerInitialized": container != nil,
            "contextInitialized": context != nil,
            "configurationCount": container?.configurations.count ?? 0,
            "registeredModels": container?.schema.entities.map { $0.name } ?? []
        ]
    }
}

// MARK: - Error Types

enum SwiftDataError: Error, LocalizedError {
    case contextNotAvailable
    case containerNotInitialized
    
    var errorDescription: String? {
        switch self {
        case .contextNotAvailable:
            return "SwiftData context is not available"
        case .containerNotInitialized:
            return "SwiftData container is not initialized"
        }
    }
}