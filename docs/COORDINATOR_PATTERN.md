# Coordinator Pattern in Thriftwood

## Overview

This document describes the coordinator pattern implementation in Thriftwood, adapted from the Hacking with Swift coordinator pattern tutorials for SwiftUI and Swift 6:

## Introduction: Why Use the Coordinator Pattern?

The coordinator pattern is a structural design pattern that removes navigation logic from view controllers (or SwiftUI views) and places it in dedicated coordinator objects. This decouples navigation from UI, making code more modular, testable, and reusable.

**Key motivations:**

- Avoids tight coupling between screens/views
- Makes navigation logic reusable and testable
- Allows for flexible app flows (e.g., A/B testing, iPad vs iPhone, accessibility)
- Enables child/subcoordinators for complex flows
- Promotes view controller/view isolation: each screen is responsible only for itself

**Classic UIKit Problem:**

```swift
if let vc = storyboard?.instantiateViewController(withIdentifier: "SomeVC") {
    navigationController?.pushViewController(vc, animated: true)
}
```

This tightly couples screens and duplicates navigation/configuration logic.

**Coordinator Solution:**
Views/controllers ask their coordinator to perform navigation. The coordinator decides what to show and how.

**References:**

- [How to use the coordinator pattern in iOS apps](https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps)
- [Advanced coordinator pattern tutorial](https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios)

## What is the Coordinator Pattern?

The coordinator pattern is a structural design pattern that removes navigation logic from view controllers/views and places it in dedicated coordinator objects. This solves the problem of tight coupling between view controllers where one view controller must know about, create, configure, and present another.

### The Problem (from Basic Tutorial)

Traditional iOS navigation creates tight coupling:

```swift
if let vc = storyboard?.instantiateViewController(withIdentifier: "SomeVC") {
    navigationController?.pushViewController(vc, animated: true)
}
```

**Issues**:

- Hard-coded links between view controllers
- Duplicate configuration code when showing same VC from multiple places
- Child view controller reaching up to parent's navigation controller
- Difficult to change flow for iPad, A/B testing, or accessibility needs

### The Solution

The coordinator pattern provides several benefits:

1. **Separation of Concerns**: Views focus on presentation, coordinators handle navigation
2. **Reusability**: Views become more reusable as they don't know about their context
3. **Isolation**: View controllers have no idea what comes before or after them
4. **Testability**: Navigation logic can be tested independently
5. **Flexibility**: Easy to change app flow without modifying view code (e.g., iPhone vs iPad)
6. **Deep Linking**: Centralized navigation makes deep linking easier to implement
7. **No Duplication**: Any view can trigger flows (like authentication) without repeating code

## Key Concepts from Hacking with Swift Articles

### Basic Coordinator Pattern

The fundamental coordinator pattern consists of:

1. **Coordinator Protocol**: Defines what all coordinators must do

```swift
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
```

2. **Main Coordinator**: Controls app flow

```swift
class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func buySubscription() {
        let vc = BuyViewController.instantiate()
        vc.coordinator = self
}
```

3. **View Controllers**: Communicate only with coordinators

```swift
class ViewController: UIViewController {
    weak var coordinator: MainCoordinator?

    @IBAction func buyTapped(_ sender: Any) {
        coordinator?.buySubscription()
    }
}
```

**Key Insight**: View controllers don't know about each other. They only talk to their coordinator. The coordinator decides what happens next.

### Advanced Concepts

### 1. Child Coordinators

**Problem**: In larger apps, a single coordinator becomes too complex.

**Solution**: Split functionality into child coordinators that report to a parent:

- **Parent Coordinator**: Manages overall app flow and child coordinator lifecycle
- **Child Coordinator**: Handles a specific feature or flow (e.g., authentication, purchase flow)

**UIKit Pattern** (from article):

```swift
// Parent creates and starts child
let child = BuyCoordinator(navigationController: navigationController)
childCoordinators.append(child)
child.parentCoordinator = self
child.start()

// Child notifies parent when finished
func didFinishBuying() {
    parentCoordinator?.childDidFinish(self)
}

// Parent removes child
func childDidFinish(_ child: Coordinator?) {
    for (index, coordinator) in childCoordinators.enumerated() {
        if coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
```

**SwiftUI Adaptation**: Use NavigationStack's path binding to manage navigation state instead of UINavigationController.

### 2. Navigating Backwards

**Problem**: Back button triggers aren't controlled by coordinators.

**UIKit Solution** (from article): Use `UINavigationControllerDelegate` to detect when view controllers are popped:

````swift
class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                            didShow viewController: UIViewController,
                            animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?
            .viewController(forKey: .from) else { return }

        if !navigationController.viewControllers.contains(fromViewController) {
            // View controller was popped - clean up coordinator
            if let buyVC = fromViewController as? BuyViewController {
                childDidFinish(buyVC.coordinator)
            }
        }
    }
}

### 3. Passing Data Between Views

**Key Principle**: Views don't know about each other; they pass data to coordinators.

**Pattern** (from article):
```swift
// View calls coordinator with data
coordinator?.buySubscription(to: product.selectedSegmentIndex)

// Coordinator receives data and decides what to do
func buySubscription(to productType: Int) {
    let vc = BuyViewController.instantiate()
    vc.selectedProduct = productType
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
}
````

### 4. Tab Bar Controllers

**Pattern** (from article):

- Each tab has its own coordinator
- Tab bar controller creates and manages tab coordinators
- Each coordinator manages its navigation stack independently

```swift
class MainTabBarController: UITabBarController {
    let mainCoordinator = MainCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        mainCoordinator.start()
        viewControllers = [mainCoordinator.navigationController]
    }
}
```

**SwiftUI Adaptation**: Use TabView with coordinator for each tab.

### 5. Avoiding Segues

**Recommendation** (from article): Don't use segues with coordinators.

**Reason**: Segues create fixed application flows and require typecasting. Instead:

- Design UIs in storyboards/SwiftUI
- Handle navigation programmatically via coordinators

### 6. Protocols vs. Closures

**Protocols** (from article): Better for larger apps with multiple actions

```swift
protocol Buying: AnyObject {
    func buySubscription()
}

protocol AccountCreating: AnyObject {
    func createAccount()
}

// View controller uses protocol composition
weak var coordinator: (Buying & AccountCreating)?
```

**Closures**: Better for simple cases with 1-2 actions

```swift
// View controller
var buyAction: (() -> Void)?
var createAccountAction: (() -> Void)?

// Coordinator sets closures
vc.buyAction = { [weak self] in
    self?.buySubscription()
}
```

## Thriftwood Implementation

### SwiftUI Adaptations

Our implementation adapts the UIKit coordinator pattern for SwiftUI:

1. **NavigationStack**: Instead of `UINavigationController`, we use `NavigationStack` with path binding
2. **Observable Pattern**: Coordinators are `@Observable` to work with SwiftUI's reactivity
3. **Type-Safe Routes**: Use enum-based navigation paths instead of string identifiers
4. **Deep Linking**: Built-in URL handling with coordinator routing

### Architecture

```
AppCoordinator (Root)
├── TabCoordinator
│   ├── DashboardCoordinator
│   ├── ServicesCoordinator
│   └── SettingsCoordinator
└── OnboardingCoordinator (first launch)
```

### Core Protocol

```swift
protocol Coordinator: AnyObject {
    var navigationPath: [Route] { get set }
    var childCoordinators: [Coordinator] { get set }
    var parent: Coordinator? { get set }

    func start()
    func navigate(to route: Route)
    func pop()
    func popToRoot()
    func childDidFinish(_ child: Coordinator)
}
```

### Route System

Each coordinator defines its routes as an enum:

```swift
enum DashboardRoute: Hashable {
    case home
    case serviceDetail(serviceId: String)
    case mediaDetail(mediaId: String)
}
```

### Benefits Over UIKit Version

1. **Type Safety**: Enum routes prevent typos and invalid states
2. **State Management**: SwiftUI's reactive model simplifies coordinator state
3. **Less Boilerplate**: No need for storyboard instantiation or delegate protocols
4. **Testability**: Observable coordinators are easier to test with Swift Testing

## Usage Examples

### Creating a Child Coordinator

```swift
func showProfile(_ profile: Profile) {
    let profileCoordinator = ProfileCoordinator(profile: profile)
    profileCoordinator.parent = self
    childCoordinators.append(profileCoordinator)
    profileCoordinator.start()
}

- No view/view controller knows what comes next or how to configure it
- Any screen can trigger flows (e.g., purchase, authentication) without knowing how they're implemented
- Centralized code for device/layout variations, A/B testing, and deep linking
- True isolation: each screen is responsible only for itself

**Further Reading:**
- [Soroush Khanlou: The Coordinator](http://khanlou.com/2015/01/the-coordinator/)
- [Coordinators Redux](http://khanlou.com/2015/10/coordinators-redux/)
- [Back Buttons and Coordinators](http://khanlou.com/2017/05/back-buttons-and-coordinators/)
```

### Removing a Child Coordinator

```swift
func childDidFinish(_ child: Coordinator) {
    childCoordinators.removeAll { $0 === child }
}
```

### Deep Linking

```swift
func handle(url: URL) {
    guard let route = Route.parse(from: url) else { return }
    navigate(to: route)
}
```

## Testing Strategy

1. **Unit Tests**: Test coordinator navigation logic
2. **Mock Coordinators**: Use protocols to inject test coordinators
3. **Route Validation**: Test route enum parsing and navigation
4. **Child Lifecycle**: Verify child coordinators are properly added/removed

## References

- [Hacking with Swift: Advanced Coordinator Pattern](https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios)
- [Soroush Khanlou: Coordinators](http://khanlou.com/tag/advanced-coordinators/)
- Original coordinator pattern developer

## Migration Notes

When migrating from LunaSea (Flutter with GoRouter):

1. **Route Paths**: Map GoRouter routes to coordinator enum cases
2. **Parameters**: Pass via associated values in route enums
3. **Guards**: Implement authentication checks in coordinator start methods
4. **Transitions**: Use SwiftUI transitions instead of Flutter page routes
