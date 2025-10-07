# Architecture Analysis: Is MVVM-C Over-Engineering?

**Date**: October 7, 2025  
**Context**: Critical evaluation of MVVM-C pattern for Thriftwood

## Executive Summary

After analyzing the legacy codebase, **YES, MVVM-C is likely over-engineering** for this app. The coordinator pattern adds significant complexity with minimal benefit for an app of this size.

## Actual App Scope (from Legacy Codebase)

### Total Screen Count: ~110 screens across all modules

| Module               | Screens | Complexity                               |
| -------------------- | ------- | ---------------------------------------- |
| **Settings**         | 47      | Highest - but mostly configuration forms |
| **Tautulli**         | 21      | Medium - viewing/stats                   |
| **Radarr**           | 12      | Medium - movies management               |
| **Sonarr**           | 10      | Medium - TV shows management             |
| **Lidarr**           | 7       | Low - music management                   |
| **Search**           | 5       | Low - search across services             |
| **SABnzbd**          | 3       | Low - download client                    |
| **NZBGet**           | 2       | Low - download client                    |
| **Dashboard**        | 1       | Low - home screen                        |
| **External Modules** | 1       | Low - module management                  |
| **BIOS**             | 1       | Low - initial setup                      |

### Navigation Patterns (from GoRouter)

The legacy app uses **GoRouter** (Flutter's navigation library) with:

- **11 top-level routes** (one per module)
- **Hierarchical subroutes** (e.g., `/radarr/movie/:id/edit`)
- **Simple navigation model** - mostly linear flows with occasional branching

**Key Insight**: The legacy app does NOT use coordinators. It uses route enums + GoRouter directly.

## MVVM-C Pattern Analysis

### What We're Currently Building

```text
View → Coordinator → Navigation
  ↓
ViewModel → Services
  ↓
Models
```

**Components per feature:**

1. View (SwiftUI)
2. ViewModel (@Observable)
3. Coordinator class
4. CoordinatorView wrapper
5. Route enum
6. Protocol conformance

**Example: Adding a simple "About" screen requires:**

- `AboutView.swift` (content)
- `AboutViewModel.swift` (logic)
- Modifying `SettingsCoordinator.swift` (navigation method)
- Adding to `SettingsRoute` enum
- Updating `SettingsCoordinatorView` switch case

### Problems with MVVM-C for This App

#### 1. **Boilerplate Overhead**

- **Files**: 4-5 files per feature screen
- **Lines of code**: ~30-50 lines just for navigation plumbing
- **Maintenance**: Changes require touching multiple files

#### 2. **Nested NavigationStack Complexity**

As we discovered today:

- Coordinators want their own NavigationStack
- This creates nested stacks
- Goes against SwiftUI's design
- Causes the "homogeneous path" error

#### 3. **State Management Confusion**

- Who owns the navigation state? AppCoordinator? Feature coordinator?
- How do coordinators communicate?
- Parent-child coordinator relationships are complex

#### 4. **Testing Overhead**

- Need to test coordinator navigation logic separately
- ViewModels need mock coordinators
- More mocking, more setup

#### 5. **Limited Benefit**

What are we actually gaining?

- ❌ **Not reducing coupling** - Views still know about coordinators
- ❌ **Not simplifying navigation** - Made it MORE complex
- ❌ **Not improving testability** - Can test nav logic with simple enums
- ❌ **Not enabling deep linking** - Could do with single NavigationStack
- ✅ **Module separation** - This is the ONLY real benefit

## Alternative: Simplified SwiftUI-Native Approach

### Recommended Architecture: MVVM (no C)

```text
View → NavigationStack → Routes
  ↓
ViewModel → Services
  ↓
Models
```

**Components per feature:**

1. View (SwiftUI)
2. ViewModel (@Observable)
3. Routes in shared enum

**Example: Adding "About" screen:**

- `AboutView.swift` (content + navigation title)
- Add `.about` to `AppRoute` enum
- One line in navigation destination switch

### Concrete Proposal

```swift
// 1. Single route enum for entire app
enum AppRoute: Hashable, Sendable {
    // Dashboard
    case dashboard

    // Services
    case services

    // Radarr (12 routes)
    case radarr
    case radarrMovies
    case radarrMovieDetail(Int)
    case radarrAddMovie(query: String = "")
    case radarrEditMovie(Int)
    case radarrReleases(Int)
    case radarrQueue
    case radarrHistory
    case radarrManualImport
    case radarrSystemStatus
    case radarrTags

    // Settings (simplify from 47 to ~15 essential screens)
    case settings
    case settingsProfiles
    case settingsAddProfile
    case settingsEditProfile(UUID)
    case settingsAppearance
    case settingsNotifications
    case settingsAbout
    // ... etc

    // Total: ~60-70 routes (down from 110 by combining similar screens)
}

// 2. Single NavigationStack at root
struct ContentView: View {
    @State private var navigationPath: [AppRoute] = []
    @State private var viewModels = ViewModelFactory()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            DashboardView()
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .radarr:
            RadarrHomeView(viewModel: viewModels.radarrHome)
        case .radarrMovies:
            RadarrMoviesListView(viewModel: viewModels.radarrMovies)
        case .radarrMovieDetail(let id):
            RadarrMovieDetailView(movieId: id, viewModel: viewModels.radarrMovieDetail(id))
        // ... etc - just return views
        }
    }
}

// 3. Views handle navigation via Environment
struct RadarrHomeView: View {
    @Environment(\.navigationPath) private var navigationPath
    let viewModel: RadarrHomeViewModel

    var body: some View {
        List {
            Button("Movies") {
                navigationPath.wrappedValue.append(.radarrMovies)
            }
        }
        .navigationTitle("Radarr")
    }
}

// 4. Or even simpler: NavigationLink
struct RadarrHomeView: View {
    let viewModel: RadarrHomeViewModel

    var body: some View {
        List {
            NavigationLink(value: AppRoute.radarrMovies) {
                Label("Movies", systemImage: "film")
            }
        }
        .navigationTitle("Radarr")
    }
}
```

### Benefits of This Approach

1. **✅ 70% Less Code**

   - No coordinator classes
   - No coordinator views
   - No protocol conformance
   - Just views + viewmodels

2. **✅ SwiftUI-Native**

   - Uses NavigationStack as designed
   - No nested stack issues
   - Works WITH the framework, not against it

3. **✅ Clear Navigation State**

   - One path: `[AppRoute]`
   - Easy to debug: print the path
   - Deep linking: just set the path array

4. **✅ Easy Testing**

   - Test ViewModels with mock services
   - Test navigation by checking path changes
   - Less mocking needed

5. **✅ Faster Development**

   - Add screen = add enum case + view
   - 5 minutes vs 20 minutes per screen
   - Less context switching

6. **✅ Easier Onboarding**
   - Standard SwiftUI patterns
   - No custom architecture to learn
   - Follow Apple's docs

### When You WOULD Need Coordinators

Coordinators make sense when:

1. **Multiple entry points** - Complex flow orchestration (e.g., banking app with many onboarding flows)
2. **Complex state machines** - Flows with many branches and conditions
3. **Large team** - Strict separation of concerns needed
4. **White-label apps** - Different navigation flows per client
5. **Complex deep linking** - Many external entry points

**Thriftwood has NONE of these:**

- Simple linear flows
- Small team (1-2 developers)
- Straightforward navigation
- Limited deep linking needs

## Recommendation

### Short Term (This Week)

**Keep MVVM-C for now** to avoid disrupting current work, BUT:

1. Document this as technical debt
2. Plan refactor for Phase 2
3. Stop adding coordinator complexity

### Medium Term (Phase 2 - After Foundation)

**Refactor to simplified MVVM:**

1. Remove all Coordinator classes
2. Consolidate to single NavigationStack
3. Use `AppRoute` enum with clear naming
4. Views handle navigation via NavigationLink or path appending
5. Keep ViewModels for business logic

### Estimated Savings

- **Development time**: 40-50% faster per feature
- **Code volume**: 70% reduction in navigation code
- **Complexity**: 80% reduction in navigation complexity
- **Bugs**: Fewer navigation-related bugs
- **Maintenance**: Easier to modify navigation flows

## Alternative: Hybrid Approach

If you want SOME separation but not full coordinators:

```swift
// Navigation helpers per module (not full coordinators)
enum RadarrNavigation {
    static func navigateToMovies(path: inout [AppRoute]) {
        path.append(.radarrMovies)
    }

    static func navigateToMovieDetail(id: Int, path: inout [AppRoute]) {
        path.append(.radarrMovieDetail(id))
    }
}

// Use in views
Button("View Movies") {
    RadarrNavigation.navigateToMovies(path: &navigationPath)
}
```

This gives module organization without coordinator overhead.

## Conclusion

**MVVM-C is over-engineering for Thriftwood.** The app is:

- Small to medium size (~60-70 meaningful screens)
- Simple navigation patterns
- Solo/small team development
- Limited deep linking needs

**Recommendation:** Move to **MVVM with single NavigationStack** for:

- 70% less code
- SwiftUI-native patterns
- Faster development
- Easier maintenance
- No nested NavigationStack issues

The coordinator pattern is adding complexity without providing meaningful benefits for an app of this scope.

---

**Decision**: Your call. We can:

1. Continue with MVVM-C (current path)
2. Refactor to simplified MVVM now (2-3 days work)
3. Finish Phase 1 with MVVM-C, refactor in Phase 2 (recommended)
