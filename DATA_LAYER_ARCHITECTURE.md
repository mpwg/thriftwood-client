# Data Layer Architecture - SwiftUI Implementation

## Overview

The SwiftUI implementation uses **DataLayerManager** as the unified data access layer, which automatically switches between SwiftData and Flutter's Hive storage based on the `HYBRID_SETTINGS_USE_SWIFTUI` toggle.

## Architecture Components

### 1. DataLayerManager (Primary Interface)

**Purpose**: Unified data access API that transparently switches between storage backends.

**When to use**: For all profile and settings operations in SwiftUI views and ViewModels.

**API**:
```swift
// Get data
let profile = try await DataLayerManager.shared.getActiveProfile()
let allProfiles = try await DataLayerManager.shared.getAllProfiles()
let settings = try await DataLayerManager.shared.getAppSettings()

// Save data
try await DataLayerManager.shared.saveProfile(profile)
try await DataLayerManager.shared.saveAppSettings(settings)
```

**Behavior**:
- When toggle is **OFF** (default): Uses Flutter's Hive storage
- When toggle is **ON**: Uses SwiftData + syncs changes back to Hive

### 2. HiveDataManager (Direct Hive Access)

**Purpose**: Direct access to Flutter's Hive storage for system operations.

**When to use**: Only for system-level operations that must maintain Flutter compatibility:
- Backup/Restore operations (`exportConfiguration()`, `importConfiguration()`)
- Clear configuration operations (`clearAllConfiguration()`)
- System log operations
- Any operation that needs to work identically with Flutter's implementation

**NOT for use**: Regular profile/settings read/write operations (use DataLayerManager instead)

### 3. DataMigrationManager (Internal)

**Purpose**: Handles bidirectional sync between Hive and SwiftData.

**When to use**: Never directly. Used internally by DataLayerManager during migrations.

## Updated Components

### SettingsViewModel

**Before**:
```swift
private let dataManager: HiveDataManager
init(dataManager: HiveDataManager = .shared) {
    self.dataManager = dataManager
}

func loadSettings() async {
    // Complex logic with storageService fallback
    if let loadedSettings = try await storageService.load(...) {
        // ...
    } else if let hiveSettings = try await dataManager.loadSettingsFromHive() {
        // ...
    }
}
```

**After**:
```swift
private let dataLayerManager: DataLayerManager
init(dataLayerManager: DataLayerManager = .shared) {
    self.dataLayerManager = dataLayerManager
}

func loadSettings() async {
    // Simple, unified access
    appSettings = try await dataLayerManager.getAppSettings()
}
```

### Benefits

1. **Automatic Storage Selection**: ViewModels don't need to know which storage is being used
2. **Seamless Migration**: Toggle changes automatically trigger data migration
3. **Bidirectional Sync**: Changes in SwiftUI mode sync back to Hive for Flutter compatibility
4. **Zero Data Loss**: Both storage systems stay consistent

## Data Flow

### When Toggle is OFF (Flutter Mode)

```
SwiftUI View
    ↓
SettingsViewModel.loadSettings()
    ↓
DataLayerManager.getAppSettings()
    ↓ (useSwiftData = false)
DataLayerManager.getAppSettingsFromHive()
    ↓
Flutter Hive Storage
```

### When Toggle is ON (SwiftUI Mode)

```
SwiftUI View
    ↓
SettingsViewModel.loadSettings()
    ↓
DataLayerManager.getAppSettings()
    ↓ (useSwiftData = true)
DataLayerManager.getAppSettingsFromSwiftData()
    ↓
SwiftData Storage
```

### When Saving Data (SwiftUI Mode)

```
SwiftUI View
    ↓
SettingsViewModel.saveSettings()
    ↓
DataLayerManager.saveAppSettings()
    ↓ (useSwiftData = true)
├─→ DataLayerManager.saveAppSettingsToSwiftData()
│       ↓
│   SwiftData Storage (primary)
│
└─→ DataLayerManager.syncAppSettingsToHive()
        ↓
    Flutter Hive Storage (for compatibility)
```

## Validation

The implementation has been validated to ensure:

✅ **SettingsViewModel** uses DataLayerManager for all profile/settings operations
✅ **DataLayerManager** properly switches between SwiftData and Hive based on toggle
✅ **Bidirectional sync** maintains data consistency across both storage systems
✅ **HiveDataManager** is only used for system operations (backup/restore/clear)
✅ **SwiftData operations** use proper FetchDescriptor and @Model patterns
✅ **No direct Hive access** from ViewModels for regular data operations

## Testing Recommendations

1. **Toggle OFF → ON**: Verify data migrates from Hive to SwiftData
2. **Toggle ON**: Verify profile changes save to SwiftData
3. **Toggle ON**: Verify changes sync back to Hive (check from Flutter)
4. **Toggle ON → OFF**: Verify Flutter sees all changes
5. **Backup/Restore**: Verify system operations still work with Hive
6. **Clear Config**: Verify clear operations reset both storage systems

## Notes

- System operations (backup/restore/clear/logs) intentionally use HiveDataManager directly for Flutter compatibility
- Regular profile/settings operations MUST use DataLayerManager
- DataLayerManager is a singleton accessible via `.shared`
- The toggle state is monitored via NotificationCenter from Flutter
