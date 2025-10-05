# Single NavigationStack Per Coordinator

- Status: accepted
- Deciders: Matthias Wallner Géhri
- Date: 2025-10-05

Technical Story: Fix navigation crash during onboarding flow caused by nested NavigationStacks

## Context and Problem Statement

During implementation of the onboarding flow, the app crashed with `SwiftUI.AnyNavigationPath.Error.comparisonTypeMismatch` when navigating from the welcome screen to the profile creation screen. The error occurred because multiple NavigationStacks were being created in the same navigation hierarchy, causing type conflicts in the navigation path.

How should we structure navigation in a SwiftUI coordinator-based architecture to ensure proper navigation stack management, working back buttons, and predictable navigation behavior?

## Decision Drivers

- **User Experience**: Back button navigation must work correctly and predictably
- **Type Safety**: Navigation paths must maintain type consistency across the hierarchy
- **Maintainability**: Navigation structure should be clear and easy to understand for future development
- **SwiftUI Best Practices**: Follow Apple's recommended patterns for NavigationStack usage
- **Coordinator Pattern**: Maintain separation of concerns with coordinator-based navigation
- **Code Reusability**: Views should be reusable in different navigation contexts (coordinator navigation, sheets, popovers)

## Considered Options

- **Option 1**: Single NavigationStack per coordinator with content-only child views
- **Option 2**: Nested NavigationStacks with separate navigation paths per feature
- **Option 3**: Single app-wide NavigationStack with unified route enum
- **Option 4**: UIKit-style navigation with programmatic push/pop

## Decision Outcome

Chosen option: **Option 1 - Single NavigationStack per coordinator with content-only child views**

This option provides the best balance of type safety, maintainability, and alignment with SwiftUI's navigation model while preserving the coordinator pattern's benefits.

### Consequences

- **Good**: Back button navigation works correctly out of the box
- **Good**: Type safety is maintained within each coordinator's navigation hierarchy
- **Good**: Views are reusable in different contexts (sheets, popovers, navigation destinations)
- **Good**: Clear separation between navigation structure (coordinator) and content (views)
- **Good**: Follows SwiftUI best practices and patterns
- **Bad**: Requires discipline to avoid creating nested NavigationStacks in child views
- **Bad**: Each coordinator manages its own navigation path independently

### Confirmation

The decision is confirmed by:

1. **Build Success**: All compilation errors resolved
2. **Test Suite**: All existing tests pass without modification
3. **Runtime Behavior**: Navigation works correctly in all tested scenarios:
   - Onboarding flow: Welcome → Profile Creation → Success
   - Settings navigation: Main → Profile List → Add Profile
   - Sheet presentation: Profile List sheet → Add Profile
4. **Back Navigation**: Standard SwiftUI back button works in all contexts

## Pros and Cons of the Options

### Option 1: Single NavigationStack per coordinator with content-only child views

- **Good**: Type-safe navigation within each coordinator's scope
- **Good**: Views are pure content and can be reused in multiple contexts
- **Good**: Back button navigation works automatically
- **Good**: Aligns with SwiftUI's NavigationStack design
- **Good**: Clear ownership of navigation state (coordinator owns the stack)
- **Neutral**: Each coordinator manages its own navigation independently
- **Bad**: Requires developer awareness to not create nested stacks

### Option 2: Nested NavigationStacks with separate navigation paths per feature

- **Good**: Each feature has complete navigation autonomy
- **Bad**: Causes type mismatch errors in SwiftUI (as experienced)
- **Bad**: Back button behavior becomes unpredictable
- **Bad**: Performance overhead from multiple navigation stacks
- **Bad**: Violates SwiftUI's navigation model
- **Bad**: Difficult to debug navigation issues

### Option 3: Single app-wide NavigationStack with unified route enum

- **Good**: Single source of truth for all navigation
- **Good**: Simple mental model
- **Bad**: Massive route enum with all possible destinations
- **Bad**: Breaks separation of concerns
- **Bad**: Feature modules become tightly coupled
- **Bad**: Difficult to maintain as app grows
- **Bad**: Hard to test individual features in isolation

### Option 4: UIKit-style navigation with programmatic push/pop

- **Good**: Maximum control over navigation behavior
- **Good**: Familiar to iOS developers with UIKit experience
- **Bad**: Goes against SwiftUI's declarative nature
- **Bad**: Requires significant boilerplate code
- **Bad**: Loses SwiftUI's built-in navigation features
- **Bad**: More difficult to maintain and test
- **Bad**: No deep linking support without custom implementation

## More Information

### Implementation Pattern

#### Coordinator View Structure

Each coordinator view creates a **single** NavigationStack bound to its coordinator's navigation path:

```swift
struct OnboardingCoordinatorView: View {
    @Bindable var coordinator: OnboardingCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            OnboardingView(coordinator: coordinator)
                .navigationDestination(for: OnboardingRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: OnboardingRoute) -> some View {
        switch route {
        case .welcome:
            OnboardingView(coordinator: coordinator)
        case .createProfile:
            AddProfileView(coordinator: settingsCoordinator)
        case .addFirstService:
            AddFirstServiceView(coordinator: coordinator)
        }
    }
}
```

#### Content View Structure

Views shown as navigation destinations are **content-only** and use navigation modifiers:

```swift
struct AddProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var coordinator: SettingsCoordinator
    @State private var viewModel: AddProfileViewModel

    var body: some View {
        Form {
            // Content sections
        }
        .navigationTitle("New Profile")        // ✅ Applied to parent stack
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {                             // ✅ Works with parent stack
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Create") { /* ... */ }
            }
        }
    }
}
```

#### Preview Structure

Previews wrap content views in NavigationStack since they need their own context:

```swift
#Preview("Add Profile") {
    let coordinator = SettingsCoordinator()
    return NavigationStack {  // ✅ Previews create their own stack
        AddProfileView(coordinator: coordinator)
    }
}
```

### Navigation Hierarchy

```text
App Root (ContentView)
└─ Coordinator Selection
   ├─ OnboardingCoordinatorView
   │  └─ NavigationStack(path: $coordinator.navigationPath)  // OnboardingRoute
   │     ├─ .welcome → OnboardingView (content)
   │     ├─ .createProfile → AddProfileView (content)
   │     └─ .addFirstService → AddFirstServiceView (content)
   │
   └─ MainTabView
      └─ TabCoordinator
         ├─ DashboardCoordinatorView
         │  └─ NavigationStack(path: $coordinator.navigationPath)  // DashboardRoute
         │
         ├─ ServicesCoordinatorView
         │  └─ NavigationStack(path: $coordinator.navigationPath)  // ServicesRoute
         │
         └─ SettingsCoordinatorView
            └─ NavigationStack(path: $coordinator.navigationPath)  // SettingsRoute
               ├─ .main → SettingsView (content)
               ├─ .profiles → ProfileListView (content)
               │  └─ sheet → AddProfileView in new presentation context
               ├─ .addProfile → AddProfileView (content)
               └─ .appearance → AppearanceView (content)
```

### Rules and Guidelines

1. **One NavigationStack per coordinator view**

   - Place NavigationStack in the coordinator view's body
   - Bind to coordinator's navigationPath property
   - Never create NavigationStack in views shown via navigationDestination

2. **Content views use navigation modifiers**

   - Apply `.navigationTitle()`, `.toolbar()`, etc. directly to view content
   - These modifiers work on the parent NavigationStack
   - Views remain reusable in different contexts

3. **Sheets/Popovers can have independent stacks**

   - Modal presentations create new presentation contexts
   - Can contain their own NavigationStack if needed for modal flows
   - Example: Settings sheet might have navigation within the sheet

4. **Test back navigation**
   - Always verify back button works after adding new navigation destinations
   - Manual testing checklist should include navigation flows
   - UI tests should verify navigation state

### Related Decisions

- Migration from Flutter to Swift (see `/docs/migration/design.md`)
- Coordinator pattern adoption (see `/docs/architecture/decisions/0002-coordinator-pattern.md` - to be created)
- MVVM architecture (see `/docs/migration/design.md`)

### References

- [SwiftUI NavigationStack Documentation](https://developer.apple.com/documentation/swiftui/navigationstack)
- [Hacking with Swift: Coordinator Pattern](https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios)
- [WWDC 2022: The SwiftUI cookbook for navigation](https://developer.apple.com/videos/play/wwdc2022/10054/)
- [Swift Forums: NavigationStack Best Practices](https://forums.swift.org/t/navigationstack-best-practices)
- Implementation fix: `/docs/implementation-summaries/fix-nested-navigation-stack.md`
