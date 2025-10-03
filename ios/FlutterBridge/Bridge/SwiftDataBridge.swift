//
//  SwiftDataBridge.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-01.
//  Bridge for Flutter access to Swift data models (Phase 4.1)
//

import Foundation
import SwiftData
import Flutter

/// Bridge that provides Flutter access to Swift SwiftData models
/// Implements the Swift-first migration strategy where Flutter accesses Swift data
@MainActor
class SwiftDataBridge: NSObject {
    static let shared = SwiftDataBridge()
    
    // MARK: - Properties
    
    /// SwiftData model context for database operations
    private(set) var modelContext: ModelContext?
    
    /// Method channel for Flutter communication
    private var methodChannel: FlutterMethodChannel?
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        setupSwiftDataContext()
    }
    
    /// Initialize the bridge with Flutter method channel
    func initialize(with flutterViewController: FlutterViewController) {
        // Register data methods with central dispatcher (prevents conflicts)
        registerDataMethods()
        
        LoggingService.shared.info("SwiftDataBridge initialized and registered with dispatcher", category: .bridge)
    }
    
    /// Register data access methods with BridgeMethodDispatcher
    private func registerDataMethods() {
        // Profile data methods
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.getAll") { call, result in
            Task { @MainActor in
                await self.handleGetAllProfiles(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.get") { call, result in
            Task { @MainActor in
                await self.handleGetProfile(call: call, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.create") { call, result in
            Task { @MainActor in
                await self.handleCreateProfile(call: call, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.update") { call, result in
            Task { @MainActor in
                await self.handleUpdateProfile(call: call, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "profile.delete") { call, result in
            Task { @MainActor in
                await self.handleDeleteProfile(call: call, result: result)
            }
        }
        
        // Settings data methods
        BridgeMethodDispatcher.shared.registerHandler(for: "settings.get") { call, result in
            Task { @MainActor in
                await self.handleGetSettings(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "settings.update") { call, result in
            Task { @MainActor in
                await self.handleUpdateSettings(call: call, result: result)
            }
        }
        
        // Indexer data methods
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.getAll") { call, result in
            Task { @MainActor in
                await self.handleGetAllIndexers(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.get") { call, result in
            Task { @MainActor in
                await self.handleGetIndexer(call: call, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.create") { call, result in
            Task { @MainActor in
                await self.handleCreateIndexer(call: call, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.update") { call, result in
            Task { @MainActor in
                await self.handleUpdateIndexer(call: call, result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "indexer.delete") { call, result in
            Task { @MainActor in
                await self.handleDeleteIndexer(call: call, result: result)
            }
        }
        
        // Logging methods (OSLog integration)
        BridgeMethodDispatcher.shared.registerHandler(for: "log.write") { call, result in
            Task { @MainActor in
                let success = LoggingService.shared.handleFlutterLogRequest(call.method, arguments: call.arguments)
                result(success)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "log.export") { call, result in
            Task { @MainActor in
                let args = call.arguments as? [String: Any]
                let limit = args?["limit"] as? Int ?? 1000
                let logs = await LoggingService.shared.exportRecentLogs(limit: limit)
                result(logs)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "log.clear") { call, result in
            Task { @MainActor in
                // OSLog doesn't support manual clearing - logs are managed by the system
                LoggingService.shared.info("Log clear requested - OSLog manages retention automatically", category: .bridge)
                result(true)
            }
        }
        
        // Migration methods
        BridgeMethodDispatcher.shared.registerHandler(for: "migration.fromHive") { call, result in
            Task { @MainActor in
                await self.handleMigrateFromHive(result: result)
            }
        }
        
        BridgeMethodDispatcher.shared.registerHandler(for: "migration.isComplete") { call, result in
            Task { @MainActor in
                let isComplete = self.isMigrationComplete()
                result(isComplete)
            }
        }
        
        LoggingService.shared.info("Data bridge methods registered with BridgeMethodDispatcher", category: .bridge)
    }
    
    /// Setup SwiftData model context
    private func setupSwiftDataContext() {
        do {
            let container = try ModelContainer(
                for: ProfileSwiftData.self, AppSettingsSwiftData.self, IndexerSwiftData.self
            )
            modelContext = ModelContext(container)
            
            // Log the SQLite database location
            modelContext?.logDatabaseLocation()
            
            LoggingService.shared.info("SwiftData context initialized", category: .database)
            
            // Initialize SwiftDataStorageService with the context
            Task { @MainActor in
                SwiftDataStorageService.shared.initialize(modelContext!)
                LoggingService.shared.info("SwiftDataStorageService initialized with context", category: .database)
            }
        } catch {
            LoggingService.shared.error("Failed to initialize SwiftData context", error: error, category: .database)
        }
    }
    
    // MARK: - Flutter Method Call Handler
    
    // MARK: - Profile Data Handlers
    
    private func handleGetAllProfiles(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not initialized", details: nil))
            return
        }
        
        do {
            let profiles = try modelContext.fetch(FetchDescriptor<ProfileSwiftData>())
            let profileDicts = profiles.map { $0.toDictionary() }
            result(profileDicts)
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleGetProfile(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any],
              let idString = args["id"] as? String,
              let id = UUID(uuidString: idString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Profile ID required", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<ProfileSwiftData>(
                predicate: #Predicate<ProfileSwiftData> { $0.id == id }
            )
            let profiles = try modelContext.fetch(descriptor)
            
            if let profile = profiles.first {
                result(profile.toDictionary())
            } else {
                result(nil)
            }
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleCreateProfile(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Profile data required", details: nil))
            return
        }
        
        do {
            // CRITICAL: Check for existing profile before creating to prevent duplicates
            let profileName = args["name"] as? String ?? "Unknown"
            let checkDescriptor = FetchDescriptor<ProfileSwiftData>(
                predicate: #Predicate<ProfileSwiftData> { $0.name == profileName }
            )
            let existingProfiles = try modelContext.fetch(checkDescriptor)
            
            if let existingProfile = existingProfiles.first {
                // Return existing profile instead of creating duplicate
                LoggingService.shared.warning("SwiftDataBridge: Profile already exists, returning existing: \(profileName)", category: .database)
                result(existingProfile.toDictionary())
                return
            }
            
            let profile = try ProfileSwiftData.fromDictionary(args)
            
            // CRITICAL: Insert profile safely to prevent duplicate registration
            do {
                modelContext.insert(profile)
                try modelContext.save()
                LoggingService.shared.info("SwiftDataBridge: Created new profile: \(profileName)", category: .database)
                result(profile.toDictionary())
            } catch {
                LoggingService.shared.warning("SwiftDataBridge: Profile insertion failed (likely duplicate): \(profileName) - \(error.localizedDescription)", category: .database)
                // If insertion fails, return the existing profile
                if let existingProfile = existingProfiles.first {
                    result(existingProfile.toDictionary())
                } else {
                    result(FlutterError(code: "CREATE_ERROR", message: "Failed to create or find profile: \(error.localizedDescription)", details: nil))
                }
            }
        } catch {
            LoggingService.shared.error("SwiftDataBridge: Profile creation failed", error: error, category: .database)
            result(FlutterError(code: "CREATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleUpdateProfile(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any],
              let idString = args["id"] as? String,
              let id = UUID(uuidString: idString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Profile ID and data required", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<ProfileSwiftData>(
                predicate: #Predicate<ProfileSwiftData> { $0.id == id }
            )
            let profiles = try modelContext.fetch(descriptor)
            
            guard let profile = profiles.first else {
                result(FlutterError(code: "NOT_FOUND", message: "Profile not found", details: nil))
                return
            }
            
            try profile.updateFromDictionary(args)
            try modelContext.save()
            result(profile.toDictionary())
        } catch {
            result(FlutterError(code: "UPDATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleDeleteProfile(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any],
              let idString = args["id"] as? String,
              let id = UUID(uuidString: idString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Profile ID required", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<ProfileSwiftData>(
                predicate: #Predicate<ProfileSwiftData> { $0.id == id }
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
    
    // MARK: - Settings Data Handlers
    
    private func handleGetSettings(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not initialized", details: nil))
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
    
    private func handleUpdateSettings(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Settings data required", details: nil))
            return
        }
        
        do {
            let settings = try modelContext.fetch(FetchDescriptor<AppSettingsSwiftData>())
            let appSettings = settings.first ?? AppSettingsSwiftData()
            
            if settings.isEmpty {
                modelContext.insert(appSettings)
            }
            
            try appSettings.updateFromDictionary(args)
            try modelContext.save()
            result(appSettings.toDictionary())
        } catch {
            result(FlutterError(code: "UPDATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    /// Route method calls to appropriate service handlers
    private func handleServiceCall(service: String, action: String, arguments: Any?, context: ModelContext) async throws -> Any? {
        switch service {
        case "profile":
            return try await handleProfileCall(action: action, arguments: arguments, context: context)
        case "settings":
            return try await handleSettingsCall(action: action, arguments: arguments, context: context)
        case "migration":
            return try await handleMigrationCall(action: action, arguments: arguments, context: context)
        default:
            throw SwiftDataBridgeError.unknownService(service)
        }
    }
    
    // MARK: - Profile Data Access
    
    /// Handle profile-related method calls from Flutter
    private func handleProfileCall(action: String, arguments: Any?, context: ModelContext) async throws -> Any? {
        switch action {
        case "getAllProfiles":
            return try await getAllProfiles(context: context)
        case "getActiveProfile":
            return try await getActiveProfile(context: context)
        case "createProfile":
            return try await createProfile(arguments: arguments, context: context)
        case "updateProfile":
            return try await updateProfile(arguments: arguments, context: context)
        case "deleteProfile":
            return try await deleteProfile(arguments: arguments, context: context)
        case "setActiveProfile":
            return try await setActiveProfile(arguments: arguments, context: context)
        default:
            throw SwiftDataBridgeError.unknownAction(action)
        }
    }
    
    /// Get all profiles as dictionaries for Flutter
    private func getAllProfiles(context: ModelContext) async throws -> [[String: Any]] {
        let descriptor = FetchDescriptor<ProfileSwiftData>()
        let profiles = try context.fetch(descriptor)
        return profiles.map { $0.toDictionary() }
    }
    
    /// Get the currently active profile
    private func getActiveProfile(context: ModelContext) async throws -> [String: Any]? {
        let descriptor = FetchDescriptor<ProfileSwiftData>(
            predicate: #Predicate { $0.isDefault == true }
        )
        let profiles = try context.fetch(descriptor)
        return profiles.first?.toDictionary()
    }
    
    /// Create a new profile from Flutter data
    private func createProfile(arguments: Any?, context: ModelContext) async throws -> [String: Any] {
        guard let profileData = arguments as? [String: Any] else {
            throw SwiftDataBridgeError.invalidArguments("Expected profile dictionary")
        }
        
        let profile = try ProfileSwiftData.fromDictionary(profileData)
        context.insert(profile)
        try context.save()
        
        return profile.toDictionary()
    }
    
    /// Update an existing profile
    private func updateProfile(arguments: Any?, context: ModelContext) async throws -> [String: Any] {
        guard let profileData = arguments as? [String: Any],
              let profileIdString = profileData["id"] as? String,
              let profileId = UUID(uuidString: profileIdString) else {
            throw SwiftDataBridgeError.invalidArguments("Expected profile dictionary with valid ID")
        }
        
        let descriptor = FetchDescriptor<ProfileSwiftData>(
            predicate: #Predicate { $0.id == profileId }
        )
        let profiles = try context.fetch(descriptor)
        
        guard let profile = profiles.first else {
            throw SwiftDataBridgeError.profileNotFound(profileId.uuidString)
        }
        
        try profile.updateFromDictionary(profileData)
        try context.save()
        
        return profile.toDictionary()
    }
    
    /// Delete a profile by ID
    private func deleteProfile(arguments: Any?, context: ModelContext) async throws -> Bool {
        guard let args = arguments as? [String: Any],
              let profileIdString = args["id"] as? String,
              let profileId = UUID(uuidString: profileIdString) else {
            throw SwiftDataBridgeError.invalidArguments("Expected profile ID string")
        }
        
        let descriptor = FetchDescriptor<ProfileSwiftData>(
            predicate: #Predicate { $0.id == profileId }
        )
        let profiles = try context.fetch(descriptor)
        
        guard let profile = profiles.first else {
            throw SwiftDataBridgeError.profileNotFound(profileId.uuidString)
        }
        
        // Don't allow deleting the default profile if it's the only one
        if profile.isDefault {
            let allProfiles = try context.fetch(FetchDescriptor<ProfileSwiftData>())
            if allProfiles.count <= 1 {
                throw SwiftDataBridgeError.cannotDeleteLastProfile
            }
        }
        
        context.delete(profile)
        try context.save()
        
        return true
    }
    
    /// Set a profile as the active/default profile
    private func setActiveProfile(arguments: Any?, context: ModelContext) async throws -> Bool {
        guard let args = arguments as? [String: Any],
              let profileIdString = args["id"] as? String,
              let profileId = UUID(uuidString: profileIdString) else {
            throw SwiftDataBridgeError.invalidArguments("Expected profile ID string")
        }
        
        // Get all profiles
        let allProfiles = try context.fetch(FetchDescriptor<ProfileSwiftData>())
        
        // Set all profiles to non-default
        for profile in allProfiles {
            profile.isDefault = false
        }
        
        // Find and set the target profile as default
        guard let targetProfile = allProfiles.first(where: { $0.id == profileId }) else {
            throw SwiftDataBridgeError.profileNotFound(profileId.uuidString)
        }
        
        targetProfile.isDefault = true
        try context.save()
        
        return true
    }
    
    // MARK: - Settings Data Access
    
    /// Handle settings-related method calls from Flutter
    private func handleSettingsCall(action: String, arguments: Any?, context: ModelContext) async throws -> Any? {
        switch action {
        case "getAppSettings":
            return try await getAppSettings(context: context)
        case "updateAppSettings":
            return try await updateAppSettings(arguments: arguments, context: context)
        default:
            throw SwiftDataBridgeError.unknownAction(action)
        }
    }
    
    /// Get app settings as dictionary for Flutter
    private func getAppSettings(context: ModelContext) async throws -> [String: Any] {
        let descriptor = FetchDescriptor<AppSettingsSwiftData>()
        let settings = try context.fetch(descriptor)
        
        // Return first settings object or create default
        if let appSettings = settings.first {
            return appSettings.toDictionary()
        } else {
            // Create default settings
            let defaultSettings = AppSettingsSwiftData()
            context.insert(defaultSettings)
            try context.save()
            return defaultSettings.toDictionary()
        }
    }
    
    /// Update app settings from Flutter data
    private func updateAppSettings(arguments: Any?, context: ModelContext) async throws -> [String: Any] {
        guard let settingsData = arguments as? [String: Any] else {
            throw SwiftDataBridgeError.invalidArguments("Expected settings dictionary")
        }
        
        let descriptor = FetchDescriptor<AppSettingsSwiftData>()
        let settings = try context.fetch(descriptor)
        
        let appSettings: AppSettingsSwiftData
        if let existingSettings = settings.first {
            appSettings = existingSettings
        } else {
            appSettings = AppSettingsSwiftData()
            context.insert(appSettings)
        }
        
        try appSettings.updateFromDictionary(settingsData)
        try context.save()
        
        return appSettings.toDictionary()
    }
    
    // MARK: - Migration Support
    
    /// Handle migration-related method calls from Flutter
    private func handleMigrationCall(action: String, arguments: Any?, context: ModelContext) async throws -> Any? {
        switch action {
        case "migrateFromHive":
            return try await migrateFromHive(arguments: arguments, context: context)
        case "isMigrationComplete":
            return isMigrationComplete()
        case "markMigrationComplete":
            return markMigrationComplete()
        default:
            throw SwiftDataBridgeError.unknownAction(action)
        }
    }
    
    /// Migrate data from Flutter Hive to SwiftData
    private func migrateFromHive(arguments: Any?, context: ModelContext) async throws -> Bool {
        guard let migrationData = arguments as? [String: Any] else {
            throw SwiftDataBridgeError.invalidArguments("Expected migration data dictionary")
        }
        
        // Migrate profiles
        if let profilesData = migrationData["profiles"] as? [[String: Any]] {
            for profileDict in profilesData {
                let profile = try ProfileSwiftData.fromDictionary(profileDict)
                context.insert(profile)
            }
        }
        
        // Migrate app settings  
        if let settingsData = migrationData["settings"] as? [String: Any] {
            let appSettings = try AppSettingsSwiftData.fromDictionary(settingsData)
            context.insert(appSettings)
        }
        
        try context.save()
        
        // Mark migration as complete
        markMigrationComplete()
        
        LoggingService.shared.info("Data migration from Hive to SwiftData completed", category: .migration)
        return true
    }
    
    /// Check if migration from Hive to SwiftData is complete
    private func isMigrationComplete() -> Bool {
        return UserDefaults.standard.bool(forKey: "HIVE_TO_SWIFTDATA_MIGRATION_COMPLETE")
    }
    
    /// Mark migration as complete
    private func markMigrationComplete() -> Bool {
        UserDefaults.standard.set(true, forKey: "HIVE_TO_SWIFTDATA_MIGRATION_COMPLETE")
        return true
    }
    
    // MARK: - Indexer Data Handlers
    
    private func handleGetAllIndexers(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not initialized", details: nil))
            return
        }
        
        do {
            let indexers = try modelContext.fetch(FetchDescriptor<IndexerSwiftData>())
            let indexerDicts = indexers.map { $0.toDictionary() }
            result(indexerDicts)
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleGetIndexer(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any],
              let idString = args["id"] as? String,
              let id = UUID(uuidString: idString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Indexer ID required", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<IndexerSwiftData>(
                predicate: #Predicate<IndexerSwiftData> { $0.id == id }
            )
            let indexers = try modelContext.fetch(descriptor)
            
            if let indexer = indexers.first {
                result(indexer.toDictionary())
            } else {
                result(nil)
            }
        } catch {
            result(FlutterError(code: "FETCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleCreateIndexer(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any],
              let indexer = IndexerSwiftData.fromDictionary(args) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Valid indexer data required", details: nil))
            return
        }
        
        do {
            modelContext.insert(indexer)
            try modelContext.save()
            result(indexer.toDictionary())
        } catch {
            result(FlutterError(code: "CREATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleUpdateIndexer(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any],
              let idString = args["id"] as? String,
              let id = UUID(uuidString: idString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Indexer ID and data required", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<IndexerSwiftData>(
                predicate: #Predicate<IndexerSwiftData> { $0.id == id }
            )
            let indexers = try modelContext.fetch(descriptor)
            
            guard let indexer = indexers.first else {
                result(FlutterError(code: "NOT_FOUND", message: "Indexer not found", details: nil))
                return
            }
            
            indexer.updateFromHiveData(args)
            try modelContext.save()
            result(indexer.toDictionary())
        } catch {
            result(FlutterError(code: "UPDATE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleDeleteIndexer(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext,
              let args = call.arguments as? [String: Any],
              let idString = args["id"] as? String,
              let id = UUID(uuidString: idString) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Indexer ID required", details: nil))
            return
        }
        
        do {
            let descriptor = FetchDescriptor<IndexerSwiftData>(
                predicate: #Predicate<IndexerSwiftData> { $0.id == id }
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
    
    // MARK: - Migration Handlers
    
    private func handleMigrateFromHive(result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not initialized", details: nil))
            return
        }
        
        do {
            // Initialize DataMigrationManager with existing method channel
            let migrationManager = DataMigrationManager(
                modelContext: modelContext,
                methodChannel: self.methodChannel
            )
            
            // Perform migration from Hive to SwiftData
            try await migrationManager.syncFromHive()
            
            // Mark migration as complete
            UserDefaults.standard.set(true, forKey: "HIVE_TO_SWIFTDATA_MIGRATION_COMPLETE")
            
            LoggingService.shared.info("Migration from Hive to SwiftData completed successfully", category: .migration)
            result(true)
        } catch {
            LoggingService.shared.error("Migration from Hive to SwiftData failed", error: error, category: .migration)
            result(FlutterError(code: "MIGRATION_ERROR", message: error.localizedDescription, details: nil))
        }
    }
}

// MARK: - Error Types

enum SwiftDataBridgeError: Error, LocalizedError {
    case unknownService(String)
    case unknownAction(String)
    case invalidArguments(String)
    case profileNotFound(String)
    case cannotDeleteLastProfile
    
    var errorDescription: String? {
        switch self {
        case .unknownService(let service):
            return "Unknown service: \(service)"
        case .unknownAction(let action):
            return "Unknown action: \(action)"
        case .invalidArguments(let message):
            return "Invalid arguments: \(message)"
        case .profileNotFound(let id):
            return "Profile not found: \(id)"
        case .cannotDeleteLastProfile:
            return "Cannot delete the last remaining profile"
        }
    }
}