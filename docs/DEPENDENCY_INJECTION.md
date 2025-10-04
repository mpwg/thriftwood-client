# Dependency Injection in Thriftwood

## Overview

Thriftwood uses **Swinject** for dependency injection (DI) to achieve:

- **Testability**: Easy mocking of dependencies in unit tests
- **Flexibility**: Swap implementations without changing consumer code
- **Decoupling**: Components depend on protocols, not concrete implementations
- **Maintainability**: Centralized service registration and configuration

## Architecture

### DIContainer (`Thriftwood/Core/DI/DIContainer.swift`)

The `DIContainer` class is a singleton that wraps Swinject's `Container` and manages all service registration and resolution.

```swift
// Get the shared container
let container = DIContainer.shared

// Resolve a service
let dataService = container.resolve(DataService.self)
```

### Service Categories

Services are organized into four categories:

1. **Infrastructure**: Core platform services (storage, security, logging)
2. **Core Services**: Business logic services (data persistence, validation)
3. **Domain Services**: Feature-specific services (Radarr, Sonarr, etc.)
4. **Coordinators**: Navigation coordinators that need dependencies

## Current Registered Services

### Infrastructure

| Service           | Protocol                  | Scope     | Description                           |
| ----------------- | ------------------------- | --------- | ------------------------------------- |
| `KeychainService` | `KeychainServiceProtocol` | Singleton | Secure credential storage using Valet |
| `ModelContainer`  | N/A                       | Singleton | SwiftData persistence container       |

### Core Services

| Service                  | Protocol                         | Scope     | Description                                      |
| ------------------------ | -------------------------------- | --------- | ------------------------------------------------ |
| `DataService`            | N/A                              | Singleton | High-level data operations (CRUD for all models) |
| `UserPreferencesService` | `UserPreferencesServiceProtocol` | Singleton | User preferences management (SwiftData-backed)   |

### Domain Services

| Service    | Protocol          | Scope | Description                                        |
| ---------- | ----------------- | ----- | -------------------------------------------------- |
| _(Future)_ | `MediaService`    | TBD   | Media management services (Radarr, Sonarr, Lidarr) |
| _(Future)_ | `DownloadService` | TBD   | Download client services (SABnzbd, NZBGet)         |

### Coordinators

| Coordinator | Dependencies | Description                                          |
| ----------- | ------------ | ---------------------------------------------------- |
| _(Future)_  | TBD          | Coordinators that need DataService or other services |

## Usage Patterns

### 1. Resolving Services in Application

```swift
@main
struct ThriftwoodApp: App {
    private let container = DIContainer.shared

    var sharedModelContainer: ModelContainer {
        container.resolve(ModelContainer.self)
    }

    @State private var dataService: DataService?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if dataService == nil {
                        dataService = container.resolve(DataService.self)
                        try? dataService?.bootstrap()
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
```

### 2. Service with Protocol Dependencies

```swift
// Service depends on protocol, not concrete implementation
@MainActor
final class DataService {
    private let keychainService: any KeychainServiceProtocol

    init(modelContainer: ModelContainer,
         keychainService: any KeychainServiceProtocol) {
        self.keychainService = keychainService
    }
}
```

### 3. Protocol-Based Service Registration

```swift
// In DIContainer.registerInfrastructure()
container.register((any KeychainServiceProtocol).self) { _ in
    KeychainService()
}.inObjectScope(.container)
```

### 4. Service with Dependencies

```swift
// In DIContainer.registerCoreServices()
container.register(DataService.self) { resolver in
    let modelContainer = resolver.resolve(ModelContainer.self)!
    guard let keychainService = resolver.resolve((any KeychainServiceProtocol).self) else {
        fatalError("Could not resolve KeychainServiceProtocol")
    }
    return DataService(modelContainer: modelContainer, keychainService: keychainService)
}.inObjectScope(.container)
```

## Testing with DI

### Mock Services

For testing, create mock implementations of protocols:

```swift
// In ThriftwoodTests/Mocks/MockKeychainService.swift
@MainActor
final class MockKeychainService: KeychainServiceProtocol {
    // In-memory storage for testing
    private var apiKeys: [UUID: String] = [:]
    private var credentials: [UUID: (username: String, password: String)] = [:]

    func saveAPIKey(_ apiKey: String, for configurationId: UUID) throws {
        apiKeys[configurationId] = apiKey
    }

    // ... implement other methods
}
```

### Test Container Setup

Create a test-specific DI container:

```swift
@MainActor
func createTestContainer() -> DIContainer {
    let container = DIContainer.shared

    // Register mock services
    container.registerMock((any KeychainServiceProtocol).self) { _ in
        MockKeychainService()
    }

    return container
}
```

### Using Mocks in Tests

```swift
@Test("Test with mock keychain")
func testWithMockKeychain() async throws {
    // Given
    let container = createTestContainer()
    let dataService = container.resolve(DataService.self)

    // When
    try dataService.createServiceConfiguration(/* ... */)

    // Then
    // Test assertions
}
```

## Scope Types

Swinject provides several object scopes:

| Scope        | Description                         | Use Case                                |
| ------------ | ----------------------------------- | --------------------------------------- |
| `.container` | Singleton within container lifetime | Infrastructure services, ModelContainer |
| `.transient` | New instance on each resolution     | Coordinators, ViewModels                |
| `.weak`      | Weakly held singleton               | Rare, for specific memory patterns      |

**Current Usage:**

- All services use `.container` (singleton) scope
- Future coordinators may use `.transient` scope

## Adding New Services

### Step 1: Define Protocol (if needed)

```swift
// In Thriftwood/Services/MyServiceProtocol.swift
protocol MyServiceProtocol {
    func doSomething() async throws
}
```

### Step 2: Implement Service

```swift
// In Thriftwood/Services/MyService.swift
@MainActor
final class MyService: MyServiceProtocol {
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func doSomething() async throws {
        // Implementation
    }
}
```

### Step 3: Register in DIContainer

```swift
// In DIContainer.registerDomainServices()
container.register((any MyServiceProtocol).self) { resolver in
    let dataService = resolver.resolve(DataService.self)!
    return MyService(dataService: dataService)
}.inObjectScope(.container)
```

### Step 4: Create Mock for Testing

```swift
// In ThriftwoodTests/Mocks/MockMyService.swift
@MainActor
final class MockMyService: MyServiceProtocol {
    var doSomethingCalled = false

    func doSomething() async throws {
        doSomethingCalled = true
    }
}
```

### Step 5: Use in Application

```swift
let myService = DIContainer.shared.resolve((any MyServiceProtocol).self)
try await myService.doSomething()
```

## Best Practices

### ✅ DO

1. **Depend on protocols, not implementations**

   ```swift
   private let keychain: any KeychainServiceProtocol  // ✅ Good
   ```

2. **Use constructor injection**

   ```swift
   init(dataService: DataService, keychain: any KeychainServiceProtocol)
   ```

3. **Register services in appropriate category methods**

   - Infrastructure → `registerInfrastructure()`
   - Core → `registerCoreServices()`
   - Domain → `registerDomainServices()`
   - Coordinators → `registerCoordinators()`

4. **Create mock implementations for testing**

   - All protocol-based services should have mocks

5. **Use appropriate scope**
   - Singleton (`.container`) for stateful services
   - Transient (`.transient`) for stateless components

### ❌ DON'T

1. **Don't depend on concrete implementations in services**

   ```swift
   private let keychain: KeychainService  // ❌ Bad
   ```

2. **Don't create services with `= ServiceName()`**

   ```swift
   let dataService = DataService()  // ❌ Bad - use DI
   ```

3. **Don't test external libraries (like Valet)**

   - Mock the protocol instead

4. **Don't mix service creation and business logic**

   - Keep registration in DIContainer

5. **Don't use service locator pattern**

   ```swift
   // ❌ Bad - service locator anti-pattern
   class MyClass {
       func doWork() {
           let service = DIContainer.shared.resolve(DataService.self)
       }
   }

   // ✅ Good - constructor injection
   class MyClass {
       private let dataService: DataService

       init(dataService: DataService) {
           self.dataService = dataService
       }
   }
   ```

## Swift 6 Concurrency Considerations

### MainActor Services

Most services in Thriftwood are `@MainActor` since they interact with SwiftUI and SwiftData:

```swift
@MainActor
final class DataService {
    // Service implementation
}
```

### Protocol with `any` Keyword

Use `any` keyword for existential types in Swift 6:

```swift
// ✅ Correct for Swift 6
private let keychain: any KeychainServiceProtocol

// ❌ Old syntax
private let keychain: KeychainServiceProtocol
```

### Registration with `any`

```swift
// ✅ Correct registration
container.register((any KeychainServiceProtocol).self) { _ in
    KeychainService()
}
```

## Migration Plan

### Milestone 1 (Foundation) - ✅ Complete

- [x] Setup Swinject package
- [x] Create DIContainer
- [x] Register ModelContainer
- [x] Register KeychainService with protocol
- [x] Register DataService
- [x] Create MockKeychainService

### Milestone 2 (Services 1) - Upcoming

- [ ] Add MediaService protocol and implementations (Radarr, Sonarr)
- [ ] Register media services in DIContainer
- [ ] Create mock media services for testing

### Milestone 3 (Services 2) - Future

- [ ] Add DownloadService implementations (SABnzbd, NZBGet)
- [ ] Register download services in DIContainer
- [ ] Create mock download services for testing

### Milestone 4+ - Future

- [ ] Register coordinators that need dependencies
- [ ] Add ViewModels with service dependencies
- [ ] Complete DI integration across entire app

## Troubleshooting

### "Could not resolve service" Error

**Problem:** Service cannot be resolved from container.

**Solutions:**

1. Verify service is registered in `DIContainer.registerServices()`
2. Check service is registered before resolution
3. Verify protocol type matches registration

### Circular Dependencies

**Problem:** Service A depends on Service B, which depends on Service A.

**Solutions:**

1. Redesign dependencies to break the cycle
2. Use protocols to create abstraction layer
3. Consider using property injection instead of constructor injection

### Test Failures with Real Services

**Problem:** Tests failing because they use real Keychain/Database.

**Solutions:**

1. Create mock implementations
2. Use `DIContainer.registerMock()` in tests
3. Inject dependencies via constructor

## References

- [Swinject GitHub](https://github.com/Swinject/Swinject)
- [Swinject Documentation](https://github.com/Swinject/Swinject/tree/master/Documentation)
- [Object Scopes](https://github.com/Swinject/Swinject/blob/master/Documentation/ObjectScopes.md)
- [Circular Dependencies](https://github.com/Swinject/Swinject/blob/master/Documentation/CircularDependencies.md)
