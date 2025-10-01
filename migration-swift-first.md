# Swift-First Migration Strategy

## Overview

The Thriftwood migration has been updated to follow a **Swift-first architecture with immediate Flutter code elimination**. This eliminates code duplication, reduces maintenance burden, and creates a single source of truth for each feature.

## Core Principles

### 1. Swift Single Source of Truth

- Swift becomes the authoritative implementation for each migrated feature
- Flutter code is completely removed once Swift implementation is complete
- No parallel implementations or feature toggles

### 2. Bridge-Based Flutter Access

- Flutter accesses Swift data models via method channel bridge
- Full read/write capability for Flutter to Swift SwiftData
- No data duplication between Flutter Hive and Swift SwiftData

### 3. Progressive Code Elimination

- Migrate features one-by-one with immediate Flutter code removal
- Each completed Swift feature eliminates corresponding Flutter implementation
- Remaining Flutter features access Swift data via bridge when needed

## Migration Process

### Phase 1: Swift Implementation (Complete Feature Parity)

```swift
// 1. Implement complete Swift feature
@Model
class RadarrMovie {
    var id: Int
    var title: String
    var year: Int
    // ... all properties from Flutter equivalent

    // MANDATORY: Bridge serialization methods
    func toDictionary() -> [String: Any] {
        return ["id": id, "title": title, "year": year]
    }

    static func fromDictionary(_ dict: [String: Any]) -> RadarrMovie? {
        // Parse Flutter data and create Swift model
    }
}

// 2. Implement service with Flutter bridge methods
@Observable
class RadarrService {
    @MainActor
    func handleFlutterDataRequest(_ call: FlutterMethodCall) async -> Any? {
        switch call.method {
        case "radarr.getMovies":
            let movies = await fetchMovies()
            return movies.map { $0.toDictionary() }
        case "radarr.addMovie":
            return await addMovie(fromFlutterData: call.arguments)
        // ... all CRUD operations
        }
    }
}
```

### Phase 2: Flutter Bridge Integration

```dart
// Flutter service becomes bridge accessor (no local storage)
class RadarrService {
  static const _bridge = MethodChannel('com.thriftwood.swift_data');

  Future<List<RadarrMovie>> getMovies() async {
    final result = await _bridge.invokeMethod('radarr.getMovies');
    return (result as List).map((dict) => RadarrMovie.fromJson(dict)).toList();
  }

  Future<RadarrMovie?> addMovie(RadarrMovie movie) async {
    final result = await _bridge.invokeMethod('radarr.addMovie', movie.toJson());
    return result != null ? RadarrMovie.fromJson(result) : null;
  }
}
```

### Phase 3: Data Migration

```swift
// One-time migration from Flutter Hive to Swift SwiftData
class DataMigrator {
    @MainActor
    func migrateRadarrData() async throws {
        // Read Flutter Hive data
        let flutterMovies = try await readFlutterHiveData("radarr_movies")

        // Convert to Swift models
        let swiftMovies = flutterMovies.compactMap { RadarrMovie.fromDictionary($0) }

        // Save to SwiftData
        for movie in swiftMovies {
            await SwiftDataManager.shared.insert(movie)
        }

        // Clear Flutter storage
        try await clearFlutterHiveData("radarr_movies")
        UserDefaults.standard.set(true, forKey: "radarr_migration_complete")
    }
}
```

### Phase 4: Flutter Code Elimination

```dart
// Update Flutter routes to delegate immediately to Swift
class RadarrRoute extends StatelessWidget {
  Widget build(BuildContext context) {
    // Immediate delegation to Swift (no Flutter UI)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SwiftBridge.navigateToSwiftFeature('radarr');
    });

    return Container(); // Temporary during navigation
  }
}

// Remove all Flutter Radarr implementation:
// - lib/modules/radarr/ (entire directory)
// - Radarr-related state management
// - Radarr API clients
// - Radarr data models
// - Radarr navigation routes
```

### Phase 5: Cleanup and Validation

- Remove unused Flutter dependencies
- Update navigation to reflect Swift-only features
- Comprehensive testing of Swift implementation
- Performance validation
- Documentation updates

## Bridge Architecture

### Swift Data Bridge

```swift
// Master bridge handler for all Flutter data access
class SwiftDataBridge {
    @MainActor
    func handleFlutterMethod(_ call: FlutterMethodCall) async -> Any? {
        let components = call.method.split(separator: ".")
        guard components.count >= 2 else { return nil }

        let service = String(components[0])  // e.g., "radarr"
        let method = String(components[1])   // e.g., "getMovies"

        switch service {
        case "radarr":
            return await RadarrService.shared.handleFlutterRequest(method, arguments: call.arguments)
        case "sonarr":
            return await SonarrService.shared.handleFlutterRequest(method, arguments: call.arguments)
        // ... other services
        default:
            return nil
        }
    }
}
```

### Flutter Bridge Client

```dart
// Centralized Flutter client for Swift data access
class SwiftDataClient {
  static const _channel = MethodChannel('com.thriftwood.swift_data');

  static Future<T?> call<T>(String service, String method, [dynamic arguments]) async {
    try {
      final result = await _channel.invokeMethod('$service.$method', arguments);
      return result as T?;
    } on PlatformException catch (e) {
      _handleBridgeError(e, service, method);
      return null;
    }
  }

  static void _handleBridgeError(PlatformException e, String service, String method) {
    // Log and show user-friendly error
    Logger.error('Swift bridge error', error: e, context: {
      'service': service,
      'method': method,
    });

    BridgeErrorReporter.showErrorToUser(
      title: 'Feature Unavailable',
      message: 'This feature requires the latest iOS implementation.',
    );
  }
}
```

## Migration Timeline

| Week  | Activity                       | Deliverable                            |
| ----- | ------------------------------ | -------------------------------------- |
| 1-2   | Settings Swift Implementation  | Complete SwiftUI settings with bridge  |
| 3     | Settings Flutter Elimination   | Remove Flutter settings code entirely  |
| 4-5   | Dashboard Swift Implementation | Complete SwiftUI dashboard with bridge |
| 6     | Dashboard Flutter Elimination  | Remove Flutter dashboard code entirely |
| 7-8   | Radarr Swift Implementation    | Complete SwiftUI Radarr with bridge    |
| 9     | Radarr Flutter Elimination     | Remove Flutter Radarr code entirely    |
| 10-11 | Sonarr Swift Implementation    | Complete SwiftUI Sonarr with bridge    |
| 12    | Sonarr Flutter Elimination     | Remove Flutter Sonarr code entirely    |
| 13-14 | Remaining Services Migration   | Complete all remaining features        |
| 15    | Final Flutter Cleanup          | Remove unused dependencies and code    |
| 16    | Pure iOS App                   | Ship native iOS app with Swift core    |

## Benefits

### Code Quality

- **Single source of truth** eliminates sync complexity
- **Reduced codebase size** from elimination of duplicate code
- **Native performance** with Swift-first architecture
- **Simplified testing** with one implementation per feature

### User Experience

- **Consistent behavior** across all features
- **Native iOS integration** with platform patterns
- **Better performance** without bridge overhead for core features
- **Smaller app size** from eliminated Flutter code

### Development Velocity

- **Faster feature development** with single implementation
- **Easier maintenance** with one codebase per feature
- **Modern architecture** with Swift 6 and SwiftUI best practices
- **Clear migration path** with defined success criteria

## Validation Criteria

### Swift Implementation Complete

- [ ] All Flutter functionality implemented in Swift
- [ ] Flutter data bridge fully functional
- [ ] Performance equals or exceeds Flutter version
- [ ] Complete test coverage
- [ ] Zero functional regressions

### Flutter Code Elimination Complete

- [ ] All Flutter UI components removed
- [ ] All Flutter state management removed
- [ ] All Flutter API clients removed
- [ ] All Flutter data models removed
- [ ] Unused dependencies cleaned up

### Data Migration Complete

- [ ] User data successfully migrated to SwiftData
- [ ] Flutter storage cleared
- [ ] No data loss or corruption
- [ ] Bridge access functional for remaining Flutter features

---

**The end goal: A native iOS app with Swift as the single source of truth, providing superior performance, maintainability, and user experience while eliminating all code duplication.**
