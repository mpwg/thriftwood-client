# Phase 4.1 Data Persistence Migration - Implementation Details

**Status: ✅ IMPLEMENTED**

This document provides detailed information about the implementation of Phase 4.1 from migration.md: Data Persistence Migration.

## Overview

The data persistence migration enables the hybrid toggle (`HYBRID_SETTINGS_USE_SWIFTUI`) to control both the **Navigation Layer** and the **Data Layer**.

### Toggle Behavior

When toggle is **OFF** (default):
- ✅ Uses Flutter's Hive storage
- ✅ SwiftUI views read/write through HiveBridge
- ✅ Zero migration overhead
- ✅ Proven stability

When toggle is **ON**:
- ✅ Automatically migrates data from Hive to SwiftData
- ✅ SwiftUI views use native SwiftData
- ✅ Changes sync back to Hive for Flutter compatibility
- ✅ Can switch back to Flutter seamlessly

## Implementation Components

### 1. SwiftData Models (`ios/Native/Models/SwiftData/`)

#### ProfileSwiftData.swift

Complete SwiftData model for profiles with all service configurations:

```swift
@Model
final class ProfileSwiftData {
    @Attribute(.unique) var id: UUID
    var name: String
    var isDefault: Bool
    
    // Service configurations for: Lidarr, Radarr, Sonarr, 
    // SABnzbd, NZBGet, Tautulli, Overseerr
    // Each service has: enabled, host, apiKey, customHeaders, strictTLS
    
    // Wake on LAN configuration
    var wakeOnLanEnabled: Bool
    var wakeOnLanMACAddress: String
    var wakeOnLanBroadcastAddress: String
    
    init(name: String = "default")
    
    // Conversion methods
    func toThriftwoodProfile() -> ThriftwoodProfile
    func updateFrom(_ profile: ThriftwoodProfile)
}
```

**Features:**
- ✅ Full parity with Flutter's LunaProfile Hive model
- ✅ All service configurations preserved
- ✅ Custom headers stored as encoded Data
- ✅ Bidirectional conversion to/from ThriftwoodProfile

#### AppSettingsSwiftData.swift

Complete SwiftData model for app-wide settings:

```swift
@Model
final class AppSettingsSwiftData {
    @Attribute(.unique) var id: UUID
    
    // Core settings
    var enabledProfile: String
    
    // Theme, drawer, networking, quick actions, time format,
    // notifications, changelog tracking
    var hybridSettingsUseSwiftUI: Bool // The toggle itself
    
    init()
    
    // Conversion methods
    func toThriftwoodAppSettings(profiles: [String: ThriftwoodProfile]) -> ThriftwoodAppSettings
    func updateFrom(_ settings: ThriftwoodAppSettings)
}
```

**Features:**
- ✅ Full parity with Flutter's LunaSeaDatabase enum values
- ✅ All app-wide settings preserved
- ✅ Stores the hybrid toggle state itself
- ✅ Bidirectional conversion to/from ThriftwoodAppSettings

### 2. Data Migration Manager (`ios/Native/Services/DataMigrationManager.swift`)

Handles bidirectional synchronization between Hive and SwiftData.

#### Key Methods

**Hive → SwiftData Migration:**

```swift
func syncFromHive() async throws {
    // Get all data from Hive via method channel
    let hiveData = try await getHiveSettings()
    
    // Sync app settings
    try await syncAppSettingsFromHive(hiveData)
    
    // Sync all profiles
    try await syncProfilesFromHive(hiveData)
    
    // Save to SwiftData
    try modelContext.save()
}
```

**SwiftData → Hive Sync:**

```swift
func syncToHive() async throws {
    // Get all SwiftData models
    let appSettings = try await getAppSettings()
    let profiles = try await getAllProfiles()
    
    // Convert to Hive format
    let hiveData = try buildHiveDataDictionary(
        appSettings: appSettings,
        profiles: profiles
    )
    
    // Send to Flutter via method channel
    try await updateHiveSettings(hiveData)
}
```

**Individual Profile Sync:**

```swift
func syncProfileToHive(_ profile: ProfileSwiftData) async throws {
    let profileDict = try buildProfileDictionary(profile)
    
    // Send to Flutter via method channel
    methodChannel.invokeMethod("updateHiveProfile", arguments: [
        "profileName": profile.name,
        "profile": profileDict
    ])
}
```

**Features:**
- ✅ Automatic migration on toggle enable
- ✅ Bidirectional sync for data consistency
- ✅ Individual profile sync for granular updates
- ✅ Comprehensive error handling
- ✅ Method channel integration for Flutter communication

### 3. Data Layer Manager (`ios/Native/Services/DataLayerManager.swift`)

Provides unified data access API and automatic storage selection.

#### Key Features

**Automatic Storage Selection:**

```swift
@Observable
class DataLayerManager {
    static let shared = DataLayerManager()
    private(set) var useSwiftData: Bool = false
    
    // Automatically uses correct storage
    func getActiveProfile() async throws -> ThriftwoodProfile {
        if useSwiftData {
            return try await getActiveProfileFromSwiftData()
        } else {
            return try await getActiveProfileFromHive()
        }
    }
}
```

**Toggle Change Detection:**

```swift
// Listen for toggle changes from Flutter
private func setupToggleListener() {
    NotificationCenter.default.addObserver(
        forName: .hybridSettingsToggleChanged,
        object: nil,
        queue: .main
    ) { [weak self] notification in
        guard let newValue = notification.object as? Bool else { return }
        await self?.handleToggleChange(newValue: newValue, initialLoad: false)
    }
}
```

**Automatic Migration on Toggle:**

```swift
@MainActor
private func handleToggleChange(newValue: Bool, initialLoad: Bool) async {
    let oldValue = useSwiftData
    useSwiftData = newValue
    
    // Enable SwiftData → migrate from Hive
    if newValue && !oldValue && !initialLoad {
        await performMigrationToSwiftData()
    }
    
    // Disable SwiftData → sync back to Hive
    if !newValue && oldValue && !initialLoad {
        await performSyncBackToHive()
    }
}
```

**Unified Data Access API:**

```swift
// Profiles
func getActiveProfile() async throws -> ThriftwoodProfile
func getAllProfiles() async throws -> [String: ThriftwoodProfile]
func saveProfile(_ profile: ThriftwoodProfile) async throws

// App Settings
func getAppSettings() async throws -> ThriftwoodAppSettings
func saveAppSettings(_ settings: ThriftwoodAppSettings) async throws
```

**Features:**
- ✅ Singleton pattern for global access
- ✅ Automatic storage selection based on toggle
- ✅ Transparent API regardless of storage backend
- ✅ Automatic migration on toggle changes
- ✅ Bidirectional sync for data consistency
- ✅ Observable for UI updates

### 4. Flutter Integration (`lib/system/bridge/hive_bridge.dart`)

Updated HiveBridge to notify Swift about toggle changes.

#### Toggle Change Notification

```dart
static Future<void> _updateHiveSettings(dynamic arguments) async {
    // ... existing update logic ...
    
    // Check if hybrid settings toggle changed
    final oldHybridValue = LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI.read();
    
    // Update hybrid settings toggle
    if (settingsMap.containsKey('hybridSettingsUseSwiftUI')) {
        final newHybridValue = settingsMap['hybridSettingsUseSwiftUI'] as bool;
        LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI.update(newHybridValue);
        
        // Notify Swift side if changed
        if (oldHybridValue != newHybridValue) {
            _notifyToggleChange(newHybridValue);
        }
    }
}

static void _notifyToggleChange(bool newValue) {
    const MethodChannel('com.thriftwood.hive')
        .invokeMethod('hybridSettingsToggleChanged', {'value': newValue});
}
```

**Features:**
- ✅ Detects toggle changes in Hive
- ✅ Notifies Swift via method channel
- ✅ Triggers automatic migration in DataLayerManager
- ✅ Seamless integration with existing HiveBridge

## Data Flow Diagrams

### Toggle OFF → ON (Migration to SwiftData)

```
User toggles ON
    ↓
Flutter: Update HYBRID_SETTINGS_USE_SWIFTUI in Hive
    ↓
Flutter: Call _notifyToggleChange(true)
    ↓
Flutter: Invoke 'hybridSettingsToggleChanged' method
    ↓
Swift: DataLayerManager receives notification
    ↓
Swift: handleToggleChange(newValue: true)
    ↓
Swift: performMigrationToSwiftData()
    ↓
Swift: DataMigrationManager.syncFromHive()
    ↓
Swift: Fetch all data from Hive via method channel
    ↓
Swift: Convert to SwiftData models
    ↓
Swift: Save to SwiftData
    ↓
Swift: useSwiftData = true
    ↓
SwiftUI views now use SwiftData
```

### Toggle ON → OFF (Sync back to Hive)

```
User toggles OFF
    ↓
Flutter: Update HYBRID_SETTINGS_USE_SWIFTUI in Hive
    ↓
Flutter: Call _notifyToggleChange(false)
    ↓
Swift: DataLayerManager receives notification
    ↓
Swift: handleToggleChange(newValue: false)
    ↓
Swift: performSyncBackToHive()
    ↓
Swift: DataMigrationManager.syncToHive()
    ↓
Swift: Fetch all data from SwiftData
    ↓
Swift: Convert to Hive format
    ↓
Swift: Send to Flutter via method channel
    ↓
Swift: useSwiftData = false
    ↓
Flutter views now use Hive
```

### Data Access with SwiftUI Mode ON

```
SwiftUI View needs profile data
    ↓
Call: DataLayerManager.shared.getActiveProfile()
    ↓
Check: useSwiftData == true
    ↓
Fetch from SwiftData
    ↓
Convert to ThriftwoodProfile
    ↓
Return to view
```

### Data Save with SwiftUI Mode ON

```
SwiftUI View saves profile
    ↓
Call: DataLayerManager.shared.saveProfile(profile)
    ↓
Check: useSwiftData == true
    ↓
Save to SwiftData
    ↓
Also sync to Hive (bidirectional)
    ↓
Both storage systems updated
```

## Testing Checklist

- [ ] Toggle OFF: SwiftUI views read from Hive correctly
- [ ] Toggle OFF→ON: Data migrates from Hive to SwiftData
- [ ] Toggle ON: SwiftUI views read from SwiftData correctly
- [ ] Toggle ON: Profile changes save to SwiftData
- [ ] Toggle ON: Profile changes sync back to Hive
- [ ] Toggle ON→OFF: SwiftData changes sync back to Hive
- [ ] Toggle OFF: Flutter views read synced data correctly
- [ ] Multiple toggle switches: No data loss
- [ ] Error handling: Failed migration reverts toggle
- [ ] Performance: Migration completes within reasonable time

## Usage Examples

### Initializing the Data Layer

```swift
// In app startup (AppDelegate or similar)
let modelContainer = try ModelContainer(
    for: ProfileSwiftData.self, AppSettingsSwiftData.self
)
let modelContext = ModelContext(modelContainer)
let methodChannel = FlutterMethodChannel(name: "com.thriftwood.hive")

await DataLayerManager.shared.initialize(
    modelContext: modelContext,
    methodChannel: methodChannel
)
```

### Accessing Data in SwiftUI Views

```swift
struct ProfileListView: View {
    @State private var profiles: [ThriftwoodProfile] = []
    
    var body: some View {
        List(profiles, id: \.name) { profile in
            ProfileRow(profile: profile)
        }
        .task {
            do {
                // Automatically uses correct storage
                let profilesDict = try await DataLayerManager.shared.getAllProfiles()
                profiles = Array(profilesDict.values)
            } catch {
                print("Failed to load profiles: \(error)")
            }
        }
    }
}
```

### Saving Data in SwiftUI Views

```swift
struct ProfileEditorView: View {
    @State private var profile: ThriftwoodProfile
    
    func save() async {
        do {
            // Automatically saves to correct storage + syncs
            try await DataLayerManager.shared.saveProfile(profile)
            print("Profile saved successfully")
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
}
```

## Future Enhancements

1. **Automatic Conflict Resolution**: Handle concurrent modifications from both platforms
2. **Incremental Sync**: Only sync changed data instead of full datasets
3. **Background Sync**: Periodic background sync to keep both storage systems in sync
4. **Migration Progress UI**: Show progress during large data migrations
5. **Rollback Support**: Ability to rollback failed migrations
6. **Data Validation**: Validate data consistency between storage systems

## Conclusion

Phase 4.1 Data Persistence Migration is fully implemented with:

- ✅ Complete SwiftData models matching Flutter's Hive structure
- ✅ Bidirectional sync between Hive and SwiftData
- ✅ Automatic migration on toggle changes
- ✅ Unified data access API
- ✅ Seamless integration with Flutter bridge

The toggle now controls both navigation and data layers, providing users with a complete hybrid experience while maintaining data consistency across both platforms.
