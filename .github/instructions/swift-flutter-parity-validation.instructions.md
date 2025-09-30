---
description: "Swift-Flutter functionality parity validation rules"
applyTo: "ios/Native/**/*.swift"
---

# Swift-Flutter Functionality Parity Validation

This document establishes **mandatory validation rules** to ensure that Swift implementations maintain 100% functional parity with their Flutter counterparts during the hybrid migration period, with proper bidirectional ViewModel integration and comprehensive migration tracking.

## Critical Validation Rules

### Rule 1: Complete Functional Parity (MANDATORY)

The Swift version **MUST** implement every feature that exists in the Flutter implementation:

- **Cannot miss any existing functionality**
- **Cannot change behavior of existing functionality**
- **Cannot remove features that exist in Flutter**
- **Cannot alter data structures or API contracts**
- **Must maintain identical user workflows and navigation patterns**
- **Must preserve all error handling and edge case behaviors**

### Rule 2: Pure SwiftUI Implementation (MANDATORY)

Swift implementations **MUST** be pure SwiftUI without UIKit dependencies:

- **No UIKit imports or usage** (UIViewController, UIView, etc.)
- **No AppKit usage** for macOS compatibility
- **Use SwiftUI native components only** (NavigationStack, Sheet, etc.)
- **SwiftUI-native file operations** (fileImporter, fileExporter)
- **SwiftUI-native dialogs** (confirmationDialog, alert)
- **Must use iOS 17+ @Observable pattern** instead of legacy ObservableObject
- **Must follow MVVM architecture** with proper ViewModels

### Rule 3: Hybrid Migration Toggle (MANDATORY)

**During the migration period, users MUST have the ability to switch between Flutter and SwiftUI implementations:**

- **Toggle Location**: Main settings screen (`lib/modules/settings/routes/settings/route.dart`)
- **Database Key**: `LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI`
- **Default State**: Flutter implementation (for stability during migration)
- **Behavior**: Toggle affects all settings navigation, with individual features respecting this choice
- **User Experience**: Clear labeling indicating which version is currently active
- **Data Consistency**: Both implementations must access the same underlying data store
- **Migration Transparency**: Users can switch back to Flutter if SwiftUI version has issues

**Implementation Requirements:**

```dart
// Flutter: Settings version selector widget (REQUIRED)
Widget _settingsVersionSelector() {
  const _db = LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI;
  return _db.listenableBuilder(
    builder: (context, _) {
      bool useSwiftUISettings = _db.read();

      return LunaBlock(
        title: 'Settings Version',
        body: [
          TextSpan(
            text: useSwiftUISettings
                ? 'Currently using SwiftUI settings (iOS native experience)'
                : 'Currently using Flutter settings (cross-platform experience)',
          )
        ],
        trailing: LunaSwitch(
          value: useSwiftUISettings,
          onChanged: _db.update,
        ),
      );
    },
  );
}

// Navigation handler that respects the toggle (REQUIRED)
void _handleSettingsNavigation(String section, bool useSwiftUISettings) {
  if (useSwiftUISettings) {
    // Navigate to SwiftUI version via bridge
    FlutterSwiftUIBridge.navigateToNativeView(
      'settings_$section',
      data: {'section': section},
    );
  } else {
    // Navigate to Flutter version using existing routes
    _navigateToFlutterSettings(section);
  }
}
```

**Bridge Registration Requirements:**

```swift
// Swift: All migrated views must be registered with the bridge
extension FlutterSwiftUIBridge {
    func registerMigratedViews() {
        // Register each SwiftUI view that replaces a Flutter equivalent
        registerNativeView("settings")
        registerNativeView("settings_configuration")
        registerNativeView("settings_profiles")
        registerNativeView("settings_system")
        // Add more as migration progresses
    }

    // Bridge must respect user choice and gracefully fallback
    func createSwiftUIView(for route: String, data: [String: Any]) -> AnyView {
        guard shouldUseNativeView(for: route) else {
            // Fallback to Flutter for unimplemented views
            return AnyView(EmptyView())
        }
        // Create appropriate SwiftUI view
    }
}
```

### Rule 4: Mandatory Migration Documentation (MANDATORY)

**Every ported function, class, and view MUST include migration tracking comments:**

```swift
// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules/[module]/[file].dart:[line_range]
// Original Flutter class: [FlutterClassName]
// Migration date: YYYY-MM-DD
// Migrated by: [Developer Name]
// Validation status: ✅ Complete | ⚠️ Partial | ❌ Missing features
// Features ported: [list of specific features/methods ported]
// Data sync: [description of bidirectional sync implementation]
// Testing: [test coverage status and validation approach]

/// Swift implementation of Flutter's [FlutterClassName]
/// Maintains 100% functional parity with Flutter counterpart
///
/// **Bidirectional Integration:**
/// - Reads from Flutter storage via SharedDataManager
/// - Writes changes back to Flutter via method channels
/// - Notifies Flutter of state changes via bridge system
///
/// **Flutter Equivalent Functions:**
/// - flutterMethod1() -> swiftMethod1()
/// - flutterMethod2() -> swiftMethod2()
/// - [list all equivalent functions]
```

### Rule 5: Bidirectional ViewModel Integration (MANDATORY)

**All ViewModels MUST implement proper Flutter ↔ Swift data synchronization:**

```swift
@Observable
class SwiftViewModel {
    // MARK: - Flutter Data Sync Properties
    private let sharedDataManager = SharedDataManager.shared
    private let methodChannel: FlutterMethodChannel?

    /// Initialize with Flutter bridge connection
    /// - Parameter methodChannel: Flutter method channel for bidirectional communication
    init(methodChannel: FlutterMethodChannel? = nil) {
        self.methodChannel = methodChannel
        Task { await loadFromFlutterStorage() }
        setupFlutterNotifications()
    }

    /// Load initial state from Flutter storage
    /// Must mirror Flutter state exactly
    @MainActor
    private func loadFromFlutterStorage() async {
        // Implementation required
    }

    /// Save changes back to Flutter
    /// Must trigger Flutter state updates
    @MainActor
    private func syncToFlutter() async {
        // Implementation required
    }

    /// Listen for Flutter state changes
    /// Must update Swift state when Flutter changes
    private func setupFlutterNotifications() {
        // Implementation required
    }
}
```

### Rule 6: Method Channel Integration (MANDATORY)

**All SwiftUI views MUST properly integrate with Flutter method channels:**

- **Incoming navigation** from Flutter must be handled via FlutterSwiftUIBridge
- **Outgoing navigation** to Flutter must use navigateBackToFlutter()
- **Data changes** must be synced bidirectionally via SharedDataManager
- **State updates** must notify both platforms immediately
- **Error states** must be consistent across platforms

### Rule 7: Zero TODOs Policy (MANDATORY)

Swift implementations **MUST** be 100% complete:

- **No TODO comments allowed** in production code
- **No placeholder implementations**
- **No commented-out functionality**
- **All error handling must be implemented**
- **All edge cases must be handled**
- **All Flutter features must be documented as ported**

### Rule 8: Data Model Consistency (MANDATORY)

Swift data models **MUST** exactly mirror Flutter models:

- Same property names and types (converted to Swift equivalents)
- Same validation rules and constraints
- Same default values and initialization
- Same JSON serialization format for bridge compatibility
- **Must implement SharedDataProtocol** for cross-platform sync
- **Must include Flutter model mapping documentation**

### Rule 9: Compilation Requirement (MANDATORY)

All Swift implementations **MUST** compile successfully:

- **Zero compilation errors** in the Swift implementation
- **All dependencies resolved** and properly linked
- **Valid syntax and type safety** throughout
- **Successful Xcode build** before validation approval
- **Swift 6 strict concurrency compliance**

### Rule 10: Modern SwiftUI Patterns (MANDATORY)

**Must follow iOS 17+ best practices:**

- **@Observable** instead of ObservableObject (no @Published properties)
- **@State** instead of @StateObject for owned ViewModels
- **@Bindable** for child views requiring two-way binding
- **@Environment(Type.self)** instead of @EnvironmentObject
- **async/await** patterns for all asynchronous operations
- **@MainActor** for UI update functions

### Rule 11: Method Channel Management (MANDATORY)

**Critical missing validation that caused dashboard navigation failure:**

**PROBLEM ANALYSIS**: The dashboard navigation issue occurred because multiple Flutter services were calling `setMethodCallHandler` on the same method channel (`com.thriftwood.bridge`), causing only the last registered handler to receive method calls. When SwiftUI attempted to navigate back to Flutter with `onReturnFromNative`, the call went to `DashboardBridgeService` instead of `HybridRouter`.

**METHOD CHANNEL EXCLUSIVE OWNERSHIP RULE**:

- **Only ONE service can call `setMethodCallHandler` per channel** - subsequent calls override previous handlers
- **All services sharing a channel MUST coordinate through a central dispatcher**
- **Bridge services MUST either use unique channels OR delegate unhandled methods**

**Implementation Requirements:**

```dart
// ❌ WRONG: Multiple services calling setMethodCallHandler on same channel
class HybridRouter {
  void initialize() {
    bridgeChannel.setMethodCallHandler(_handleMethodCall); // This gets overridden!
  }
}

class DashboardBridgeService {
  void initialize() {
    bridgeChannel.setMethodCallHandler(_handleMethodCall); // This overrides HybridRouter!
  }
}

// ✅ CORRECT: Central dispatcher pattern
class BridgeMethodDispatcher {
  final Map<String, Function> _methodHandlers = {};

  void initialize() {
    bridgeChannel.setMethodCallHandler(_centralDispatch); // Single handler
  }

  void registerMethodHandler(String method, Function handler) {
    _methodHandlers[method] = handler;
  }

  Future<dynamic> _centralDispatch(MethodCall call) async {
    final handler = _methodHandlers[call.method];
    if (handler != null) {
      return await handler(call);
    }
    throw PlatformException(code: 'UNIMPLEMENTED', message: 'Method ${call.method} not implemented');
  }
}

// ✅ ALSO CORRECT: Service delegation pattern
class DashboardBridgeService {
  final HybridRouter _hybridRouter;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'dashboardSpecificMethod':
        return await _handleDashboardMethod(call);
      default:
        // Delegate unhandled methods to HybridRouter
        return await _hybridRouter.handleMethodCall(call);
    }
  }
}
```

**MANDATORY Method Channel Validation Checklist:**

- [ ] **Channel ownership documented**: Each method channel has exactly one `setMethodCallHandler` call
- [ ] **Method routing verified**: All expected method calls reach correct handlers
- [ ] **Handler delegation implemented**: Services delegate unknown methods to appropriate handlers
- [ ] **Method coverage tested**: All bridge methods manually tested end-to-end
- [ ] **Channel conflict detection**: Build-time or runtime detection of multiple handlers on same channel
- [ ] **Method call logging**: Debug logging shows which service handles each method call

### Rule 12: Hybrid Navigation Validation (MANDATORY)

**Navigation flow validation that would have caught the dashboard issue:**

**All registered SwiftUI views MUST have working end-to-end navigation:**

- **Route Registration Consistency**: SwiftUI bridge registration route identifiers MUST exactly match Flutter GoRouter route paths
  - ❌ Register "dashboard" but route is "/dashboard"
  - ✅ Register "/dashboard" for route "/dashboard"
- **Flutter Route Intercept**: All Flutter routes that have SwiftUI equivalents MUST check hybrid navigation before showing Flutter widget
  - ❌ Direct Flutter widget instantiation without hybrid check
  - ✅ HybridRouteWrapper that checks `shouldUseNativeView()` first
- **Bridge Registration Verification**: All registered SwiftUI views MUST be callable from Flutter
- **Navigation Testing**: Every registered SwiftUI view MUST be manually tested via Flutter navigation
- **Route Path Mapping**: Bridge route mapping MUST handle both exact matches and path variations
- **Return Navigation Testing**: All SwiftUI views MUST successfully navigate back to Flutter

**Implementation Requirements:**

```swift
// MANDATORY: Exact route path matching in bridge registration
extension FlutterSwiftUIBridge {
    func registerDashboardView() {
        // ❌ WRONG: Route mismatch
        registerNativeView("dashboard")

        // ✅ CORRECT: Exact Flutter route match
        registerNativeView("/dashboard")

        // ✅ ALSO CORRECT: Handle both variants
        registerNativeView("/dashboard")
        registerNativeView("dashboard") // Support both formats
    }
}
```

```dart
// MANDATORY: Flutter routes must check hybrid navigation
class HybridDashboardRoute extends GoRoute {
  HybridDashboardRoute() : super(
    path: '/dashboard',
    builder: (context, state) {
      // Check if SwiftUI version should be used
      return FutureBuilder<bool>(
        future: NativeBridge.isNativeViewAvailable('/dashboard'),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            // Navigate to SwiftUI immediately
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await NativeBridge.navigateToNativeView('/dashboard');
            });
            return Container(); // Temporary placeholder
          }

          // Show Flutter version
          return DashboardRoute();
        },
      );
    },
  );
}
```

**Validation Checklist for Hybrid Navigation:**

- [ ] **Route identifier exact match** between Flutter path and SwiftUI registration
- [ ] **Bridge registration successful** (check iOS logs for registration confirmation)
- [ ] **Flutter route intercept implemented** using HybridRouteWrapper or equivalent
- [ ] **Navigation tested manually** from Flutter to SwiftUI view
- [ ] **Back navigation working** from SwiftUI to Flutter
- [ ] **Deep linking functional** for direct SwiftUI view access
- [ ] **Route variants handled** (with and without leading slash)
- [ ] **Error fallback implemented** if SwiftUI view fails to load

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
