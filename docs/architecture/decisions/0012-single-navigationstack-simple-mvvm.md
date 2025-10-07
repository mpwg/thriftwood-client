<!--
Thriftwood - Frontend for Media Management
Copyright (C) 2025 Matthias Wallner Géhri

This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
International License. To view a copy of this license, visit
http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
-->

# ADR-0012: Single NavigationStack with Simple MVVM

**Status**: Accepted (supersedes ADR-0011)  
**Date**: 2025-01-06  
**Deciders**: @mpwg  
**Related**: ADR-0001, ADR-0005, ADR-0011  
**Supersedes**: ADR-0011 Hierarchical Navigation Pattern

## Context

After implementing the nested NavigationStack approach from ADR-0011 and fixing navigation bugs in Settings and Radarr modules, a critical evaluation revealed that the MVVM-C pattern with nested NavigationStacks is **over-engineering** for an app of this size.

### Key Findings from Analysis

1. **Legacy App Complexity** (from `MVVM-C-ANALYSIS.md`):

   - Legacy Flutter app: ~110 screens across 11 modules
   - Navigation: Simple GoRouter (no coordinators, no nested stacks)
   - Pattern: Straightforward route matching with state management

2. **Current Swift Implementation Overhead**:

   - Each feature requires 4-5 files (Coordinator, CoordinatorView, Route enum, Views)
   - 30-50 lines of navigation boilerplate per feature
   - Nested NavigationStacks fight against SwiftUI's intended design
   - Complex path management across multiple coordinators

3. **SwiftUI Design Philosophy**:

   - NavigationStack is designed for homogeneous path types (single route enum)
   - Nested NavigationStacks in the same window is an anti-pattern
   - SwiftUI's declarative navigation works best with centralized state

4. **Development Velocity**:
   - Simple MVVM would reduce code by ~70%
   - Faster feature development (1-2 files instead of 4-5)
   - Easier to understand and maintain for a solo developer

### The Problem with Nested NavigationStacks

The recent bug fix revealed a fundamental issue: pushing a coordinator view (SettingsCoordinatorView, RadarrCoordinatorView) into a NavigationStack and then having those views contain their own NavigationStack creates confusing nested navigation state.

**Console Error** (before fix):

```text
Only root-level navigation destinations are effective for a navigation stack with a homogeneous path
```

**Current Structure** (nested stacks):

```text
ContentView
└── MainAppNavigationView (NavigationStack<AppRoute>)
    └── navigationDestination:
        ├── .radarr → RadarrCoordinatorView (NavigationStack<RadarrRoute>)
        └── .settings → SettingsCoordinatorView (NavigationStack<SettingsRoute>)
```

While we fixed the immediate bug by adding NavigationStack wrappers, this revealed the deeper architectural issue.

## Decision

### Adopt Simple MVVM with Single NavigationStack at Window Level

#### Architecture

1. **Single NavigationStack** at the root of `ContentView`
2. **Unified AppRoute Enum** with all routes (organized by module)
3. **Logic Coordinators** (not navigation coordinators):
   - Handle business logic, service coordination, state management
   - **Do NOT** manage navigation paths
   - Provide callbacks for navigation decisions
4. **AppCoordinator** becomes the **sole navigation authority**:
   - Manages the single navigation path array
   - Handles all route transitions
   - Provides centralized deep linking

### Proposed Structure

```swift
// Unified Route Enum (organized by module)
enum AppRoute: Hashable {
    // App Level
    case services
    case settings

    // Radarr Module
    case radarrHome
    case radarrMovies
    case radarrMovieDetail(id: Int)
    case radarrAddMovie

    // Sonarr Module
    case sonarrHome
    case sonarrSeries
    case sonarrSeriesDetail(id: Int)

    // Settings Module
    case settingsGeneral
    case settingsProfiles
    case settingsProfileDetail(id: UUID)
    case settingsAbout

    // ... other modules
}

// AppCoordinator (sole navigation authority)
@Observable
final class AppCoordinator {
    var navigationPath: [AppRoute] = []

    // Dependencies
    private let radarrLogicCoordinator: RadarrLogicCoordinator
    private let settingsLogicCoordinator: SettingsLogicCoordinator

    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }

    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func navigateToRoot() {
        navigationPath.removeAll()
    }
}

// Logic Coordinator (business logic, not navigation)
@Observable
final class RadarrLogicCoordinator {
    private let radarrService: RadarrServiceProtocol

    // Business logic methods
    func loadMovies() async throws -> [Movie] {
        try await radarrService.getMovies()
    }

    func addMovie(_ movie: Movie) async throws {
        try await radarrService.addMovie(movie)
    }

    // Navigation is handled by callbacks to AppCoordinator
    // No navigationPath property here
}

// ContentView (single NavigationStack)
struct ContentView: View {
    @State private var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            AppHomeView(coordinator: coordinator)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.view(for: route)
                }
        }
    }
}
```

### Migration Strategy

1. **Phase 1: Unify Routes**

   - Merge AppRoute, RadarrRoute, SettingsRoute into single AppRoute enum
   - Organize by module using enum extensions or comments
   - Keep route cases structured and documented

2. **Phase 2: Refactor Coordinators**

   - Rename coordinators to "LogicCoordinator" (e.g., RadarrLogicCoordinator)
   - Remove navigationPath properties
   - Convert navigation methods to callbacks
   - Keep business logic intact

3. **Phase 3: Update AppCoordinator**

   - Add logic coordinators as dependencies
   - Update view(for:) method to handle all routes
   - Implement centralized navigation methods

4. **Phase 4: Update Views**

   - Remove coordinator navigationPath bindings
   - Update button actions to call AppCoordinator navigation methods
   - Simplify view hierarchy

5. **Phase 5: Update Tests**

   - Update coordinator tests to focus on business logic
   - Add navigation tests to AppCoordinator
   - Verify deep linking scenarios

6. **Phase 6: Update Documentation**
   - Rewrite navigation architecture docs
   - Update coding conventions
   - Create migration guide

## Consequences

### Positive

1. **Significantly Less Code**

   - ~70% reduction in navigation boilerplate
   - 1-2 files per feature instead of 4-5
   - Simpler mental model

2. **Faster Development**

   - New features don't require coordinator setup
   - Navigation changes are centralized
   - Easier to prototype and iterate

3. **Better SwiftUI Integration**

   - Single NavigationStack follows SwiftUI design
   - No nested stack confusion
   - Simpler state management

4. **Easier Testing**

   - Business logic coordinators are pure logic (no navigation state)
   - Navigation testing is centralized in AppCoordinator
   - Clearer test boundaries

5. **Improved Maintainability**
   - Single source of truth for navigation
   - Easier to understand for new developers
   - Simpler debugging

### Negative

1. **Large AppRoute Enum**

   - Could grow to 50+ cases for full app
   - Mitigation: Use extensions to organize by module
   - Example:

     ```swift
     // MARK: - Radarr Routes
     extension AppRoute {
         static let radarrHome: AppRoute = .radarrHome
         // ... other Radarr routes
     }
     ```

2. **Loss of "True" Coordinators**

   - Coordinators become logic-only (not navigation coordinators)
   - Mitigation: Rename to "LogicCoordinator" to clarify role
   - Business logic separation is preserved

3. **Migration Effort**
   - Need to refactor existing coordinator code
   - Update all navigation call sites
   - Mitigation: Can be done incrementally, module by module

### Neutral

1. **Deep Linking**

   - Centralized in AppCoordinator (easier to manage)
   - All routes are in one enum (simpler matching)

2. **Modularization**
   - Logic coordinators still provide module boundaries
   - Business logic remains separated by feature

## Comparison to Alternatives

### Option B: Keep Nested NavigationStacks (Current)

**Pros**:

- Already partially implemented
- "True" coordinator pattern

**Cons**:

- Complex nested state management
- Fights against SwiftUI design
- High boilerplate (4-5 files per feature)
- Harder to understand and maintain

**Decision**: Rejected due to over-engineering for app size

### Option C: No Coordinators at All

**Pros**:

- Minimal code
- Very simple

**Cons**:

- Business logic mixed with views
- Harder to test
- No separation of concerns

**Decision**: Rejected - still want business logic separation

### Option A: Single NavigationStack with Logic Coordinators (Chosen)

**Pros**:

- Optimal balance of simplicity and separation
- ~70% less code than Option B
- Better SwiftUI integration
- Faster development

**Cons**:

- Large route enum (mitigated with extensions)
- Migration effort (one-time cost)

**Decision**: Chosen for optimal simplicity/separation balance

## Implementation Checklist

- [ ] Create unified AppRoute enum with all routes
- [ ] Refactor AppCoordinator to handle all navigation
- [ ] Rename coordinators to LogicCoordinator
- [ ] Remove navigationPath from logic coordinators
- [ ] Update ContentView to single NavigationStack
- [ ] Update all views to use AppCoordinator navigation
- [ ] Update all tests for new pattern
- [ ] Rewrite navigation documentation
- [ ] Update coding conventions
- [ ] Create migration guide
- [ ] Close issues #208-212 (superseded)
- [ ] Create new implementation issue

## Decision Refinement: LogicCoordinator Elimination (2025-01-06)

### Context

During Phase 3 implementation of this ADR, a critical question arose: **"Why do we have coordinator classes in pure MVVM?"**

Upon review, the "LogicCoordinators" (RadarrLogicCoordinator, SettingsLogicCoordinator, etc.) were essentially:

- ViewModel factories that created ViewModels with service dependencies
- Service holders that passed services to ViewModels
- **Zero navigation logic** (navigation delegated to AppCoordinator)

### Analysis

**What LogicCoordinators Actually Did**:

```swift
// RadarrLogicCoordinator - just a ViewModel factory
func makeMoviesListViewModel() -> MoviesListViewModel {
    MoviesListViewModel(radarrService: radarrService)
}
```

**What AppCoordinator Already Did**:

```swift
// AppCoordinator - already has services and creates ViewModels
private let radarrService: RadarrServiceProtocol
// ...
func navigate(to route: AppRoute) {
    let viewModel = MoviesListViewModel(radarrService: radarrService)
    navigationPath.append(route)
}
```

**Conclusion**: LogicCoordinators were redundant. AppCoordinator already has DI container access and can create ViewModels directly.

### Decision

**Eliminate LogicCoordinators completely** for true pure MVVM:

- ✅ **AppCoordinator**: Creates ViewModels directly using injected services
- ✅ **ViewModels**: Handle business logic (no coordinators needed)
- ✅ **Services**: Provide data access (injected via DI)
- ✅ **Views**: Pure presentation (navigation via callbacks)
- ❌ **No LogicCoordinators**: Not needed in pure MVVM

### Impact

**Code Reduction** (~800 lines removed):

- Deleted RadarrLogicCoordinator.swift (120 lines)
- Deleted SettingsLogicCoordinator.swift (80 lines)
- Deleted 6 obsolete coordinator files (DashboardCoordinator, ServicesCoordinator, etc.) (500+ lines)
- Removed all `#if false` disabled code blocks
- Simplified AppCoordinator implementation

**Architecture Simplification**:

- One coordinator (AppCoordinator) instead of 1+N pattern
- Direct ViewModel creation (no factory pattern needed)
- Clearer responsibility boundaries
- True pure MVVM (not MVVM-C)

**Developer Experience**:

- Fewer files to understand
- Direct service-to-ViewModel flow
- No "coordinator" vs "logic coordinator" confusion
- Faster feature development

### Rationale

**Why This Is Better Than Original Plan**:

1. **Original Plan** (ADR-0012 v1):

   - AppCoordinator handles navigation
   - LogicCoordinators create ViewModels
   - Result: Two coordinator types with unclear boundaries

2. **Actual Implementation** (ADR-0012 final):
   - AppCoordinator handles navigation AND creates ViewModels
   - No intermediary needed
   - Result: Simpler, more maintainable architecture

**Trade-offs**:

- ✅ Simpler architecture (fewer concepts)
- ✅ Less code to maintain
- ✅ Clearer separation of concerns
- ❌ AppCoordinator has more responsibilities (acceptable for app size)
- ❌ Less granular testability (mitigated by testing ViewModels directly)

### Implementation Results

**What Changed from Original ADR**:

```diff
- Option A: Single NavigationStack with Logic Coordinators (Chosen)
+ Implemented: Single NavigationStack with Pure MVVM (No Logic Coordinators)
```

**Final Architecture**:

- **AppCoordinator**: Sole navigation authority, creates ViewModels directly
- **OnboardingCoordinator**: Only child coordinator (separate first-run flow)
- **ViewModels**: Business logic (created by AppCoordinator or views)
- **Services**: Data access (injected via DI)
- **Views**: Presentation only

**Validation**:

- ✅ All tests pass (100%)
- ✅ BUILD SUCCEEDED
- ✅ ~800 lines of code removed
- ✅ All comments updated to reflect pure MVVM
- ✅ Comprehensive documentation rewritten

### Lessons Learned

1. **Challenge assumptions during implementation**: "Why do we need this?" led to better architecture
2. **Pure MVVM doesn't need coordinators**: Coordinators are for MVVM-C navigation, not business logic
3. **Simpler is better for solo development**: Fewer abstractions = faster iteration
4. **Document architectural evolution**: Capture why decisions changed during implementation

### Review Conditions

Re-evaluate this decision if:

- App grows to 50+ screens (may need feature coordinators)
- Multiple developers join (may benefit from stricter separation)
- Complex multi-step flows emerge (may need specialized coordinators)

**Current Assessment** (110 screens planned): Pure MVVM is sufficient.

## References

- `docs/architecture/decisions/MVVM-C-ANALYSIS.md` - Critical analysis
- ADR-0001: Single NavigationStack per Coordinator (now superseded)
- ADR-0005: MVVM-C Pattern (simplified to MVVM)
- ADR-0011: Hierarchical Navigation Pattern (superseded)
- `docs/implementation-summaries/fix-settings-radarr-navigation.md` - Bug fix that revealed issue
- `docs/architecture/NAVIGATION_ARCHITECTURE.md` - Pure MVVM implementation guide (Version 3.0)

## Notes

This decision supersedes ADR-0011 which prescribed nested NavigationStacks with hierarchical button navigation. That approach was found to be over-engineering after implementation and critical analysis.

**Implementation Evolution**: The original ADR-0012 plan included "LogicCoordinators" for business logic separation. During implementation (Phase 3), it became clear these were unnecessary abstractions. The final implementation eliminates LogicCoordinators for a true pure MVVM architecture, achieving even greater simplification than originally planned.

**Final Architecture**: True pure MVVM with single NavigationStack, ~800 lines of code removed beyond original estimates.

**Migration Timeline**: Completed in ~20 hours over 6 phases (ANALYZE, DESIGN, IMPLEMENT, VALIDATE, REFLECT, HANDOFF).
