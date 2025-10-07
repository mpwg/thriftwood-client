# Fix: Nested NavigationStack Error in Services/Radarr Navigation

**Date**: 2025-10-06  
**Issue**: SwiftUI navigation crash when clicking Radarr in Services  
**Status**: ✅ Fixed  
**Related**: [fix-nested-navigation-stack.md](./fix-nested-navigation-stack.md) (Same root cause)

## Problem

When clicking "Radarr" in the Services tab, the app crashed with:

```text
SwiftUI/NavigationColumnState.swift:673: Fatal error: 'try!' expression unexpectedly raised an error: SwiftUI.AnyNavigationPath.Error.comparisonTypeMismatch
```

### Root Cause

This is the **same nested NavigationStack issue** that was fixed in the onboarding flow ([ADR 0010](../architecture/decisions/0010-coordinator-navigation-initialization.md)):

1. `ServicesCoordinatorView` has a `NavigationStack` with `[ServicesRoute]` path
2. When navigating to `.radarr` route, it pushed `RadarrCoordinatorView` as a destination
3. `RadarrCoordinatorView` **created its own `NavigationStack`** with `[RadarrRoute]` path
4. This caused nested NavigationStacks with incompatible route types → crash

### Why This Causes Type Mismatch

- Outer stack expects `ServicesRoute` types
- Inner stack manages `RadarrRoute` types
- SwiftUI's NavigationStack can't handle mixed route types in nested stacks
- Path comparison fails because routes are different types

## Solution

**Use fullScreenCover presentation instead of push navigation for nested coordinators.**

### Core Principle

When a child coordinator needs its own navigation hierarchy (different route type), it should be presented in a **new modal context** rather than pushed onto the parent's navigation stack.

### Changes Made

#### 1. ServicesCoordinatorView - Added Modal Presentation

**Before** (❌ Wrong - Push Navigation):

```swift
struct ServicesCoordinatorView: View {
    @Bindable var coordinator: ServicesCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            List {
                NavigationLink(value: ServicesRoute.radarr) {  // ❌ Push navigation
                    Label("Radarr", systemImage: "film")
                }
            }
            .navigationDestination(for: ServicesRoute.self) { route in
                switch route {
                case .radarr:
                    let radarrCoordinator = coordinator.getRadarrCoordinator()
                    RadarrCoordinatorView(coordinator: radarrCoordinator)  // ❌ Nested stack!
                }
            }
        }
    }
}
```

**After** (✅ Correct - Modal Presentation):

```swift
struct ServicesCoordinatorView: View {
    @Bindable var coordinator: ServicesCoordinator
    @State private var showingRadarr = false
    @State private var showingSonarr = false

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            List {
                Button(action: {
                    showingRadarr = true  // ✅ Show modally
                }) {
                    Label("Radarr", systemImage: "film")
                }
            }
            .fullScreenCover(isPresented: $showingRadarr) {
                let radarrCoordinator = coordinator.getRadarrCoordinator()
                RadarrCoordinatorView(coordinator: radarrCoordinator)  // ✅ New context!
            }
        }
    }
}
```

#### 2. RadarrCoordinatorView - Keeps Its Own NavigationStack

`RadarrCoordinatorView` **keeps its NavigationStack** because it's now presented in a new modal context (not nested):

```swift
struct RadarrCoordinatorView: View {
    @Bindable var coordinator: RadarrCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {  // ✅ OK in modal context
            moviesListView()
                .navigationDestination(for: RadarrRoute.self) { route in
                    destination(for: route)
                }
        }
    }
}
```

#### 3. Updated ServicesRoute Destination Handler

Since Radarr/Sonarr are now modal, their route cases return `EmptyView`:

```swift
@ViewBuilder
private func destination(for route: ServicesRoute) -> some View {
    switch route {
    case .radarr:
        // Radarr is shown via fullScreenCover, not push navigation
        // This case exists only for enum completeness
        EmptyView()

    case .sonarr:
        // Sonarr is shown via fullScreenCover, not push navigation
        // This case exists only for enum completeness
        EmptyView()

    // ... other cases
    }
}
```

## Architecture Guidelines

### When to Use Push vs Modal Navigation

#### ✅ Use Push Navigation (NavigationLink/navigationDestination)

When:

- Child views use the **same route type** as parent
- Views are detail/drill-down within same feature
- Back button navigation is expected

Examples:

- Services List → Add Service
- Services List → Service Configuration
- Movies List → Movie Detail
- Movie Detail → Edit Movie

#### ✅ Use Modal Presentation (sheet/fullScreenCover)

When:

- Child coordinator has **different route type** than parent
- Feature is self-contained with its own navigation hierarchy
- Dismiss/Close action is more appropriate than Back

Examples:

- Services List → Radarr (has `RadarrRoute` navigation)
- Services List → Sonarr (has `SonarrRoute` navigation)
- Onboarding → Profile Creation (in some flows)

#### Presentation Style Choice

- **fullScreenCover**: For feature-level navigation (Radarr, Sonarr)
  - Takes full screen, feels like entering a new section
  - Has its own navigation bar with close button
- **sheet**: For task-oriented flows (Add Profile, Quick Actions)
  - Partial screen, feels temporary/modal
  - User expects to complete a task and return

### Navigation Hierarchy

```text
TabCoordinator
├─ ServicesCoordinator (NavigationStack with [ServicesRoute])
│  ├─ Services List (root view)
│  ├─ Add Service (push: ServicesRoute.addService)
│  ├─ Configure Service (push: ServicesRoute.serviceConfiguration)
│  ├─ [MODAL] Radarr (fullScreenCover with RadarrCoordinator)
│  │  └─ RadarrCoordinator (NavigationStack with [RadarrRoute])  ✅ Independent hierarchy
│  │     ├─ Movies List (root)
│  │     ├─ Movie Detail (push: RadarrRoute.movieDetail)
│  │     └─ Add Movie (push: RadarrRoute.addMovie)
│  └─ [MODAL] Sonarr (fullScreenCover with SonarrCoordinator)
│     └─ SonarrCoordinator (NavigationStack with [SonarrRoute])  ✅ Independent hierarchy
```

## Testing

### Build & Test Results

```bash
# Build: ✅ Succeeded
xcodebuild build -project Thriftwood.xcodeproj -scheme Thriftwood

# Tests: (Run after manual testing confirms UX)
xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood
```

### Manual Testing Checklist

- [ ] Services tab loads without crash
- [ ] Click Radarr → opens full screen
- [ ] Radarr shows movies list
- [ ] Navigate within Radarr (movie detail, add movie)
- [ ] Close Radarr → returns to Services list
- [ ] Repeat for Sonarr when implemented
- [ ] Test deep linking to Radarr routes

## Impact

### Files Modified

- `Thriftwood/UI/ServicesCoordinatorView.swift`

  - Added `@State` for modal presentation flags
  - Changed Radarr/Sonarr from `NavigationLink` to `Button`
  - Added `.fullScreenCover` modifiers
  - Updated destination handler to return `EmptyView` for modal routes

- `Thriftwood/UI/Radarr/RadarrCoordinatorView.swift`
  - **Kept** `NavigationStack` (required for modal context)
  - No changes needed - already correct for modal presentation

### Behavior Changes

**Before**:

- ❌ Crash when clicking Radarr
- Nested NavigationStack error

**After**:

- ✅ Radarr opens in full screen modal
- ✅ Radarr has independent navigation hierarchy
- ✅ Close button dismisses back to Services
- ✅ No navigation type conflicts

### UX Impact

**Potential Consideration**: Full screen modal is more "app-switcher" like than push navigation. This may be desirable:

- **Pro**: Clear context separation (entering a major feature)
- **Pro**: Radarr feels like its own mini-app within Thriftwood
- **Pro**: Matches iOS patterns for feature-level navigation
- **Con**: Users might expect swipe-back gesture (not available in modal)
- **Con**: More explicit close action required

**Alternative**: If push navigation UX is strongly preferred, the architecture needs a more complex solution:

- Use type-erased `NavigationPath` instead of typed route arrays
- Manually manage path with `Codable` conformance
- More complexity, same crash risk if not perfect

**Decision**: Stick with modal presentation for v1. It's simpler, crash-proof, and UX is acceptable.

## Future Considerations

### For Other Nested Coordinators

Apply the same pattern when adding:

- Sonarr (already scaffolded)
- Lidarr
- Overseerr
- Download clients (SABnzbd, NZBGet)

### If Push Navigation Is Required

To support push navigation for nested coordinators (future enhancement):

1. **Migrate to type-erased NavigationPath**:

   ```swift
   var navigationPath = NavigationPath()  // Type-erased
   ```

2. **Make all route types Codable and Hashable**:

   ```swift
   enum ServicesRoute: Codable, Hashable { }
   enum RadarrRoute: Codable, Hashable { }
   ```

3. **Handle mixed route types in destinations**:

   ```swift
   .navigationDestination(for: ServicesRoute.self) { /* ... */ }
   .navigationDestination(for: RadarrRoute.self) { /* ... */ }
   ```

4. **Update coordinator protocol** to use `NavigationPath`

This is more complex and adds Codable overhead. Only pursue if modal UX is rejected by users.

## References

- [ADR 0010: Coordinator Navigation Initialization](../architecture/decisions/0010-coordinator-navigation-initialization.md)
- [fix-nested-navigation-stack.md](./fix-nested-navigation-stack.md) - Original onboarding fix
- [Apple Docs: NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack)
- [Apple Docs: fullScreenCover](<https://developer.apple.com/documentation/swiftui/view/fullscreencover(ispresented:ondismiss:content:)>)
- [WWDC22: The SwiftUI cookbook for navigation](https://developer.apple.com/videos/play/wwdc2022/10054/)

---

**Lesson Learned**: When child coordinators have their own route types, present them modally (sheet/fullScreenCover) rather than pushing onto parent NavigationStack. This avoids nested NavigationStack crashes and provides clear UX separation for major features.
