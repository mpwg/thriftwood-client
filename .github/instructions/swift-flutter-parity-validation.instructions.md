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

### Rule 3: Mandatory Migration Documentation (MANDATORY)

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

### Rule 4: Bidirectional ViewModel Integration (MANDATORY)

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

### Rule 5: Method Channel Integration (MANDATORY)

**All SwiftUI views MUST properly integrate with Flutter method channels:**

- **Incoming navigation** from Flutter must be handled via FlutterSwiftUIBridge
- **Outgoing navigation** to Flutter must use navigateBackToFlutter()
- **Data changes** must be synced bidirectionally via SharedDataManager
- **State updates** must notify both platforms immediately
- **Error states** must be consistent across platforms

### Rule 6: Zero TODOs Policy (MANDATORY)

Swift implementations **MUST** be 100% complete:

- **No TODO comments allowed** in production code
- **No placeholder implementations**
- **No commented-out functionality**
- **All error handling must be implemented**
- **All edge cases must be handled**
- **All Flutter features must be documented as ported**

### Rule 7: Data Model Consistency (MANDATORY)

Swift data models **MUST** exactly mirror Flutter models:

- Same property names and types (converted to Swift equivalents)
- Same validation rules and constraints
- Same default values and initialization
- Same JSON serialization format for bridge compatibility
- **Must implement SharedDataProtocol** for cross-platform sync
- **Must include Flutter model mapping documentation**

### Rule 8: Compilation Requirement (MANDATORY)

All Swift implementations **MUST** compile successfully:

- **Zero compilation errors** in the Swift implementation
- **All dependencies resolved** and properly linked
- **Valid syntax and type safety** throughout
- **Successful Xcode build** before validation approval
- **Swift 6 strict concurrency compliance**

### Rule 9: Modern SwiftUI Patterns (MANDATORY)

**Must follow iOS 17+ best practices:**

- **@Observable** instead of ObservableObject (no @Published properties)
- **@State** instead of @StateObject for owned ViewModels
- **@Bindable** for child views requiring two-way binding
- **@Environment(Type.self)** instead of @EnvironmentObject
- **async/await** patterns for all asynchronous operations
- **@MainActor** for UI update functions

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

# Validate Swift compilation
echo "🔨 Building Swift implementation..."
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -destination 'generic/platform=iOS' build-for-testing
if [ $? -ne 0 ]; then
    echo "❌ Swift compilation failed"
    exit 1
fi

echo "✅ Pre-commit validation passed"
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
