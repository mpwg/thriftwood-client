//
//  HiveDataManager.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  Manages bidirectional data sync between SwiftUI and Flutter's Hive storage
//

import Foundation
import Flutter

// MARK: - Hive Data Manager

/// Manages bidirectional data sync between SwiftUI and Flutter's Hive storage
@Observable
class HiveDataManager {
    static let shared = HiveDataManager()
    
    private var methodChannel: FlutterMethodChannel?
    private let storageService: StorageService
    
    private init() {
        self.storageService = UserDefaultsStorageService()
    }
    
    /// Initialize with method channel for Flutter communication
    func initialize(with channel: FlutterMethodChannel) {
        self.methodChannel = channel
        setupMethodCallHandler()
    }
    
    /// Setup method call handler for receiving data from Flutter
    private func setupMethodCallHandler() {
        methodChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            Task { @MainActor in
                await self?.handleMethodCall(call: call, result: result)
            }
        }
    }
    
    /// Handle method calls from Flutter
    @MainActor
    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        switch call.method {
        case "syncSettingsFromHive":
            await handleSyncSettingsFromHive(call: call, result: result)
        case "syncProfileFromHive":
            await handleSyncProfileFromHive(call: call, result: result)
        case "getSettingsForHive":
            await handleGetSettingsForHive(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Public Methods
    
    /// Sync settings to Flutter's Hive storage
    func syncSettings(_ settings: ThriftwoodAppSettings) async {
        do {
            let settingsDict = try settings.toDictionary()
            
            await methodChannel?.invokeMethod("updateHiveSettings", arguments: [
                "settings": settingsDict
            ])
        } catch {
            print("Error syncing settings to Hive: \(error)")
        }
    }
    
    /// Notify Flutter of profile change
    func notifyProfileChange(_ profileName: String) async {
        await methodChannel?.invokeMethod("profileChanged", arguments: [
            "profile": profileName
        ])
    }
    
    /// Load settings from Flutter's Hive storage
    func loadSettingsFromHive() async throws -> ThriftwoodAppSettings? {
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel?.invokeMethod("getHiveSettings", arguments: nil) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: HiveDataError.flutterError(error.message ?? "Unknown error"))
                    } else if let settingsDict = result as? [String: Any] {
                        do {
                            let settings = try ThriftwoodAppSettings.fromDictionary(settingsDict)
                            continuation.resume(returning: settings)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    
    /// Save specific profile to Hive
    func saveProfileToHive(_ profile: ThriftwoodProfile) async {
        do {
            let profileDict = try profile.toDictionary()
            
            await methodChannel?.invokeMethod("updateHiveProfile", arguments: [
                "profileName": profile.name,
                "profile": profileDict
            ])
        } catch {
            print("Error saving profile to Hive: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    /// Handle sync settings from Hive
    @MainActor
    private func handleSyncSettingsFromHive(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let args = call.arguments as? [String: Any],
              let settingsDict = args["settings"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid settings data", details: nil))
            return
        }
        
        do {
            let settings = try ThriftwoodAppSettings.fromDictionary(settingsDict)
            try await storageService.save(settings, forKey: "app_settings")
            
            // Notify any observers that settings changed
            NotificationCenter.default.post(name: .settingsDidUpdate, object: settings)
            
            result(true)
        } catch {
            result(FlutterError(code: "SYNC_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    /// Handle sync profile from Hive
    @MainActor
    private func handleSyncProfileFromHive(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let args = call.arguments as? [String: Any],
              let profileName = args["profileName"] as? String,
              let profileDict = args["profile"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid profile data", details: nil))
            return
        }
        
        do {
            let profile = try ThriftwoodProfile.fromDictionary(profileDict)
            
            // Load current settings and update the profile
            if var settings = try await storageService.load(ThriftwoodAppSettings.self, forKey: "app_settings") {
                settings.profiles[profileName] = profile
                try await storageService.save(settings, forKey: "app_settings")
                
                // Notify observers
                NotificationCenter.default.post(name: .profileDidUpdate, object: ["profileName": profileName, "profile": profile])
            }
            
            result(true)
        } catch {
            result(FlutterError(code: "SYNC_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    /// Handle get settings for Hive
    @MainActor
    private func handleGetSettingsForHive(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        do {
            if let settings = try await storageService.load(ThriftwoodAppSettings.self, forKey: "app_settings") {
                let settingsDict = try settings.toDictionary()
                result(settingsDict)
            } else {
                result(nil)
            }
        } catch {
            result(FlutterError(code: "LOAD_ERROR", message: error.localizedDescription, details: nil))
        }
    }
}

// MARK: - Storage Service Protocol

protocol StorageService {
    func save<T: Codable>(_ object: T, forKey key: String) async throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T?
    func delete(forKey key: String) async throws
}

// MARK: - UserDefaults Storage Implementation

class UserDefaultsStorageService: StorageService {
    private let userDefaults = UserDefaults.standard
    
    func save<T: Codable>(_ object: T, forKey key: String) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        userDefaults.set(data, forKey: key)
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func delete(forKey key: String) async throws {
        userDefaults.removeObject(forKey: key)
    }
}

// MARK: - Errors

enum HiveDataError: LocalizedError {
    case flutterError(String)
    case encodingError(String)
    case decodingError(String)
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .flutterError(let message):
            return "Flutter error: \(message)"
        case .encodingError(let message):
            return "Encoding error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .notFound:
            return "Data not found"
        }
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let settingsDidUpdate = Notification.Name("settingsDidUpdate")
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}

// MARK: - Model Extensions for Dictionary Conversion

extension ThriftwoodAppSettings {
    func toDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw HiveDataError.encodingError("Failed to convert to dictionary")
        }
        
        return dictionary
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) throws -> ThriftwoodAppSettings {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        let decoder = JSONDecoder()
        return try decoder.decode(ThriftwoodAppSettings.self, from: data)
    }
}

extension ThriftwoodProfile {
    func toDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw HiveDataError.encodingError("Failed to convert profile to dictionary")
        }
        
        return dictionary
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) throws -> ThriftwoodProfile {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        let decoder = JSONDecoder()
        return try decoder.decode(ThriftwoodProfile.self, from: data)
    }
}