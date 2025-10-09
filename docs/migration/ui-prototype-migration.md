# UI Prototype Migration - Requirements and Design

## Overview

Migrating Thriftwood's UI to match the PrototypeGUI design, which features a dashboard-based navigation with service-specific views.

## Prototype Analysis

### Navigation Architecture

**Current (Thriftwood):**

- NavigationStack with path-based routing
- AppRoute enum defines all routes
- Linear navigation flow

**Prototype (Target):**

- NavigationSplitView with sidebar + detail
- Dashboard shows all services in sidebar
- Direct view composition, no route enum needed

### Key Views in Prototype

1. **PrototypeGUIApp.swift** - Main app entry point
2. **ContentView.swift** - Root view with NavigationSplitView
3. **DashboardView.swift** - Service selection sidebar
4. **Service Views:**
   - RadarrView.swift - Main Radarr interface
   - SonarrView.swift - Placeholder
   - LidarrView.swift - Placeholder
   - SABnzbdView.swift - Placeholder
   - TautulliView.swift - Placeholder
5. **Radarr Detailed Views:**
   - MovieDetailView.swift - Tabbed detail (Overview, Files, History, Cast/Crew)
   - AddMovieView.swift - Search and add movies
   - AddSingleMovieView.swift - Add specific movie
   - MovieRow.swift - List item
   - MovieFilesView.swift - File management
   - MovieHistoryView.swift - Activity history
   - MovieCastCrewView.swift - Credits
6. **Settings Views:**
   - SettingsView.swift - Settings sidebar
   - ConfigurationView.swift - Service configuration
   - RadarrSettingsView.swift - Radarr-specific settings
   - RadarrConnectionView.swift - Connection details
7. **Platform Support:**
   - PlatformSpecific/Color.swift - Cross-platform color handling
   - PlatformSpecific/PlatformToolbarPlacement.swift - Toolbar positioning
8. **Components:**
   - SearchView.swift - Global search
   - PlaceholderEmptyView.swift - Empty states

### Data Models (from prototype)

```swift
// Movie.swift - Radarr movie model
struct Movie {
    let id: Int
    let title: String
    let year: Int
    let overview: String?
    let status: String
    let hasFile: Bool
    let monitored: Bool
    // ... additional fields
}

// MovieFile.swift - Movie file information
struct MovieFile {
    let id: Int
    let movieId: Int
    let quality: String
    let size: Int64
    // ... additional fields
}

// MovieHistoryEntry.swift - Activity history
struct MovieHistoryEntry {
    let id: Int
    let date: Date
    let eventType: String
    // ... additional fields
}
```

## Migration Requirements (EARS Format)

### Navigation

**REQ-NAV-1**: WHEN the app launches, THE SYSTEM SHALL display a NavigationSplitView with a service sidebar and main content area.

**REQ-NAV-2**: WHEN the user selects a service in the sidebar, THE SYSTEM SHALL display that service's main view in the detail pane.

**REQ-NAV-3**: WHILE in a service view, THE SYSTEM SHALL provide navigation to sub-views (detail, settings) within that service context.

### Dashboard

**REQ-DASH-1**: THE SYSTEM SHALL display all available services (Radarr, Sonarr, Lidarr, SABnzbd, Tautulli) in the sidebar.

**REQ-DASH-2**: WHEN a service is unavailable or unconfigured, THE SYSTEM SHALL still show it in the sidebar with appropriate indicators.

**REQ-DASH-3**: THE SYSTEM SHALL highlight the currently selected service in the sidebar.

### Radarr Views

**REQ-RAD-1**: WHEN the user selects Radarr, THE SYSTEM SHALL display a list of movies with search functionality.

**REQ-RAD-2**: WHEN the user selects a movie, THE SYSTEM SHALL display detailed information in tabs: Overview, Files, History, Cast/Crew.

**REQ-RAD-3**: WHEN the user initiates "Add Movie", THE SYSTEM SHALL provide a search interface to find and add new movies.

**REQ-RAD-4**: THE SYSTEM SHALL display movie files with quality, size, and file information.

**REQ-RAD-5**: THE SYSTEM SHALL display movie history with events and timestamps.

### Settings

**REQ-SET-1**: THE SYSTEM SHALL provide settings navigation with sections for services, appearance, and app information.

**REQ-SET-2**: WHEN configuring a service, THE SYSTEM SHALL provide fields for URL, API key, and connection testing.

**REQ-SET-3**: THE SYSTEM SHALL validate service connections before saving.

### Platform Support

**REQ-PLAT-1**: THE SYSTEM SHALL compile and run on both macOS and iOS with platform-appropriate UI adaptations.

**REQ-PLAT-2**: THE SYSTEM SHALL use platform-specific toolbar placements (automatic on iOS, navigationBar on macOS).

## Design Decisions

### Decision - 2025-10-09T00:00:00Z

**Decision**: Use NavigationSplitView instead of NavigationStack for root navigation
**Context**: Prototype uses dashboard pattern with sidebar, current app uses linear navigation
**Rationale**: NavigationSplitView provides better UX for multi-service architecture, natural for both macOS and iPad
**Impact**: Major refactoring of ContentView and routing, but cleaner long-term architecture
**Review**: After initial implementation, assess if deep linking still works

### Decision - 2025-10-09T00:00:01Z

**Decision**: Remove AppRoute enum in favor of direct view composition
**Context**: Current routing uses enum with all possible routes defined upfront
**Rationale**: Dashboard pattern doesn't need centralized routing enum, views compose naturally
**Impact**: Simpler navigation code, easier to add new views, better fits dashboard paradigm
**Review**: After migration, verify all navigation flows work correctly

### Decision - 2025-10-09T00:00:02Z

**Decision**: Implement platform-specific abstractions for Color and Toolbar
**Context**: Prototype has conditional compilation for macOS vs iOS differences
**Rationale**: Maintain single codebase with platform-appropriate behavior
**Impact**: Small abstraction layer, enables true cross-platform support
**Review**: Test on both platforms after implementation

### Decision - 2025-10-09T00:00:03Z

**Decision**: Migrate Radarr views fully, keep other services as placeholders
**Context**: Prototype has full Radarr implementation, other services are stubs
**Rationale**: Focus on complete, working Radarr experience first, expand later
**Impact**: Users get functional movie management immediately, other services follow milestone plan
**Review**: After Radarr stabilizes, prioritize next service based on user demand

## Implementation Plan

See tasks.md for detailed implementation steps. High-level phases:

1. **Phase 1**: Platform abstractions and navigation foundation
2. **Phase 2**: Dashboard and service sidebar
3. **Phase 3**: Radarr view migration with ViewModels
4. **Phase 4**: Settings views
5. **Phase 5**: Other service placeholders
6. **Phase 6**: Testing and validation

## Success Criteria

- [ ] App launches with dashboard navigation
- [ ] All services appear in sidebar
- [ ] Radarr views match prototype functionality
- [ ] Movie detail view has all tabs working
- [ ] Add movie flow functions correctly
- [ ] Settings allow service configuration
- [ ] Compiles and runs on macOS (iOS optional for now)
- [ ] All SwiftLint checks pass
- [ ] All license headers present
- [ ] Existing tests still pass
- [ ] New views have corresponding tests
