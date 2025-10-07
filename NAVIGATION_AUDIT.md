<!--
Thriftwood - Frontend for Media Management
Copyright (C) 2025 Matthias Wallner Géhri

This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
International License. To view a copy of this license, visit
http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
-->

# Navigation Architecture Audit

**Date**: October 7, 2025  
**Branch**: feature/phase-1-hierarchical-navigation  
**Auditor**: GitHub Copilot

## Executive Summary

✅ **Overall Assessment**: Good MVVM-C implementation with **one critical architectural issue**

**Critical Issue**: Radarr navigation uses fullScreenCover instead of hierarchical NavigationStack push, breaking the hierarchical navigation pattern.

---

## MVVM-C Pattern Compliance

### ✅ Strengths

1. **Proper Coordinator Usage**

   - All navigation logic is in Coordinators
   - Views are dumb and use closures for actions
   - No direct NavigationLink usage in views
   - Clear separation of concerns

2. **View Layer**

   - All views use closure-based navigation (e.g., `onNavigateToServices: () -> Void`)
   - No direct access to coordinators from views (proper encapsulation)
   - No direct manipulation of navigation state

3. **Coordinator Hierarchy**

   - Clear parent-child relationships
   - Proper lifecycle management (start, childDidFinish)
   - Observable pattern for reactive updates

4. **ViewModel Integration**
   - ViewModels created by coordinators (proper factory pattern)
   - Clean dependency injection via coordinators

---

## Navigation Flow Analysis

### 1. App Startup ✅

```
ContentView
  └─> AppCoordinator.start()
       ├─> [onboarding incomplete] → OnboardingCoordinator
       └─> [onboarding complete] → MainAppNavigationView (AppHomeView)
```

**Status**: ✅ Working correctly

- Proper coordinator initialization
- Correct onboarding vs main app logic
- Fixed: activeCoordinator clearing on onboarding complete

### 2. App Home Navigation ✅

**AppHomeView** (root of NavigationStack)

- **Services Button** → `coordinator.navigateToServices()` → pushes `.services` route
- **Settings Button** → `coordinator.navigateToSettings()` → pushes `.settings` route

**Status**: ✅ MVVM-C compliant

- Closures used for navigation
- Coordinator handles all logic
- Proper NavigationStack usage

### 3. Services Navigation ✅

**ServicesHomeView** (pushed destination)

- **Radarr Button** → `onNavigateToRadarr()` → `showingRadarr = true` (fullScreenCover)

**Status**: ⚠️ Works but architecturally inconsistent (see Critical Issue #1)

### 4. Radarr Navigation ✅

**RadarrHomeView** (root of separate NavigationStack)

- **Movies** → `coordinator.showMoviesList()` → pushes `.moviesList`
- **Add Movie** → `coordinator.showAddMovie()` → pushes `.addMovie`
- **Queue** → `coordinator.showQueue()` → pushes `.queue`
- **History** → `coordinator.showHistory()` → pushes `.history`
- **System Status** → `coordinator.showSystemStatus()` → pushes `.systemStatus`

**Status**: ✅ MVVM-C compliant within its own stack

- Proper coordinator methods
- Hierarchical navigation working
- All buttons use coordinator closures

### 5. Settings Navigation ✅

**SettingsView** (pushed destination with own NavigationStack)

- **Profiles** → `coordinator.navigate(to: .profiles)` → pushes `.profiles`
- **Add Profile** → navigation via ProfileListView
- etc.

**Status**: ✅ MVVM-C compliant

- SettingsCoordinator properly initialized
- Hierarchical navigation working

### 6. Home Button Navigation ✅

All pushed destinations have home buttons that call `coordinator.popToRoot()`

**Status**: ✅ Working correctly

- Proper coordinator method calls
- Consistent across all views

---

## Critical Issues

### 🚨 Issue #1: Radarr Uses fullScreenCover Instead of Push

**Location**: `ContentView.swift` line 119-123

```swift
.fullScreenCover(isPresented: $showingRadarr) {
    if let radarrCoordinator = radarrCoordinator {
        RadarrCoordinatorView(coordinator: radarrCoordinator)
    }
}
```

**Problems**:

1. **Breaks Hierarchical Pattern**: Radarr appears as modal, not pushed view
2. **No Navigation Bar Back Button**: Users can't use standard back gesture/button
3. **Separate Navigation Stack**: Radarr has its own NavigationStack, isolated from app stack
4. **Home Button Doesn't Work in Radarr**: The home button in Radarr views would need to:
   - First pop the Radarr stack to root
   - Then dismiss the fullScreenCover
   - Then pop the app stack to root
5. **Inconsistent with Settings**: Settings uses push navigation, Radarr uses modal

**Why This Happened**:
Phase 1 implementation note in `design.md` and task descriptions explicitly said to use fullScreenCover as a temporary solution. This was marked as "will be updated in Phase 1 Part 2" but never was.

**Correct Implementation**:
Radarr should be pushed to the app's NavigationStack, not presented modally:

```swift
case .services:
    ServicesHomeView(
        onNavigateToRadarr: {
            coordinator.navigateToRadarr()  // New method
        }
    )

// In AppCoordinator:
func navigateToRadarr() {
    navigate(to: .radarr)  // Push to navigation stack
}

// In ContentView.makeView:
case .radarr:
    if let radarrCoordinator = radarrCoordinator {
        RadarrCoordinatorView(coordinator: radarrCoordinator)
    }
```

---

## Architecture Recommendations

### High Priority

1. **✅ Fix Radarr Navigation**

   - Change from fullScreenCover to NavigationStack push
   - Add `.radarr` case to `AppRoute` enum
   - Add `navigateToRadarr()` method to `AppCoordinator`
   - Update `ServicesHomeView` callback to call new coordinator method
   - This makes navigation consistent across all features

2. **Consider Coordinator Lifecycle**
   - Currently RadarrCoordinator is initialized in `.onAppear` of MainAppNavigationView
   - Should it be lazy-loaded only when navigating to Radarr?
   - Or should AppCoordinator manage child coordinators?

### Medium Priority

3. **Document Navigation Pattern**

   - Add comments explaining the hierarchical pattern
   - Document why certain coordinators are separate (e.g., Radarr, Settings)
   - Create navigation flow diagrams

4. **Centralize Coordinator Creation**
   - Move coordinator initialization to AppCoordinator
   - Use factory pattern for child coordinators
   - Better lifecycle management

### Low Priority

5. **Deep Linking Support**
   - Current deep link tests are disabled
   - Need to implement URL-based navigation
   - Should work with hierarchical pattern

---

## MVVM-C Compliance Checklist

- [x] Views use closures, not direct coordinator access
- [x] Coordinators handle all navigation logic
- [x] ViewModels created by coordinators
- [x] No NavigationLink in views (all button-based)
- [x] Proper parent-child coordinator relationships
- [x] Observable pattern for state updates
- [ ] **Consistent navigation pattern** (fullScreenCover breaks this)
- [x] Proper separation of concerns

**Score**: 7/8 (87.5%)

---

## Navigation Map

```
AppHomeView (root)
├─> Services (push) → ServicesHomeView
│   └─> Radarr (fullScreenCover ⚠️) → RadarrCoordinatorView
│       ├─> Movies → MoviesListView
│       │   └─> Movie Detail → MovieDetailView
│       ├─> Add Movie → AddMovieView
│       ├─> Queue → (placeholder)
│       ├─> History → (placeholder)
│       └─> System Status → (placeholder)
│
└─> Settings (push) → SettingsCoordinatorView
    ├─> Profiles → ProfileListView
    │   ├─> Add Profile → AddProfileView
    │   └─> Edit Profile → (placeholder)
    ├─> Appearance → (placeholder)
    └─> Acknowledgements → AcknowledgementsView
```

**Legend**:

- **push**: Proper hierarchical navigation
- **fullScreenCover**: Modal presentation (⚠️ architectural inconsistency)

---

## Testing Recommendations

1. **Test Navigation Flows**

   - Manually test all button interactions
   - Verify back button behavior
   - Verify home button behavior
   - Test deep navigation paths

2. **Update Coordinator Tests**

   - Phase 2 task to rewrite disabled tests
   - Test new hierarchical navigation patterns
   - Verify coordinator lifecycle

3. **Integration Tests**
   - Test entire navigation flows end-to-end
   - Verify state preservation during navigation
   - Test orientation changes, backgrounding

---

## Conclusion

**The navigation architecture is fundamentally sound** with proper MVVM-C implementation. The only significant issue is the Radarr modal presentation which should be fixed to maintain consistency.

**Recommendation**: Fix Issue #1 (Radarr fullScreenCover) before marking Phase 1 complete. This is a 30-minute fix that will significantly improve navigation consistency.
