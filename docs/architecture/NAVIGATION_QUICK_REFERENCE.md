# Navigation Architecture Quick Reference

**For comprehensive guide, see [NAVIGATION_ARCHITECTURE.md](./NAVIGATION_ARCHITECTURE.md)** | **Architecture: [ADR-0012](decisions/0012-single-navigationstack-simple-mvvm.md)**

Quick reference for implementing navigation in Thriftwood following Pure MVVM architecture.

## Core Principle

**Single NavigationStack managed by AppCoordinator. Views use callbacks for navigation.**

> **🔵 AppCoordinator = ONE NavigationStack for entire app**  
> **🟡 Views = Navigation via callbacks (no direct coordinator access)**  
> **🟢 OnboardingCoordinator = Only child coordinator (separate flow)**

## Architecture Overview

```
AppCoordinator (sole navigation authority)
  └─> Single NavigationStack(path: $appCoordinator.navigationPath)
      ├─> Dashboard Tab
      ├─> Services Tab
      ├─> Settings Tab
      └─> All feature screens (19 AppRoute cases)
```

**Eliminated**: Feature coordinators (RadarrCoordinator, SettingsCoordinator, etc.) - all deleted in ADR-0012

## Checklist for New Views

### ✅ DO

- **Views**: Use callbacks for navigation: `let onItemSelected: (Int) -> Void`
- **ViewModels**: Business logic only, no navigation concerns
- **AppCoordinator**: Add new routes to AppRoute enum and view(for:) switch
- **Navigation**: Call AppCoordinator methods: `navigate(to:)`, `navigateBack()`, `popToRoot()`
- **Sheets/Modals**: Can have their own NavigationStack (new presentation context)
- **Test navigation**: Verify callbacks work in CoordinatorTests

### ❌ DON'T

- **Direct navigation**: Never use NavigationStack in feature views
- **Feature coordinators**: Don't create per-feature coordinators (all deleted)
- **Logic coordinators**: Don't create ViewModel factories (eliminated in ADR-0012)
- **Hard-coded routes**: Don't bypass AppCoordinator navigation methods
- **Tight coupling**: Views shouldn't reference specific routes directly

## Code Templates

### View with Navigation (Pure MVVM)

### View with Navigation (Pure MVVM)

```swift
struct MoviesListView: View {
    @State private var viewModel: MoviesListViewModel
    let onMovieSelected: (Int) -> Void  // ✅ Callback to AppCoordinator

    init(viewModel: MoviesListViewModel, onMovieSelected: @escaping (Int) -> Void) {
        self._viewModel = State(initialValue: viewModel)
        self.onMovieSelected = onMovieSelected
    }

    var body: some View {
        List(viewModel.movies) { movie in
            Button {
                onMovieSelected(movie.id)  // ✅ Navigate via callback
            } label: {
                Text(movie.title)
            }
        }
        .navigationTitle("Movies")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                    // Navigate to add movie screen
                    onMovieSelected(-1)  // Use special ID or separate callback
                }
            }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
}

// Preview
#Preview {
    NavigationStack {
        MoviesListView(
            viewModel: MoviesListViewModel(radarrService: MockRadarrService()),
            onMovieSelected: { _ in }
        )
    }
}
```

### ViewModel (Business Logic Only)

```swift
@MainActor
@Observable
final class MoviesListViewModel: BaseViewModel {
    var movies: [Movie] = []
    var isLoading = false

    private let radarrService: RadarrServiceProtocol

    init(radarrService: RadarrServiceProtocol) {
        self.radarrService = radarrService
        super.init()
    }

    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }

        do {
            movies = try await radarrService.fetchMovies()
        } catch {
            handleError(error)
```

## Common Navigation Patterns

### 1. Navigate Forward

```swift
// AppCoordinator provides navigation method
appCoordinator.navigate(to: .radarrMovieDetail(123))

// View uses callback
onMovieSelected(123)
```

### 2. Navigate Back

```swift
// Option 1: Environment dismiss (preferred for most cases)
@Environment(\.dismiss) private var dismiss
Button("Back") { dismiss() }

// Option 2: AppCoordinator programmatic back
appCoordinator.navigateBack()

// Option 3: Pop to root
appCoordinator.popToRoot()
```

### 3. Sheet/Modal with Navigation

```swift
.sheet(isPresented: $showingModal) {
    NavigationStack {  // ✅ OK: New presentation context
        AddMovieView(onMovieAdded: { id in
            // Handle completion
        })
    }
}
```

### 4. ViewModel Communication (NO Navigation)

ViewModels should **never** navigate. Instead, use callbacks:

```swift
// ❌ WRONG: ViewModel navigating
class MyViewModel {
    func onItemSelected(id: Int) {
        coordinator.navigate(to: .detail(id))  // ❌ NO!
    }
}

// ✅ CORRECT: ViewModel uses callback
class MyViewModel {
    var onItemSelected: ((Int) -> Void)?

    func handleItemSelection(id: Int) {
        onItemSelected?(id)  // ✅ Let AppCoordinator navigate
    }
}
```

## Testing Navigation

### Test AppCoordinator Navigation

```swift
@Test("AppCoordinator navigates to route")
func testNavigation() async {
    let coordinator = AppCoordinator(...)

    coordinator.navigate(to: .radarrMoviesList)

    #expect(coordinator.navigationPath.count == 1)
    #expect(coordinator.navigationPath.last == .radarrMoviesList)
}

@Test("AppCoordinator navigates back")
func testNavigateBack() async {
    let coordinator = AppCoordinator(...)

    coordinator.navigate(to: .radarrMoviesList)
    coordinator.navigate(to: .radarrMovieDetail(123))
    #expect(coordinator.navigationPath.count == 2)

    coordinator.navigateBack()
    #expect(coordinator.navigationPath.count == 1)
    #expect(coordinator.navigationPath.last == .radarrMoviesList)
}
```

### Test View Callbacks

```swift
@Test("View calls navigation callback")
func testViewNavigationCallback() async {
    var selectedId: Int?

    let view = MoviesListView(
        viewModel: MoviesListViewModel(radarrService: MockRadarrService()),
        onMovieSelected: { id in selectedId = id }
    )

    // Simulate button tap
    view.onMovieSelected(123)

    #expect(selectedId == 123)
}
```

## Architecture Decision Records

- **[ADR-0012: Single NavigationStack with Simple MVVM](decisions/0012-single-navigationstack-simple-mvvm.md)** - Current architecture
- **[ADR-0011: Hierarchical Navigation](decisions/0011-hierarchical-navigation-pattern.md)** - Superseded (nested NavigationStacks)
- **[ADR-0010: Coordinator Navigation Initialization](decisions/0010-coordinator-navigation-initialization.md)** - Empty path initialization
- **[ADR-0001: Single NavigationStack Per Coordinator](decisions/0001-single-navigationstack-per-coordinator.md)** - Superseded

## Migration Guide

### From Old MVVM-C Pattern

**1. Remove coordinator references from views:**

```diff
// OLD
struct MoviesListView: View {
-   let coordinator: RadarrCoordinator
+   let onMovieSelected: (Int) -> Void

    Button {
-       coordinator.showMovieDetail(movie.id)
+       onMovieSelected(movie.id)
    }
}
```

**2. Remove logic coordinators:**

Logic coordinators (RadarrLogicCoordinator, etc.) are obsolete. Delete them completely.

**3. Update AppCoordinator to create ViewModels directly:**

```diff
// AppCoordinator.swift
func view(for route: AppRoute) -> some View {
    switch route {
    case .radarrMoviesList:
-       let coordinator = radarrLogicCoordinator  // ❌ Deleted
-       let viewModel = coordinator.makeMoviesListViewModel()
+       let viewModel = MoviesListViewModel(radarrService: radarrService)  // ✅ Direct creation
        return MoviesListView(
            viewModel: viewModel,
+           onMovieSelected: { [weak self] id in
+               self?.navigate(to: .radarrMovieDetail(id))
+           }
        )
    }
}
```

## Key Principles Summary

1. **AppCoordinator is sole navigation authority** - manages single NavigationStack
2. **Views use callbacks** - no direct coordinator references except environment
3. **ViewModels are business logic only** - zero navigation concerns
4. **OnboardingCoordinator is the exception** - only child coordinator (separate flow)
5. **No logic coordinators** - AppCoordinator creates ViewModels directly
6. **Services injected via DI** - Swinject container manages dependencies

## Quick Troubleshooting

**Problem**: View needs to navigate
**Solution**: Add callback parameter and pass from AppCoordinator

**Problem**: ViewModel needs to trigger navigation
**Solution**: ViewModel uses callback, AppCoordinator handles navigation

**Problem**: Creating new feature screen
**Solution**:

1. Add case to AppRoute enum
2. Add case to AppCoordinator.view(for:) switch
3. Create view with callback parameters

**Problem**: Tests failing after navigation changes
**Solution**: Update tests to use callbacks instead of coordinator methods

## See Also

- **[NAVIGATION_ARCHITECTURE.md](./NAVIGATION_ARCHITECTURE.md)** - Comprehensive navigation guide with diagrams
- **[NAVIGATION_TRACING.md](../NAVIGATION_TRACING.md)** - Debug navigation issues
- **[CODING_CONVENTIONS.md](../CODING_CONVENTIONS.md)** - Architecture patterns section
- **[ADR-0012](decisions/0012-single-navigationstack-simple-mvvm.md)** - Architecture decision record
  }

// In the view:
.onChange(of: viewModel.shouldNavigateToDetail) { \_, shouldNavigate in
if shouldNavigate, let id = viewModel.detailId {
coordinator.navigateToDetail(id: id)
viewModel.shouldNavigateToDetail = false
}
}

````

## Testing Navigation

### Test Coordinator Navigation

```swift
@Test("Navigate to detail updates path")
@MainActor
func navigateToDetail() {
    let coordinator = MyFeatureCoordinator()
    coordinator.start()

    #expect(coordinator.navigationPath.count == 1)

    coordinator.navigateToDetail(id: "123")

    #expect(coordinator.navigationPath.count == 2)
    #expect(coordinator.navigationPath.last == .detail(id: "123"))
}

@Test("Pop removes last route")
@MainActor
func popNavigation() {
    let coordinator = MyFeatureCoordinator()
    coordinator.start()
    coordinator.navigateToDetail(id: "123")

    #expect(coordinator.navigationPath.count == 2)

    coordinator.pop()

    #expect(coordinator.navigationPath.count == 1)
}
````

## Troubleshooting

### Error: `comparisonTypeMismatch`

**Cause**: Nested NavigationStacks with different route types

**Solution**: Remove NavigationStack from content view, use navigation modifiers only

### Back Button Not Working

**Cause**: View might be creating its own NavigationStack

**Solution**: Content views should not have NavigationStack in body

### Navigation State Not Updating

**Cause**: NavigationPath not properly bound to coordinator

**Solution**: Use `NavigationStack(path: $coordinator.navigationPath)` with `@Bindable`

### View Not Appearing in Navigation

**Cause**: Missing `navigationDestination(for:)` modifier

**Solution**: Add navigation destination handler in coordinator view

## Resources

- **[NAVIGATION_ARCHITECTURE.md](./NAVIGATION_ARCHITECTURE.md)** - Comprehensive guide with Mermaid diagrams
- [ADR-0001: Single NavigationStack Per Coordinator](/docs/architecture/decisions/0001-single-navigationstack-per-coordinator.md)
- [Architecture Overview](/docs/architecture/README.md)
- [Implementation Fix Documentation](/docs/implementation-summaries/fix-nested-navigation-stack.md)
- [SwiftUI NavigationStack Docs](https://developer.apple.com/documentation/swiftui/navigationstack)

---

**When in doubt**: Look at existing coordinators (`OnboardingCoordinator`, `SettingsCoordinator`) as reference implementations.
