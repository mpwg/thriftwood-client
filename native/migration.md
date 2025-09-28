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

- **Module-by-Module Migration**: Convert one service integration at a time
- **Service API Compatibility**: Maintain exact API compatibility with existing services
- **Profile System Preservation**: Keep multi-profile configuration system
- **SwiftUI + Combine**: Use modern iOS patterns for state management
- **iOS 16+ Target**: Leverage latest SwiftUI capabilities for media-focused UI
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

### Phase 5: Advanced Features

#### Task 5.1: Push Notifications

```
OBJECTIVE: Implement native push notification handling
TASKS:
1. Configure push notification capabilities
2. Implement AppDelegate/SceneDelegate handlers
3. Create NotificationService:
   - Register for remote notifications
   - Handle notification payloads
   - Process background notifications
4. Implement in-app notification UI
5. Test notification delivery and handling
```

#### Task 5.2: Background Tasks

```
OBJECTIVE: Migrate background processing features
TASKS:
1. Identify background tasks in Flutter
2. Implement using BackgroundTasks framework:
   - Background refresh
   - Background processing
3. Set up background URL sessions
4. Implement background location updates (if needed)
5. Test background execution
```

#### Task 5.3: Platform Integrations

```
OBJECTIVE: Implement iOS-specific features
TASKS:
1. Camera/Photo library integration
2. Implement ShareSheet functionality
3. Add Siri Shortcuts (if applicable)
4. Integrate with HealthKit (if applicable)
5. Implement Widget Extension (if applicable)
6. Add App Clips support (if applicable)
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

## Code Migration Patterns

### Flutter Widget to SwiftUI View

**Flutter Pattern:**

```dart
class CustomWidget extends StatefulWidget {
  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  String data = "";

  void fetchData() async {
    // API call
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(data),
    );
  }
}
```

**SwiftUI Equivalent:**

```swift
struct CustomView: View {
    @StateObject private var viewModel = CustomViewModel()

    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.fetchData()
            }
    }
}

@MainActor
class CustomViewModel: ObservableObject {
    @Published var data = ""

    func fetchData() async {
        // API call
    }
}
```

### State Management Migration

**Flutter Provider/Riverpod:**

```dart
final dataProvider = StateNotifierProvider<DataNotifier, DataState>((ref) {
  return DataNotifier();
});
```

**SwiftUI EnvironmentObject:**

```swift
@MainActor
class DataStore: ObservableObject {
    @Published var dataState: DataState = .initial
}

// In App:
@StateObject private var dataStore = DataStore()

// In Views:
@EnvironmentObject var dataStore: DataStore
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

1. **Feature Parity**: 100% of Flutter features implemented
2. **Performance**: App launch time < 1 second
3. **Crash Rate**: < 0.1%
4. **Memory Usage**: < 100MB for typical session
5. **Test Coverage**: > 80% code coverage
6. **Accessibility**: Pass all Xcode accessibility audits
7. **App Size**: Smaller than or equal to Flutter version

## Risk Mitigation

### Technical Risks

- **SwiftUI Limitations**: Have UIKit fallback plan for complex components
- **State Management Complexity**: Use Combine framework for complex flows
- **Performance Issues**: Profile early and often
- **Third-party Dependencies**: Find native alternatives early

### Process Risks

- **Timeline Delays**: Build buffer into each phase
- **Feature Creep**: Strictly maintain feature parity first
- **Testing Gaps**: Automate testing from day one
- **Knowledge Gaps**: Document all decisions and patterns

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

- SwiftUI expertise (iOS 16+)
- Combine framework knowledge
- REST API integration experience
- Core Data/SwiftData experience
- Testing frameworks (XCTest)
- CI/CD experience (Xcode Cloud/Fastlane)

### Development Tools

- Xcode 15+
- Swift 5.9+
- SwiftLint
- Swift Package Manager
- Instruments for profiling
- Proxyman/Charles for network debugging

### Time Estimates

- Total Duration: 16 weeks
- Developer Resources: 2-3 iOS developers
- QA Resources: 1 QA engineer
- Review Checkpoints: Weekly

---

_This migration plan is designed to be executed by AI coding assistants with human oversight. Each task includes clear objectives and specific implementation steps suitable for AI-assisted development._
