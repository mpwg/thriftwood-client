# Model Access and Dependency Injection - Architecture Guide

## Overview

This document explains how SwiftData models are accessed in Thriftwood and confirms that the current architecture follows dependency injection best practices.

## Architecture Pattern: Repository Pattern with DI

### ✅ Current Implementation (CORRECT)

```
┌─────────────────────────────────────────────────┐
│                  SwiftUI Views                  │
│                  ViewModels                     │
└────────────────────┬────────────────────────────┘
                     │ Inject via DI
                     ▼
┌─────────────────────────────────────────────────┐
│              Service Layer (DI)                 │
│  • UserPreferencesService (Protocol)            │
│  • DataService (Concrete)                       │
│  • KeychainService (Protocol)                   │
└────────────────────┬────────────────────────────┘
                     │ Manages
                     ▼
┌─────────────────────────────────────────────────┐
│           SwiftData Models (Entities)           │
│  • Profile                                      │
│  • AppSettings                                  │
│  • ServiceConfiguration                         │
│  • Indexer                                      │
│  • ExternalModule                               │
└─────────────────────────────────────────────────┘
```

## Key Principles

### 1. Models Are Data Entities, Not Services

**Models** (`Profile`, `AppSettings`, etc.) are **data structures**, not services:

- ✅ They represent data in the database
- ✅ They have no business logic
- ✅ They are managed by `DataService`
- ✅ They are created/fetched through `DataService` methods

### 2. DataService Is The Access Layer (Injectable)

**DataService** is the service that provides access to models:

- ✅ Registered in DI container as singleton
- ✅ Injectable via protocol or concrete type
- ✅ All CRUD operations go through DataService
- ✅ Manages SwiftData ModelContext

### 3. Higher-Level Services Use DataService

**UserPreferencesService** is a higher-level service:

- ✅ Injected with `DataService` via DI
- ✅ Provides domain-specific operations
- ✅ Abstracts DataService complexity
- ✅ Observable for SwiftUI integration

## DI Container Registration

```swift
// In DIContainer.swift

// Core Services Registration
private func registerCoreServices() {
    // DataService (singleton)
    container.register(DataService.self) { resolver in
        let modelContainer = resolver.resolve(ModelContainer.self)!
        let keychainService = resolver.resolve((any KeychainServiceProtocol).self)!
        return DataService(modelContainer: modelContainer,
                          keychainService: keychainService)
    }.inObjectScope(.container)

    // UserPreferencesService (singleton, using protocol)
    container.register((any UserPreferencesServiceProtocol).self) { resolver in
        let dataService = resolver.resolve(DataService.self)!
        return try! UserPreferencesService(dataService: dataService)
    }.inObjectScope(.container)
}
```

## Usage Patterns

### ✅ CORRECT: Access Models Through DataService

```swift
// In ViewModel
@MainActor
final class ProfileViewModel: BaseViewModel {
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func loadProfiles() async throws {
        let profiles = try dataService.fetchProfiles()
        // Use profiles...
    }

    func createProfile(name: String) async throws {
        let profile = Profile(name: name)  // ✅ OK in ViewModel
        try dataService.createProfile(profile)
    }
}

// In View
struct ProfileListView: View {
    @State private var dataService = DIContainer.shared.resolve(DataService.self)

    var body: some View {
        // Access profiles through dataService
        List {
            ForEach(profiles) { profile in
                Text(profile.name)
            }
        }
        .task {
            profiles = try? dataService.fetchProfiles()
        }
    }
}
```

### ✅ CORRECT: Use Higher-Level Services

```swift
// In ViewModel
@MainActor
final class SettingsViewModel: BaseViewModel {
    private let preferences: any UserPreferencesServiceProtocol

    init(preferences: any UserPreferencesServiceProtocol) {
        self.preferences = preferences
    }

    func toggleTheme() {
        preferences.themeAMOLED.toggle()
        // Automatically persisted through DataService
    }
}

// In View
struct SettingsView: View {
    @State private var preferences = DIContainer.shared
        .resolve((any UserPreferencesServiceProtocol).self)

    var body: some View {
        Toggle("AMOLED Theme", isOn: $preferences.themeAMOLED)
    }
}
```

### ❌ INCORRECT: Direct Model Instantiation Outside Service Layer

```swift
// ❌ BAD: Creating models directly in View without DataService
struct ProfileListView: View {
    var body: some View {
        Button("Add Profile") {
            let profile = Profile(name: "New")  // ❌ Wrong!
            // How do we save this? No access to ModelContext!
        }
    }
}

// ❌ BAD: Accessing ModelContext directly
struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext  // ❌ Wrong!

    func saveSettings() {
        // Direct ModelContext access bypasses service layer
        modelContext.insert(settings)  // ❌ Wrong!
    }
}
```

## Testing Patterns

### ✅ CORRECT: Models Can Be Instantiated in Tests

```swift
@Test("Create profile")
func createProfile() async throws {
    let dataService = try makeTestDataService()

    // ✅ OK to create model instances in tests
    let profile = Profile(name: "Test Profile")
    try dataService.createProfile(profile)

    let fetched = try dataService.fetchProfile(named: "Test Profile")
    #expect(fetched?.name == "Test Profile")
}
```

### ✅ CORRECT: Use Mock Services in Tests

```swift
@Test("Update preferences")
func updatePreferences() async throws {
    let mockPreferences = MockUserPreferencesService()

    // ✅ Use mock service (DI pattern)
    mockPreferences.themeAMOLED = true
    try mockPreferences.save()

    #expect(mockPreferences.saveCalled == true)
}
```

## Why This Pattern?

### Benefits

1. **Separation of Concerns**

   - Models: Data structure
   - DataService: Data access logic
   - Higher services: Business logic
   - Views: Presentation

2. **Testability**

   - Easy to mock services
   - In-memory testing with ModelContainer.inMemoryContainer()
   - No need to mock individual models

3. **Maintainability**

   - Single point of data access (DataService)
   - Easy to add caching, logging, etc.
   - Changes to persistence don't affect Views

4. **Type Safety**
   - Protocol-based services
   - Compiler-enforced dependencies
   - Clear API boundaries

## Common Questions

### Q: Why don't models need DI?

**A:** Models are **data structures**, not dependencies. They're managed by DataService, which IS injectable.

```swift
// Models are passive data containers
@Model
final class Profile {
    var name: String
    var isEnabled: Bool
    // No business logic, no dependencies
}

// Services have dependencies and are injectable
final class DataService {
    private let modelContext: ModelContext
    private let keychainService: any KeychainServiceProtocol

    func createProfile(_ profile: Profile) {
        modelContext.insert(profile)
    }
}
```

### Q: Can Views create model instances?

**A:** Yes, but they should immediately pass them to DataService:

```swift
struct AddProfileView: View {
    @State private var dataService = DIContainer.shared.resolve(DataService.self)
    @State private var name = ""

    func save() {
        let profile = Profile(name: name)  // ✅ OK
        try? dataService.createProfile(profile)  // ✅ Pass to service
    }
}
```

### Q: What about @Environment(\.modelContext)?

**A:** Avoid it. Use DataService instead:

```swift
// ❌ DON'T use ModelContext directly
@Environment(\.modelContext) private var modelContext

// ✅ DO use DataService
@State private var dataService = DIContainer.shared.resolve(DataService.self)
```

## Summary

✅ **Current Architecture is CORRECT**

- Models are data entities managed by services
- DataService is the injectable access layer
- UserPreferencesService wraps DataService with domain logic
- All services are registered in DI container
- Views and ViewModels depend on services, not models directly

**No changes needed** - the architecture already follows DI best practices!

---

**Last Updated**: October 4, 2025
