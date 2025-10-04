//
//  DataService.swift
//  Thriftwood
//
//  Service for managing SwiftData persistence operations
//  Provides CRUD operations for all models
//

import Foundation
import SwiftData
import Combine

/// Service for managing data persistence with SwiftData
@MainActor
final class DataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = modelContainer.mainContext
    }
    
    // MARK: - Profile Operations
    
    /// Fetches all profiles ordered by name
    func fetchProfiles() throws -> [Profile] {
        let descriptor = FetchDescriptor<Profile>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Fetches the currently enabled profile
    func fetchEnabledProfile() throws -> Profile? {
        let descriptor = FetchDescriptor<Profile>(
            predicate: #Predicate { $0.isEnabled == true }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    /// Fetches a profile by name
    func fetchProfile(named name: String) throws -> Profile? {
        let descriptor = FetchDescriptor<Profile>(
            predicate: #Predicate { $0.name == name }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    /// Creates a new profile
    func createProfile(_ profile: Profile) throws {
        modelContext.insert(profile)
        try modelContext.save()
    }
    
    /// Updates an existing profile
    func updateProfile(_ profile: Profile) throws {
        profile.markAsUpdated()
        try modelContext.save()
    }
    
    /// Deletes a profile
    func deleteProfile(_ profile: Profile) throws {
        modelContext.delete(profile)
        try modelContext.save()
    }
    
    /// Switches the enabled profile (disables all others, enables the specified one)
    func switchToProfile(_ profile: Profile) throws {
        // Disable all profiles
        let allProfiles = try fetchProfiles()
        for p in allProfiles {
            p.isEnabled = false
        }
        
        // Enable the specified profile
        profile.isEnabled = true
        profile.markAsUpdated()
        
        try modelContext.save()
    }
    
    // MARK: - AppSettings Operations
    
    /// Fetches the app settings (singleton)
    func fetchAppSettings() throws -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()
        if let settings = try modelContext.fetch(descriptor).first {
            return settings
        } else {
            // Create default settings if none exist
            let defaultSettings = AppSettings.createDefault()
            modelContext.insert(defaultSettings)
            try modelContext.save()
            return defaultSettings
        }
    }
    
    /// Updates app settings
    func updateAppSettings(_ settings: AppSettings) throws {
        settings.markAsUpdated()
        try modelContext.save()
    }
    
    // MARK: - Service Configuration Operations
    
    /// Creates or updates a service configuration for a profile
    func updateServiceConfiguration<T>(_ configuration: T, for profile: Profile) throws where T: AnyObject {
        // SwiftData will automatically manage relationships
        // Just save the context
        try modelContext.save()
    }
    
    // MARK: - Indexer Operations
    
    /// Fetches all indexers ordered by display name
    func fetchIndexers() throws -> [Indexer] {
        let descriptor = FetchDescriptor<Indexer>(
            sortBy: [SortDescriptor(\.displayName)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Creates a new indexer
    func createIndexer(_ indexer: Indexer) throws {
        modelContext.insert(indexer)
        try modelContext.save()
    }
    
    /// Updates an existing indexer
    func updateIndexer(_ indexer: Indexer) throws {
        try modelContext.save()
    }
    
    /// Deletes an indexer
    func deleteIndexer(_ indexer: Indexer) throws {
        modelContext.delete(indexer)
        try modelContext.save()
    }
    
    // MARK: - External Module Operations
    
    /// Fetches all external modules ordered by display name
    func fetchExternalModules() throws -> [ExternalModule] {
        let descriptor = FetchDescriptor<ExternalModule>(
            sortBy: [SortDescriptor(\.displayName)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Creates a new external module
    func createExternalModule(_ module: ExternalModule) throws {
        modelContext.insert(module)
        try modelContext.save()
    }
    
    /// Updates an existing external module
    func updateExternalModule(_ module: ExternalModule) throws {
        try modelContext.save()
    }
    
    /// Deletes an external module
    func deleteExternalModule(_ module: ExternalModule) throws {
        modelContext.delete(module)
        try modelContext.save()
    }
    
    // MARK: - Bootstrap
    
    /// Bootstraps the database with default data on first launch
    func bootstrap() throws {
        // Check if default profile already exists
        if let _ = try fetchProfile(named: Profile.defaultProfileName) {
            return // Already bootstrapped
        }
        
        // Create default profile
        let defaultProfile = Profile.createDefault()
        try createProfile(defaultProfile)
        
        // Ensure default app settings exist
        _ = try fetchAppSettings()
    }
    
    // MARK: - Utility
    
    /// Saves the current context
    func save() throws {
        try modelContext.save()
    }
    
    /// Resets the entire database (for testing/debugging)
    func reset() throws {
        // Delete all profiles
        let profiles = try fetchProfiles()
        for profile in profiles {
            modelContext.delete(profile)
        }
        
        // Delete all indexers
        let indexers = try fetchIndexers()
        for indexer in indexers {
            modelContext.delete(indexer)
        }
        
        // Delete all external modules
        let modules = try fetchExternalModules()
        for module in modules {
            modelContext.delete(module)
        }
        
        // Delete app settings
        let descriptor = FetchDescriptor<AppSettings>()
        if let settings = try modelContext.fetch(descriptor).first {
            modelContext.delete(settings)
        }
        
        try modelContext.save()
    }
}
