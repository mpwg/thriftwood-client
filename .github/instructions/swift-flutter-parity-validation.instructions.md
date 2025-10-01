---
description: "Swift-Flutter migration rules with code elimination and Swift data model access"
applyTo: "ios/Native/**/*.swift"
---

# Swift-Flutter Migration Rules with Code Elimination

This document establishes **mandatory migration rules** for eliminating Flutter code duplication during the hybrid migration, with Swift-first architecture and Flutter access to migrated Swift data models.

## CRITICAL RULE CHANGE: Swift-First Migration with Code Elimination

### Rule 1: Complete Swift Migration Eliminates Flutter Code (MANDATORY)

**When a feature is fully implemented in Swift, the Flutter implementation MUST be removed:**

- **Swift becomes the single source of truth** for that feature
- **Flutter accesses Swift data models** via bridge layer for read/write operations
- **No code duplication allowed** - Swift implementation replaces Flutter entirely
- **Flutter UI delegates to Swift** via bridge when Swift implementation available
- **Progressive elimination** - migrate feature-by-feature, removing Flutter code as Swift completes

### Rule 2: Flutter-Swift Data Model Bridge (MANDATORY)

**Flutter MUST have direct access to Swift data models once migrated:**

- **Swift @Model classes** become the primary data persistence layer
- **Flutter reads Swift data** via method channel bridge
- **Flutter writes Swift data** via method channel bridge
- **No data duplication** between Flutter Hive and Swift SwiftData
- **Bidirectional sync eliminated** - Swift is single source, Flutter is accessor

### Rule 3: Migration Progression Pattern (MANDATORY)

**Migration follows strict progression with immediate Flutter code removal:**

1. **Phase 1**: Implement Swift feature with complete functional parity
2. **Phase 2**: Create Flutter-Swift data bridge for the feature
3. **Phase 3**: Update Flutter to use Swift data via bridge
4. **Phase 4**: Remove Flutter implementation completely
5. **Phase 5**: Flutter UI either delegates to Swift or uses Swift data directly

### Rule 4: Flutter Delegation Pattern (MANDATORY)

**Flutter UI must check for Swift availability and delegate appropriately:**

```dart
// MANDATORY: Flutter checks Swift availability and delegates
class SettingsRoute extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SwiftBridge.isFeatureAvailable('settings'),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          // Swift implementation available - delegate immediately
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await SwiftBridge.navigateToSwiftFeature('settings');
          });
          return Container(); // Temporary placeholder during navigation
        }

        // Swift not available - show fallback message (no Flutter implementation)
        return FeatureNotAvailableView(
          feature: 'Settings',
          message: 'This feature requires iOS native implementation',
        );
      },
    );
  }
}
```

### Rule 5: Swift Data Model Access Layer (MANDATORY)

**Swift data models must be accessible from Flutter with full read/write capability:**

```swift
// Swift: Expose data models to Flutter via method channel bridge
@Model
class RadarrMovie {
    var id: Int
    var title: String
    var year: Int
    // ... other properties

    // MANDATORY: Flutter bridge access methods
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "year": year,
            // ... all properties
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> RadarrMovie? {
        guard let id = dict["id"] as? Int,
              let title = dict["title"] as? String,
              let year = dict["year"] as? Int else {
            return nil
        }

        let movie = RadarrMovie()
        movie.id = id
        movie.title = title
        movie.year = year
        return movie
    }
}

// MANDATORY: Data access bridge for Flutter
class SwiftDataBridge {
    @MainActor
    func handleFlutterDataRequest(_ call: FlutterMethodCall) async -> Any? {
        switch call.method {
        case "radarr.getMovies":
            return await getRadarrMovies()
        case "radarr.addMovie":
            return await addRadarrMovie(call.arguments)
        case "radarr.updateMovie":
            return await updateRadarrMovie(call.arguments)
        case "radarr.deleteMovie":
            return await deleteRadarrMovie(call.arguments)
        default:
            return nil
        }
    }

    @MainActor
    private func getRadarrMovies() async -> [[String: Any]] {
        // Query SwiftData for all RadarrMovie objects
        let movies = await SwiftDataManager.shared.fetchAll(RadarrMovie.self)
        return movies.map { $0.toDictionary() }
    }

    @MainActor
    private func addRadarrMovie(_ arguments: Any?) async -> [String: Any]? {
        guard let dict = arguments as? [String: Any],
              let movie = RadarrMovie.fromDictionary(dict) else {
            return nil
        }

        await SwiftDataManager.shared.insert(movie)
        return movie.toDictionary()
    }
}
```

### Rule 6: Flutter Code Elimination Timeline (MANDATORY)

**Flutter code MUST be removed immediately upon Swift feature completion:**

- **No grace period** - Swift completion triggers immediate Flutter removal
- **Feature flags removed** - no toggle between Swift/Flutter implementations
- **Database migration** - Flutter Hive data migrated to Swift SwiftData once
- **Dependency cleanup** - Remove Flutter dependencies no longer needed
- **Dead code elimination** - Remove all related Flutter state management, APIs, UI

### Rule 7: Swift-Flutter Bridge Architecture (MANDATORY)

**Architecture ensures Flutter can access Swift without code duplication:**

```dart
// Flutter: Access Swift data models via bridge
class RadarrService {
  static const _bridge = MethodChannel('com.thriftwood.swift_data');

  // Flutter accesses Swift data models directly
  Future<List<RadarrMovie>> getMovies() async {
    final result = await _bridge.invokeMethod('radarr.getMovies');
    return (result as List).map((dict) => RadarrMovie.fromJson(dict)).toList();
  }

  Future<RadarrMovie?> addMovie(RadarrMovie movie) async {
    final result = await _bridge.invokeMethod('radarr.addMovie', movie.toJson());
    return result != null ? RadarrMovie.fromJson(result) : null;
  }

  Future<bool> updateMovie(RadarrMovie movie) async {
    final result = await _bridge.invokeMethod('radarr.updateMovie', movie.toJson());
    return result == true;
  }

  Future<bool> deleteMovie(int movieId) async {
    final result = await _bridge.invokeMethod('radarr.deleteMovie', {'id': movieId});
    return result == true;
  }
}

// Flutter data model becomes bridge accessor (no local storage)
class RadarrMovie {
  final int id;
  final String title;
  final int year;

  RadarrMovie({required this.id, required this.title, required this.year});

  // Bridge serialization methods
  factory RadarrMovie.fromJson(Map<String, dynamic> json) {
    return RadarrMovie(
      id: json['id'],
      title: json['title'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
    };
  }
}
```

## Migration Validation Rules

### Rule 8: Swift Implementation Completeness (MANDATORY)

**Before Flutter code elimination, Swift implementation MUST be 100% complete:**

- [ ] **All Flutter functionality implemented** in Swift
- [ ] **Data bridge fully functional** for Flutter access
- [ ] **Error handling implemented** for all Swift operations
- [ ] **Performance equals or exceeds** Flutter implementation
- [ ] **Full test coverage** for Swift implementation and bridge
- [ ] **No functional regressions** compared to Flutter version

### Rule 9: Flutter Code Removal Process (MANDATORY)

**Systematic removal of Flutter code once Swift is complete:**

1. **Update Flutter routes** to delegate to Swift immediately
2. **Remove Flutter UI widgets** for the migrated feature
3. **Remove Flutter state management** (Provider, ChangeNotifier, etc.)
4. **Remove Flutter API clients** for the feature
5. **Remove Flutter data models** (local storage, Hive boxes)
6. **Update Flutter dependencies** (remove unused packages)
7. **Clean up Flutter navigation** (remove obsolete routes)
8. **Update documentation** to reflect Swift-only implementation

### Rule 10: Data Migration Strategy (MANDATORY)

**One-time migration from Flutter Hive to Swift SwiftData:**

```swift
// Swift: One-time data migration from Flutter storage
class FlutterToSwiftDataMigrator {
    @MainActor
    func migrateRadarrData() async throws {
        // Read existing Flutter Hive data
        let flutterData = try await readFlutterHiveData("radarr_movies")

        // Convert to Swift data models
        let swiftMovies = flutterData.compactMap { RadarrMovie.fromDictionary($0) }

        // Save to SwiftData
        for movie in swiftMovies {
            await SwiftDataManager.shared.insert(movie)
        }

        // Clear Flutter storage to prevent confusion
        try await clearFlutterHiveData("radarr_movies")

        // Mark migration complete
        UserDefaults.standard.set(true, forKey: "radarr_data_migrated")
    }
}
```

### Rule 11: Bridge Error Handling (MANDATORY)

**Flutter-Swift bridge must handle all error scenarios gracefully:**

```dart
// Flutter: Robust error handling for Swift bridge calls
class SwiftBridgeWrapper {
  static const _channel = MethodChannel('com.thriftwood.swift_data');

  static Future<T?> callSwiftMethod<T>(String method, [dynamic arguments]) async {
    try {
      final result = await _channel.invokeMethod(method, arguments);
      return result as T?;
    } on PlatformException catch (e) {
      // Log detailed error information
      Logger.error('Swift bridge call failed', error: e, context: {
        'method': method,
        'arguments': arguments,
      });

      // Show user-friendly error
      BridgeErrorReporter.showErrorToUser(
        title: 'Feature Unavailable',
        message: 'This feature requires the latest iOS native implementation.',
        actions: [
          ErrorAction.retry(() => callSwiftMethod<T>(method, arguments)),
          ErrorAction.reportBug(e),
        ],
      );

      return null;
    } catch (e) {
      Logger.error('Unexpected bridge error', error: e);
      return null;
    }
  }
}
```

## Updated Migration Timeline

### Phase 1: Swift Implementation (2 weeks per feature)

- Implement complete Swift feature with SwiftUI
- Create comprehensive test suite
- Implement Flutter-Swift data bridge
- Validate 100% feature parity

### Phase 2: Flutter Delegation (1 week per feature)

- Update Flutter routes to check Swift availability
- Implement immediate delegation to Swift
- Create fallback UI for unavailable features
- Test end-to-end user workflows

### Phase 3: Data Migration (1 week per feature)

- Implement one-time Flutter → Swift data migration
- Migrate existing user data to SwiftData
- Validate data integrity and completeness
- Clear Flutter storage to prevent conflicts

### Phase 4: Flutter Code Elimination (1 week per feature)

- Remove Flutter UI implementation completely
- Remove Flutter state management
- Remove Flutter API clients and data models
- Clean up dependencies and navigation
- Update documentation

### Phase 5: Validation & Optimization (1 week per feature)

- Full regression testing
- Performance validation
- User acceptance testing
- Documentation updates
- Release preparation

## Benefits of Swift-First Migration

### Code Quality Benefits

- **Single source of truth** eliminates data synchronization complexity
- **Reduced maintenance burden** - one implementation instead of two
- **Better performance** - native Swift performance without bridge overhead
- **Simplified architecture** - clear separation of concerns

### User Experience Benefits

- **Consistent behavior** - no discrepancies between Flutter/Swift versions
- **Better iOS integration** - native iOS patterns and performance
- **Faster feature delivery** - no need to maintain parallel implementations
- **Smaller app size** - eliminated Flutter code reduces bundle size

### Development Benefits

- **Faster development** - single implementation path
- **Easier testing** - one codebase to test and validate
- **Simplified debugging** - no cross-platform synchronization issues
- **Modern architecture** - Swift 6 + SwiftUI best practices

## Validation Checklist for Swift-First Migration

### Pre-Migration Validation

- [ ] **Swift implementation 100% complete** with full feature parity
- [ ] **Flutter-Swift data bridge implemented** and tested
- [ ] **Data migration strategy defined** and tested
- [ ] **Error handling comprehensive** for all bridge operations
- [ ] **Performance benchmarks meet or exceed** Flutter version

### Migration Execution Validation

- [ ] **Flutter delegation implemented** correctly
- [ ] **Data migration executed** successfully without loss
- [ ] **Flutter code removed** completely (UI, state, API, data)
- [ ] **Dependencies cleaned up** (unused packages removed)
- [ ] **Navigation updated** to reflect Swift-only implementation

### Post-Migration Validation

- [ ] **Full feature functionality** confirmed in production
- [ ] **No user-facing regressions** identified
- [ ] **Performance improvement** measured and documented
- [ ] **Code coverage maintained** or improved
- [ ] **Documentation updated** to reflect new architecture

---

**🎯 Migration Success Criteria for Swift-First Approach:**

A feature migration is complete when:

- ✅ Swift implementation provides 100% of original Flutter functionality
- ✅ Flutter can access Swift data models with full read/write capability
- ✅ No Flutter code remains for the migrated feature
- ✅ User experience is identical or improved
- ✅ Performance equals or exceeds the original Flutter implementation
- ✅ Single source of truth eliminates data synchronization complexity

**The goal: Native iOS performance with Swift as the single source of truth, accessible to Flutter when needed, with zero code duplication.**
// Flutter: Always decide at runtime and work from both sources
final ok = await HybridRouter.navigateTo(context, '/some/route', data: {...});
if (!ok) {
// Show actionable error (see Rule 14)
}

````

```swift
// Swift: Present native or route to Flutter symmetrically
if FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route) {
    FlutterSwiftUIBridge.shared.presentNativeView(route: route, data: data)
} else {
    HybridNavigationCoordinator.shared.navigateInFlutter(route: route, data: data)
}
````

Validation Checklist:

- [ ] Can navigate Flutter → SwiftUI for every registered route
- [ ] Can navigate SwiftUI → Flutter for the same route set
- [ ] Return navigation works in both directions (Back to Flutter / Back to SwiftUI)
- [ ] Data/results are passed equivalently in both directions
- [ ] Deep links function from either technology as an entry point

### Rule 14: Actionable Navigation Errors (NO SILENT FAILURES) (MANDATORY)

Navigation errors MUST NEVER be silently ignored. Users MUST see an actionable error with clear next steps (Retry, Go Back, Open Logs). Debug output alone is insufficient.

Acceptable UI patterns:

- Flutter: `ErrorRoutePage`, `LunaMessage.error(...)`, `showLunaErrorSnackBar(...)`, or a modal dialog with Retry/Go Back.
- SwiftUI: `Alert`/`confirmationDialog`, an error placeholder view with buttons (Retry / Back to Flutter), or banner/toast with accessible labels.

Implementation Requirements:

```dart
// Wrap all bridge navigation calls
try {
  final ok = await NativeBridge.navigateToNativeView(route, data: data);
  if (!ok) {
    showLunaErrorSnackBar(title: 'Navigation failed', message: 'Could not open $route');
  }
} on PlatformException catch (e) {
  // Report + show actionable UI
  BridgeErrorReporter.reportPlatformException(e, 'navigateToNativeView', 'NativeBridge', context: {'route': route});
  showLunaErrorSnackBar(title: 'Navigation error', error: e);
}
```

```swift
// Do not just print and return; surface an actionable error to the user
guard FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route) else {
    HybridNavigationCoordinator.shared.presentError(
        title: "Navigation not available",
        message: "The native view for \(route) is not registered.",
        actions: [.retry, .backToFlutter]
    )
    return
}
```

Validation Checklist:

- [ ] All navigation helpers return a success/failure signal
- [ ] Call sites check the result and show user-facing errors on failure
- [ ] Exceptions are caught and reported, then surfaced via accessible UI
- [ ] No code path relies solely on `print`, `debugPrint`, or logs for navigation errors
- [ ] Error UI includes at least one action (Retry / Go Back / Report / Open Logs)

## Comprehensive Validation Checklist

Use this checklist for every Swift implementation. **ALL items must be checked before approval.**

### 🔍 Migration Documentation Validation

- [ ] **Migration comment header present** with all required fields
- [ ] **Flutter source file path and line numbers documented**
- [ ] **Original Flutter class/function names listed**
- [ ] **Migration date and developer recorded**
- [ ] **Validation status clearly marked**
- [ ] **Ported features comprehensively listed**
- [ ] **Bidirectional sync approach documented**
- [ ] **Test coverage status documented**

### 🔄 Bidirectional Integration Validation

- [ ] **ViewModel implements SharedDataProtocol**
- [ ] **Loads initial state from Flutter storage**
- [ ] **Saves changes back to Flutter immediately**
- [ ] **Listens for Flutter state change notifications**
- [ ] **Method channel integration implemented**
- [ ] **Cross-platform data types properly converted**
- [ ] **No data loss during platform switching**
- [ ] **State changes trigger updates on both platforms**

### ⚡ Core Functionality Validation

- [ ] **Every Flutter method has a Swift equivalent**
- [ ] **All parameters and return types match semantically**
- [ ] **Error conditions are handled identically**
- [ ] **State management follows same patterns**
- [ ] **Data persistence maintains consistency**
- [ ] **User workflows remain unchanged**
- [ ] **All edge cases properly handled**
- [ ] **Performance characteristics maintained or improved**

### 🎨 Pure SwiftUI Validation

- [ ] **No UIKit imports** (UIViewController, UIView, UIApplication, etc.)
- [ ] **No AppKit imports** for macOS compatibility
- [ ] **Uses SwiftUI native components only**
- [ ] **File operations use SwiftUI fileImporter/fileExporter**
- [ ] **Dialogs use SwiftUI confirmationDialog/alert**
- [ ] **Navigation uses SwiftUI NavigationStack/NavigationLink**
- [ ] **Animations use SwiftUI animation modifiers**
- [ ] **Gestures use SwiftUI gesture recognizers**

### 📱 iOS 17+ Modern Patterns Validation

- [ ] **@Observable used instead of ObservableObject**
- [ ] **No @Published properties** (auto-tracking enabled)
- [ ] **@State used instead of @StateObject** for owned ViewModels
- [ ] **@Bindable used for child views** requiring two-way binding
- [ ] **@Environment(Type.self) used instead of @EnvironmentObject**
- [ ] **async/await patterns** for all asynchronous operations
- [ ] **@MainActor used for UI update functions**
- [ ] **Swift 6 strict concurrency compliance**

### 🗃️ Data Model Validation

- [ ] **All Flutter properties represented in Swift**
- [ ] **Property types are Swift-equivalent** (String, Int, Bool, etc.)
- [ ] **Enums match case-for-case with Flutter**
- [ ] **JSON serialization produces identical structure**
- [ ] **Default values match Flutter initialization**
- [ ] **Validation rules identical to Flutter**
- [ ] **Computed properties maintain same logic**
- [ ] **Relationship mapping preserved**

### 🖥️ UI State & Navigation Validation

- [ ] **Loading states match Flutter behavior exactly**
- [ ] **Error states provide same feedback and actions**
- [ ] **Success states trigger identical user flows**
- [ ] **Navigation patterns are equivalent**
- [ ] **User interactions produce same results**
- [ ] **Form validation behaves identically**
- [ ] **Modal presentations work consistently**
- [ ] **Deep linking maintains same behavior**

### 🌉 Method Channel & Bridge Validation

- [ ] **FlutterSwiftUIBridge integration implemented**
- [ ] **SharedDataManager properly configured**
- [ ] **Method channel communication working**
- [ ] **Data serialization/deserialization functional**
- [ ] **Navigation calls work bidirectionally**
- [ ] **Error propagation across bridge**
- [ ] **Performance impact minimal**
- [ ] **Memory management proper (no retain cycles)**

### 🔗 Method Channel Management Validation (CRITICAL)

**These validations would have prevented the dashboard navigation failure:**

- [ ] **Single handler per channel verified**
  - Confirm only one `setMethodCallHandler` call per method channel
  - Check for handler override conflicts during bridge initialization
- [ ] **Method call routing documented**
  - Document which service handles which method calls
  - Verify method call dispatch logic covers all expected cases
- [ ] **Handler delegation implemented**
  - Services delegate unhandled method calls to appropriate fallback handlers
  - No method calls result in "UNIMPLEMENTED" exceptions unexpectedly
- [ ] **Channel conflict detection active**
  - Runtime or build-time detection of multiple handlers on same channel
  - Clear error messages when handler conflicts are detected
- [ ] **Method call logging enabled**
  - Debug logs show which service receives and handles each method call
  - Method call flow traceable from SwiftUI → Flutter bridge → service handler
- [ ] **End-to-end method testing completed**
  - All bridge method calls manually tested from SwiftUI to Flutter
  - Return navigation methods (like `onReturnFromNative`) verified working
- [ ] **Method handler coverage verified**
  - All registered SwiftUI views can successfully call back to Flutter
  - All Flutter → SwiftUI navigation methods functional
- [ ] **Error handling for unknown methods**
  - Clear error messages when unimplemented methods are called
  - Graceful fallback behavior for missing method handlers

### 🧭 Hybrid Navigation Validation (CRITICAL - MISSING CAUSED DASHBOARD ISSUE)

**These validations would have caught the dashboard navigation failure:**

- [ ] **Route registration path exactly matches Flutter route path**
  - Verify registered route identifier matches GoRouter path character-for-character
  - Test both "/route" and "route" formats if bridge supports both
- [ ] **Flutter route implements hybrid navigation check**
  - Route builder calls `NativeBridge.isNativeViewAvailable()` before showing Flutter widget
  - Route redirects to SwiftUI when hybrid navigation is enabled
- [ ] **Bridge registration confirmed in iOS logs**
  - Check console for "✅ [ViewName] registered with FlutterSwiftUIBridge" message
  - Verify no registration errors or warnings
- [ ] **End-to-end navigation test completed**
  - Manually navigate from Flutter app to the SwiftUI view
  - Verify SwiftUI view loads correctly and displays expected content
  - Test "Back to Flutter" navigation works properly
- [ ] **Deep linking and direct access functional**
  - Direct navigation to SwiftUI route works from Flutter
  - URL-based navigation (if applicable) correctly routes to SwiftUI
- [ ] **Route fallback behavior verified**
  - If SwiftUI view fails to load, Flutter version displays correctly
  - No blank screens or navigation dead-ends
- [ ] **Bridge method channel operational**
  - Data can be passed from Flutter to SwiftUI view during navigation
  - SwiftUI view can communicate back to Flutter bridge
- [ ] **Multiple navigation paths tested**
  - Navigation works from different Flutter screens/contexts
  - Navigation works through different user workflows (deep links, menu navigation, etc.)

### 🔧 System Integration Validation

- [ ] **File operations match Flutter behavior**
- [ ] **Network requests use same endpoints/formats**
- [ ] **Cache management operates identically**
- [ ] **Background tasks behave equivalently**
- [ ] **Permissions and security match**
- [ ] **Device capabilities accessed consistently**
- [ ] **Third-party integrations maintained**
- [ ] **Analytics and logging preserved**

### ✅ Compilation & Quality Validation

- [ ] **Swift implementation compiles without errors**
- [ ] **No compilation warnings related to implementation**
- [ ] **All dependencies properly resolved**
- [ ] **Xcode build succeeds completely**
- [ ] **Type safety validation passes**
- [ ] **Memory leaks absent (Instruments validation)**
- [ ] **Performance regression testing passed**
- [ ] **SwiftUI Preview compilation successful**

### ♿ Accessibility & Testing Validation

- [ ] **VoiceOver support equivalent to Flutter**
- [ ] **Keyboard navigation fully functional**
- [ ] **Dynamic Type support implemented**
- [ ] **High contrast mode support**
- [ ] **Unit tests written for ViewModel logic**
- [ ] **UI tests cover critical user paths**
- [ ] **Integration tests validate cross-platform data sync**
- [ ] **Manual testing completed and documented**

## Advanced Integration Patterns

### Flutter ↔ Swift ViewModel Communication

**Pattern 1: Real-time State Synchronization**

```swift
@Observable
class RadarrViewModel {
    // MARK: - Flutter Parity Implementation
    // Flutter equivalent: lib/modules/radarr/core/state.dart:1-150
    // Original Flutter class: RadarrState extends LunaModuleState
    // Migration date: 2025-09-30
    // Migrated by: GitHub Copilot
    // Validation status: ✅ Complete
    // Features ported: API client, movie management, queue operations, settings
    // Data sync: Bidirectional via SharedDataManager + method channels
    // Testing: Unit tests + integration tests + manual validation

    private let sharedDataManager = SharedDataManager.shared
    private let methodChannel: FlutterMethodChannel?

    // Mirror Flutter's RadarrState properties exactly
    var movies: [Movie] = []
    var isLoading: Bool = false
    var apiEnabled: Bool = false

    init(methodChannel: FlutterMethodChannel? = nil) {
        self.methodChannel = methodChannel
        setupFlutterSync()
    }

    /// Setup bidirectional sync with Flutter RadarrState
    private func setupFlutterSync() {
        // Listen for Flutter state changes
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            Task { @MainActor in
                await self?.handleFlutterStateChange(call, result: result)
            }
        }

        // Load initial state from Flutter
        Task { await loadFromFlutterState() }
    }

    /// Sync any local changes back to Flutter immediately
    @MainActor
    private func syncToFlutter() async {
        guard let channel = methodChannel else { return }

        let stateData = [
            "movies": movies.map { $0.toDictionary() },
            "isLoading": isLoading,
            "apiEnabled": apiEnabled
        ]

        do {
            _ = try await channel.invokeMethod("updateRadarrState", arguments: stateData)
        } catch {
            print("Failed to sync RadarrViewModel to Flutter: \(error)")
        }
    }

    /// Handle incoming state changes from Flutter
    @MainActor
    private func handleFlutterStateChange(_ call: FlutterMethodCall, result: @escaping FlutterResult) async {
        switch call.method {
        case "onRadarrStateChanged":
            if let args = call.arguments as? [String: Any] {
                await updateFromFlutterState(args)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
```

**Pattern 2: Method Channel Function Mapping**

```swift
extension RadarrViewModel {
    // MARK: - Flutter Function Parity
    // Maps Flutter RadarrState methods to Swift equivalents

    /// Swift equivalent of Flutter's fetchMovies()
    /// Original: lib/modules/radarr/core/state.dart:45-67
    @MainActor
    func fetchMovies() async throws {
        // Identical implementation to Flutter's fetchMovies()
        isLoading = true
        defer {
            isLoading = false
            await syncToFlutter() // Notify Flutter of state change
        }

        // Implementation mirrors Flutter logic exactly...
        movies = try await apiClient.getMovies()
    }

    /// Swift equivalent of Flutter's addMovie(movie)
    /// Original: lib/modules/radarr/core/state.dart:89-112
    @MainActor
    func addMovie(_ movie: Movie) async throws {
        // Mirror Flutter's addMovie implementation
        try await apiClient.addMovie(movie)
        await fetchMovies() // Refresh like Flutter does
        await syncToFlutter() // Ensure Flutter state updated
    }
}
```

### SharedDataManager Integration

**All ViewModels must integrate with SharedDataManager for persistent storage sync:**

```swift
extension RadarrViewModel {
    // MARK: - Persistent Storage Sync

    /// Load state from Flutter's Hive storage
    @MainActor
    private func loadFromFlutterState() async {
        do {
            // Load from same storage keys Flutter uses
            if let movies: [Movie] = try await sharedDataManager.loadData(type: [Movie].self, forKey: "radarr_movies") {
                self.movies = movies
            }

            if let enabled: Bool = try await sharedDataManager.loadData(type: Bool.self, forKey: "radarr_enabled") {
                self.apiEnabled = enabled
            }
        } catch {
            print("Failed to load RadarrViewModel state from Flutter storage: \(error)")
        }
    }

    /// Save state to Flutter's Hive storage
    @MainActor
    private func saveToFlutterStorage() async {
        do {
            try await sharedDataManager.saveData(movies, forKey: "radarr_movies")
            try await sharedDataManager.saveData(apiEnabled, forKey: "radarr_enabled")
        } catch {
            print("Failed to save RadarrViewModel state to Flutter storage: \(error)")
        }
    }
}
```

### View-Level Integration Requirements

**Every SwiftUI View must integrate with FlutterSwiftUIBridge:**

```swift
struct RadarrMoviesView: View {
    // MARK: - Flutter Parity Implementation
    // Flutter equivalent: lib/modules/radarr/routes/radarr.dart:15-89
    // Original Flutter class: RadarrRoute extends StatefulWidget
    // Migration date: 2025-09-30
    // Features ported: Movie list, search, filtering, context menus
    // Navigation: Integrated with FlutterSwiftUIBridge

    @State private var viewModel: RadarrViewModel
    @Environment(\.dismiss) private var dismiss

    init() {
        // Initialize with method channel from FlutterSwiftUIBridge
        let bridge = FlutterSwiftUIBridge.shared
        self._viewModel = State(initialValue: RadarrViewModel(methodChannel: bridge.methodChannel))
    }

    var body: some View {
        NavigationStack {
            // SwiftUI implementation matching Flutter UI exactly...
            List(viewModel.movies) { movie in
                MovieRow(movie: movie)
                    .onTapGesture {
                        // Navigate to movie details - check if SwiftUI or Flutter
                        Task {
                            await navigateToMovieDetails(movie)
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back to Flutter") {
                    FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
                        "lastRoute": "/radarr",
                        "timestamp": Date().timeIntervalSince1970
                    ])
                }
            }
        }
    }

    /// Navigate to movie details - hybrid navigation decision
    private func navigateToMovieDetails(_ movie: Movie) async {
        let bridge = FlutterSwiftUIBridge.shared
        let detailsRoute = "/radarr/movie/\(movie.id)"

        if bridge.shouldUseNativeView(for: detailsRoute) {
            // Navigate to SwiftUI details view
            // Implementation for SwiftUI navigation...
        } else {
            // Navigate back to Flutter for details view
            bridge.navigateBackToFlutter(data: [
                "navigateTo": detailsRoute,
                "movieId": movie.id,
                "movieData": movie.toDictionary()
            ])
        }
    }
}
```

## Implementation Requirements

### Mandatory Documentation Standards

**Every Swift file must include comprehensive migration documentation:**

```swift
// MARK: - Flutter Parity Implementation
// Flutter equivalent: [exact file path and line numbers]
// Original Flutter class: [exact class name and hierarchy]
// Migration date: YYYY-MM-DD
// Migrated by: [Developer name or GitHub Copilot]
// Validation status: ✅ Complete | ⚠️ Partial | ❌ Missing features
// Features ported: [comprehensive list of features/methods]
// Data sync: [detailed description of bidirectional sync]
// Testing: [test coverage status and validation approach]
// Dependencies: [any external dependencies or services used]
// Known limitations: [any current limitations or TODO items]
// Performance notes: [any performance considerations or optimizations]

/// [Comprehensive description of the Swift implementation]
///
/// This SwiftUI implementation maintains 100% functional parity with Flutter's [ClassName].
/// All user workflows, state management, and data persistence work identically.
///
/// **Bidirectional Integration Details:**
/// - Initial state loaded from Flutter storage on initialization
/// - All state changes immediately synced back to Flutter via SharedDataManager
/// - Flutter state changes received via method channel notifications
/// - Navigation integrated with FlutterSwiftUIBridge for seamless transitions
///
/// **Flutter Method Mapping:**
/// - flutter_method_1() -> swift_method_1()
/// - flutter_method_2() -> swift_method_2()
/// - [complete mapping of all methods]
///
/// **Data Storage Consistency:**
/// - Uses identical storage keys as Flutter implementation
/// - Maintains same data serialization format
/// - Preserves all validation rules and constraints
```

### Comprehensive Testing Requirements

**Testing must validate complete Flutter parity:**

- **Unit Tests**: Every ViewModel method must have corresponding test validating identical behavior to Flutter
- **Integration Tests**: Cross-platform data sync must be thoroughly tested
- **UI Tests**: Critical user workflows must be validated on both platforms
- **Performance Tests**: No regression in performance compared to Flutter
- **Manual Testing**: Complete feature validation with side-by-side comparison
- **Accessibility Tests**: VoiceOver and keyboard navigation validation

### Strict Code Review Requirements

**All Swift implementations require multi-stage validation:**

1. **Self-Validation**: Developer completes full validation checklist
2. **Automated Validation**: CI/CD checks compilation and test coverage
3. **Peer Review**: Another developer validates Flutter parity
4. **Integration Testing**: QA validates cross-platform functionality
5. **Final Sign-off**: Technical lead approves migration completion

## Automated Enforcement & CI/CD Integration

### Pre-Commit Hooks (MANDATORY)

```bash
#!/bin/bash
# .git/hooks/pre-commit - Flutter-Swift Parity Validation

echo "🔍 Validating Swift-Flutter parity..."

# Check for required migration comments in Swift files
find ios/Native -name "*.swift" -exec grep -L "// MARK: - Flutter Parity Implementation" {} \; | while read file; do
    echo "❌ Missing Flutter parity documentation: $file"
    exit 1
done

# Check for TODO comments in Swift files
if grep -r "TODO\|FIXME\|XXX" ios/Native --include="*.swift"; then
    echo "❌ TODO comments found in Swift implementation"
    exit 1
fi

# CRITICAL: Validate hybrid navigation registration consistency
echo "🧭 Validating hybrid navigation route registration..."

# Extract registered SwiftUI routes from Bridge files
if [ -d "ios/Native/Bridge" ]; then
    swift_routes=$(grep -r "registerNativeView(" ios/Native/Bridge --include="*.swift" | sed -n 's/.*registerNativeView("\([^"]*\)").*/\1/p' | sort | uniq)

    # Extract Flutter GoRouter routes
    if [ -d "lib/router" ]; then
        flutter_routes=$(grep -r "path: ['\"]" lib/router --include="*.dart" | sed -n "s/.*path: ['\"]\\([^'\"]*\\)['\"].*/\\1/p" | sort | uniq)

        # Check for registration mismatches that caused dashboard navigation failure
        echo "📍 Registered SwiftUI routes: $swift_routes"
        echo "📍 Flutter GoRouter routes: $flutter_routes"

        # Find routes that are registered in Swift but don't match Flutter routes exactly
        mismatched_routes=""
        while IFS= read -r swift_route; do
            if [ ! -z "$swift_route" ]; then
                route_found=false

                # Check exact match
                if echo "$flutter_routes" | grep -Fxq "$swift_route"; then
                    route_found=true
                # Check variation with leading slash
                elif [[ "$swift_route" == /* ]]; then
                    route_without_slash="${swift_route:1}"
                    if echo "$flutter_routes" | grep -Fxq "$route_without_slash"; then
                        route_found=true
                    fi
                else
                    route_with_slash="/$swift_route"
                    if echo "$flutter_routes" | grep -Fxq "$route_with_slash"; then
                        route_found=true
                    fi
                fi

                if [ "$route_found" = false ]; then
                    mismatched_routes="$mismatched_routes\n❌ SwiftUI route '$swift_route' has no matching Flutter route"
                fi
            fi
        done <<< "$swift_routes"

        if [ ! -z "$mismatched_routes" ]; then
            echo -e "$mismatched_routes"
            echo
            echo "� CRITICAL: Route registration mismatch detected!"
            echo "This causes navigation failures like the dashboard issue we just fixed."
            echo "Fix: Ensure SwiftUI registerNativeView() identifiers exactly match Flutter GoRouter paths"
            exit 1
        fi
    fi
fi

# Validate Swift compilation
echo "�🔨 Building Swift implementation..."
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -destination 'generic/platform=iOS' build-for-testing
if [ $? -ne 0 ]; then
    echo "❌ Swift compilation failed"
    exit 1
fi

echo "✅ Pre-commit validation passed - No hybrid navigation mismatches detected"
```

### CI/CD Pipeline Validation

```yaml
# .github/workflows/flutter-swift-parity.yml
name: Flutter-Swift Parity Validation

on:
  pull_request:
    paths: ["ios/Native/**/*.swift"]

jobs:
  validate-parity:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Validate Migration Documentation
        run: |
          # Ensure all Swift files have migration headers
          missing_docs=$(find ios/Native -name "*.swift" -exec grep -L "Flutter equivalent:" {} \;)
          if [ ! -z "$missing_docs" ]; then
            echo "❌ Missing Flutter parity documentation in:"
            echo "$missing_docs"
            exit 1
          fi

      - name: Check for TODO Comments
        run: |
          todos=$(grep -r "TODO\|FIXME\|XXX" ios/Native --include="*.swift" || true)
          if [ ! -z "$todos" ]; then
            echo "❌ TODO comments found in Swift implementation:"
            echo "$todos"
            exit 1
          fi

      - name: Validate Swift Modern Patterns
        run: |
          # Check for deprecated patterns
          deprecated=$(grep -r "@Published\|@StateObject\|@ObservedObject\|@EnvironmentObject" ios/Native --include="*.swift" || true)
          if [ ! -z "$deprecated" ]; then
            echo "❌ Deprecated SwiftUI patterns found. Use iOS 17+ @Observable pattern:"
            echo "$deprecated"
            exit 1
          fi

      - name: Build Swift Implementation
        run: |
          cd ios
          xcodebuild -workspace Runner.xcworkspace -scheme Runner -destination 'generic/platform=iOS' build-for-testing
```

### Peer Review Requirements

**All Pull Requests touching Swift files require:**

1. **Migration Documentation Review**:

   - [ ] All required migration comment fields completed
   - [ ] Flutter source files and line numbers verified
   - [ ] Feature parity claims validated against Flutter implementation

2. **Bidirectional Integration Review**:

   - [ ] SharedDataManager integration implemented correctly
   - [ ] Method channel communication working as expected
   - [ ] State synchronization tested with Flutter running

3. **Code Quality Review**:
   - [ ] Modern SwiftUI patterns used (iOS 17+ @Observable)
   - [ ] No UIKit dependencies introduced
   - [ ] Swift 6 concurrency patterns followed

## Critical Issues Documentation - Dashboard Navigation Failure Analysis

**This section documents the specific issues that caused the SwiftUI dashboard to be inaccessible, and the validation rules that would have prevented them.**

### Issue 1: Route Registration Mismatch (CRITICAL)

**Problem**: The dashboard SwiftUI view was registered with route identifier "dashboard" but the actual Flutter route was "/dashboard"

**Root Cause**:

```swift
// ❌ WRONG - What was implemented
extension FlutterSwiftUIBridge {
    func registerDashboardView() {
        registerNativeView("dashboard") // No leading slash
    }
}
```

**Impact**: Bridge couldn't find the SwiftUI view when Flutter navigated to "/dashboard"

**Solution**:

```swift
// ✅ CORRECT - Fixed implementation
extension FlutterSwiftUIBridge {
    func registerDashboardView() {
        registerNativeView("/dashboard") // Matches exact Flutter route
    }
}
```

**Prevention Rule**: Route registration identifiers MUST exactly match Flutter GoRouter path strings character-for-character

### Issue 2: Missing Hybrid Navigation Check (CRITICAL)

**Problem**: Flutter dashboard route directly instantiated Flutter widget without checking if SwiftUI version should be used

**Root Cause**:

```dart
// ❌ WRONG - What was implemented
GoRoute(
  path: '/dashboard',
  builder: (context, state) => DashboardRoute(), // Direct Flutter widget
),
```

**Impact**: Flutter always showed its own dashboard widget, never checking for SwiftUI alternative

**Solution**:

```dart
// ✅ CORRECT - Fixed implementation
GoRoute(
  path: '/dashboard',
  builder: (context, state) => HybridDashboardRoute(), // Checks for SwiftUI first
),

class HybridDashboardRoute extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: NativeBridge.isNativeViewAvailable('/dashboard'),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          // Navigate to SwiftUI version
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await NativeBridge.navigateToNativeView('/dashboard');
          });
          return Container(); // Temporary placeholder
        }
        return DashboardRoute(); // Show Flutter version
      },
    );
  }
}
```

**Prevention Rule**: All Flutter routes with SwiftUI equivalents MUST check hybrid navigation before showing Flutter widget

### Issue 3: Insufficient End-to-End Testing (CRITICAL)

**Problem**: No systematic validation that registered SwiftUI views are actually accessible from Flutter navigation

**Root Cause**: Missing validation step to manually test navigation from Flutter to SwiftUI views

**Impact**: SwiftUI view was registered but couldn't be reached through normal app navigation

**Solution**: Mandatory end-to-end navigation testing for all hybrid routes

**Prevention Rule**: All SwiftUI view registrations MUST include manual navigation test from Flutter app

### Issue 4: Inconsistent Route Handling (MODERATE)

**Problem**: Bridge handled different route formats inconsistently ("/route" vs "route")

**Root Cause**:

```swift
// ❌ INCONSISTENT - What was implemented
func createSwiftUIView(for route: String, data: [String: Any]) -> AnyView {
    switch route {
    case "dashboard": // Only handled version without slash
        return AnyView(DashboardView())
    default:
        return AnyView(EmptyView())
    }
}
```

**Solution**:

```swift
// ✅ CONSISTENT - Fixed implementation
func createSwiftUIView(for route: String, data: [String: Any]) -> AnyView {
    switch route {
    case "/dashboard", "dashboard": // Handle both formats
        return AnyView(DashboardView())
    default:
        return AnyView(EmptyView())
    }
}
```

**Prevention Rule**: Bridge route handling MUST support both "/route" and "route" formats for maximum compatibility

### Lessons Learned - New Mandatory Validation Steps

**These validation steps are now MANDATORY for all SwiftUI view implementations:**

1. **Route Registration Verification**:

   - Verify registered route identifier exactly matches Flutter GoRouter path
   - Test both "/route" and "route" variations if applicable
   - Check iOS logs for successful registration confirmation

2. **Flutter Route Hybrid Check Implementation**:

   - Implement HybridRouteWrapper or equivalent for all routes with SwiftUI versions
   - Verify route checks `NativeBridge.isNativeViewAvailable()` before showing Flutter widget
   - Test route fallback behavior when SwiftUI view is unavailable

3. **End-to-End Navigation Testing**:

   - Manually navigate from Flutter app to SwiftUI view
   - Verify SwiftUI view loads and displays correctly
   - Test "Back to Flutter" navigation functionality
   - Validate deep linking and direct navigation paths

4. **Bridge Integration Validation**:
   - Confirm bridge method channel is operational
   - Test data passing from Flutter to SwiftUI during navigation
   - Verify SwiftUI view can communicate back to Flutter bridge

**Implementation Timeline**: These validation steps are retroactively applied to all existing SwiftUI implementations and MANDATORY for all future migrations.

## Common Migration Patterns & Examples

### Pattern 1: Flutter ChangeNotifier → Swift @Observable

```dart
// Flutter: lib/modules/radarr/core/state.dart
class RadarrState extends ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  void setMovies(List<Movie> movies) {
    _movies = movies;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
```

```swift
// Swift: ios/Native/ViewModels/RadarrViewModel.swift
// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules/radarr/core/state.dart:15-45
// Original Flutter class: RadarrState extends ChangeNotifier
// Migration date: 2025-09-30
// Features ported: movies list, loading state, state notifications
// Data sync: Bidirectional via SharedDataManager

@Observable
class RadarrViewModel {
    var movies: [Movie] = []
    var isLoading: Bool = false

    private let sharedDataManager = SharedDataManager.shared

    /// Swift equivalent of Flutter's setMovies()
    @MainActor
    func setMovies(_ movies: [Movie]) async {
        self.movies = movies
        await syncToFlutter() // Notify Flutter of change
    }

    /// Swift equivalent of Flutter's setLoading()
    @MainActor
    func setLoading(_ loading: Bool) async {
        self.isLoading = loading
        await syncToFlutter() // Notify Flutter of change
    }
}
```

### Pattern 2: Flutter Provider → SwiftUI @Environment

```dart
// Flutter: Using Provider for dependency injection
ChangeNotifierProvider(
  create: (context) => RadarrState(context),
  builder: (context, _) => RadarrRoute(),
)
```

```swift
// Swift: Using @Environment for dependency injection
struct ContentView: View {
    @State private var radarrViewModel = RadarrViewModel()

    var body: some View {
        RadarrMoviesView()
            .environment(radarrViewModel) // iOS 17+ pattern
    }
}

struct RadarrMoviesView: View {
    @Environment(RadarrViewModel.self) private var viewModel

    var body: some View {
        // View implementation using viewModel
    }
}
```

### Pattern 3: Flutter StatefulWidget → SwiftUI View + ViewModel

```dart
// Flutter: lib/modules/radarr/routes/movies/route.dart
class MoviesRoute extends StatefulWidget {
  @override
  State<MoviesRoute> createState() => _MoviesRouteState();
}

class _MoviesRouteState extends State<MoviesRoute> {
  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  Future<void> _refreshMovies() async {
    // Implementation
  }
}
```

```swift
// Swift: ios/Native/Views/RadarrMoviesView.swift
// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules/radarr/routes/movies/route.dart:1-89
// Original Flutter class: MoviesRoute extends StatefulWidget
// Features ported: initState -> onAppear, refresh functionality

struct RadarrMoviesView: View {
    @State private var viewModel = RadarrViewModel()

    var body: some View {
        List(viewModel.movies) { movie in
            MovieRow(movie: movie)
        }
        .onAppear {
            Task {
                await viewModel.refreshMovies() // Swift equivalent of _refreshMovies()
            }
        }
    }
}
```

## Violation Consequences & Escalation

### Immediate Rejections

- **Missing migration documentation** → PR automatically rejected by CI
- **TODO comments present** → Build fails, cannot merge
- **Compilation errors** → PR blocked until resolved
- **Deprecated SwiftUI patterns** → Code review rejection

### Progressive Enforcement

1. **First Violation**: Educational feedback, required fixes
2. **Second Violation**: Additional code review required
3. **Third Violation**: Migration privileges suspended pending training
4. **Repeated Violations**: Technical lead review of migration approach

### Quality Gates

- **🚨 Red**: Immediate rejection, cannot proceed
- **⚠️ Yellow**: Warning, requires attention before next PR
- **✅ Green**: Approved, meets all parity requirements

## Debugging Guide for Hybrid Navigation Issues

### Method Channel Handler Conflicts (Most Common Issue)

**Symptoms:**

- SwiftUI navigation works but return navigation fails
- "Method [method] not implemented" exceptions in Flutter
- Debug logs show method calls going to wrong service
- Navigation appears to work but produces unexpected errors

**Debugging Steps:**

1. **Check Handler Registration Order** in `lib/system/bridge/bridge_initializer.dart`:

```dart
// Look for multiple setMethodCallHandler calls on same channel
// The LAST one to call setMethodCallHandler wins!

void initialize() {
  HybridRouter().initialize();        // Sets handler on 'com.thriftwood.bridge'
  DashboardBridgeService().initialize(); // OVERRIDES HybridRouter handler!
}
```

2. **Add Method Call Logging** to identify which service receives calls:

```dart
Future<dynamic> _handleMethodCall(MethodCall call) async {
  print('🔍 ${runtimeType} received method call: ${call.method}');
  // ... handle method
}
```

3. **Verify Method Coverage** by listing all expected methods each service should handle:

```dart
// Document expected methods for each service
// HybridRouter: onReturnFromNative, navigateToFlutter, isNativeViewAvailable
// DashboardBridgeService: dashboardSpecificMethod1, dashboardSpecificMethod2
// Any overlap = potential conflict!
```

4. **Test Method Call Flow**:

- From SwiftUI, call each bridge method
- Verify correct Flutter service receives the call
- Check that method execution completes successfully

**Resolution Patterns:**

**Pattern 1: Central Dispatcher**

```dart
class BridgeMethodDispatcher {
  static final _instance = BridgeMethodDispatcher._internal();
  factory BridgeMethodDispatcher() => _instance;
  BridgeMethodDispatcher._internal();

  final Map<String, Future<dynamic> Function(MethodCall)> _handlers = {};

  void initialize() {
    _bridgeChannel.setMethodCallHandler(_dispatch);
  }

  void registerHandler(String method, Future<dynamic> Function(MethodCall) handler) {
    _handlers[method] = handler;
  }

  Future<dynamic> _dispatch(MethodCall call) async {
    final handler = _handlers[call.method];
    if (handler != null) {
      return await handler(call);
    }
    throw PlatformException(code: 'UNIMPLEMENTED', message: 'Method ${call.method} not handled by any service');
  }
}
```

**Pattern 2: Service Delegation**

```dart
class DashboardBridgeService {
  final HybridRouter _hybridRouter;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    // Handle dashboard-specific methods
    switch (call.method) {
      case 'dashboardMethod1':
      case 'dashboardMethod2':
        return await _handleDashboardMethod(call);
      default:
        // Delegate to HybridRouter for navigation methods
        return await _hybridRouter.handleMethodCall(call);
    }
  }
}
```

### Route Registration Mismatches

**Symptoms:**

- SwiftUI view registered but Flutter navigation doesn't work
- `isNativeViewAvailable` returns false for registered routes
- Manual navigation to SwiftUI works but automatic routing fails

**Debugging Steps:**

1. **Check Route Path Consistency**:

```swift
// iOS Bridge Registration
registerNativeView("settings")           // ❌ Wrong if Flutter route is "/settings"
registerNativeView("/settings")          // ✅ Correct

// Flutter Route Definition
GoRoute(path: '/settings', ...)          // Must match exactly
```

2. **Verify Registration Success** in iOS logs:

```
✅ Settings view registered with FlutterSwiftUIBridge  // Good
❌ Registration failed for route: settings             // Bad
```

3. **Test Route Availability Check**:

```dart
final available = await NativeBridge.isNativeViewAvailable('/settings');
print('Route /settings available: $available'); // Should be true
```

### Data Synchronization Failures

**Symptoms:**

- SwiftUI view loads but shows outdated data
- Changes in SwiftUI don't appear in Flutter
- Data inconsistencies between platforms

**Debugging Steps:**

1. **Check SharedDataManager Integration**:

```swift
// Verify data loading from Flutter storage
let data = try await sharedDataManager.loadData(type: MyDataType.self, forKey: "my_key")
print("Loaded from Flutter: \(data)")
```

2. **Verify Bidirectional Sync**:

```swift
// After making changes, confirm sync to Flutter
await syncToFlutter()
print("Data synced back to Flutter")
```

## Exception Process & Documentation

### When Parity Cannot Be Achieved

**Rare cases where Flutter behavior cannot be replicated exactly:**

1. **Document the limitation in detail**:

```swift
// MARK: - Platform Limitation Exception
// Flutter behavior: [exact Flutter behavior description]
// iOS limitation: [technical reason why exact parity impossible]
// Alternative implementation: [description of equivalent user experience]
// Approved by: [Technical lead name and date]
// Review date: [when this exception should be reconsidered]
```

2. **Propose alternative implementation** maintaining equivalent user experience
3. **Get explicit technical lead approval** with documentation
4. **Set review date** for reconsideration as platforms evolve

### Exception Examples

```swift
// MARK: - Platform Limitation Exception
// Flutter behavior: Uses Android/iOS native file picker with specific styling
// iOS limitation: SwiftUI fileImporter has different visual presentation
// Alternative implementation: SwiftUI native fileImporter with equivalent functionality
// User experience: Same file selection capability, iOS-native presentation
// Approved by: Technical Lead - 2025-09-30
// Review date: 2026-01-01 (when SwiftUI fileImporter gains more customization)
```

---

## Final Validation Statement

**🎯 Migration Success Criteria**:

A Swift implementation is considered successfully migrated when:

- ✅ User cannot distinguish between Flutter and SwiftUI versions
- ✅ All data syncs bidirectionally without loss or delay
- ✅ Navigation flows seamlessly between platforms
- ✅ Performance equals or exceeds Flutter version
- ✅ Full accessibility parity maintained
- ✅ Zero functional regressions introduced

**Remember: The hybrid migration is invisible to users. They should experience a cohesive, unified application regardless of which platform renders each view.**
