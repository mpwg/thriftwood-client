# ADR-0012 Implementation Progress

**Date**: 2025-10-07  
**Issue**: #214  
**Status**: In Progress (Phase 2)

## Completed Work

### ✅ Phase 1: Unified AppRoute Enum

**File**: `Thriftwood/Core/Navigation/Route/AppRoute.swift`

- Created unified `AppRoute` enum consolidating AppRoute, RadarrRoute, and SettingsRoute
- Organized by module with MARK comments:
  - App Level: `onboarding`, `services`, `settings`
  - Radarr (8 routes): `radarrHome`, `radarrMoviesList`, `radarrMovieDetail`, `radarrAddMovie`, `radarrSettings`, `radarrSystemStatus`, `radarrQueue`, `radarrHistory`
  - Settings (8 routes): `settingsMain`, `settingsProfiles`, `settingsAddProfile`, `settingsEditProfile`, `settingsAppearance`, `settingsNotifications`, `settingsAbout`, `settingsLogs`
- Full `DeepLinkable` protocol implementation with `parse(from:)` and `toURL()`
- Comprehensive documentation with ADR-0012 references

### ✅ Phase 2a-c: Coordinator Refactoring

**Files Renamed**:

1. `RadarrCoordinator.swift` → `RadarrLogicCoordinator.swift`
2. `SettingsCoordinator.swift` → `SettingsLogicCoordinator.swift`

**RadarrLogicCoordinator Changes**:

- Removed `CoordinatorProtocol` conformance
- Removed `childCoordinators`, `parent`, and `navigationPath` properties
- Removed all navigation methods (`showHome`, `showMoviesList`, `showMovieDetail`, etc.)
- **Kept business logic**:
  - `radarrService` and `dataService` dependencies
  - ViewModel factories: `getMoviesListViewModel()`, `getMovieDetailViewModel()`, `getAddMovieViewModel()`
  - Business logic: `handleSettingsSaved()`

**SettingsLogicCoordinator Changes**:

- Removed `CoordinatorProtocol` conformance
- Removed `childCoordinators`, `parent`, and `navigationPath` properties
- Removed all navigation methods (`showProfiles`, `showAddProfile`, `showEditProfile`, etc.)
- Simplified to pure business logic coordinator (currently minimal, ready for future logic)

## In Progress

### ⏳ Phase 2d: Refactor AppCoordinator

**Goal**: Make AppCoordinator the sole navigation authority for unified AppRoute enum

**Required Changes**:

1. Add logic coordinators as dependencies:

   ```swift
   private let radarrLogicCoordinator: RadarrLogicCoordinator
   private let settingsLogicCoordinator: SettingsLogicCoordinator
   ```

2. Change `navigationPath` type from `[AppRoute]` to handle all routes:

   ```swift
   var navigationPath: [AppRoute] = []  // Already correct type!
   ```

3. Update `view(for:)` method to handle all AppRoute cases:

   - Radarr routes: `.radarrHome`, `.radarrMoviesList`, `.radarrMovieDetail`, etc.
   - Settings routes: `.settingsMain`, `.settingsProfiles`, `.settingsEditProfile`, etc.

4. Implement unified navigation methods:

   ```swift
   func navigate(to route: AppRoute)
   func navigateBack()
   func navigateToRoot()  // Already exists as popToRoot()
   ```

5. Remove old specific navigation methods:
   - `navigateToServices()` → use `navigate(to: .services)`
   - `navigateToRadarr()` → use `navigate(to: .radarrHome)`
   - `navigateToSettings()` → use `navigate(to: .settingsMain)`

## Next Steps

### Phase 3: Update ContentView

- Remove nested NavigationStacks from coordinator views
- Update to single NavigationStack at root

### Phase 4: Update Views

- Update all button actions to use `coordinator.navigate(to: .routeName)`
- Remove navigationPath bindings

### Phase 5: Update Tests

- Focus coordinator tests on business logic
- Move navigation tests to AppCoordinator

### Phase 6: Documentation

- Rewrite navigation architecture docs
- Create migration guide

## Build Status

**Not yet attempted** - will build after Phase 2d completion to identify all breaking changes.

## Migration Notes

### Old Pattern (Nested Stacks)

```swift
// AppCoordinator
navigationPath.append(.radarr)  // Navigate to coordinator view

// RadarrCoordinator
navigationPath.append(.moviesList)  // Navigate within Radarr
```

### New Pattern (Single Stack)

```swift
// AppCoordinator (sole navigation authority)
navigationPath.append(.radarrMoviesList)  // Direct route to view
```

### Benefits Realized So Far

1. **Less Code**: Removed ~100 lines of navigation boilerplate from coordinators
2. **Clearer Separation**: Logic coordinators are now pure business logic (no navigation concerns)
3. **Simpler Mental Model**: One route enum, one navigation path

## Files Modified

1. ✅ `Thriftwood/Core/Navigation/Route/AppRoute.swift` - Unified routes
2. ✅ `Thriftwood/Core/Navigation/RadarrLogicCoordinator.swift` - Renamed, navigation removed
3. ✅ `Thriftwood/Core/Navigation/SettingsLogicCoordinator.swift` - Renamed, navigation removed
4. ⏳ `Thriftwood/Core/Navigation/AppCoordinator.swift` - In progress

## Estimated Remaining Time

- Phase 2d: 2-3 hours (AppCoordinator refactoring + initial build fixes)
- Phase 3: 2-3 hours (ContentView + coordinator views)
- Phase 4: 3-4 hours (Update all view navigation calls)
- Phase 5: 3-4 hours (Update tests)
- Phase 6: 1-2 hours (Documentation)
- **Total Remaining**: ~12-16 hours

## Challenges & Solutions

### Challenge: View Model Access

**Problem**: Views need access to ViewModels from RadarrLogicCoordinator  
**Solution**: Keep service properties as `internal` so views can access via coordinator

### Challenge: Navigation Callbacks

**Problem**: How do views trigger navigation without coordinator having navigation methods?  
**Solution**: Pass AppCoordinator to views, they call `appCoordinator.navigate(to: .route)`

### Challenge: Backward Compatibility

**Problem**: Many existing views use old navigation pattern  
**Solution**: Update incrementally, use build errors to find all call sites
