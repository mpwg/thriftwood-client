# Thriftwood Coding Conventions

This document defines coding standards and conventions for Thriftwood development.

## Table of Contents

- [Swift Language](#swift-language)
- [Naming Conventions](#naming-conventions)
- [File Organization](#file-organization)
- [Swift 6 Concurrency](#swift-6-concurrency)
- [Architecture Patterns](#architecture-patterns)
- [Testing Standards](#testing-standards)
- [Documentation](#documentation)
- [License Headers](#license-headers)
- [Code Quality](#code-quality)

## Swift Language

### Swift Version

- **Swift 6.2+** required
- **Strict Concurrency Checking**: Complete (`-strict-concurrency=complete`)
- Use modern Swift features (async/await, structured concurrency, @Observable)

### Language Features

**DO**:

- Use `async/await` for asynchronous code
- Use `@MainActor` for UI-related code
- Use `@Observable` for SwiftUI state
- Use result builders where appropriate (SwiftUI, tests)
- Use property wrappers (`@State`, `@Bindable`, `@Environment`)
- Prefer `guard let` over force unwrapping
- Use `if let` or `guard let` for optionals

**DON'T**:

- Use force unwrapping (`!`) except in tests or truly safe scenarios
- Use implicitly unwrapped optionals (`var foo: String!`)
- Use callbacks/closures when async/await is available
- Mix async/await with completion handlers

## Naming Conventions

### General Rules

Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

**Types**: `UpperCamelCase`

```swift
struct Profile { }
class ProfileService { }
enum ProfileError { }
protocol ProfileServiceProtocol { }
```

**Functions and Variables**: `lowerCamelCase`

```swift
func loadProfiles() async { }
var profileName: String
let maxRetries = 3
```

**Constants**: `lowerCamelCase` (not SCREAMING_SNAKE_CASE)

```swift
let defaultTimeout = 30.0
static let sharedInstance = MyClass()
```

**Enums**: Case should be `lowerCamelCase`

```swift
enum ThriftwoodError {
    case networkError(URLError)
    case invalidResponse
}
```

### Prefixing

**Theme Types**: Use `MPWG` prefix to avoid SwiftUI conflicts

```swift
struct MPWGTheme { }
enum MPWGThemeMode { }
class MPWGThemeManager { }
```

**Protocol Naming**:

```swift
protocol ProfileServiceProtocol { }  // Service protocols
protocol Coordinator { }             // Pattern protocols
```

### Acronyms

Treat acronyms as words:

```swift
// Good
var urlString: String
class HttpClient { }

// Bad
var uRLString: String
class HTTPClient { }
```

**Exception**: Well-known acronyms in type names can be uppercase:

```swift
struct APIClient { }  // OK
struct URLRequest { }  // OK (follows Apple convention)
```

## File Organization

### File Structure

```swift
//
//  FileName.swift
//  Thriftwood
//
//  [GPL-3.0 License Header - 19 lines]
//

import Foundation
import SwiftUI
// Other imports (alphabetical)

/// Type documentation
@MainActor
struct MyView: View {
    // MARK: - Properties

    // MARK: - Initialization

    // MARK: - Body

    var body: some View {
        // ...
    }

    // MARK: - Private Methods

    // MARK: - Subviews
}

// MARK: - Preview
#Preview {
    MyView()
}
```

### Import Organization

1. System frameworks first
2. Third-party frameworks
3. Internal modules
4. Alphabetical within each group

```swift
import Foundation
import SwiftUI
import SwiftData

import AsyncHTTPClient
import Swinject

@testable import Thriftwood
```

### MARK Comments

Use `// MARK:` to organize code sections:

```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Lifecycle
// MARK: - Public Methods
// MARK: - Private Methods
// MARK: - Protocol Conformance
// MARK: - Subviews
```

### File Naming

- One primary type per file
- File name matches type name: `ProfileService.swift`
- Extensions: `String+Validation.swift`
- Protocols: `ProfileServiceProtocol.swift`
- Tests: `ProfileServiceTests.swift`

## Swift 6 Concurrency

### Actor Isolation

**UI Code**: Always `@MainActor`

```swift
@MainActor
struct MyView: View { }

@MainActor
final class MyViewModel: BaseViewModel { }

@MainActor
final class MyCoordinator: Coordinator { }
```

**Services**: Specify isolation based on usage

```swift
// Accessed from UI - use @MainActor
@MainActor
final class DataService { }

// Actor for internal concurrency
actor ProfileCache { }

// Global actor for specific domain
@globalActor
actor DatabaseActor {
    static let shared = DatabaseActor()
}
```

### Async/Await

**DO**:

```swift
func loadProfiles() async throws -> [Profile] {
    let profiles = try await dataService.fetchProfiles()
    return profiles.sorted { $0.name < $1.name }
}
```

**DON'T**:

```swift
func loadProfiles(completion: @escaping (Result<[Profile], Error>) -> Void) {
    // Avoid callbacks when async/await available
}
```

### Sendable

Mark types as `Sendable` when they cross isolation boundaries:

```swift
struct Profile: Sendable {
    let id: UUID
    let name: String
}

final class ProfileService: @unchecked Sendable {
    // Must use locks/actors for internal state
}
```

### Task Management

```swift
// In Views
.task {
    await viewModel.load()
}

// Cancel properly
.onDisappear {
    viewModel.cleanup()
}
```

## Architecture Patterns

### MVVM-C Structure

See [ADR-0005: Use MVVM-C Pattern](architecture/decisions/0005-use-mvvm-c-pattern.md)

**Model**: SwiftData models or plain structs

```swift
@Model
final class Profile {
    var name: String
    init(name: String) { self.name = name }
}
```

**View**: Pure SwiftUI, no business logic

```swift
@MainActor
struct ProfileListView: View {
    @State private var viewModel: ProfileListViewModel

    var body: some View {
        List(viewModel.profiles) { profile in
            Text(profile.name)
        }
    }
}
```

**ViewModel**: Business logic and state

```swift
@MainActor
@Observable
final class ProfileListViewModel: BaseViewModel {
    var profiles: [Profile] = []

    func loadProfiles() async {
        // Business logic here
    }
}
```

**Coordinator**: Navigation logic

```swift
@MainActor
@Observable
final class ProfileCoordinator: Coordinator {
    var path: [ProfileRoute] = []

    func start() {
        // ⚠️ IMPORTANT: Always initialize with empty path
        // The root view represents the initial state
        // See ADR-0010 for details
        path = []
    }

    func navigate(to route: ProfileRoute) {
        path.append(route)
    }
}
```

#### Coordinator Navigation Pattern

**CRITICAL RULE**: Always initialize `navigationPath` with an empty array in `start()`.

❌ **INCORRECT**:

```swift
func start() {
    navigationPath = [.home]  // This creates an unwanted navigation push
}
```

✅ **CORRECT**:

```swift
func start() {
    navigationPath = []  // Root view represents the initial state
}
```

**Why**: The root view in `NavigationStack` IS the initial state. Initializing the path with a route causes that route to be handled as a destination, creating an extra navigation level that users must back out of.

**See**: [ADR-0010: Coordinator Navigation Initialization Pattern](architecture/decisions/0010-coordinator-navigation-initialization.md) for complete details and examples.

### Dependency Injection

Use Swinject via `DIContainer`:

```swift
// Registration
container.register(ProfileServiceProtocol.self) { resolver in
    ProfileService(dataService: resolver.resolve(DataService.self)!)
}.inObjectScope(.container)

// Resolution
let service = DIContainer.shared.resolve(ProfileServiceProtocol.self)
```

### Protocol-Based Services

```swift
protocol ProfileServiceProtocol {
    func fetchProfiles() async throws -> [Profile]
    func createProfile(name: String) async throws -> Profile
}

final class ProfileService: ProfileServiceProtocol {
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func fetchProfiles() async throws -> [Profile] {
        // Implementation
    }
}
```

## Testing Standards

### Swift Testing Framework

Use Swift Testing (not XCTest):

```swift
import Testing
@testable import Thriftwood

@Suite("Profile Service Tests")
struct ProfileServiceTests {
    @Test("Create profile successfully")
    func createProfile() async throws {
        let service = createTestService()
        let profile = try await service.createProfile(name: "Test")
        #expect(profile.name == "Test")
    }

    @Test("Create profile with empty name throws error")
    func createProfileEmptyName() async throws {
        let service = createTestService()
        await #expect(throws: ThriftwoodError.self) {
            try await service.createProfile(name: "")
        }
    }
}
```

### Test Organization

```swift
@Suite("Feature Name Tests")
struct FeatureTests {
    // MARK: - Setup

    func createTestService() -> ProfileService {
        // Setup code
    }

    // MARK: - Tests

    @Test("Positive test case")
    func testPositive() { }

    @Test("Negative test case")
    func testNegative() { }

    @Test("Edge case")
    func testEdgeCase() { }
}
```

### Mocking

Use protocol-based mocks:

```swift
final class MockProfileService: ProfileServiceProtocol {
    var fetchProfilesCalled = false
    var fetchProfilesResult: Result<[Profile], Error> = .success([])

    func fetchProfiles() async throws -> [Profile] {
        fetchProfilesCalled = true
        return try fetchProfilesResult.get()
    }
}
```

### Test Requirements

- **All new functionality must have tests**
- **Bug fixes must include regression tests**
- **Modified code must have updated tests**
- Aim for >80% coverage of business logic
- Use in-memory storage for data tests

## Documentation

### Code Comments

**DO**:

- Document **why**, not **what**
- Explain non-obvious logic
- Document public APIs
- Use `///` for documentation comments

```swift
/// Creates a new profile with the given name.
///
/// - Parameter name: The unique profile name
/// - Returns: The newly created profile
/// - Throws: `ThriftwoodError.validationError` if name is empty or duplicate
func createProfile(name: String) async throws -> Profile {
    // Validate name before insertion to ensure uniqueness
    // (Database constraint doesn't provide user-friendly errors)
    guard !name.isEmpty else {
        throw ThriftwoodError.validationError("Profile name cannot be empty")
    }
    // ...
}
```

**DON'T**:

- State the obvious
- Leave commented-out code
- Use TODO without ticket reference

```swift
// Bad: Obvious
// Create a profile
let profile = Profile(name: name)

// Bad: Commented code
// let oldCode = something()

// Bad: TODO without context
// TODO: Fix this

// Good: TODO with context
// TODO: [THRIFT-123] Optimize profile lookup for large datasets
```

### Documentation Comments

Use standard format:

```swift
/// Short description (one line).
///
/// Longer description explaining behavior, invariants, and usage.
///
/// - Parameters:
///   - param1: Description
///   - param2: Description
/// - Returns: Description
/// - Throws: Description of errors
func myFunction(param1: String, param2: Int) throws -> Result {
    // ...
}
```

## License Headers

**MANDATORY**: Every Swift file must include GPL-3.0 header:

```swift
//
//  FileName.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
```

**CI will block merges if headers are missing.**

Check with:

```bash
./scripts/check-license-headers.sh --check
```

Add automatically:

```bash
./scripts/check-license-headers.sh --add
```

## Code Quality

### SwiftLint

All code must pass SwiftLint rules. See `.swiftlint.yml` for configuration.

**Key Rules**:

- **Disabled**: `todo`, `line_length` (flexible during dev)
- **Enabled**: All default rules + performance + documentation
- **Custom**: License header enforcement, logger usage

Run before committing:

```bash
swiftlint lint --strict
swiftlint --fix  # Auto-fix issues
```

### Code Smells to Avoid

**Large Functions**: Break down functions >50 lines

```swift
// Bad
func processProfile() {
    // 200 lines of code
}

// Good
func processProfile() {
    validateProfile()
    saveProfile()
    notifyObservers()
}
```

**Deep Nesting**: Use guard statements

```swift
// Bad
if let profile = profile {
    if profile.isValid {
        if profile.name != "" {
            // Do something
        }
    }
}

// Good
guard let profile = profile else { return }
guard profile.isValid else { return }
guard !profile.name.isEmpty else { return }
// Do something
```

**Force Unwrapping**: Use safe unwrapping

```swift
// Bad
let name = profile.name!

// Good
guard let name = profile.name else { return }

// OK in tests
let name = profile.name!  // Safe in controlled test environment
```

## Error Handling

Use typed errors with `ThriftwoodError`:

```swift
enum ThriftwoodError: LocalizedError {
    case networkError(URLError)
    case validationError(String)
    case notFound(String)

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .validationError(let message):
            return message
        case .notFound(let item):
            return "\(item) not found"
        }
    }
}
```

Handle errors gracefully:

```swift
do {
    let profile = try await service.createProfile(name: name)
    // Success path
} catch let error as ThriftwoodError {
    // Handle specific errors
    logger.error("Failed to create profile: \(error)")
    self.error = error
} catch {
    // Handle unexpected errors
    logger.error("Unexpected error: \(error)")
    self.error = ThriftwoodError.unknownError(error)
}
```

## Logging

Use the `Logger` service:

```swift
import OSLog

let logger = Logger.ui  // Or .networking, .storage, .auth, etc.

logger.info("Loading profiles")
logger.warning("Profile name is unusually long: \(name)")
logger.error("Failed to load profiles: \(error)")

// Privacy-aware logging
logger.debug("User logged in: \(userId, privacy: .private)")
logger.info("Profile count: \(count, privacy: .public)")
```

**Categories**:

- `.networking` - HTTP requests/responses
- `.storage` - Database operations
- `.authentication` - Auth flows
- `.ui` - UI events
- `.services` - Service operations
- `.general` - General logging

## Best Practices Summary

### DO

✅ Use async/await for asynchronous code  
✅ Mark UI code with `@MainActor`  
✅ Follow MVVM-C architecture pattern  
✅ Write tests for all new code  
✅ Include GPL-3.0 license headers  
✅ Use protocol-based services  
✅ Document public APIs  
✅ Run SwiftLint before committing  
✅ Use guard for early returns  
✅ Prefer composition over inheritance

### DON'T

❌ Force unwrap optionals  
❌ Mix async/await with callbacks  
❌ Put business logic in views  
❌ Skip writing tests  
❌ Forget license headers  
❌ Use global mutable state  
❌ Leave TODOs without context  
❌ Comment out code (delete it)  
❌ Ignore SwiftLint warnings  
❌ Hardcode strings (use localization)

## References

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Swift Programming Language](https://docs.swift.org/swift-book/)
- [SwiftUI Guidelines](https://developer.apple.com/design/human-interface-guidelines/swiftui)
- [Swift Evolution](https://github.com/apple/swift-evolution)
- [SwiftLint Rules](https://realm.github.io/SwiftLint/rule-directory.html)

## Questions?

For clarification on any convention:

- Check [Architecture Decision Records](architecture/decisions/README.md)
- Review existing code for examples
- Ask in [GitHub Discussions](https://github.com/mpwg/thriftwood-client/discussions)
