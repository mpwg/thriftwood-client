# Migration Architecture Documentation

## Overview

This document defines the architectural separation between permanent SwiftUI code and migration-temporary Flutter bridge code in the Thriftwood iOS app.

## Directory Structure

```text
ios/
├── Native/                     # PERMANENT SwiftUI Architecture
│   ├── Views/                  # Pure SwiftUI views (will remain)
│   ├── ViewModels/             # Pure Swift view models (will remain)
│   ├── Models/                 # SwiftData models (will remain)
│   └── Services/               # Pure Swift services (will remain)
├── FlutterBridge/              # MIGRATION TEMPORARY (entire folder deleted when complete)
│   ├── Bridge/                 # Method channel handlers, bridge components
│   ├── Views/                  # Flutter integration extensions for views
│   ├── ViewModels/             # ViewModels with Flutter dependencies
│   ├── Models/                 # Model extensions for Flutter integration
│   ├── Services/               # Services for Flutter-SwiftUI data sync
│   ├── FlutterEngineManager.swift  # Flutter engine lifecycle management
│   └── Readme.md               # Documentation (this file)
├── Runner/                     # iOS App Structure
│   └── AppDelegate.swift       # Clean app delegate with migration markers
└── ...
```

## Separation Rules

### Code belongs in ios/Native if

- ✅ Pure SwiftUI views and components
- ✅ SwiftData models and persistence
- ✅ Pure Swift business logic
- ✅ Native iOS integrations
- ✅ Code that will remain after Flutter is removed

### Code belongs in ios/FlutterBridge if

- ⚠️ References `FlutterSwiftUIBridge`, method channels, or Flutter imports
- ⚠️ Manages data sync between Flutter Hive and Swift SwiftData
- ⚠️ Handles hybrid navigation between Flutter and SwiftUI
- ⚠️ Contains Flutter engine initialization or management
- ⚠️ Any code marked with "MIGRATION TEMPORARY" comments

## Implementation Strategy

### 1. File Splitting Approach

When only part of a file contains migration-temporary code:

```swift
// Main file (stays in ios/Native/)
struct DashboardView: View {
    // Pure SwiftUI implementation
}

// Extension file (goes in ios/FlutterBridge/)
extension DashboardView {
    // Flutter integration methods
    static func withFlutterIntegration() -> DashboardView {
        // Migration-temporary bridge setup
    }
}
```

### 2. Migration Markers

All migration-temporary code includes clear markers:

```swift
/// ⚠️ MIGRATION TEMPORARY: [Description]
/// This [code/file/class] will be DELETED when migration to pure SwiftUI is complete
```

### 3. AppDelegate Pattern

The AppDelegate.swift is kept clean with clear migration markers:

```swift
// MIGRATION TEMPORARY: Initialize Flutter for hybrid functionality
// TODO: Remove this when migration to pure SwiftUI is complete
FlutterEngineManager.shared.initializeFlutterEngine()
```

## Migration Completion Checklist

When the Flutter migration is complete:

1. **Delete entire `ios/FlutterBridge/` folder**
2. **Clean up AppDelegate.swift:**
   - Remove FlutterEngineManager references
   - Remove Flutter import statements
   - Remove migration TODO comments
3. **Update Podfile:**
   - Remove Flutter dependencies
   - Remove Flutter-related pod configurations
4. **Clean up Native files:**
   - Remove any remaining Flutter import statements
   - Remove migration-temporary extension usages
   - Implement pure SwiftUI navigation replacements

## Files Moved to FlutterBridge

### Bridge Components

- `Bridge/FlutterSwiftUIBridge.swift` - Core bridge system
- `Bridge/BridgeMethodDispatcher.swift` - Method channel dispatcher
- `Bridge/HybridNavigationCoordinator.swift` - Navigation coordination
- `Bridge/SwiftDataBridge.swift` - SwiftData access from Flutter
- `Bridge/SharedDataManager.swift` - Data synchronization
- `Bridge/DashboardBridgeRegistration.swift` - Dashboard-specific bridge setup

### Services

- `Services/HiveDataManager.swift` - Flutter Hive ↔ SwiftUI data sync

### ViewModels

- `ViewModels/CalendarViewModel.swift` - Calendar VM with Flutter method channels

### Extensions

- `Views/DashboardView+FlutterIntegration.swift` - Dashboard Flutter integration
- `Views/SwiftUINavigation+FlutterBridge.swift` - Navigation bridge helpers
- `Models/CalendarModels+FlutterIntegration.swift` - Calendar model bridge extensions

### Engine Management

- `FlutterEngineManager.swift` - Flutter engine lifecycle management

## Benefits of This Architecture

1. **Clear Separation**: Easy to identify what code is permanent vs temporary
2. **Safe Migration**: Can delete entire FlutterBridge folder when migration complete
3. **Maintainable**: Pure SwiftUI code is not polluted with migration concerns
4. **Reviewable**: Easy to review and validate migration-temporary code separately
5. **Testable**: Can test pure SwiftUI functionality independently of Flutter bridge

## Notes for Developers

- **Never add new Flutter dependencies to `ios/Native/`**
- **All new bridge code goes in `ios/FlutterBridge/`**
- **Mark all migration-temporary code with ⚠️ comments**
- **When implementing new SwiftUI views, avoid Flutter dependencies**
- **Use extension files in FlutterBridge for any needed Flutter integration**
