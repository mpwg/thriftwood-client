q# Navigation Architecture - Pure MVVM (ADR-0012)

**Version**: 3.0  
**Last Updated**: October 7, 2025  
**Status**: Active - Pure MVVM Implementation  
**Related**: [ADR-0012](decisions/0012-single-navigationstack-simple-mvvm.md)

## Executive Summary

Thriftwood uses a **single NavigationStack with pure MVVM architecture** as defined in ADR-0012. This is a dramatic simplification from the previous multi-coordinator MVVM-C approach.

### The Golden Rule

> **AppCoordinator manages ONE NavigationStack for the entire app. All navigation goes through AppCoordinator methods. ViewModels are created directly (no logic coordinators).**

## What Changed (ADR-0012 Refactoring)

### Before: Multi-Coordinator MVVM-C

- Multiple NavigationStacks (AppCoordinator, TabCoordinator, per-feature coordinators)
- Separate route enums (AppRoute, ServicesRoute, SettingsRoute, RadarrRoute)
- Logic coordinators (RadarrLogicCoordinator, SettingsLogicCoordinator)
- Complex coordinator hierarchy

### After: Single NavigationStack Pure MVVM

- ✅ **One** NavigationStack in MainAppNavigationView
- ✅ **One** unified AppRoute enum (19 routes)
- ✅ **One** navigation authority (AppCoordinator)
- ✅ **One** child coordinator (OnboardingCoordinator for first-run only)
- ✅ **No** logic coordinators - ViewModels created directly
- ✅ **~800 lines** of code removed

## Architecture Overview

### Pure MVVM Navigation Flow

```
ContentView
├─> OnboardingCoordinatorView (if onboarding not complete)
│   └─> Own NavigationStack for onboarding flow
│
└─> MainAppNavigationView (if onboarding complete)
    └─> Single NavigationStack(path: $appCoordinator.navigationPath)
        ├─> AppHomeView
        ├─> ServicesHomeView
        ├─> SettingsView
        ├─> ProfileListView
        ├─> RadarrHomeView
        ├─> MoviesListView
        ├─> MovieDetailView
        └─> ... all other views (19 total routes)
```

**Key Components:**

1. **AppCoordinator** - Manages navigation for entire app
2. **AppRoute enum** - All routes in one enum
3. **ViewModels** - Business logic (created directly)
4. **Services** - Data access (injected via DI)
5. **Views** - Display only (navigation via callbacks)

## Core Components

### 1. AppCoordinator - Sole Navigation Authority

**File**: `Thriftwood/Core/Navigation/AppCoordinator.swift`

```swift
@Observable
@MainActor
final class AppCoordinator: CoordinatorProtocol {
    // MARK: - Properties

    /// Single navigation path for entire app (unified AppRoute enum)
    var navigationPath: [AppRoute] = []

    /// Services injected directly (no logic coordinators)
    private let preferencesService: any UserPreferencesServiceProtocol
    private let profileService: any ProfileServiceProtocol
    private let radarrService: any RadarrServiceProtocol
    private let dataService: any DataServiceProtocol

    /// Only child coordinator (for onboarding flow)
    private(set) var activeCoordinator: (any CoordinatorProtocol)?

    // MARK: - Navigation Methods

    /// Navigate to a route
    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }

    /// Go back one screen
    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    /// Return to root (AppHomeView)
    func popToRoot() {
        navigationPath.removeAll()
    }

    // MARK: - View Factory

    /// Creates all views with their ViewModels
    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .onboarding:
            EmptyView()  // Handled via activeCoordinator

        case .services:
            ServicesHomeView(...)

        case .radarrHome:
            RadarrHomeView(...)

        case .radarrMoviesList:
            MoviesListView(...)
                .environment(MoviesListViewModel(radarrService: radarrService))

        case .radarrMovieDetail(let movieId):
            MovieDetailView(...)
                .environment(MovieDetailViewModel(movieId: movieId, radarrService: radarrService))

        // ... other routes (19 total)
        }
    }
}
```

**Key Points:**

- Creates ViewModels directly (no logic coordinators)
- Injects services from DI container
- All navigation methods centralized
- Only child coordinator is OnboardingCoordinator

### 2. AppRoute - Unified Route Enum

**File**: `Thriftwood/Core/Navigation/Route/AppRoute.swift`

```swift
/// All routes in the application
enum AppRoute: Hashable {
    // Onboarding
    case onboarding

    // Services
    case services

    // Radarr (movies)
    case radarrHome
    case radarrMoviesList
    case radarrMovieDetail(movieId: Int)
    case radarrAddMovie
    case radarrQueue
    case radarrHistory
    case radarrSystemStatus
    case radarrSettings

    // Settings
    case settingsMain
    case settingsProfiles
    case settingsAddProfile
    case settingsEditProfile(profileId: String)
    case settingsAppearance
    case settingsNotifications
    case settingsAbout
    case settingsLogs
}
```

**19 total routes** - all navigation in one enum.

### 3. MainAppNavigationView - Single NavigationStack

**File**: `Thriftwood/ContentView.swift`

```swift
struct MainAppNavigationView: View {
    @Bindable var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {  // ✅ ONLY NavigationStack
            AppHomeView(
                onServicesSelected: {
                    coordinator.navigate(to: .services)
                },
                onSettingsSelected: {
                    coordinator.navigate(to: .settingsMain)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.view(for: route)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Home", systemImage: "house") {
                                coordinator.popToRoot()
                            }
                        }
                    }
            }
        }
    }
}
```

**Key Points:**

- Only one NavigationStack for entire app
- Bound to `coordinator.navigationPath`
- All routes handled by `coordinator.view(for:)`
- Home button in toolbar for easy navigation to root

## Layer Separation (Pure MVVM)

| Layer              | Responsibility  | Creates            | Example                            |
| ------------------ | --------------- | ------------------ | ---------------------------------- |
| **AppCoordinator** | Navigation only | Views & ViewModels | `navigate(to: .radarrMoviesList)`  |
| **ViewModels**     | Business logic  | Nothing            | `MoviesListViewModel.loadMovies()` |
| **Services**       | Data access     | Models             | `RadarrService.getMovies()`        |
| **Views**          | Display         | Nothing            | `MoviesListView` renders data      |

**Eliminated:** Logic coordinators (were just ViewModel factories)

## Navigation Patterns

### Pattern 1: Simple Navigation

View calls AppCoordinator method via callback:

```swift
// MoviesListView.swift
struct MoviesListView: View {
    let onMovieSelected: (Int) -> Void  // Callback from AppCoordinator
    let onAddMovie: () -> Void
    @Environment(MoviesListViewModel.self) private var viewModel

    var body: some View {
        List(viewModel.movies) { movie in
            Button {
                onMovieSelected(movie.id)  // ✅ Navigate via callback
            } label: {
                MovieRowView(movie: movie)
            }
        }
        .toolbar {
            Button("Add", systemImage: "plus") {
                onAddMovie()  // ✅ Navigate via callback
            }
        }
    }
}

// AppCoordinator creates view with callbacks
case .radarrMoviesList:
    MoviesListView(
        onMovieSelected: { movieId in
            navigate(to: .radarrMovieDetail(movieId: movieId))
        },
        onAddMovie: {
            navigate(to: .radarrAddMovie)
        }
    )
    .environment(MoviesListViewModel(radarrService: radarrService))
```

### Pattern 2: ViewModel with Navigation Callback

ViewModel triggers navigation via callback:

```swift
// AddMovieViewModel.swift
@Observable
final class AddMovieViewModel {
    func addMovie(_ movie: Movie) async throws {
        try await radarrService.addMovie(movie)
        // ViewModel doesn't navigate - it calls back
        onMovieAdded?(movie.id)
    }

    var onMovieAdded: ((Int) -> Void)?  // Set by AppCoordinator
}

// AppCoordinator creates view
case .radarrAddMovie:
    let viewModel = AddMovieViewModel(radarrService: radarrService)
    viewModel.onMovieAdded = { movieId in
        navigate(to: .radarrMovieDetail(movieId: movieId))
    }
    return AddMovieView(viewModel: viewModel)
```

### Pattern 3: Back Navigation

Views call `navigateBack()` or `popToRoot()`:

```swift
// MovieDetailView.swift
struct MovieDetailView: View {
    let onDelete: () -> Void  // Callback from AppCoordinator

    var body: some View {
        // ... content
        .toolbar {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteMovie()
                    onDelete()  // ✅ Navigate back via callback
                }
            }
        }
    }
}

// AppCoordinator
case .radarrMovieDetail(let movieId):
    MovieDetailView(
        onDelete: {
            navigateBack()  // Returns to previous screen
        }
    )
    .environment(MovieDetailViewModel(movieId: movieId, radarrService: radarrService))
```

## Dependency Injection

### Service Registration

**File**: `Thriftwood/Core/DI/DIContainer.swift`

```swift
private func registerCoordinators() {
    // AppCoordinator gets services directly (no logic coordinators)
    container.register(AppCoordinator.self) { resolver in
        AppCoordinator(
            preferencesService: resolver.resolve(UserPreferencesServiceProtocol.self)!,
            profileService: resolver.resolve(ProfileServiceProtocol.self)!,
            radarrService: resolver.resolve(RadarrServiceProtocol.self)!,
            dataService: resolver.resolve(DataServiceProtocol.self)!
        )
    }
    .inObjectScope(.container)  // Singleton
}
```

### ViewModel Creation

ViewModels are created directly by:

1. **Views** (for simple cases)
2. **AppCoordinator** (when navigation callbacks needed)

```swift
// Option 1: View creates ViewModel
struct MoviesListView: View {
    @State private var viewModel: MoviesListViewModel

    init(...) {
        self.viewModel = MoviesListViewModel(
            radarrService: DIContainer.shared.resolve(RadarrServiceProtocol.self)!
        )
    }
}

// Option 2: AppCoordinator injects via .environment()
case .radarrMoviesList:
    MoviesListView(...)
        .environment(MoviesListViewModel(radarrService: radarrService))
```

## Special Cases

### Onboarding Flow

OnboardingCoordinator is the **only child coordinator**:

```swift
// AppCoordinator.swift
func start() {
    if !preferencesService.onboardingCompleted {
        showOnboarding()  // Creates OnboardingCoordinator
    }
}

private func showOnboarding() {
    let onboardingCoordinator = OnboardingCoordinator()
    onboardingCoordinator.parent = self
    onboardingCoordinator.onComplete = { [weak self] in
        self?.completeOnboarding()
    }
    childCoordinators.append(onboardingCoordinator)
    activeCoordinator = onboardingCoordinator
    onboardingCoordinator.start()
}
```

**Why OnboardingCoordinator exists:**

- Separate navigation stack for multi-step onboarding
- Cleanly transitions to main app when complete
- Self-contained flow with own route enum

### Sheets and Modals

Sheets can use their own local navigation if needed:

```swift
.sheet(isPresented: $showAddProfile) {
    NavigationStack {  // ✅ Local NavigationStack for sheet
        AddProfileView(...)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showAddProfile = false }
                }
            }
    }
}
```

## Testing Navigation

### AppCoordinator Tests

**File**: `ThriftwoodTests/CoordinatorTests.swift`

```swift
@Test("AppCoordinator initializes correctly")
func testAppCoordinatorInitialization() async {
    let coordinator = AppCoordinator(...)

    #expect(coordinator.navigationPath.isEmpty)
    #expect(coordinator.childCoordinators.isEmpty)
    #expect(coordinator.activeCoordinator == nil)
}

@Test("AppCoordinator navigates to route")
func testAppCoordinatorNavigation() async {
    let coordinator = AppCoordinator(...)

    coordinator.navigate(to: .radarrMoviesList)

    #expect(coordinator.navigationPath.count == 1)
    #expect(coordinator.navigationPath.last == .radarrMoviesList)
}
```

## Migration Guide

### From Multi-Coordinator to Single NavigationStack

If you're working on old code, here's how to migrate:

**1. Remove coordinator references in views:**

```swift
// OLD (MVVM-C)
struct MoviesListView: View {
    let coordinator: RadarrCoordinator

    var body: some View {
        List {
            ForEach(movies) { movie in
                Button { coordinator.showMovieDetail(movie.id) }
            }
        }
    }
}

// NEW (Pure MVVM)
struct MoviesListView: View {
    let onMovieSelected: (Int) -> Void  // Callback

    var body: some View {
        List {
            ForEach(movies) { movie in
                Button { onMovieSelected(movie.id) }  // ✅ Use callback
            }
        }
    }
}
```

**2. Update AppCoordinator view factory:**

```swift
// Add new route to AppRoute enum
case .radarrMoviesList

// Add case in AppCoordinator.view(for:)
case .radarrMoviesList:
    MoviesListView(
        onMovieSelected: { movieId in
            navigate(to: .radarrMovieDetail(movieId: movieId))
        }
    )
    .environment(MoviesListViewModel(radarrService: radarrService))
```

**3. Remove logic coordinators:**

Logic coordinators (RadarrLogicCoordinator, etc.) are **obsolete**. Delete them and inject services directly.

## Best Practices

### ✅ DO

- Create ViewModels directly (no coordinator factories)
- Use callbacks for navigation from views
- Keep AppCoordinator focused on navigation only
- Use unified AppRoute enum for all routes
- Inject services via DI container

### ❌ DON'T

- Create logic coordinators (ViewModels handle logic)
- Create child coordinators (except OnboardingCoordinator)
- Create multiple NavigationStacks (only MainAppNavigationView has one)
- Put business logic in AppCoordinator (use ViewModels)
- Pass coordinators to views (use callbacks)

## Troubleshooting

### Navigation not working?

1. Check route is in AppRoute enum
2. Verify AppCoordinator.view(for:) has case for route
3. Ensure navigationDestination is bound to AppRoute
4. Check callback is calling coordinator.navigate()

### ViewModel not updating?

1. Verify ViewModel is @Observable
2. Check view uses @Environment(ViewModel.self)
3. Ensure service is injected via DI

### Build errors after refactoring?

1. Delete obsolete coordinator files
2. Remove logic coordinator references
3. Update tests to use new AppCoordinator signature
4. Clean build folder

## Summary

**Pure MVVM (ADR-0012) achieves:**

- ✅ **Single NavigationStack** - One path for entire app
- ✅ **Unified routing** - AppRoute enum (19 routes)
- ✅ **Simplified architecture** - No logic coordinators
- ✅ **Direct ViewModel creation** - No factory pattern needed
- ✅ **~800 lines removed** - Massive code reduction
- ✅ **Easier testing** - Simple coordinator tests
- ✅ **Better maintainability** - Clear separation of concerns

Navigation is now centralized, simple, and follows pure MVVM principles.
