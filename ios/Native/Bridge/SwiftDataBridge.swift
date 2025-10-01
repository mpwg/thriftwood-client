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
    private var modelContext: ModelContext?
    
    /// Method channel for Flutter communication
    private var methodChannel: FlutterMethodChannel?
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        setupSwiftDataContext()
    }
    
    /// Initialize the bridge with Flutter method channel
    func initialize(with flutterViewController: FlutterViewController) {
        methodChannel = FlutterMethodChannel(
            name: "com.thriftwood.swift_data",
            binaryMessenger: flutterViewController.binaryMessenger
        )
        
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            Task { @MainActor in
                await self?.handleFlutterMethodCall(call, result: result)
            }
        }
        
        print("✅ SwiftDataBridge initialized and ready for Flutter access")
    }
    
    /// Setup SwiftData model context
    private func setupSwiftDataContext() {
        do {
            let container = try ModelContainer(
                for: ProfileSwiftData.self, AppSettingsSwiftData.self
            )
            modelContext = ModelContext(container)
            print("✅ SwiftData context initialized")
        } catch {
            print("❌ Failed to initialize SwiftData context: \(error)")
        }
    }
    
    // MARK: - Flutter Method Call Handler
    
    /// Handle method calls from Flutter
    private func handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let modelContext = modelContext else {
            result(FlutterError(code: "NO_CONTEXT", message: "SwiftData context not initialized", details: nil))
            return
        }
        
        let components = call.method.split(separator: ".")
        guard components.count >= 2 else {
            result(FlutterError(code: "INVALID_METHOD", message: "Method format should be 'service.action'", details: nil))
            return
        }
        
        let service = String(components[0])
        let action = String(components[1])
        
        do {
            let response = try await handleServiceCall(service: service, action: action, arguments: call.arguments, context: modelContext)
            result(response)
        } catch {
            result(FlutterError(code: "BRIDGE_ERROR", message: error.localizedDescription, details: nil))
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
        
        print("✅ Data migration from Hive to SwiftData completed")
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