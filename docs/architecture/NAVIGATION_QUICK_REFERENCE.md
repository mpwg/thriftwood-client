# Navigation Architecture Quick Reference

**For comprehensive guide with diagrams, see [NAVIGATION_ARCHITECTURE.md](./NAVIGATION_ARCHITECTURE.md)**

Quick reference for implementing navigation in Thriftwood following our architectural decisions.

## Core Rule

**One NavigationStack per coordinator, content-only child views.**

> **🔵 Coordinator Views = NavigationStack**  
> **🟡 Content Views = No NavigationStack**

## Checklist for New Views

### ✅ DO

- **Content views**: Don't create NavigationStack in the view body
- **Navigation modifiers**: Apply `.navigationTitle()`, `.toolbar()` directly to content
- **Coordinator views**: Create one NavigationStack bound to coordinator's path
- **Previews**: Wrap content views in NavigationStack
- **Sheets**: Can have their own NavigationStack (new presentation context)
- **Test back button**: Verify navigation works after changes

### ❌ DON'T

- **Nested stacks**: Never create NavigationStack inside navigationDestination views
- **Direct navigation**: Don't call `navigationPath.append()` from views
- **Hard-coded routes**: Use coordinator methods instead
- **Tight coupling**: Views shouldn't know about other coordinators' routes

## Code Templates

### Coordinator View

```swift
struct MyFeatureCoordinatorView: View {
    @Bindable var coordinator: MyFeatureCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            MyFeatureHomeView(coordinator: coordinator)
                .navigationDestination(for: MyFeatureRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: MyFeatureRoute) -> some View {
        switch route {
        case .home:
            MyFeatureHomeView(coordinator: coordinator)
        case .detail(let id):
            MyFeatureDetailView(id: id, coordinator: coordinator)
        case .edit(let item):
            MyFeatureEditView(item: item, coordinator: coordinator)
        }
    }
}
```

### Content View (with navigation)

```swift
struct MyContentView: View {
    @Environment(\.dismiss) private var dismiss
    let coordinator: MyFeatureCoordinator
    @State private var viewModel: MyContentViewModel

    init(coordinator: MyFeatureCoordinator) {
        self.coordinator = coordinator
        // Initialize ViewModel
        self.viewModel = MyContentViewModel(
            service: DIContainer.shared.resolve((any MyServiceProtocol).self)
        )
    }

    var body: some View {
        ScrollView {
            // Content here
        }
        .navigationTitle("My Screen")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Action") {
                    coordinator.navigateToDetail()
                }
            }
        }
    }
}

// Preview
#Preview {
    let coordinator = MyFeatureCoordinator()
    return NavigationStack {
        MyContentView(coordinator: coordinator)
    }
}
```

### Content View (modal/sheet)

```swift
struct MyModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: MyModalViewModel

    var body: some View {
        NavigationStack {  // ✅ OK in modal context
            Form {
                // Content
            }
            .navigationTitle("Modal Screen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task { await saveAndDismiss() }
                    }
                }
            }
        }
    }
}
```

### Coordinator

```swift
@Observable
@MainActor
final class MyFeatureCoordinator: CoordinatorProtocol {
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [MyFeatureRoute] = []

    init() {
        AppLogger.navigation.info("MyFeatureCoordinator initialized")
    }

    func start() {
        AppLogger.navigation.info("MyFeatureCoordinator starting")
        navigationPath = [.home]
    }

    // Navigation methods
    func navigateToDetail(id: String) {
        AppLogger.navigation.info("Navigating to detail: \(id)")
        navigate(to: .detail(id: id))
    }

    func navigateToEdit(item: MyItem) {
        AppLogger.navigation.info("Navigating to edit")
        navigate(to: .edit(item: item))
    }
}

// Route enum
enum MyFeatureRoute: Hashable, Sendable {
    case home
    case detail(id: String)
    case edit(item: MyItem)
}
```

## Common Patterns

### Navigation from View

```swift
// ✅ Correct: Use coordinator method
Button("Go to Detail") {
    coordinator.navigateToDetail(id: item.id)
}

// ❌ Wrong: Direct path manipulation
Button("Go to Detail") {
    coordinator.navigationPath.append(.detail(id: item.id))
}
```

### Back Navigation

```swift
// ✅ Correct: Use environment dismiss or coordinator
@Environment(\.dismiss) private var dismiss

Button("Back") {
    dismiss()
}

// OR use coordinator for programmatic back
Button("Cancel") {
    coordinator.pop()
}
```

### Sheet with Navigation

```swift
.sheet(isPresented: $showingModal) {
    NavigationStack {  // ✅ OK: New presentation context
        MyModalView()
    }
}
```

### Navigation from ViewModel

```swift
// ViewModels should not navigate directly
// Instead, use callbacks or published state

@Observable
class MyViewModel {
    var shouldNavigateToDetail: Bool = false
    var detailId: String?

    func handleItemSelection(id: String) {
        self.detailId = id
        self.shouldNavigateToDetail = true
    }
}

// In the view:
.onChange(of: viewModel.shouldNavigateToDetail) { _, shouldNavigate in
    if shouldNavigate, let id = viewModel.detailId {
        coordinator.navigateToDetail(id: id)
        viewModel.shouldNavigateToDetail = false
    }
}
```

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
```

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
