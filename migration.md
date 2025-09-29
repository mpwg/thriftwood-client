# Thriftwood Flutter to Native SwiftUI Migration Plan

## Executive Summary

This document outlines a gradual, view-by-view migration strategy to transform Thriftwood's iOS implementation from Flutter to native SwiftUI. The migration preserves the existing Flutter infrastructure while incrementally replacing views with native SwiftUI components, targeting iOS 18+ with modern Swift 6 patterns.

## Current Codebase Analysis

### Actual Flutter Implementation Structure

Based on the codebase analysis:

- **lib/core/**: Core functionality including API clients, database, UI components

  - `api/`: Service API implementations (Radarr, Sonarr, Lidarr, etc.)
  - `database/`: Profile management and configuration storage
  - `ui/`: Shared UI components and utilities

- **lib/modules/**: Feature modules

  - `dashboard/`: Home dashboard with quick actions
  - `radarr/`, `sonarr/`, `lidarr/`: Media management modules
  - `sabnzbd/`, `nzbget/`: Download client modules
  - `tautulli/`: Plex analytics module
  - `search/`: Cross-service search
  - `settings/`: Configuration and profile management
  - `wake_on_lan/`: Network utility

- **ios/**: Existing iOS project with Flutter integration
  - Already has Xcode project structure
  - Uses CocoaPods for dependencies
  - Fastlane configuration for deployment

## Gradual Migration Strategy

### Phase 0: Initial Setup and Compilation (Week 1)

**Milestone 1: Get the existing iOS project compiling in Xcode**

```swift
OBJECTIVE: Establish native iOS development environment alongside Flutter
TASKS:
1. Open ios/Runner.xcworkspace in Xcode 16+
2. Update project settings:
   - Set iOS Deployment Target to 18.0
   - Enable Swift 6 language mode
   - Configure strict concurrency checking
3. Resolve any compilation issues:
   - Update CocoaPods dependencies
   - Fix any deprecated API usage
   - Ensure Flutter framework is properly linked
4. Create new Swift target "ThriftwoodNative" alongside Flutter Runner:
   - Add as embedded framework
   - Configure to share bundle resources
   - Set up module imports
5. Test that both Flutter and native targets compile
6. Verify app runs with existing Flutter implementation
```

### Phase 1: SwiftUI Infrastructure (Week 2)

**Create native infrastructure parallel to Flutter**

```swift
OBJECTIVE: Establish SwiftUI foundation without breaking Flutter
TASKS:
1. Add SwiftUI entry point in ThriftwoodNative target:
   - Create ThriftwoodApp.swift with @main
   - Set up initial ContentView
   - Configure to launch from AppDelegate when flag is set
2. Create core native architecture:
   /ThriftwoodNative/
     /Core/
       - APIClient.swift (base networking)
       - ProfileManager.swift (configuration)
       - ThemeManager.swift
     /Models/
       - ServiceModels.swift (Codable structs)
     /ViewModels/
       - Base ViewModels with @Observable
     /Views/
       - Initial view structure
3. Implement feature flag system:
   - UserDefaults flag to toggle Flutter/Native views
   - Method swizzling to intercept Flutter navigation
   - Bridge to present SwiftUI views from Flutter
4. Create Flutter-to-SwiftUI bridge:
   - MethodChannel for Flutter->Native communication
   - Host SwiftUI views in FlutterViewController
   - Share data models between platforms
```

### Phase 2: First Native View - Settings (Week 3-4)

**Migrate Settings as the first complete SwiftUI module**

```swift
OBJECTIVE: Replace Settings module with SwiftUI while keeping Flutter running
TASKS:
1. Port Settings data models:
   - Convert configuration models to Swift
   - Implement Codable for persistence
   - Create SwiftData schema for profiles
2. Build SettingsViewModel:
   @Observable
   @MainActor
   class SettingsViewModel {
       var profiles: [Profile] = []
       var activeProfile: Profile?
       var connectionStatus: [String: Bool] = [:]

       func testConnection(service: ServiceType) async
       func saveProfile(_ profile: Profile) async
   }
3. Create SettingsView hierarchy:
   - Main settings list
   - Profile management views
   - Service configuration forms
   - Connection test UI
4. Implement navigation intercept:
   - Detect when Flutter navigates to settings
   - Present SwiftUI SettingsView instead
   - Handle back navigation to Flutter
5. Test data synchronization:
   - Ensure SwiftUI changes reflect in Flutter
   - Verify profile switching works
```

### Phase 3: Dashboard Migration (Week 5-6)

**Replace Dashboard with native implementation**

```swift
OBJECTIVE: Migrate the main dashboard to SwiftUI
TASKS:
1. Analyze current Flutter dashboard:
   - lib/modules/dashboard/pages/dashboard.dart structure
   - Quick action implementations
   - Module grid layout
2. Create DashboardViewModel:
   - Service status monitoring
   - Quick actions handling
   - Module availability checks
3. Build DashboardView:
   - Module grid with NavigationLink
   - Service status indicators
   - Quick action buttons
4. Implement hybrid navigation:
   - SwiftUI dashboard launches Flutter modules
   - Gradual module replacement strategy
5. Port dashboard-specific API calls:
   - Service status checks
   - Recent activity fetching
```

### Phase 4: Service Module Migration (Week 7-12)

**Migrate media service modules one by one**

#### 4.1 Radarr Module (Week 7-8)

```swift
OBJECTIVE: Complete Radarr native implementation
TASKS:
1. Port Radarr API client:
   - Convert from lib/core/api/radarr/
   - Implement with async/await
   - Actor-based for thread safety
2. Create Radarr ViewModels:
   - MovieListViewModel
   - MovieDetailViewModel
   - QueueViewModel
3. Build Radarr Views:
   - Movie grid/list view
   - Movie detail with actions
   - Add movie search
   - Queue management
4. Integrate with existing navigation:
   - Replace Flutter Radarr views progressively
   - Maintain data consistency
```

#### 4.2 Sonarr Module (Week 9-10)

```swift
OBJECTIVE: Complete Sonarr native implementation
TASKS:
1. Port Sonarr API client from lib/core/api/sonarr/
2. Create Series/Episode ViewModels
3. Build Sonarr view hierarchy
4. Implement calendar view
5. Handle series monitoring
```

#### 4.3 Download Clients (Week 11-12)

```swift
OBJECTIVE: Migrate SABnzbd and NZBGet modules
TASKS:
1. Port download client APIs
2. Create unified download queue view
3. Implement queue management actions
4. Build history views
```

### Phase 5: Complete Native Transition (Week 13-14)

**Remove Flutter dependencies and polish**

```swift
OBJECTIVE: Complete transition to pure SwiftUI
TASKS:
1. Remove Flutter module dependencies:
   - Remove Flutter.framework
   - Clean up bridging code
   - Remove MethodChannels
2. Migrate remaining modules:
   - Tautulli analytics
   - Search functionality
   - Wake-on-LAN
3. Implement native-only features:
   - Widgets
   - App Clips
   - SharePlay support
4. Performance optimization:
   - Image caching
   - List virtualization
   - Background refresh
5. Polish and testing:
   - UI refinements
   - Comprehensive testing
   - Accessibility audit
```

## Implementation Patterns

### Gradual View Replacement Pattern

```swift
// Flutter-SwiftUI Bridge
class ViewBridge: NSObject {
    static let shared = ViewBridge()

    func shouldUseNativeView(for route: String) -> Bool {
        // Check feature flag for specific routes
        let nativeRoutes = UserDefaults.standard.stringArray(forKey: "nativeRoutes") ?? []
        return nativeRoutes.contains(route)
    }

    func presentNativeView(for route: String, from controller: FlutterViewController) {
        guard shouldUseNativeView(for: route) else { return }

        let hostingController = UIHostingController(
            rootView: NativeViewFactory.createView(for: route)
        )
        controller.present(hostingController, animated: true)
    }
}

// Native View Factory
enum NativeViewFactory {
    static func createView(for route: String) -> AnyView {
        switch route {
        case "/settings":
            return AnyView(SettingsView())
        case "/dashboard":
            return AnyView(DashboardView())
        case "/radarr":
            return AnyView(RadarrHomeView())
        default:
            return AnyView(Text("Not implemented"))
        }
    }
}
```

### Modern MVVM Pattern for iOS 18+

```swift
// Model - Aligned with Flutter models
struct Movie: Codable, Identifiable, Sendable {
    let id: Int
    let title: String
    let year: Int
    let hasFile: Bool
    let monitored: Bool
    // Match lib/core/api/radarr/models/movie.dart structure
}

// API Client - Actor for concurrency
actor RadarrClient {
    private let baseURL: URL
    private let apiKey: String

    func fetchMovies() async throws -> [Movie] {
        var request = URLRequest(url: baseURL.appendingPathComponent("movie"))
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Movie].self, from: data)
    }
}

// ViewModel - Observable with async/await
@Observable
@MainActor
class MovieListViewModel {
    var movies: [Movie] = []
    var isLoading = false
    var searchText = ""

    var filteredMovies: [Movie] {
        guard !searchText.isEmpty else { return movies }
        return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    private let client: RadarrClient

    init(client: RadarrClient) {
        self.client = client
    }

    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }

        do {
            movies = try await client.fetchMovies()
        } catch {
            // Handle error
        }
    }
}

// View - Pure SwiftUI
struct MovieListView: View {
    @State private var viewModel: MovieListViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.filteredMovies) { movie in
                MovieRow(movie: movie)
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Movies")
            .task {
                await viewModel.loadMovies()
            }
            .refreshable {
                await viewModel.loadMovies()
            }
        }
    }
}
```

### Profile System Bridge

```swift
// Bridge existing Flutter profile system
class ProfileBridge {
    static let shared = ProfileBridge()

    // Read from existing Flutter storage
    func getCurrentProfile() -> Profile? {
        // Read from shared UserDefaults/Keychain that Flutter uses
        // Path: lib/core/database/database.dart
    }

    // Gradually migrate to SwiftData
    func migrateToSwiftData() async {
        // One-time migration from Flutter storage
    }
}
```

## Migration Execution Checklist

### Per-View Migration Steps

- [ ] Analyze Flutter view implementation
- [ ] Create Swift models matching Dart models
- [ ] Build ViewModel with @Observable
- [ ] Implement SwiftUI view
- [ ] Add to ViewBridge routing
- [ ] Test alongside Flutter implementation
- [ ] Enable native view via feature flag
- [ ] Monitor for issues
- [ ] Remove Flutter implementation

### Testing Strategy for Gradual Migration

1. **Parallel Testing**: Run both Flutter and Native views side-by-side
2. **A/B Testing**: Use feature flags to test with subset of users
3. **Data Validation**: Ensure data consistency between platforms
4. **Performance Comparison**: Measure and compare metrics
5. **Rollback Plan**: Quick disable via feature flags

## Success Metrics

1. **Compilation**: iOS project compiles in Xcode with zero errors
2. **Gradual Migration**: Each view works independently without breaking Flutter
3. **Feature Parity**: All Flutter features available in SwiftUI
4. **Performance**: Native views perform better than Flutter equivalents
5. **Modern Swift**: 100% Swift 6 compliance with async/await
6. **iOS 18 Features**: Leverage latest iOS capabilities
7. **Code Sharing**: Reuse models and logic where possible
8. **User Experience**: Seamless transition for users

## Risk Mitigation

### Technical Risks

- **Hybrid Complexity**: Test bridge thoroughly, have fallback to Flutter
- **Data Synchronization**: Use shared storage, validate consistency
- **Navigation State**: Carefully manage navigation stack between platforms
- **Performance**: Profile both implementations, ensure native is faster

### Process Risks

- **Incremental Releases**: Ship native views gradually to users
- **Rollback Strategy**: Feature flags allow instant rollback
- **Testing Coverage**: Maintain tests for both implementations
- **Team Knowledge**: Document bridge patterns and architecture

## Current Codebase Specific Adjustments

Based on the actual codebase structure:

1. **API Clients**: Port from `lib/core/api/` maintaining exact endpoints
2. **Models**: Convert from `lib/core/api/*/models/` preserving JSON structure
3. **UI Components**: Recreate `lib/core/ui/` components in SwiftUI
4. **Navigation**: Replace `go_router` routes with NavigationStack
5. **State Management**: Convert Provider pattern to @Observable ViewModels
6. **Database**: Migrate from `lib/core/database/` to SwiftData

## Next Steps

1. **Week 1**: Get iOS project compiling in Xcode 16
2. **Week 2**: Create ThriftwoodNative target with basic SwiftUI shell
3. **Week 3**: Implement Settings as first native view
4. **Week 4**: Add Dashboard with hybrid navigation
5. **Ongoing**: Migrate service modules one by one

---

_This migration plan is designed for gradual, low-risk transition from Flutter to SwiftUI, allowing both implementations to coexist during the migration period._

```swift
// Build basic view structure
// Implement ViewModel
// Connect data bindings
// Add user interactions
```

4. **Match Visual Design**

   ```swift
   // Apply styling and themes
   // Implement animations
   // Fine-tune layouts
   // Test on multiple devices
   ```

5. **Test Feature Parity**
   ```swift
   // Compare with Flutter version
   // Test all edge cases
   // Verify data consistency
   // Check performance metrics
   ```

## MVVM Architecture & Swift 6 Patterns

### Modern SwiftUI MVVM Architecture

The target architecture follows Apple's modern SwiftUI patterns with strict MVVM separation:

#### Layer Responsibilities

1. **Model Layer**

   - Pure data structures (`struct` with `Codable`, `Sendable`)
   - SwiftData persistence models (`@Model` classes)
   - Business logic encapsulated in services

2. **ViewModel Layer**

   - `@Observable` classes (Swift 5.9+) for reactive state
   - `@MainActor` isolation for UI thread safety
   - Async/await for all asynchronous operations
   - No direct UI dependencies

3. **View Layer**
   - SwiftUI views with declarative UI
   - `@State` for view-specific ViewModels
   - `@Environment` for shared dependencies
   - Minimal business logic

#### Swift 6 Concurrency Requirements

- **Actor Isolation**: API clients and services use `actor` for data race safety
- **Sendable Conformance**: All data crossing concurrency boundaries must be `Sendable`
- **MainActor UI**: All ViewModels that update UI are `@MainActor` isolated
- **Structured Concurrency**: Use `async/await` with proper task management

#### Example Modern MVVM Pattern

```swift
// Model - Pure data, Sendable
struct ServiceConfiguration: Codable, Sendable {
    let host: String
    let apiKey: String
    let headers: [String: String]
}

// Service - Actor for thread safety
actor ServiceAPIClient {
    private let config: ServiceConfiguration

    init(config: ServiceConfiguration) {
        self.config = config
    }

    func fetchData() async throws -> [ServiceItem] {
        // Network operations isolated in actor
    }
}

// ViewModel - MainActor for UI updates
@Observable
@MainActor
class ServiceViewModel {
    var items: [ServiceItem] = []
    var isLoading = false
    var errorMessage: String?

    private let apiClient: ServiceAPIClient

    init(apiClient: ServiceAPIClient) {
        self.apiClient = apiClient
    }

    func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            items = try await apiClient.fetchData()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// View - Declarative UI only
struct ServiceView: View {
    @State private var viewModel: ServiceViewModel

    init(apiClient: ServiceAPIClient) {
        self._viewModel = State(initialValue: ServiceViewModel(apiClient: apiClient))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ServiceListView(items: viewModel.items)
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}
```

## Thriftwood-Specific Migration Patterns

### Service Module State Migration

**Flutter Provider Pattern (Thriftwood):**

```dart
class RadarrState extends ChangeNotifier {
  RadarrAPI? api;
  bool enabled = false;
  Map<int, Future<RadarrMovie>> movies = {};

  void setMovie(int id, Future<RadarrMovie> future) {
    movies[id] = future;
    notifyListeners();
  }
}

// Usage in Widget:
context.read<RadarrState>().setMovie(movieId,
  context.read<RadarrState>().api!.movies.getMovie(movieId: movieId)
);
```

**SwiftUI Modern MVVM (Native):**

```swift
// Model
struct RadarrMovie: Codable, Identifiable, Sendable {
    let id: Int
    let title: String
    let status: String
    let year: Int
}

// ViewModel (Observable)
@Observable
@MainActor
class RadarrViewModel {
    var isEnabled = false
    var movies: [Int: RadarrMovie] = [:]
    var loadingStates: [Int: Bool] = [:]
    var errorMessage: String?

    private let apiClient: RadarrAPIClient

    init(apiClient: RadarrAPIClient) {
        self.apiClient = apiClient
    }

    func loadMovie(id: Int) async {
        loadingStates[id] = true
        errorMessage = nil

        do {
            movies[id] = try await apiClient.getMovie(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }

        loadingStates[id] = false
    }
}

// View
struct RadarrMovieView: View {
    @State private var viewModel: RadarrViewModel
    let movieId: Int

    init(movieId: Int, apiClient: RadarrAPIClient) {
        self.movieId = movieId
        self._viewModel = State(initialValue: RadarrViewModel(apiClient: apiClient))
    }

    var body: some View {
        Group {
            if viewModel.loadingStates[movieId] == true {
                ProgressView()
            } else if let movie = viewModel.movies[movieId] {
                MovieDetailView(movie: movie)
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error)
            }
        }
        .task {
            await viewModel.loadMovie(id: movieId)
        }
    }
}
```

### API Client Migration Pattern

**Flutter Retrofit/Dio Pattern:**

```dart
@RestApi(baseUrl: "http://localhost:7878/api/v3/")
abstract class RadarrAPI {
  factory RadarrAPI(Dio dio) = _RadarrAPI;

  @GET("/movie")
  Future<List<RadarrMovie>> getMovies();

  @GET("/movie/{id}")
  Future<RadarrMovie> getMovie(@Path("id") int movieId);
}
```

**SwiftUI URLSession Pattern:**

```swift
actor RadarrAPIClient {
    private let baseURL: URL
    private let session: URLSession
    private let headers: [String: String]

    func getMovies() async throws -> [RadarrMovie] {
        let url = baseURL.appendingPathComponent("movie")
        var request = URLRequest(url: url)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([RadarrMovie].self, from: data)
    }

    func getMovie(id: Int) async throws -> RadarrMovie {
        let url = baseURL.appendingPathComponent("movie/\(id)")
        var request = URLRequest(url: url)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(RadarrMovie.self, from: data)
    }
}
```

### Profile System Migration

**Flutter Hive Profile System:**

```dart
@HiveType(typeId: 0)
class LunaProfile extends HiveObject {
  @HiveField(0)
  String radarrHost = '';
  @HiveField(1)
  String radarrApiKey = '';
  @HiveField(2)
  Map<String, dynamic> radarrHeaders = {};
}

// Usage:
final profile = LunaBox.profiles.read('default');
```

**SwiftUI SwiftData Profile System (Modern):**

```swift
// Model
@Model
class ThriftwoodProfile: Sendable {
    var name: String
    var radarrHost: String
    var radarrApiKey: String
    var radarrHeaders: [String: String]

    init(name: String) {
        self.name = name
        self.radarrHost = ""
        self.radarrApiKey = ""
        self.radarrHeaders = [:]
    }
}

// ViewModel
@Observable
@MainActor
class ProfileViewModel {
    var activeProfile: ThriftwoodProfile?
    var availableProfiles: [ThriftwoodProfile] = []
    var isLoading = false
    var errorMessage: String?

    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func loadProfiles() async {
        isLoading = true
        defer { isLoading = false }

        do {
            availableProfiles = try await profileService.fetchProfiles()
            if activeProfile == nil {
                activeProfile = availableProfiles.first
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func switchProfile(_ profile: ThriftwoodProfile) async {
        activeProfile = profile
        // Notify other services of profile change
        await NotificationCenter.default.post(name: .profileChanged, object: profile)
    }
}

// Service (Actor for thread safety)
actor ProfileService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchProfiles() throws -> [ThriftwoodProfile] {
        let descriptor = FetchDescriptor<ThriftwoodProfile>()
        return try modelContext.fetch(descriptor)
    }

    func saveProfile(_ profile: ThriftwoodProfile) throws {
        modelContext.insert(profile)
        try modelContext.save()
    }
}

    func loadProfile(named: String) async {
        // Load from SwiftData
    }
}
```

## Testing Strategy

### Unit Testing Requirements

- Minimum 80% code coverage for ViewModels
- Test all data transformations
- Verify API response handling
- Test error scenarios

### UI Testing Requirements

- Test critical user flows
- Verify navigation paths
- Test form validations
- Check accessibility

### Integration Testing

- Test API integrations
- Verify data persistence
- Test push notifications
- Validate deep linking

## Success Metrics

1. **MVVM Architecture Compliance**: Clear separation of Model, ViewModel, and View layers
2. **Swift 6 Concurrency**: 100% data race safety with actor isolation and Sendable conformance
3. **Modern State Management**: All state uses `@Observable` macro with async/await patterns
4. **Service Integration Parity**: 100% of Radarr, Sonarr, Lidarr, NZBGet, SABnzbd, Tautulli APIs supported
5. **Profile System**: Multi-profile configuration with SwiftData persistence
6. **Performance**: App launch < 1 second, zero main thread blocking operations
7. **Media Library Support**: Handle large libraries (10,000+ movies/shows) with efficient SwiftUI Lists
8. **Offline Capability**: Graceful handling of service outages with cached data
9. **Theme Consistency**: AMOLED black theme using modern SwiftUI styling
10. **Test Coverage**: > 80% coverage using Swift Testing framework
11. **Accessibility**: Full VoiceOver support and Dynamic Type compliance
12. **App Store Ready**: Pass all iOS 17+ guidelines and SwiftUI best practices## Risk Mitigation

### Swift 6 Migration Risks

- **Concurrency Complexity**: Start with actors early, use Swift 6 migration guide
- **Sendable Conformance**: Plan data model architecture to support Sendable requirements
- **MainActor Isolation**: Carefully design ViewModel boundaries to avoid cross-actor calls
- **Legacy Dependencies**: Audit third-party packages for Swift 6 compatibility
- **Learning Curve**: Allocate time for team Swift 6 training and experimentation

### Technical Risks

- **SwiftUI Complexity**: Use modern SwiftUI patterns, avoid UIKit unless necessary
- **State Management**: Leverage `@Observable` instead of complex Combine flows
- **Performance Issues**: Profile with Instruments early and often, use Swift 6 optimizations
- **API Integration**: Design actor-based API clients from the start
- **Data Race Safety**: Enable strict concurrency checking from day one

### Process Risks

- **Timeline Delays**: Build 20% buffer for Swift 6 learning curve
- **Architecture Drift**: Enforce MVVM with code reviews and architecture guidelines
- **Testing Strategy**: Migrate to Swift Testing framework early in process
- **Knowledge Transfer**: Document Swift 6 patterns and MVVM decisions
- **Tooling Compatibility**: Verify all development tools support Swift 6

## Rollback Strategy

If critical issues arise:

1. Maintain Flutter app in parallel until native is stable
2. Use feature flags to toggle between implementations
3. Keep git branches for each major phase
4. Have hotfix process for Flutter app during transition

## Post-Migration Checklist

- [ ] All Flutter features implemented in SwiftUI
- [ ] Comprehensive test coverage achieved
- [ ] Performance benchmarks met or exceeded
- [ ] Accessibility standards met
- [ ] App Store submission ready
- [ ] Documentation complete
- [ ] Team trained on SwiftUI codebase
- [ ] Flutter dependencies removed
- [ ] Native-only features identified and roadmapped

## Appendix: Resource Requirements

### Team Skills Needed

- **SwiftUI expertise (iOS 17+)** with modern patterns
- **Swift 6 Concurrency** (actors, async/await, Sendable)
- **MVVM Architecture** with `@Observable` macro
- **SwiftData** for modern persistence
- **Swift Testing** framework (replacing XCTest)
- **REST API integration** with URLSession and actors
- **CI/CD experience** (Xcode Cloud/Fastlane)
- **Accessibility** implementation (VoiceOver, Dynamic Type)

### Development Tools

- **Xcode 16+** (required for Swift 6 and Swift Testing)
- **Swift 6.0+** with strict concurrency checking enabled
- **SwiftLint** configured for Swift 6 patterns
- **Swift Package Manager** for dependencies
- **Swift Testing** for unit and integration tests
- **Instruments** for profiling and memory analysis
- **Accessibility Inspector** for accessibility validation
- **Proxyman/Charles** for network debugging

### Swift 6 Configuration Requirements

**Xcode Project Settings:**

- Swift Language Version: Swift 6
- Strict Concurrency Checking: Complete
- iOS Deployment Target: iOS 17.0+
- Enable Swift Testing Framework: Yes

**Build Configuration:**

```swift
// Package.swift configuration
.target(
    name: "Thriftwood",
    swiftSettings: [
        .enableExperimentalFeature("StrictConcurrency"),
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .enableUpcomingFeature("ConciseMagicFile"),
        .enableUpcomingFeature("ForwardTrailingClosures"),
        .enableUpcomingFeature("ImplicitOpenExistentials")
    ]
)
```

**Compiler Flags:**

- `-strict-concurrency=complete`
- `-enable-actor-data-race-checks`
- `-warn-swift3-objc-inference-minimal`

### Time Estimates

- Total Duration: 18 weeks (adjusted for Swift 6 migration complexity)
- Developer Resources: 2-3 iOS developers with Swift 6 expertise
- QA Resources: 1 QA engineer familiar with Swift Testing
- Architecture Review: Weekly with focus on MVVM compliance
- Performance Review: Bi-weekly using Instruments

---

_This migration plan is designed to be executed by AI coding assistants with human oversight. Each task includes clear objectives and specific implementation steps suitable for AI-assisted development._
