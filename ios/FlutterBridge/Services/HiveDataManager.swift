//
//  HiveDataManager.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  Manages bidirectional data sync between SwiftUI and Flutter's Hive storage
//

import Foundation
import Flutter

// Import the Luna log types from SettingsViewModel
// Note: In a real implementation, these would be in separate model files

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
    func syncSettings(_ settings: ThriftwoodAppSettings) async throws {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        let settingsDict = try settings.toDictionary()
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel.invokeMethod("updateHiveSettings", arguments: [
                    "settings": settingsDict
                ]) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: HiveDataError.flutterError(
                            "Failed to sync settings to Hive: \(error.message ?? "Unknown error"). " +
                            "Code: \(error.code), Details: \(error.details.map { "\($0)" } ?? "None")"
                        ))
                    } else {
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    /// Notify Flutter of profile change
    func notifyProfileChange(_ profileName: String) async throws {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel.invokeMethod("profileChanged", arguments: [
                    "profile": profileName
                ]) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: HiveDataError.flutterError(
                            "Failed to notify Flutter of profile change '\(profileName)': \(error.message ?? "Unknown error"). " +
                            "Code: \(error.code), Details: \(error.details.map { "\($0)" } ?? "None")"
                        ))
                    } else {
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    /// Load settings from Flutter's Hive storage
    func loadSettingsFromHive() async throws -> ThriftwoodAppSettings? {
        guard let methodChannel = methodChannel else {
            print("Warning: Method channel not initialized, cannot load from Hive storage")
            return nil
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel.invokeMethod("getHiveSettings", arguments: nil) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: HiveDataError.flutterError(
                            "Failed to load settings from Hive: \(error.message ?? "Unknown error"). " +
                            "Code: \(error.code), Details: \(error.details.map { "\($0)" } ?? "None")"
                        ))
                    } else if let settingsDict = result as? [String: Any] {
                        do {
                            let settings = try ThriftwoodAppSettings.fromDictionary(settingsDict)
                            continuation.resume(returning: settings)
                        } catch {
                            continuation.resume(throwing: HiveDataError.decodingError(
                                "Failed to decode settings from Hive data: \(error.localizedDescription). " +
                                "Data keys: \(settingsDict.keys.sorted())"
                            ))
                        }
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    
    /// Save specific profile to Hive
    func saveProfileToHive(_ profile: ThriftwoodProfile) async throws {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        let profileDict = try profile.toDictionary()
        
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                methodChannel.invokeMethod("updateHiveProfile", arguments: [
                    "profileName": profile.name,
                    "profile": profileDict
                ]) { result in
                    if let error = result as? FlutterError {
                        continuation.resume(throwing: HiveDataError.flutterError(
                            "Failed to save profile '\(profile.name)' to Hive: \(error.message ?? "Unknown error"). " +
                            "Code: \(error.code), Details: \(error.details.map { "\($0)" } ?? "None")"
                        ))
                    } else {
                        continuation.resume()
                    }
                }
            }
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
    
    // MARK: - System Methods for Flutter Compatibility
    
    /// Export configuration using Flutter's LunaConfig.export() pattern
    func exportConfiguration() async throws -> Data {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            methodChannel.invokeMethod("exportConfiguration", arguments: nil) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(domain: error.code, code: 0, userInfo: [NSLocalizedDescriptionKey: error.message ?? "Export failed"]))
                } else if let jsonString = result as? String {
                    if let data = jsonString.data(using: .utf8) {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: HiveDataError.encodingError("Failed to encode configuration"))
                    }
                } else {
                    continuation.resume(throwing: HiveDataError.unknownError("Invalid export response"))
                }
            }
        }
    }
    
    /// Import configuration using Flutter's LunaConfig.import() pattern
    func importConfiguration(_ data: Data) async throws {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw HiveDataError.encodingError("Failed to decode configuration data")
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            methodChannel.invokeMethod("importConfiguration", arguments: jsonString) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(domain: error.code, code: 0, userInfo: [NSLocalizedDescriptionKey: error.message ?? "Import failed"]))
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    /// Clear all configuration using Flutter's LunaDatabase.bootstrap() pattern
    func clearAllConfiguration() async throws {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            methodChannel.invokeMethod("clearAllConfiguration", arguments: nil) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(domain: error.code, code: 0, userInfo: [NSLocalizedDescriptionKey: error.message ?? "Clear configuration failed"]))
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    /// Get logs using Flutter's LunaBox.logs.data pattern
    func getLogs() async throws -> [LunaLogEntry] {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            methodChannel.invokeMethod("getLogs", arguments: nil) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(domain: error.code, code: 0, userInfo: [NSLocalizedDescriptionKey: error.message ?? "Get logs failed"]))
                } else if let logsArray = result as? [[String: Any]] {
                    // Debug: Print first log entry to see the actual structure
                    if let firstLog = logsArray.first {
                        print("HiveDataManager DEBUG - First log structure:")
                        for (key, value) in firstLog {
                            print("  \(key): \(value) (\(type(of: value)))")
                        }
                    }
                    
                    do {
                        let logs = try logsArray.map { logDict -> LunaLogEntry in
                            // Handle timestamp: Flutter sends ISO8601 string, convert to milliseconds
                            guard let timestampString = logDict["timestamp"] as? String,
                                  let timestampDate = ISO8601DateFormatter().date(from: timestampString),
                                  let typeString = logDict["type"] as? String,
                                  let type = LunaLogType(rawValue: typeString),
                                  let message = logDict["message"] as? String else {
                                throw HiveDataError.decodingError("Invalid log format: missing required fields")
                            }
                            
                            // Convert ISO8601 date back to milliseconds since epoch (to match Flutter format)
                            let timestamp = Int(timestampDate.timeIntervalSince1970 * 1000)
                            
                            // Handle stack trace: Flutter sends as array, join to string
                            var stackTraceString: String? = nil
                            if let stackTraceArray = logDict["stack_trace"] as? [String] {
                                stackTraceString = stackTraceArray.joined(separator: "\n")
                            }
                            
                            return LunaLogEntry(
                                timestamp: timestamp,
                                type: type,
                                className: logDict["class_name"] as? String,  // Flutter uses "class_name"
                                methodName: logDict["method_name"] as? String,  // Flutter uses "method_name"
                                message: message,
                                error: logDict["error"] as? String,
                                stackTrace: stackTraceString
                            )
                        }
                        continuation.resume(returning: logs)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    /// Clear logs using Flutter's LunaLogger().clear() pattern
    func clearLogs() async throws {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            methodChannel.invokeMethod("clearLogs", arguments: nil) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(domain: error.code, code: 0, userInfo: [NSLocalizedDescriptionKey: error.message ?? "Clear logs failed"]))
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    /// Export logs using Flutter's LunaLogger().export() pattern
    func exportLogs() async throws -> Data {
        guard let methodChannel = methodChannel else {
            throw HiveDataError.channelNotInitialized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            methodChannel.invokeMethod("exportLogs", arguments: nil) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(domain: error.code, code: 0, userInfo: [NSLocalizedDescriptionKey: error.message ?? "Export logs failed"]))
                } else if let jsonString = result as? String {
                    if let data = jsonString.data(using: .utf8) {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: HiveDataError.encodingError("Failed to encode logs"))
                    }
                } else {
                    continuation.resume(throwing: HiveDataError.unknownError("Invalid logs export response"))
                }
            }
        }
    }
}
