//
//  SwiftDataFlutterBridge.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-03.
//  Flutter bridge for accessing Swift SwiftData (Bridge methods only)
//

import Foundation
import SwiftData
import Flutter

/// Flutter bridge that provides access to Swift SwiftData models
/// This bridge does NOT create its own ModelContainer - it uses SwiftDataManager
/// Implements the Swift-first migration strategy where Flutter accesses Swift data
@MainActor
class SwiftDataFlutterBridge: NSObject {
    static let shared = SwiftDataFlutterBridge()
    
    // MARK: - Properties
    
    /// Get ModelContext from SwiftDataManager (not owned by bridge)
    private var modelContext: ModelContext? {
        return SwiftDataManager.shared.getContext()
    }
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    /// Initialize the bridge with Flutter method channel (does NOT create SwiftData)
    func initialize(with flutterViewController: FlutterViewController) {
        // Verify SwiftDataManager is initialized
        guard SwiftDataManager.shared.isInitialized() else {
            LoggingService.shared.error("SwiftDataFlutterBridge: Cannot initialize - SwiftDataManager not ready", category: .bridge)
            return
        }
        
        // Register bridge methods with central dispatcher (prevents conflicts)
        registerBridgeMethods()
        
        LoggingService.shared.info("SwiftDataFlutterBridge: Bridge methods registered successfully", category: .bridge)
    }
    
    /// Register Flutter bridge methods with BridgeMethodDispatcher
    private func registerBridgeMethods() {
        // Profile methods
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.getAll") { call, result in
            Task { @MainActor in
                await self.handleGetAllProfiles(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.getActive") { call, result in
            Task { @MainActor in
                await self.handleGetActiveProfile(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.create") { call, result in
            Task { @MainActor in
                await self.handleCreateProfile(arguments: call.arguments, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.update") { call, result in
            Task { @MainActor in
                await self.handleUpdateProfile(arguments: call.arguments, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.delete") { call, result in
            Task { @MainActor in
                await self.handleDeleteProfile(arguments: call.arguments, result: result)
            }
        }
        
        // Settings methods
        BridgeMethodDispatcher.shared.registerHandler(for: "settings.get") { call, result in
            Task { @MainActor in
                await self.handleGetSettings(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "settings.update") { call, result in
            Task { @MainActor in
                await self.handleUpdateSettings(arguments: call.arguments, result: result)
            }
        }
        
        // Indexer methods
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.getAll") { call, result in
            Task { @MainActor in
                await self.handleGetAllIndexers(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.create") { call, result in
            Task { @MainActor in
                await self.handleCreateIndexer(arguments: call.arguments, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.update") { call, result in
            Task { @MainActor in
                await self.handleUpdateIndexer(arguments: call.arguments, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.delete") { call, result in
            Task { @MainActor in
                await self.handleDeleteIndexer(arguments: call.arguments, result: result)
            }
        }
        
        // Migration methods
        BridgeMethodDispatcher.shared.registerHandler(for: "migration.execute") { call, result in
            Task { @MainActor in
                await self.handleExecuteMigration(arguments: call.arguments, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "migration.isComplete") { call, result in
            Task { @MainActor in
                let isComplete = self.isMigrationComplete()
                result(isComplete)
            }
        }
        
        LoggingService.shared.info("SwiftDataFlutterBridge: All bridge methods registered", category: .bridge)
    }
    
    // MARK: - Profile Bridge Methods
    
    private func handleGetAllProfiles(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        do {
            let profiles = try modelContext.fetch(FetchDescriptor<ProfileSwiftData>())
            let profileDictionaries = profiles.map { $0.toDictionary() }
            result(profileDictionaries)
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleGetActiveProfile(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        do {
            // Get app settings to find active profile
            let settingsDescriptor = FetchDescriptor<AppSettingsSwiftData>()
            let settings = try modelContext.fetch(settingsDescriptor)
            guard let appSettings = settings.first else {
                result(FlutterError(code: "NO_SETTINGS", message: "No app settings found", details: nil))
                return
            }
            
            // Find the active profile
            let profileDescriptor = FetchDescriptor<ProfileSwiftData>(
                predicate: #Predicate { $0.name == appSettings.enabledProfile }
            )
            let profiles = try modelContext.fetch(profileDescriptor)
            
            if let activeProfile = profiles.first {
                result(activeProfile.toDictionary())
            } else {
                result(FlutterError(code: "NOT_FOUND", message: "Active profile not found", details: nil))
            }
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleCreateProfile(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        guard let profileData = arguments as? [String: Any],
              let profileName = profileData["name"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid profile data", details: nil))
            return
        }
        
        do {
            let newProfile = ProfileSwiftData(name: profileName)
            
            // Apply any additional profile data from arguments
            if let isDefault = profileData["isDefault"] as? Bool {
                newProfile.isDefault = isDefault
            }
            
            modelContext.insert(newProfile)
            try modelContext.save()
            
            result(newProfile.toDictionary())
        } catch {
            result(FlutterError(code: "CREATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleUpdateProfile(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        guard let profileData = arguments as? [String: Any],
              let profileName = profileData["name"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid profile data", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<ProfileSwiftData>(
                predicate: #Predicate { $0.name == profileName }
            )
            let profiles = try modelContext.fetch(descriptor)
            
            guard let profile = profiles.first else {
                result(FlutterError(code: "NOT_FOUND", message: "Profile not found", details: nil))
                return
            }
            
            // Update profile from Hive data
            profile.updateFromHiveData(profileData)
            try modelContext.save()
            
            result(profile.toDictionary())
        } catch {
            result(FlutterError(code: "UPDATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleDeleteProfile(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        guard let profileName = arguments as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Profile name required", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<ProfileSwiftData>(
                predicate: #Predicate { $0.name == profileName }
            )
            let profiles = try modelContext.fetch(descriptor)
            
            guard let profile = profiles.first else {
                result(FlutterError(code: "NOT_FOUND", message: "Profile not found", details: nil))
                return
            }
            
            modelContext.delete(profile)
            try modelContext.save()
            result(true)
        } catch {
            result(FlutterError(code: "DELETE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    // MARK: - Settings Bridge Methods
    
    private func handleGetSettings(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        do {
            let settings = try modelContext.fetch(FetchDescriptor<AppSettingsSwiftData>())
            if let appSettings = settings.first {
                result(appSettings.toDictionary())
            } else {
                // Create default settings if none exist
                let defaultSettings = AppSettingsSwiftData()
                modelContext.insert(defaultSettings)
                try modelContext.save()
                result(defaultSettings.toDictionary())
            }
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleUpdateSettings(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        guard let settingsData = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid settings data", details: nil))
            return
        }
        
        do {
            let settings = try modelContext.fetch(FetchDescriptor<AppSettingsSwiftData>())
            let appSettings: AppSettingsSwiftData
            
            if let existing = settings.first {
                appSettings = existing
            } else {
                appSettings = AppSettingsSwiftData()
                modelContext.insert(appSettings)
            }
            
            // Update settings from Flutter data
            try appSettings.updateFromDictionary(settingsData)
            try modelContext.save()
            
            result(appSettings.toDictionary())
        } catch {
            result(FlutterError(code: "UPDATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    // MARK: - Indexer Bridge Methods
    
    private func handleGetAllIndexers(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        do {
            let indexers = try modelContext.fetch(FetchDescriptor<IndexerSwiftData>())
            let indexerDictionaries = indexers.map { $0.toDictionary() }
            result(indexerDictionaries)
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleCreateIndexer(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        guard let indexerData = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid indexer data", details: nil))
            return
        }
        
        do {
            guard let newIndexer = IndexerSwiftData.fromDictionary(indexerData) else {
                result(FlutterError(code: "INVALID_DATA", message: "Could not create indexer from data", details: nil))
                return
            }
            
            modelContext.insert(newIndexer)
            try modelContext.save()
            
            result(newIndexer.toDictionary())
        } catch {
            result(FlutterError(code: "CREATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleUpdateIndexer(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        guard let indexerData = arguments as? [String: Any],
              let indexerId = indexerData["id"] as? String,
              let uuid = UUID(uuidString: indexerId) else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid indexer data or ID", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<IndexerSwiftData>(
                predicate: #Predicate { $0.id == uuid }
            )
            let indexers = try modelContext.fetch(descriptor)
            
            guard let indexer = indexers.first else {
                result(FlutterError(code: "NOT_FOUND", message: "Indexer not found", details: nil))
                return
            }
            
            indexer.updateFromHiveData(indexerData)
            try modelContext.save()
            
            result(indexer.toDictionary())
        } catch {
            result(FlutterError(code: "UPDATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleDeleteIndexer(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        guard let indexerId = arguments as? String,
              let uuid = UUID(uuidString: indexerId) else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid indexer ID", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<IndexerSwiftData>(
                predicate: #Predicate { $0.id == uuid }
            )
            let indexers = try modelContext.fetch(descriptor)
            
            guard let indexer = indexers.first else {
                result(FlutterError(code: "NOT_FOUND", message: "Indexer not found", details: nil))
                return
            }
            
            modelContext.delete(indexer)
            try modelContext.save()
            result(true)
        } catch {
            result(FlutterError(code: "DELETE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    // MARK: - Migration Bridge Methods
    
    private func handleExecuteMigration(arguments: Any?, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not available", details: nil))
            return
        }
        
        // Migration logic would go here
        // This is a placeholder for now
        result(true)
    }
    
    private func isMigrationComplete() -> Bool {
        return UserDefaults.standard.bool(forKey: "HIVE_TO_SWIFTDATA_MIGRATION_COMPLETE")
    }
}