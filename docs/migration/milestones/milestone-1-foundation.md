# Milestone 1: Foundation

**Duration**: Weeks 1-3  
**Goal**: Establish core architecture and infrastructure  
**Deliverable**: Basic app shell with navigation and data layer

## Week 1: Project Setup & Architecture

### Task 1.1: Project Initialization

**Estimated Time**: 2 hours  
**Status**: ✅ COMPLETE  
**Implementation Focus**: Easy maintenance for indie development

- [x] Create new Xcode project with Swift 6
- [x] Configure project settings and capabilities
- [x] Setup Git repository and .gitignore
  - Enhanced .gitignore with comprehensive macOS, Xcode, SPM, and dev tool exclusions
  - Documented structure for easy maintenance
- [x] Configure SwiftLint rules
  - Created `.swiftlint.yml` with maintainability-focused rules
  - Balanced strictness: catches errors without being overly restrictive
  - Custom rules for documentation and logging best practices
- [x] Setup CI/CD pipeline (GitHub Actions)
  - Simple, single-pipeline workflow in `.github/workflows/ci.yml`
  - Runs on every push: lint, build, test
  - Fast feedback with caching and automatic cancellation
  - Documentation in `.github/CI_README.md`

### Task 1.2: Core Architecture Setup

**Estimated Time**: 8 hours  
**Actual Time**: 6 hours  
**Status**: ✅ COMPLETE  
**Implementation Date**: 2025-10-03

**Implementation Summary**:

Implemented complete core architecture following clean architecture principles with Swift 6.2's Approachable Concurrency.

**Completed Components**:

1. **Folder Structure** (`/Thriftwood/Core/`, `/Services/`, `/UI/`)

   - Clean separation of concerns
   - Modular organization for scalability

2. **Dependency Injection** (Swinject framework)

   - Added Swinject 2.10.0 via Swift Package Manager
   - Documentation in `/docs/SWINJECT_SETUP.md`
   - Type-safe dependency resolution
   - Support for singletons and factories via Swinject's Container API
   - Will be configured in app initialization as services are implemented

3. **Error Handling** (`Core/Error/ThriftwoodError.swift`)

   - Comprehensive error types (network, API, authentication, data, etc.)
   - User-friendly localized error messages
   - Retry logic support with `isRetryable` property
   - Error conversion utilities for mapping platform errors

4. **Logging Framework** (`Core/Logging/Logger.swift`)

   - OSLog-based structured logging with subsystem organization
   - Multiple categories (networking, storage, authentication, UI, services, general)
   - Privacy-aware logging with automatic redaction
   - Debug/Info/Warning/Error/Critical severity levels
   - Convenience static loggers for common use cases
   - All methods marked `nonisolated` for use from any context

5. **Base Protocols** (`Services/ServiceProtocols.swift`)

   - `ServiceConfiguration` for service setup
   - `ServiceProtocol` base interface
   - Foundation for service implementations

6. **Networking Layer** (`Core/Networking/`)

   - `APIClient` protocol for HTTP operations
   - `Endpoint` structure for request configuration
   - `HTTPMethod` and `HTTPHeaders` type aliases
   - Request/Response generic types

7. **Base ViewModel** (`Core/ViewModels/BaseViewModel.swift`)
   - `@Observable` protocol using Swift 6 Observation framework
   - `@MainActor` isolated for UI safety
   - Lifecycle methods (load, reload, cleanup)
   - Error handling and loading state management

**Key Architectural Decisions**:

1. **Approachable Concurrency**:

   - Leverages Swift 6.2's more pragmatic concurrency checking
   - Uses `nonisolated(unsafe)` with locks where needed
   - Avoids excessive `@preconcurrency` and `@unchecked Sendable`
   - See `/docs/CONCURRENCY.md` for detailed rationale

2. **Lock-Based DI with Swinject**:

   - Using Swinject directly for dependency injection
   - Well-established iOS/macOS DI framework
   - Will configure Container in app delegate/initialization
   - No custom wrapper needed - direct Swinject API usage

3. **OSLog for Logging**:
   - Native Apple framework with zero dependencies
   - Automatic privacy redaction in release builds
   - Integrated with macOS Console.app for debugging

**Known Issues**:

- None - all tests passing (34 Swift Testing tests)
- Swinject Container will be configured when services are implemented in Milestone 2

**Files Created**:

- `Thriftwood/Core/DI/BaseViewModel.swift` (94 lines)
- `Thriftwood/Core/Error/ThriftwoodError.swift` (167 lines)
- `Thriftwood/Core/Logging/Logger.swift` (124 lines)
- `Thriftwood/Core/Networking/APIClient.swift` (86 lines)
- `Thriftwood/Core/Networking/Endpoint.swift` (37 lines)
- `Thriftwood/Core/Networking/HTTPMethod.swift` (15 lines)
- `Thriftwood/Services/ServiceProtocols.swift` (24 lines)
- `ThriftwoodTests/LoggerSwiftTests.swift` (Swift Testing - 19 tests)
- `ThriftwoodTests/ThriftwoodErrorSwiftTests.swift` (Swift Testing - 14 tests)
- `ThriftwoodTests/ThriftwoodTests.swift` (1 basic test)
- `docs/CONCURRENCY.md` (concurrency strategy documentation)
- `docs/SWINJECT_SETUP.md` (Swinject integration guide)

**Next Steps**:

- Proceed to Task 1.3: Navigation Framework
- Configure Swinject Container in Task 1.3 or when first services are implemented

### Task 1.3: Navigation Framework

**Estimated Time**: 6 hours  
**Actual Time**: 7 hours  
**Status**: ✅ COMPLETE  
**Implementation Date**: 2025-10-04

**Implementation Summary**:

Implemented comprehensive coordinator pattern for SwiftUI navigation with full deep linking support.

**Completed Components**:

1. **Coordinator Protocol** (`Core/Navigation/Coordinator.swift`)

   - Base protocol for all coordinators
   - Support for child coordinators and parent references
   - NavigationStack integration with path-based routing
   - Navigation methods: navigate, pop, popToRoot

2. **Route Definitions** (`Core/Navigation/Route.swift`)

   - `AppRoute` for top-level navigation (onboarding, main)
   - `TabRoute` for main tab bar (dashboard, services, settings)
   - `DashboardRoute`, `ServicesRoute`, `SettingsRoute` for feature navigation
   - `DeepLinkable` protocol for URL-based navigation

3. **Coordinator Implementations**

   - `AppCoordinator` - Root coordinator managing app-wide flow
   - `TabCoordinator` - Tab bar navigation with child coordinators
   - `DashboardCoordinator` - Dashboard feature navigation
   - `ServicesCoordinator` - Services feature navigation
   - `SettingsCoordinator` - Settings feature navigation
   - `OnboardingCoordinator` - First-run onboarding flow

4. **Deep Linking Support**

   - URL scheme: `thriftwood://`
   - All routes support URL generation and parsing
   - `TabCoordinator.handleDeepLink()` routes to appropriate child
   - Round-trip URL encoding/decoding tested

5. **Tests** (Swift Testing)
   - 17 coordinator tests covering initialization, navigation, and lifecycle
   - 30 deep link tests covering URL parsing, generation, and routing
   - All tests passing ✅

**Key Architectural Decisions**:

- **Coordinator Pattern**: Separates navigation logic from views
- **SwiftUI NavigationStack**: Modern navigation using path arrays
- **Type-Safe Routes**: Hashable enums prevent invalid navigation
- **Deep Linking**: First-class URL support for all app routes

**Files Created**:

- `Thriftwood/Core/Navigation/Coordinator.swift` (89 lines)
- `Thriftwood/Core/Navigation/Route.swift` (217 lines)
- `Thriftwood/Core/Navigation/AppCoordinator.swift` (114 lines)
- `Thriftwood/Core/Navigation/TabCoordinator.swift` (147 lines)
- `Thriftwood/Core/Navigation/DashboardCoordinator.swift` (79 lines)
- `Thriftwood/Core/Navigation/ServicesCoordinator.swift` (89 lines)
- `Thriftwood/Core/Navigation/SettingsCoordinator.swift` (101 lines)
- `Thriftwood/Core/Navigation/OnboardingCoordinator.swift` (58 lines)
- `ThriftwoodTests/CoordinatorTests.swift` (294 lines - 17 tests)
- `ThriftwoodTests/DeepLinkTests.swift` (30 tests)
- `docs/COORDINATOR_PATTERN.md` (Coordinator pattern documentation)

**Next Steps**:

- Proceed to Task 1.4: Networking Layer

### Task 1.4: Networking Layer

**Estimated Time**: 8 hours  
**Actual Time**: 2 hours  
**Status**: ✅ COMPLETE  
**Implementation Date**: 2025-10-04

**Implementation Summary**:

Established networking infrastructure using **AsyncHTTPClient** (industry-standard Swift HTTP client) - NO custom implementation needed. Following best practices: use proven frameworks instead of custom code.

**Completed Components**:

1. **AsyncHTTPClient Integration** ⭐

   - **Standard Framework**: swift-server/async-http-client @ 1.28.0
   - Built on SwiftNIO for high performance
   - HTTP/2 support, connection pooling, streaming
   - Cross-platform consistency (macOS, Linux, iOS)
   - **No wrapper needed** - use directly in services
   - Documentation: `/docs/AsyncHTTPClient-Integration.md`

2. **HTTPTypes Integration**

   - Apple's swift-http-types @ 1.4.0
   - Type-safe HTTP methods, headers, status codes
   - Used by AsyncHTTPClient for request/response types

3. **OpenAPI Runtime**
   - swift-openapi-runtime @ 1.8.3
   - For OpenAPI-based API clients (Radarr, Sonarr)
   - Type-safe client generation from OpenAPI specs

**Key Architectural Decisions**:

1. **Use Standard Framework Directly**:

   - AsyncHTTPClient is production-ready and feature-complete
   - Creating custom wrappers would be unnecessary abstraction
   - Has built-in testing support (no custom mocks needed)
   - Active maintenance by Swift Server Workgroup

2. **No Custom APIClient Protocol**:

   - AsyncHTTPClient.HTTPClient is the protocol
   - Already supports dependency injection
   - Has comprehensive error handling
   - Provides request/response logging

3. **HTTPTypes for Type Safety**:

   - Apple's modern HTTP types
   - Better than raw strings for methods/headers
   - Interoperates with AsyncHTTPClient

4. **OpenAPI for Service APIs**:
   - Generate type-safe clients from OpenAPI specs
   - Radarr, Sonarr, etc. have OpenAPI documentation
   - Reduces manual HTTP code

**Dependencies Added**:

- ✅ `swift-http-types` @ 1.4.0 (Apple)
- ✅ `swift-openapi-runtime` @ 1.8.3 (Apple)
- ✅ `swift-openapi-generator` @ 1.10.3 (Apple)
- ✅ `async-http-client` @ 1.28.0 (Swift Server)
- ✅ `Swinject` @ 2.10.0 (DI)

**Files Created**:

- `docs/AsyncHTTPClient-Integration.md` (usage guide and examples)
- **No Core/Networking directory** - not needed with AsyncHTTPClient

**Direct Usage Example**:

```swift
import AsyncHTTPClient

// In service implementation
final class RadarrService {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func getMovies() async throws -> [Movie] {
        var request = HTTPClientRequest(url: "\(baseURL)/api/v3/movie")
        request.method = .GET
        request.headers.add(name: "X-Api-Key", value: apiKey)

        let response = try await httpClient.execute(request, timeout: .seconds(30))
        let data = try await response.body.collect(upTo: 10 * 1024 * 1024)

        return try JSONDecoder().decode([Movie].self, from: Data(buffer: data))
    }
}

// In DI container
container.register(HTTPClient.self) { _ in
    HTTPClient(eventLoopGroupProvider: .singleton)
}
.inObjectScope(.container)
```

**Tests**:

- ⏳ Service integration tests will use AsyncHTTPClient directly
- Can use HTTPClient with test configuration for mocking
- No need for custom mock implementations

**Known Issues**:

- None - all dependencies resolved, build successful ✅

**Next Steps**:

- Use AsyncHTTPClient directly in Milestone 2 service implementations
- Configure HTTPClient in DI container when implementing first service
- Consider OpenAPI client generation for services with specs

**Why No Custom Code**:

AsyncHTTPClient provides everything needed:

- ✅ Request building (HTTPClientRequest)
- ✅ Response handling (HTTPClientResponse)
- ✅ Connection pooling
- ✅ Timeout management
- ✅ Error handling
- ✅ Logging support
- ✅ Testing capabilities
- ✅ SSL/TLS support

Creating custom wrappers would violate the principle: **use standard frameworks over custom implementations**.

**Documentation**:

See `/docs/AsyncHTTPClient-Integration.md` for:

- Complete usage examples
- Configuration recommendations
- Best practices
- DI integration patterns

## Week 2: Data Layer & Storage

### Task 2.1: SwiftData Setup

**Estimated Time**: 6 hours  
**Actual Time**: 4 hours  
**Status**: ✅ COMPLETE  
**Implementation Date**: 2025-10-04

**Implementation Summary**:

Implemented comprehensive SwiftData models and persistence layer to replace Flutter/Hive database. All legacy data structures have been migrated to Swift 6-native SwiftData models.

**Completed Components**:

1. **Profile Model** (`Core/Storage/Models/Profile.swift`)

   - Multi-profile support with one-to-one relationships to service configurations
   - Automatic cascade deletion of related configurations
   - Profile switching and default profile creation
   - `hasAnyServiceEnabled()` convenience method

2. **Service Configuration Models** (`Core/Storage/Models/*.swift`)

   - `RadarrConfiguration` - Movie management (API key auth)
   - `SonarrConfiguration` - TV show management (API key auth)
   - `LidarrConfiguration` - Music management (API key auth)
   - `SABnzbdConfiguration` - Download client (API key auth)
   - `NZBGetConfiguration` - Download client (username/password auth)
   - `TautulliConfiguration` - Plex statistics (API key auth)
   - `OverseerrConfiguration` - Media requests (API key auth)
   - `WakeOnLANConfiguration` - Network wake-up (broadcast + MAC address)
   - All models support custom HTTP headers (native Codable dictionary storage)
   - Protocol-based validation via `ServiceConfigurationProtocol`

3. **Indexer and ExternalModule Models**

   - `Indexer` - Search indexers (Newznab/Torznab providers)
   - `ExternalModule` - External web links for dashboard

4. **AppSettings Model** (`Core/Storage/Models/AppSettings.swift`)

   - Singleton model replacing all UserDefaults storage
   - Theme settings (AMOLED, borders, background opacity)
   - Navigation/drawer settings
   - Quick actions configuration for all services
   - Networking options (TLS validation)
   - Display preferences (24-hour time, notifications)
   - Active profile tracking

5. **ModelContainer Setup** (`Core/Storage/ModelContainer+Thriftwood.swift`)

   - `thriftwoodContainer()` - Production container with disk persistence
   - `inMemoryContainer()` - Testing container
   - Configured with all 13 model types

6. **DataService** (`Core/Storage/DataService.swift`)

   - @MainActor isolated for UI safety
   - Profile CRUD operations with profile switching
   - AppSettings singleton management
   - Indexer and ExternalModule CRUD
   - Bootstrap method for first-launch setup
   - Reset method for testing/debugging
   - Type-safe FetchDescriptor queries with predicates

7. **Migration Support** (`Core/Storage/DataMigration.swift`)

   - Schema versioning (SchemaV1 initial release)
   - `ThriftwoodMigrationPlan` for future migrations
   - `LegacyDataMigration` service (placeholder for future Hive import)
   - SwiftData automatic migration support

8. **App Integration** (`ThriftwoodApp.swift`)
   - ModelContainer initialization with error handling
   - DataService bootstrap on app launch
   - Proper @State lifecycle management

**Key Architectural Decisions**:

1. **Native SwiftData Features**:

   - No custom transformers needed - SwiftData handles `[String: String]` natively
   - Codable conformance for all models
   - @Attribute(.unique) for singleton enforcement
   - Cascade delete rules for relationships

2. **Separate Models Per Service**:

   - Cleaner than single "god object" profile
   - Easier to test and maintain
   - Natural relationships via SwiftData

3. **Protocol-Based Validation**:

   - `ServiceConfigurationProtocol` for common validation logic
   - Each service can override with custom rules
   - URL and authentication validation

4. **@MainActor Isolation**:
   - All SwiftData operations on main actor
   - Safe for SwiftUI integration
   - Consistent with Swift 6 concurrency

**Tests** (Swift Testing):

- ✅ 22 comprehensive tests in `DataServiceTests.swift`
- Profile CRUD operations (create, read, update, delete, switch)
- Service configuration attachment and cascade deletion
- AppSettings singleton behavior
- Indexer and ExternalModule CRUD
- Validation logic (URLs, API keys, MAC addresses)
- Bootstrap and reset functionality
- **All tests passing** ✅

**Files Created**:

- `Thriftwood/Core/Storage/Models/Profile.swift` (125 lines)
- `Thriftwood/Core/Storage/Models/ServiceConfiguration.swift` (29 lines)
- `Thriftwood/Core/Storage/Models/RadarrConfiguration.swift` (52 lines)
- `Thriftwood/Core/Storage/Models/SonarrConfiguration.swift` (52 lines)
- `Thriftwood/Core/Storage/Models/LidarrConfiguration.swift` (52 lines)
- `Thriftwood/Core/Storage/Models/SABnzbdConfiguration.swift` (52 lines)
- `Thriftwood/Core/Storage/Models/NZBGetConfiguration.swift` (58 lines)
- `Thriftwood/Core/Storage/Models/TautulliConfiguration.swift` (52 lines)
- `Thriftwood/Core/Storage/Models/OverseerrConfiguration.swift` (52 lines)
- `Thriftwood/Core/Storage/Models/WakeOnLANConfiguration.swift` (53 lines)
- `Thriftwood/Core/Storage/Models/Indexer.swift` (56 lines)
- `Thriftwood/Core/Storage/Models/ExternalModule.swift` (47 lines)
- `Thriftwood/Core/Storage/Models/AppSettings.swift` (172 lines)
- `Thriftwood/Core/Storage/ModelContainer+Thriftwood.swift` (68 lines)
- `Thriftwood/Core/Storage/DataService.swift` (230 lines)
- `Thriftwood/Core/Storage/DataMigration.swift` (132 lines)
- `Thriftwood/Core/Storage/DictionaryTransformer.swift` (21 lines)
- `ThriftwoodTests/DataServiceTests.swift` (379 lines - 22 tests)
- Updated `Thriftwood/ThriftwoodApp.swift` (bootstrap integration)

**Migration from Legacy**:

Successfully mapped all Flutter/Hive structures:

| Legacy (Hive)                | Swift (SwiftData)             |
| ---------------------------- | ----------------------------- |
| `LunaProfile`                | `Profile`                     |
| `profile.radarr*` fields     | `RadarrConfiguration`         |
| `profile.sonarr*` fields     | `SonarrConfiguration`         |
| `profile.lidarr*` fields     | `LidarrConfiguration`         |
| `profile.sabnzbd*` fields    | `SABnzbdConfiguration`        |
| `profile.nzbget*` fields     | `NZBGetConfiguration`         |
| `profile.tautulli*` fields   | `TautulliConfiguration`       |
| `profile.overseerr*` fields  | `OverseerrConfiguration`      |
| `profile.wakeOnLAN*` fields  | `WakeOnLANConfiguration`      |
| `LunaIndexer`                | `Indexer`                     |
| `LunaExternalModule`         | `ExternalModule`              |
| `thriftwoodDatabase` (Hive)  | `AppSettings`                 |
| `UserDefaults` storage       | `AppSettings` (in SwiftData)  |
| Hive boxes (separate tables) | SwiftData entities (one file) |

**Known Issues**:

- None - all tests passing ✅

**Next Steps**:

- Proceed to Task 2.2: Keychain Integration
- API keys will be stored in Keychain (not SwiftData)
- SwiftData stores URLs, usernames, and settings
- Credentials will be moved to secure storage

### Task 2.2: Keychain Integration

**Estimated Time**: 4 hours

- [ ] Implement KeychainService wrapper
- [ ] Create secure storage for API keys
- [ ] Add biometric authentication support

### Task 2.3: User Preferences

**Estimated Time**: 4 hours

- [ ] Create UserDefaults wrapper with @AppStorage
- [ ] Define app settings structure
- [ ] Implement theme preferences
- [ ] Setup language/locale preferences

### Task 2.4: Profile Management

**Estimated Time**: 6 hours

- [ ] Create Profile model and repository
- [ ] Implement profile CRUD operations
- [ ] Add profile switching logic
- [ ] Create profile export/import functionality

## Week 3: UI Foundation & Common Components

### Task 3.1: Design System

**Estimated Time**: 6 hours

- [ ] Define color scheme (light/dark mode)
- [ ] Create typography scales
- [ ] Setup spacing and sizing constants
- [ ] Create app icon and launch screen
- [ ] Define animation constants

### Task 3.2: Common UI Components

**Estimated Time**: 8 hours

- [ ] Create LoadingView component
- [ ] Implement ErrorView with retry
- [ ] Build EmptyStateView
- [ ] Create custom navigation bar
- [ ] Implement pull-to-refresh modifier

### Task 3.3: Form Components

**Estimated Time**: 6 hours

- [ ] Create TextFieldRow for settings
- [ ] Build SecureFieldRow for passwords
- [ ] Implement ToggleRow
- [ ] Create PickerRow for selections
- [ ] Add form validation helpers

### Task 3.4: Main App Structure

**Estimated Time**: 8 hours

- [ ] Implement MainTabView
- [ ] Create SettingsView skeleton
- [ ] Build ProfileListView
- [ ] Add AddProfileView
- [ ] Implement launch/onboarding flow

## Testing & Documentation

### Task T1: Unit Tests

**Estimated Time**: 8 hours

- [ ] Test networking layer
- [ ] Test data persistence
- [ ] Test profile management
- [ ] Test keychain operations
- [ ] Test navigation logic

### Task D1: Documentation

**Estimated Time**: 4 hours

- [ ] Document architecture decisions
- [ ] Create API documentation
- [ ] Write setup guide
- [ ] Document coding conventions

## Acceptance Criteria

### Functional Criteria

- [ ] App launches successfully
- [ ] Can create and switch profiles
- [ ] Settings are persisted
- [ ] Navigation works correctly
- [ ] Error states are handled

### Technical Criteria

- [ ] No compiler warnings
- [ ] SwiftLint passes
- [ ] > 80% test coverage for foundation
- [ ] All TODO items resolved
- [ ] Documentation complete

## Risks & Mitigations

| Risk                    | Mitigation                     |
| ----------------------- | ------------------------------ |
| SwiftData instability   | Have CoreData fallback plan    |
| Swift 6 adoption issues | Keep compatibility mode option |
| Complex navigation      | Simplify if needed             |

## Next Milestone Preview

With foundation complete, Milestone 2 will focus on implementing the first two services (Radarr and Sonarr) with full CRUD functionality.
