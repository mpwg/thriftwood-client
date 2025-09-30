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

### Migration Architecture (Reference `migration.md`)

- **FlutterSwiftUIBridge**: Seamless navigation between Flutter/SwiftUI views
- **Shared data layer**: Bidirectional sync between Hive (Flutter) and SwiftData (SwiftUI)
- **Hybrid navigation**: Route registration system to determine platform per view

### Key Files

- **`migration.md`**: Complete hybrid migration strategy and timeline
- **`lib/core.dart`**: Deprecated central export (avoid using)
- **`lib/database/database.dart`**: Hive initialization and profile bootstrapping
- **`lib/router/router.dart`**: GoRouter configuration
- **`lib/system/bridge/`**: Flutter ↔ SwiftUI bridge implementation

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

- **Test both platforms**: Ensure data consistency and navigation flow
- **Bridge registration**: Register migrated views with `FlutterSwiftUIBridge`
- **Maintain functionality**: App must remain fully functional at each phase
- **Performance monitoring**: No regressions during hybrid period

### SwiftUI Code Organization

All SwiftUI code goes in `ios/Native/` with this structure:

```
ios/Native/
├── Bridge/             # Flutter ↔ SwiftUI integration
├── Models/             # @Observable data models
├── ViewModels/         # MVVM presentation logic
├── Views/              # SwiftUI user interfaces
└── Services/           # Business logic & data persistence
```

Files in `ios/Native/` are automatically included in Xcode project.

### SwiftUI Implementation Standards

```swift
// Modern Swift 6 service implementation
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

// SwiftUI view with proper state management
struct RadarrMoviesView: View {
    @State private var service = RadarrService()

    var body: some View {
        NavigationStack {
            List(service.movies) { movie in
                MovieRow(movie: movie)
            }
            .task { try? await service.fetchMovies() }
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

- Follow the migration timeline in `migration.md` strictly
- Use `HybridRouter.navigateTo()` for navigation during hybrid period
- Maintain profile data consistency across platforms
- Test navigation paths thoroughly after each migration phase
- Follow Swift 6 concurrency patterns for new SwiftUI code
- Place new SwiftUI files in `ios/Native/` directory structure

### ❌ Don't

- Skip hybrid infrastructure setup before migrating views
- Break existing Flutter functionality during migration
- Use legacy UIKit patterns in new SwiftUI code
- Ignore accessibility requirements in migrated views
- Hardcode service configurations (use profile system)
- Import `lib/core.dart` (deprecated central export)

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
