# Copilot Instructions for Thriftwood

## Project Overview

Thriftwood is a Flutter-based media server controller app for managing Radarr, Sonarr, Lidarr, NZBGet, SABnzbd, Tautulli, and Wake-on-LAN services. The project is undergoing a SwiftUI migration (see `migration.md`).

## Critical Workflows

### Code Generation (Run After ANY Dependency Changes)

```bash
npm run generate  # Runs all generators: environment, assets, build_runner, localization
```

Individual generators:

- `npm run generate:build_runner` - Retrofit APIs, Hive adapters, JSON serialization
- `npm run generate:build_runner:watch` - Watch mode for development
- `npm run generate:environment` - Environment configuration
- `npm run generate:assets` - Spider asset generation

### Platform-Specific Commands

```bash
# Clean builds for all platforms
npm run build:android    # Flutter clean + APK release
npm run build:ios        # Flutter clean + IPA release
npm run build:macos      # Flutter clean + macOS release

# CocoaPods management (iOS/macOS)
npm run cocoapods:nuke:ios     # Complete Pod reset + deintegrate
npm run cocoapods:nuke:macos   # Complete Pod reset + deintegrate

# Fastlane deployment
npm run prepare:keychain:ios   # Setup signing keychain
```

## Architecture Deep Dive

### Bootstrap Sequence (`lib/main.dart:18`)

Critical initialization order in guarded zone:

1. **LunaDatabase** → Hive initialization with type adapters
2. **LunaLogger** → Logging system setup
3. **LunaTheme** → Theme system (AMOLED black support)
4. **LunaWindowManager** → Desktop window management
5. **LunaNetwork** → Network layer with Dio interceptors
6. **LunaImageCache** → Image caching system
7. **LunaRouter** → Go Router declarative routing
8. **LunaMemoryStore** → Memory caching layer

Recovery mode (`LunaRecoveryMode`) handles bootstrap failures.

### Module System (`lib/modules.dart`)

Each service is a self-contained module with Hive enum serialization:

- **Core**: Dashboard, Search, Settings
- **Media**: Lidarr, Radarr, Sonarr
- **Downloads**: NZBGet, SABnzbd
- **Monitoring**: Tautulli
- **Network**: Wake on LAN

### Database Layer (Hive NoSQL)

- **Structure**: `lib/database/` - models, tables, config
- **Tables**: Each service has dedicated table (`lib/database/tables/`)
- **Profiles**: Multi-instance support via `LunaProfile` system
- **Config**: Import/export in `lib/database/config.dart`

### API Layer (Retrofit + Dio)

- **Location**: `lib/api/` - one package per service
- **Pattern**: Retrofit annotations with Dio HTTP client
- **Models**: Auto-generated JSON serialization with `@JsonSerializable`
- **Generation**: Must run `npm run generate:build_runner` after API changes

### State Management (Provider Pattern)

- **Primary**: Provider pattern throughout
- **Module State**: Each module extends `LunaModuleState`
- **Global State**: `lib/system/state.dart`
- **Deprecated**: Avoid `lib/core.dart` exports, use direct imports

### Routing (Go Router)

- **Config**: Declarative routing with `go_router`
- **Structure**: Routes in `lib/router/routes/`
- **Navigation**: Module-based organization

## Project-Specific Conventions

### Code Generation Dependencies

**Critical**: Always run `npm run generate` after:

- Adding/modifying `@JsonSerializable` models
- Adding/modifying `@RestApi` endpoints
- Adding/modifying Hive `@HiveType` adapters
- Changing assets in `assets/` directory

### State Pattern

```dart
// Module state example (lib/modules/radarr/core/state.dart)
class RadarrState extends LunaModuleState {
  RadarrAPI? _api;
  Map<int, Future<RadarrMovie>> _movies = {};

  void setMovie(int id, Future<RadarrMovie> future) {
    _movies[id] = future;
    notifyListeners();
  }
}

// Usage in widgets
context.read<RadarrState>().setMovie(movieId,
  context.read<RadarrState>().api!.movies.getMovie(movieId: movieId)
);
```

### Database Table Pattern

```dart
// lib/database/tables/radarr.dart
enum RadarrDatabase<T> implements LunaTableMixin<T> {
  ENABLED<bool>(false),
  HOST<String>(''),
  API_KEY<String>(''),
  HEADERS<Map<String, dynamic>>({}),

  @override
  LunaTable get table => LunaTable.radarr;

  @override
  void register() {
    Hive.registerAdapter(RadarrSortingAdapter());
    // Register all Hive adapters for this module
  }
}
```

### API Client Pattern

```dart
// lib/api/radarr/api.dart
@RestApi(baseUrl: "")
abstract class RadarrAPI {
  factory RadarrAPI(Dio dio) = _RadarrAPI;

  @GET("/movie")
  Future<List<RadarrMovie>> getMovies();

  @GET("/movie/{id}")
  Future<RadarrMovie> getMovie(@Path("id") int movieId);
}
```

## Swift Migration Context

### Current Native Components

- **ThriftwoodNative/** - SwiftUI implementation in progress
- **Architecture**: Modern MVVM with `@Observable`, actors, Swift 6
- **Bridge**: Flutter-Native communication via MethodChannels
- **Migration**: View-by-view replacement (Settings → Dashboard → Services)

### Key Files for Migration

- `migration.md` - Complete migration strategy
- `lib/modules/*/core/state.dart` - Flutter state to port
- `lib/api/*/api.dart` - API clients to convert to Swift actors
- `ThriftwoodNative/Core/` - Native architecture foundation

## Development Environment

### Requirements

- Flutter SDK >=3.0.0 <4.0.0
- Dart SDK (included with Flutter)
- Node.js (for npm scripts)
- iOS: Xcode 16+, CocoaPods, Fastlane
- Android: Android Studio, Gradle

### Linting

Custom rules in `analysis_options.yaml` disable several Flutter defaults. Always check lint errors before committing.

### Multi-Platform Support

- **Platforms**: Android, iOS, Linux, macOS, Windows, Web
- **Minimum**: iOS 13.0+, Android API 21+
- **Desktop**: Native window management with `LunaWindowManager`

## Integration Points

### External Dependencies

- **Media Servers**: Radarr, Sonarr, Lidarr APIs
- **Download Clients**: NZBGet, SABnzbd APIs
- **Monitoring**: Tautulli API
- **Search**: Newznab/Torznab indexer APIs
- **Push Notifications**: Webhook-based system

### Cross-Component Communication

- **Provider**: Context-based state sharing
- **Events**: `notifyListeners()` pattern for state updates
- **Memory Store**: `LunaMemoryStore` for cross-module data
- **Database**: Hive boxes for persistent cross-module config

## Build System Integration

### Package.json Scripts

All build commands use npm scripts that wrap Flutter commands with proper cleanup and preparation steps.

### CocoaPods Integration

iOS/macOS use CocoaPods with custom `Podfile` configurations. The nuke scripts handle complete Pod environment resets.

### Fastlane Integration

Automated builds and deployments use Fastlane lanes defined in `ios/fastlane/` and `android/fastlane/`.

## Key Instruction References

When working with this codebase, always reference:

- `.github/instructions/dart-n-flutter.instructions.md` - Dart/Flutter best practices
- `.github/instructions/swift6-migration.md` - Swift 6 migration patterns
- `.github/instructions/swiftui.md` - SwiftUI implementation guidelines
- `.github/instructions/swift-concurrency.md` - Actor isolation patterns
- `.github/instructions/swift-observable.md` - Modern state management
- `.github/instructions/performance-optimization.instructions.md` - Optimization strategies
- `.github/instructions/security-and-owasp.instructions.md` - Secure coding practices

The project follows specification-driven development (`spec-driven-workflow-v1.instructions.md`) with comprehensive documentation requirements.
