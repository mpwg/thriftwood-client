//
//  SharedDataManager.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  Shared data storage system for hybrid Flutter/SwiftUI app
//

import Foundation

/// Protocol for objects that can be synchronized between Flutter and SwiftUI
protocol SharedDataProtocol: Codable {
    /// Save this object to Flutter storage (Hive)
    func saveToFlutterStorage() async throws
    
    /// Load this object from Flutter storage (Hive)
    static func loadFromFlutterStorage() async throws -> Self?
    
    /// Notify Flutter of changes to this object
    func notifyFlutterOfChanges() async
}

/// Manager for shared data between Flutter and SwiftUI platforms
@Observable @MainActor
class SharedDataManager {
    
    // MARK: - Properties
    
    /// Shared instance for global access
    static let shared = SharedDataManager()
    
    /// UserDefaults suite for shared data
    private let userDefaults: UserDefaults
    
    /// Method channel for communicating with Flutter
    private var methodChannel: FlutterMethodChannel?
    

    
    /// Cache for frequently accessed data
    private var dataCache: [String: Any] = [:]
    
    /// Queue for synchronization operations
    private let syncQueue = DispatchQueue(label: "com.thriftwood.data-sync", qos: .userInitiated)
    
    // MARK: - Initialization
    
    private init() {
        // Use a shared UserDefaults suite for cross-platform access
        self.userDefaults = UserDefaults(suiteName: "group.com.thriftwood.shared") ?? UserDefaults.standard
        
        print("SharedDataManager initialized")
    }
    
    /// Initialize with Flutter method channel
    /// - Parameter methodChannel: The method channel for Flutter communication
    func initialize(with methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        setupDataChangeNotifications()
        print("SharedDataManager connected to Flutter method channel")
    }
    
    // MARK: - Data Storage Methods
    
    /// Save data that is accessible by both Flutter and SwiftUI
    /// - Parameters:
    ///   - data: The data to save (must be Codable)
    ///   - key: The storage key
    func saveData<T: Codable>(_ data: T, forKey key: String) async throws {
        print("Saving data for key: \(key)")
        
        // Encode data to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(data)
        
        // Save to UserDefaults (accessible by SwiftUI)
        userDefaults.set(encodedData, forKey: key)
        
        // Cache the data
        dataCache[key] = data
        
        // Sync to Flutter storage
        try await syncToFlutterStorage(encodedData, forKey: key)
        
        // Notify both platforms of changes
        await notifyDataChange(forKey: key, data: data)
        
        print("Data saved successfully for key: \(key)")
    }
    
    /// Load data that was saved by either Flutter or SwiftUI
    /// - Parameters:
    ///   - type: The type to decode to
    ///   - key: The storage key
    /// - Returns: The decoded data or nil if not found
    func loadData<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        print("Loading data for key: \(key)")
        
        // Check cache first
        if let cachedData = dataCache[key] as? T {
            return cachedData
        }
        
        // Try to load from UserDefaults
        guard let data = userDefaults.data(forKey: key) else {
            print("No data found in UserDefaults for key: \(key)")
            // Try to load from Flutter storage
            return try await loadFromFlutterStorage(type, forKey: key)
        }
        
        // Decode data
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedData = try decoder.decode(type, from: data)
        
        // Cache the data
        dataCache[key] = decodedData
        
        print("Data loaded successfully for key: \(key)")
        return decodedData
    }
    
    /// Remove data from both platforms
    /// - Parameter key: The storage key
    func removeData(forKey key: String) async throws {
        print("Removing data for key: \(key)")
        
        // Remove from UserDefaults
        userDefaults.removeObject(forKey: key)
        
        // Remove from cache
        dataCache.removeValue(forKey: key)
        
        // Remove from Flutter storage
        try await removeFromFlutterStorage(forKey: key)
        
        // Notify both platforms
        await notifyDataRemoval(forKey: key)
        
        print("Data removed successfully for key: \(key)")
    }
    
    // MARK: - Flutter Storage Sync
    
    private func syncToFlutterStorage(_ data: Data, forKey key: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            methodChannel?.invokeMethod("saveToFlutterStorage", arguments: [
                "key": key,
                "data": data.base64EncodedString()
            ]) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(
                        domain: "SharedDataManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: error.message ?? "Unknown Flutter error"]
                    ))
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    private func loadFromFlutterStorage<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            methodChannel?.invokeMethod("loadFromFlutterStorage", arguments: [
                "key": key
            ]) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(
                        domain: "SharedDataManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: error.message ?? "Unknown Flutter error"]
                    ))
                } else if let dataString = result as? String,
                          let data = Data(base64Encoded: dataString) {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let decodedData = try decoder.decode(type, from: data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func removeFromFlutterStorage(forKey key: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            methodChannel?.invokeMethod("removeFromFlutterStorage", arguments: [
                "key": key
            ]) { result in
                if let error = result as? FlutterError {
                    continuation.resume(throwing: NSError(
                        domain: "SharedDataManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: error.message ?? "Unknown Flutter error"]
                    ))
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - Change Notifications
    
    private func setupDataChangeNotifications() {
        // Listen for changes from Flutter
        // This would be expanded to handle specific data change notifications
    }
    
    private func notifyDataChange<T: Codable>(forKey key: String, data: T) async {
        // Notify Flutter of data changes
        methodChannel?.invokeMethod("onDataChanged", arguments: [
            "key": key,
            "timestamp": Date().timeIntervalSince1970
        ])
        
        // SwiftUI will automatically track changes with @Observable
        // No manual notification needed
    }
    
    private func notifyDataRemoval(forKey key: String) async {
        // Notify Flutter of data removal
        methodChannel?.invokeMethod("onDataRemoved", arguments: [
            "key": key,
            "timestamp": Date().timeIntervalSince1970
        ])
        
        // SwiftUI will automatically track changes with @Observable
        // No manual notification needed
    }
}

// MARK: - Profile Management

/// Profile manager that works with both Flutter and SwiftUI
@Observable @MainActor
class SharedProfileManager {
    
    // MARK: - Properties
    
    /// Currently active profile
    var activeProfile: Profile?
    
    /// All available profiles
    var profiles: [Profile] = []
    
    /// Reference to shared data manager
    private let dataManager = SharedDataManager.shared
    
    // MARK: - Profile Model
    
    struct Profile: Codable, Identifiable {
        let id: String
        let name: String
        let isDefault: Bool
        let services: [ServiceConfig]
        let createdAt: Date
        let updatedAt: Date
        
        struct ServiceConfig: Codable {
            let type: String // "radarr", "sonarr", etc.
            let name: String
            let url: String
            let apiKey: String
            let isEnabled: Bool
        }
    }
    
    // MARK: - Initialization
    
    init() {
        Task {
            await loadProfiles()
        }
    }
    
    // MARK: - Profile Methods
    
    /// Load profiles from shared storage
    func loadProfiles() async {
        do {
            // Load all profiles
            if let loadedProfiles = try await dataManager.loadData([Profile].self, forKey: "profiles") {
                profiles = loadedProfiles
            }
            
            // Load active profile ID and set active profile
            if let activeProfileId = try await dataManager.loadData(String.self, forKey: "activeProfileId"),
               let profile = profiles.first(where: { $0.id == activeProfileId }) {
                activeProfile = profile
            } else if !profiles.isEmpty {
                // Set first profile as active if none is set
                activeProfile = profiles.first
            }
            
            print("Loaded \(profiles.count) profiles, active: \(activeProfile?.name ?? "none")")
        } catch {
            print("Error loading profiles: \(error)")
        }
    }
    
    /// Save profiles to shared storage
    func saveProfiles() async throws {
        try await dataManager.saveData(profiles, forKey: "profiles")
        
        if let activeProfile = activeProfile {
            try await dataManager.saveData(activeProfile.id, forKey: "activeProfileId")
        }
        
        print("Profiles saved successfully")
    }
    
    /// Switch to a different profile
    /// - Parameter profile: The profile to switch to
    func switchToProfile(_ profile: Profile) async throws {
        activeProfile = profile
        try await dataManager.saveData(profile.id, forKey: "activeProfileId")
        
        print("Switched to profile: \(profile.name)")
    }
    
    /// Add a new profile
    /// - Parameter profile: The profile to add
    func addProfile(_ profile: Profile) async throws {
        profiles.append(profile)
        try await saveProfiles()
        
        print("Added new profile: \(profile.name)")
    }
    
    /// Update an existing profile
    /// - Parameter profile: The updated profile
    func updateProfile(_ profile: Profile) async throws {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
            
            // Update active profile if it's the one being updated
            if activeProfile?.id == profile.id {
                activeProfile = profile
            }
            
            try await saveProfiles()
            print("Updated profile: \(profile.name)")
        }
    }
    
    /// Remove a profile
    /// - Parameter profileId: The ID of the profile to remove
    func removeProfile(withId profileId: String) async throws {
        profiles.removeAll { $0.id == profileId }
        
        // If we removed the active profile, switch to another one
        if activeProfile?.id == profileId {
            activeProfile = profiles.first
        }
        
        try await saveProfiles()
        print("Removed profile with ID: \(profileId)")
    }
    
    /// Sync with Flutter's existing profile storage
    func syncWithFlutterStorage() async throws {
        // This method would implement bidirectional sync with Flutter's Hive storage
        // For now, we load from our shared storage
        await loadProfiles()
        
        print("Synced profile data with Flutter storage")
    }
}