# Thriftwood Flutter to Native SwiftUI Migration Plan

## Executive Summary

This document outlines a systematic approach to migrate Thriftwood's iOS implementation from Flutter to native SwiftUI. Thriftwood is a self-hosted media server controller app that manages Radarr (movies), Sonarr (TV), Lidarr (music), NZBGet/SABnzbd (downloads), Tautulli (Plex stats), and other services. The migration follows a module-by-module strategy, preserving the existing service integrations and multi-profile architecture.

## Current Thriftwood Architecture Analysis

### App Overview

- **Purpose**: Self-hosted media server management dashboard
- **Target Services**: Radarr, Sonarr, Lidarr, NZBGet, SABnzbd, Tautulli, Search indexers, Wake-on-LAN
- **Key Features**: Multi-service API integration, profile management, unified calendar, statistics, search across services
- **Current iOS**: iOS 13.0+, uses Fastlane for deployment, CocoaPods for dependencies

### Flutter Implementation Details

- **State Management**: Provider pattern with ChangeNotifier per module (RadarrState, SonarrState, etc.)
- **Navigation**: go_router with declarative routing per module
- **Database**: Hive local storage with profile-based configuration
- **API Layer**: Retrofit + Dio with generated clients for each service
- **Architecture**: Module-based with clear separation (lib/modules/radarr/, lib/modules/sonarr/, etc.)

### Core Modules to Migrate

1. **Dashboard**: Central hub with calendar, recent activity, quick actions
2. **Service Modules**: Radarr, Sonarr, Lidarr (content management)
3. **Download Clients**: NZBGet, SABnzbd (download monitoring)
4. **Analytics**: Tautulli (Plex statistics and user management)
5. **Search**: Cross-service indexer search
6. **Settings**: Service configuration, profiles, themes
7. **Utilities**: Wake-on-LAN, external modules

## Migration Strategy

### Core Principles

- **MVVM Architecture**: Clear separation of View, ViewModel, and Model layers
- **Swift 6 Concurrency**: Actor-based API clients with data race safety
- **Modern State Management**: Use `@Observable` macro and async/await patterns
- **Service API Compatibility**: Maintain exact API compatibility with existing services
- **Profile System Preservation**: Keep multi-profile configuration system with SwiftData
- **iOS 17+ Target**: Leverage latest SwiftUI and Swift 6 capabilities
- **Fastlane Integration**: Maintain existing CI/CD pipeline

### Phase Overview

1. **Phase 1: Foundation & Settings** (Week 1-2)

   - SwiftUI project setup with Thriftwood branding
   - Profile management system (multi-configuration support)
   - Settings module migration (service configurations)

2. **Phase 2: Core Services & APIs** (Week 3-4)

   - Service connection models (Radarr, Sonarr, etc.)
   - API client layer with URLSession
   - Local storage with SwiftData/CoreData

3. **Phase 3: Dashboard & Navigation** (Week 5-7)

   - Main dashboard with service status
   - go_router equivalent navigation system
   - Unified calendar for all services

4. **Phase 4: Content Management Modules** (Week 8-12)

   - Radarr module (movies, queues, history, search)
   - Sonarr module (TV shows, calendar, releases)
   - Lidarr module (music, artists, albums)

5. **Phase 5: Download & Analytics** (Week 13-15)

   - NZBGet/SABnzbd download monitoring
   - Tautulli statistics and user management
   - Search across indexers

6. **Phase 6: Polish & Deployment** (Week 16)
   - Theme system (including AMOLED black)
   - Fastlane integration
   - App Store submission

## Detailed Task Breakdown

### Phase 1: Foundation & Settings

#### Task 1.1: Create Thriftwood iOS Project

```swift
OBJECTIVE: Set up Thriftwood-specific iOS project architecture
TASKS:
1. Create new Xcode project "Thriftwood" with SwiftUI + iOS 16+ target
2. Configure bundle ID: app.thriftwood.thriftwood (match existing)
3. Set up modular architecture matching Flutter structure:
   - /Core (shared utilities, theme, network)
   - /Modules/Dashboard, /Modules/Radarr, /Modules/Sonarr, etc.
   - /Services (API clients, database, configuration)
   - /Models (service-specific data models)
4. Import Thriftwood branding assets (icons, launch screens)
5. Configure existing Fastlane integration for deployment
```

#### Task 1.2: Profile Management System

```swift
OBJECTIVE: Implement multi-profile configuration system
TASKS:
1. Create LunaProfile model matching Flutter's profile system
2. Implement ProfileManager with SwiftData/CoreData storage
3. Create profile selection UI (Settings > Profiles)
4. Implement profile switching functionality
5. Ensure all service configurations are profile-scoped
6. Test profile import/export functionality
```

#### Task 1.3: Settings Module Foundation

```swift
OBJECTIVE: Migrate core settings and configuration screens
TASKS:
1. Create SettingsView with navigation structure matching Flutter
2. Implement configuration sections:
   - General settings (theme, language)
   - Service configurations (Radarr, Sonarr, Lidarr, etc.)
   - System settings (logs, cache)
3. Create service connection detail forms with validation
4. Implement custom header configuration for API requests
5. Test connection validation for each service type
```

### Phase 2: Core Services & APIs

#### Task 2.1: Service Data Models

```swift
OBJECTIVE: Convert Thriftwood service models to Swift
TASKS:
1. Create service-specific model groups:
   - RadarrModels: Movie, QueueItem, History, SystemStatus
   - SonarrModels: Series, Episode, Calendar, Release
   - LidarrModels: Artist, Album, Track, Search
   - TautulliModels: User, Session, History, Statistics
   - DownloadModels: NZBGet/SABnzbd queue, history, stats
2. Implement Codable conformance matching exact JSON from APIs
3. Create model extensions for computed properties and helpers
4. Add comprehensive unit tests validating JSON parsing
5. Implement proper error handling for API response variations
```

#### Task 2.2: API Client Layer

```swift
OBJECTIVE: Build service API clients matching Flutter Retrofit implementation
TASKS:
1. Create base APIClient with URLSession:
   - Support for custom headers per service
   - API key authentication handling
   - Request/response logging with privacy
   - Automatic retry with exponential backoff
2. Implement service-specific clients:
   - RadarrAPI: Movies, queue, history, system endpoints
   - SonarrAPI: Series, episodes, calendar, releases
   - LidarrAPI: Artists, albums, search, wanted
   - TautulliAPI: Activity, history, users, statistics
   - DownloadAPI: NZBGet/SABnzbd status and control
3. Handle service-specific authentication (API keys, basic auth)
4. Implement connection testing for each service
5. Create mock clients for testing and previews
```

#### Task 2.3: State Management Architecture

```swift
OBJECTIVE: Implement modular state management matching Flutter Provider pattern
TASKS:
1. Create service-specific ObservableObject stores:
   - RadarrStore, SonarrStore, LidarrStore, TautulliStore, etc.
   - Match Flutter state management patterns
2. Implement profile-aware configuration loading
3. Set up Combine publishers for cross-module communication
4. Create centralized AppStore for global state coordination
5. Implement state persistence and restoration
6. Handle offline/connection error states gracefully
```

### Phase 3: Dashboard & Navigation

#### Task 3.1: Main Navigation System

```swift
OBJECTIVE: Implement Thriftwood's modular navigation matching go_router
TASKS:
1. Create TabView with service modules:
   - Dashboard, Radarr, Sonarr, Lidarr, Downloads, Tautulli, Search, Settings
2. Implement NavigationStack for each module's internal routing
3. Create deep linking support for service-specific screens
4. Add navigation state restoration between app launches
5. Implement module enabling/disabling based on configuration
6. Create navigation helpers matching Flutter's routing patterns
```

#### Task 3.2: Dashboard Module

```swift
OBJECTIVE: Central dashboard with service status and unified calendar
TASKS:
1. Create DashboardView with service status cards:
   - Show connection status for each configured service
   - Display quick stats (movies, shows, downloads, etc.)
   - Recent activity feed from all services
2. Implement unified calendar matching Flutter version:
   - Radarr movie releases
   - Sonarr episode air dates
   - Combined view with filtering options
3. Add quick actions menu:
   - Search across services
   - Wake-on-LAN functionality
   - Service-specific shortcuts
4. Implement pull-to-refresh for real-time updates
5. Create dashboard customization settings
```

#### Task 3.3: Theme System

```swift
OBJECTIVE: Implement Thriftwood's theming including AMOLED black
TASKS:
1. Create ThemeManager matching Flutter's theme system:
   - Standard dark/light themes
   - AMOLED black theme option
   - Custom accent colors
2. Implement theme switching with live preview
3. Create themed UI components library:
   - Cards, buttons, navigation elements
   - Media-specific components (movie posters, progress bars)
4. Add theme persistence across app launches
5. Support system appearance following (when not AMOLED)
```

### Phase 4: Content Management Modules

#### Task 4.1: Radarr Module (Movies)

```swift
OBJECTIVE: Complete Radarr movie management functionality
TASKS:
1. Create RadarrHomeView with movie collection:
   - Grid/list view toggle matching Flutter
   - Movie posters with status indicators
   - Sorting and filtering options
2. Implement movie detail screens:
   - Movie information, cast, crew
   - File management and quality selection
   - Manual search and download options
3. Create specialized views:
   - Movies calendar for upcoming releases
   - Queue monitoring with progress indicators
   - History view with search/filter
   - Missing movies with search capabilities
4. Add movie search and add functionality
5. Implement system status and configuration screens
```

#### Task 4.2: Sonarr Module (TV Shows)

```swift
OBJECTIVE: Complete Sonarr TV show management functionality
TASKS:
1. Create SonarrHomeView with series collection:
   - Series posters with season/episode counts
   - Continuing vs ended series filtering
   - Monitoring status indicators
2. Implement series detail screens:
   - Series information and cast
   - Season/episode management
   - Episode file quality and management
3. Create specialized views:
   - TV calendar for upcoming episodes
   - Queue monitoring for active downloads
   - History with episode-specific details
   - Upcoming episodes view
4. Add series search and monitoring setup
5. Implement release management and manual search
```

#### Task 4.3: Lidarr Module (Music)

```swift
OBJECTIVE: Complete Lidarr music management functionality
TASKS:
1. Create LidarrHomeView with artist collection:
   - Artist artwork and album counts
   - Monitoring status and quality profiles
2. Implement artist/album detail screens:
   - Artist biography and discography
   - Album tracks with quality indicators
   - Manual search and download options
3. Create specialized views:
   - Music calendar for upcoming releases
   - Queue monitoring for downloads
   - History view with track details
   - Wanted albums management
4. Add artist/album search functionality
5. Implement music library statistics and management
```

### Phase 5: Download Clients & Analytics

#### Task 5.1: Download Client Integration

```swift
OBJECTIVE: NZBGet and SABnzbd download monitoring
TASKS:
1. Create DownloadsView with unified queue monitoring:
   - Active downloads with progress bars
   - Queue management (pause, resume, delete)
   - Speed and ETA indicators
2. Implement client-specific features:
   - NZBGet post-processing status
   - SABnzbd category management
   - History with repair/unpack status
3. Create download statistics dashboard:
   - Speed graphs and bandwidth usage
   - Storage space monitoring
   - Weekly/monthly download statistics
4. Add download control actions:
   - Queue reordering and prioritization
   - Pause/resume individual downloads
   - Server shutdown/restart controls
```

#### Task 5.2: Tautulli Analytics

```swift
OBJECTIVE: Plex statistics and user management via Tautulli
TASKS:
1. Create TautulliHomeView with server overview:
   - Current activity with live sessions
   - Server statistics and performance
   - Recently added media highlights
2. Implement user management screens:
   - User list with watch statistics
   - Individual user details and history
   - Login/IP address tracking
3. Create analytics dashboards:
   - Play statistics with graphs
   - Most watched content rankings
   - User activity patterns
4. Add server management features:
   - Media library scanning
   - Server logs and notifications
   - System information monitoring
```

#### Task 5.3: Search & Utilities

```swift
OBJECTIVE: Cross-service search and utility features
TASKS:
1. Create unified search interface:
   - Search across Radarr, Sonarr, Lidarr simultaneously
   - Indexer management and testing
   - Search result aggregation and deduplication
2. Implement Wake-on-LAN functionality:
   - Server discovery and configuration
   - Magic packet sending with validation
   - Scheduled wake-up options
3. Add external module support:
   - Custom service integration framework
   - URL scheme handling for external apps
   - Third-party service bookmarks
4. Create utility screens:
   - System logs viewer with filtering
   - Cache management and clearing
   - Import/export configuration tools
```

### Phase 6: Polish & Optimization

#### Task 6.1: Performance Optimization

```
OBJECTIVE: Optimize app performance
TASKS:
1. Profile app using Instruments:
   - Memory usage
   - CPU usage
   - Network activity
2. Optimize image loading and caching
3. Implement lazy loading where appropriate
4. Reduce app launch time
5. Optimize build settings
6. Minimize app size
```

#### Task 6.2: Accessibility

```
OBJECTIVE: Ensure full accessibility compliance
TASKS:
1. Add VoiceOver support to all views
2. Implement Dynamic Type support
3. Add accessibility labels and hints
4. Test with Accessibility Inspector
5. Implement haptic feedback appropriately
6. Ensure proper focus management
```

#### Task 6.3: Testing & Quality Assurance

```
OBJECTIVE: Comprehensive testing coverage
TASKS:
1. Write unit tests for ViewModels
2. Create UI tests for critical flows
3. Implement snapshot testing
4. Set up CI/CD pipeline
5. Perform regression testing
6. Conduct user acceptance testing
```

## Migration Execution Guidelines

### For Each Component Migration

1. **Analyze Flutter Implementation**

   ```swift
   // Document Flutter widget structure
   // Note state management approach
   // List all user interactions
   // Document business logic
   ```

2. **Design SwiftUI Solution**

   ```swift
   // Create view hierarchy plan
   // Design ViewModel structure
   // Plan state management
   // Consider SwiftUI limitations
   ```

3. **Implement Core Functionality**

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
