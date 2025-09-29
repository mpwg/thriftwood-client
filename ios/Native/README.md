# iOS Native Swift Code Organization

**IMPORTANT**: All new Swift files for the hybrid Flutter-SwiftUI migration should be placed in the `ios/Native/` directory structure. Files in this folder are automatically included in the Xcode project.

## Directory Structure

```
ios/Native/
├── Bridge/                     # Flutter ↔ SwiftUI Bridge System
│   ├── FlutterSwiftUIBridge.swift
│   ├── HybridNavigationCoordinator.swift
│   └── SharedDataManager.swift
├── Models/                     # Data Models (@Observable)
│   └── ThriftwoodModels.swift
├── ViewModels/                 # MVVM ViewModels (@Observable)
│   └── SettingsViewModel.swift
├── Views/                      # SwiftUI Views
│   └── SwiftUISettingsViews.swift
└── Services/                   # Business Logic & Data Services
    └── HiveDataManager.swift
```

## File Descriptions

### Bridge/ - Flutter-SwiftUI Integration

- **FlutterSwiftUIBridge.swift**: Core bridge for seamless navigation between Flutter and SwiftUI views
- **HybridNavigationCoordinator.swift**: Manages hybrid navigation patterns and deep linking
- **SharedDataManager.swift**: Handles data sharing between Flutter and SwiftUI

### Models/ - Data Layer (@Observable Pattern)

- **ThriftwoodModels.swift**:
  - `ThriftwoodProfile`: Mirror of Flutter's LunaProfile with service configurations
  - `ThriftwoodAppSettings`: App-wide settings and preferences
  - `ServiceConfiguration`: Individual service setup (Radarr, Sonarr, etc.)
  - `DownloadClientConfiguration`: Download client settings (SABnzbd, NZBGet)
  - Enums: `AppTheme`, `BackupFrequency`

### ViewModels/ - Presentation Logic (MVVM)

- **SettingsViewModel.swift**:
  - `SettingsViewModel`: Main settings business logic and data operations
  - `ProfilesViewModel`: Profile management operations
  - `ConfigurationViewModel`: Service configuration management
  - All use `@Observable` for iOS 17+ SwiftUI integration

### Views/ - SwiftUI User Interface

- **SwiftUISettingsViews.swift**:
  - `SwiftUISettingsView`: Main settings screen with sections for profile, appearance, security, notifications
  - `SwiftUIProfilesView`: Profile management interface with create/rename/delete
  - `SwiftUIConfigurationView`: Service configuration with expandable sections
  - Supporting views: `ServiceBadge`, `ProfileRow`, `ServiceConfigurationRow`

### Services/ - Business Logic & Data Persistence

- **HiveDataManager.swift**:
  - `HiveDataManager`: Bidirectional sync with Flutter's Hive storage
  - `StorageService` protocol and `UserDefaultsStorageService` implementation
  - Dictionary conversion extensions for cross-platform data exchange
  - Error handling and notification system

## Architecture Patterns

### MVVM with @Observable (iOS 17+)

- **Models**: `@Observable` classes for automatic SwiftUI updates
- **ViewModels**: Business logic, data operations, state management
- **Views**: Pure SwiftUI with data binding to ViewModels

### Data Flow

1. **SwiftUI Views** → bind to **ViewModels** via `@Observable`
2. **ViewModels** → manage **Models** and call **Services**
3. **Services** → handle persistence, networking, Flutter sync
4. **Bridge** → facilitates navigation and data exchange with Flutter

### Hybrid Navigation

1. Flutter checks if route should use SwiftUI (`FlutterSwiftUIBridge.isNativeViewAvailable`)
2. If native, present SwiftUI view via `FlutterSwiftUIBridge.presentNativeView`
3. SwiftUI views can navigate back to Flutter via `FlutterSwiftUIBridge.navigateBackToFlutter`
4. Data synchronization happens automatically through `HiveDataManager`

## Phase 2 Implementation Status

### ✅ Completed

- [x] Hybrid infrastructure (Bridge system)
- [x] Data models (@Observable pattern)
- [x] MVVM ViewModels with business logic
- [x] SwiftUI Views (Settings, Profiles, Configuration)
- [x] Data synchronization architecture
- [x] Proper folder organization

### 🚧 In Progress

- [ ] Flutter-side HybridRouter integration
- [ ] Settings version selector UI
- [ ] Comprehensive testing framework

### ⏳ Next Steps

- [ ] Complete Flutter navigation updates
- [ ] Add version selector to existing Flutter settings
- [ ] End-to-end testing of hybrid navigation
- [ ] Data consistency validation

## Development Guidelines

### Adding New Swift Files

1. **Always** place new Swift files in appropriate `ios/Native/` subfolder
2. Follow the established naming conventions
3. Use `@Observable` for models that need SwiftUI updates
4. Implement proper error handling and async/await patterns
5. Add preview support for SwiftUI views when possible

### Testing Approach

- SwiftUI Views: Use `@Test` with mock ViewModels
- ViewModels: Test business logic with mock services
- Bridge: Test Flutter ↔ SwiftUI communication
- Data Sync: Verify consistency between Flutter Hive and Swift storage

### Code Quality

- Follow Swift 6 strict concurrency patterns
- Use `@MainActor` for UI updates
- Implement proper error handling with user-friendly messages
- Ensure accessibility compliance (VoiceOver, keyboard navigation)
- Add comprehensive documentation for public APIs

## Migration Timeline Reference

This is **Phase 2** of the hybrid migration plan:

- **Phase 1** ✅: Hybrid infrastructure setup
- **Phase 2** 🚧: Settings migration (current)
- **Phase 3** ⏳: Dashboard migration
- **Phase 4** ⏳: Service modules migration
- **Phase 5** ⏳: Pure SwiftUI transition

---

**Remember**: Files in `ios/Native/` are automatically included in the Xcode project. Use appropriate subfolders to maintain clean architecture and easy navigation.
