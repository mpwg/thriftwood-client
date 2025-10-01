# Thriftwood (LunaSea) Copilot Instructions

## Project Overview

**Thriftwood** (originally LunaSea) is a self-hosted media management controller app supporting multiple \*arr services (Radarr, Sonarr, Lidarr), download clients (SABnzbd, NZBGet), and media analytics (Tautulli). The project is undergoing a **Flutter-to-SwiftUI hybrid migration** toward a pure SwiftUI iOS app.

**Current State**: Flutter app with modular service architecture  
**Target State**: Pure SwiftUI app following modern Swift 6 patterns  
**Migration Strategy**: Hybrid coexistence allowing gradual view-by-view migration

## Architecture Patterns

### Current Flutter Structure

- **`lib/modules/`**: Service modules (dashboard, radarr, sonarr, lidarr, etc.)
- **`lib/api/`**: Retrofit-based API clients for each service
- **`lib/database/`**: Hive-based profile management and configuration
- **`lib/router/`**: GoRouter-based navigation system
- **`lib/widgets/`**: Shared UI components

### Migration Architecture (Swift-First with Code Elimination)

**CRITICAL CHANGE**: Migration now follows Swift-first architecture with immediate Flutter code elimination:

- **Swift becomes single source of truth** for each migrated feature
- **Flutter code is removed** once Swift implementation is complete
- **Flutter accesses Swift data models** via bridge layer (no data duplication)
- **Progressive feature elimination** - migrate and remove Flutter code iteratively
- **Bridge-based data access** - Flutter reads/writes Swift SwiftData models directly

### Key Migration Principles

- **No Code Duplication**: Swift replaces Flutter entirely, no parallel implementations
- **Bridge-Based Access**: Flutter accesses Swift data via method channel bridge
- **Immediate Elimination**: Flutter code removed as soon as Swift implementation complete
- **Single Source of Truth**: Swift SwiftData becomes primary data persistence
- **Progressive Migration**: Feature-by-feature elimination of Flutter components

### Key Files

- **`migration.md`**: Complete hybrid migration strategy and timeline
- **`lib/core.dart`**: Deprecated central export (avoid using)
- **`lib/database/database.dart`**: Hive initialization and profile bootstrapping
- **`lib/router/router.dart`**: GoRouter configuration
- **`lib/system/bridge/`**: Flutter ↔ SwiftUI bridge implementation
- **`ios/Native/Bridge/SwiftDataBridge.swift`**: Flutter access to Swift data models
- **`lib/bridge/swift_data_accessor.dart`**: Flutter client for Swift data access

## Development Guidelines

### Swift Migration Conventions (Follow `.github/instructions/`)

- **Swift 6**: Use strict concurrency checking, async/await, and actors
- **SwiftUI**: Embrace declarative patterns, avoid UIKit abstractions
- **SwiftData**: Replace Hive with `@Model` classes for persistence
- **Architecture**: Follow feature-based organization, not MVC folders
- **State Management**: Use `@Observable` for iOS 17+, `@ObservableObject` for legacy
- **Accessibility**: Full WCAG 2.2 AA compliance with inclusive design patterns

### Flutter Conventions (Legacy/Migration Period)

- **Modules**: Self-contained feature modules with dedicated state management
- **API Clients**: Retrofit + Dio for HTTP with typed responses
- **State**: Provider pattern for service state management
- **Database**: Hive boxes with profile-based configuration
- **Navigation**: GoRouter with type-safe routing

### Service Integration Patterns

Each service (Radarr, Sonarr, etc.) follows consistent patterns:

```dart
// API Structure
lib/api/{service}/
  ├── commands/          # API endpoint implementations
  ├── types/            # Data models and enums
  └── {service}_api.dart # Main API client

// Module Structure
lib/modules/{service}/
  ├── core/             # State management and utilities
  ├── routes/           # UI screens and navigation
  └── {service}.dart    # Module exports
```

### Profile System

- **Multi-profile support**: Users can configure multiple service instances
- **Hive storage**: Profile data persisted in local Hive boxes
- **Active profile**: Global state determines current configuration context
- **Migration note**: Must maintain profile data consistency during SwiftUI transition

### Hybrid Bridge System

The bridge enables seamless Flutter ↔ SwiftUI navigation:

```dart
// Check if route uses SwiftUI
final isNative = await NativeBridge.isNativeViewAvailable(route);

// Navigate appropriately
if (isNative) {
  await NativeBridge.navigateToNativeView(route, data: data);
} else {
  context.go(route);
}
```

Bridge initialization happens in `lib/main.dart` via `BridgeInitializer.initialize()`.

## Migration Development Workflow

### Phase-Based Implementation (See `migration.md` for full details)

1. **Hybrid Infrastructure** (Weeks 1-2): Flutter ↔ SwiftUI bridge system
2. **Settings Migration** (Weeks 3-4): First SwiftUI view with data sync
3. **Dashboard Migration** (Weeks 5-6): SwiftUI dashboard with hybrid navigation
4. **Service Modules** (Weeks 7-14): Individual service view migrations
5. **Pure SwiftUI** (Weeks 15-16): Remove Flutter dependencies

### During Migration Period

- **No User Toggle**: Users don't choose between Flutter/Swift - Swift always used when available
- **Immediate Delegation**: Flutter routes immediately delegate to Swift when implemented
- **Data Migration**: One-time migration from Flutter Hive to Swift SwiftData
- **Code Elimination**: Flutter implementation removed upon Swift completion
- **Bridge Access**: Flutter maintains access to Swift data for remaining Flutter features

### Swift-First Implementation Standards

```swift
// Modern Swift 6 service with Flutter bridge access
@Model
class RadarrMovie {
    var id: Int
    var title: String
    // ...properties

    // MANDATORY: Flutter bridge serialization
    func toDictionary() -> [String: Any] { /* implementation */ }
    static func fromDictionary(_ dict: [String: Any]) -> RadarrMovie? { /* implementation */ }
}

@Observable
class RadarrService {
    // MANDATORY: Flutter data access methods
    @MainActor
    func handleFlutterRequest(_ method: String, arguments: Any?) async -> Any? {
        switch method {
        case "getMovies": return await getMovies().map { $0.toDictionary() }
        case "addMovie": return await addMovie(fromDict: arguments)
        // ... all CRUD operations
        }
    }
}
```

## Testing and Quality Assurance

### Testing Requirements (Follow `.github/instructions/ai-agent-testing.instructions.md`)

- **SwiftUI Views**: Use `@Test` with SwiftData mock contexts
- **API Integration**: Test actual service endpoints with UI validation
- **Migration**: Verify data sync between Flutter/SwiftUI during hybrid period
- **Accessibility**: Test with VoiceOver and keyboard navigation

### Code Quality Standards

- **Accessibility**: WCAG 2.2 AA compliance (see `.github/instructions/a11y.instructions.md`)
- **Documentation**: Follow markdown standards for all documentation
- **Conventional Commits**: Use structured commit messages for changelog generation
- **Swift 6 Migration**: Follow strict concurrency and data race safety guidelines

## Build and Development Commands

### Flutter Development

```bash
flutter run                    # Development build
flutter build ios             # Production iOS build
flutter test                  # Run Flutter tests
```

### iOS Development (Migration Period)

```bash
# iOS project in ios/ directory
pod install                   # Install dependencies
xcodebuild -workspace Runner.xcworkspace -scheme Runner # Build iOS app
```

### Key Configuration Files

- **`pubspec.yaml`**: Flutter dependencies and app metadata
- **`analysis_options.yaml`**: Dart/Flutter linting configuration
- **`ios/Podfile`**: iOS dependency management during migration

## Common Patterns and Anti-Patterns

### ✅ Do

- Implement complete Swift feature before removing Flutter code
- Create comprehensive Flutter-Swift data bridge
- Remove Flutter implementation immediately upon Swift completion
- Migrate user data from Flutter Hive to Swift SwiftData once
- Test Swift implementation thoroughly before Flutter code elimination
- Document which features are Swift-only vs. Flutter-accessible

### ❌ Don't

- Maintain parallel Flutter and Swift implementations
- Keep Flutter code after Swift implementation is complete
- Create user toggles between Flutter and Swift versions
- Duplicate data between Flutter Hive and Swift SwiftData
- Skip data migration when eliminating Flutter storage
- Remove Flutter code before Swift implementation is 100% complete and tested

## External Dependencies and APIs

### Service APIs

- **Radarr/Sonarr/Lidarr**: \*arr application APIs for media management
- **SABnzbd/NZBGet**: Download client APIs for queue management
- **Tautulli**: Plex analytics API for usage statistics
- **Wake-on-LAN**: Network wake functionality

### Authentication Patterns

- API keys stored in profile configuration
- Base URL + API key authentication for most services
- Retrofit interceptors handle authentication headers in Flutter
- URLSession + async/await for SwiftUI implementations

## State Management Patterns

### Flutter Modules (Current)

Each service module extends `LunaModuleState` with Provider pattern:

```dart
class RadarrState extends LunaModuleState {
  RadarrAPI? _api;
  List<RadarrMovie>? _movies;

  void reset() {
    // Reset data and refetch if enabled
    resetProfile();
    if (_enabled) {
      fetchMovies();
    }
  }
}
```

### SwiftUI Migration (Target)

Use `@Observable` classes for automatic SwiftUI updates:

```swift
@Observable
class RadarrService {
    private let apiClient: RadarrAPIClient
    var movies: [Movie] = []
    var isLoading = false

    func fetchMovies() async throws {
        isLoading = true
        defer { isLoading = false }
        movies = try await apiClient.getMovies()
    }
}
```

This codebase prioritizes user workflow continuity during the migration while modernizing to SwiftUI and Swift 6 patterns. Always reference the migration plan and existing instruction files for implementation details.

## New Mandatory Navigation Rules

- Source-agnostic navigation: It must not matter whether you are currently on a Flutter widget or a SwiftUI view—routes must be reachable from both, and back navigation must work in both directions. Implement symmetric navigation APIs on both platforms and never assume a single origin.
- No silent navigation errors: Never ignore failures. Catch exceptions, report via `BridgeErrorReporter`/logger equivalents, and show an actionable UI (Retry, Go Back, Open Logs). Debug prints alone are not sufficient.

Swift symmetric decision pattern example:

```swift
let coordinator = HybridNavigationCoordinator.shared
if FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route) {
    FlutterSwiftUIBridge.shared.presentNativeView(route: route, data: data)
} else {
    coordinator.navigateInFlutter(route: route, data: data)
}
```

    coordinator.navigateInFlutter(route: route, data: data)

}

```

```
