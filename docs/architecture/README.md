# Thriftwood Architecture Overview

This document provides a high-level overview of Thriftwood's architecture, design patterns, and key technical decisions.

## Table of Contents

- [Architecture Principles](#architecture-principles)
- [System Architecture](#system-architecture)
- [Design Patterns](#design-patterns)
- [Navigation Architecture](#navigation-architecture)
- [Data Layer](#data-layer)
- [Service Layer](#service-layer)
- [UI Layer](#ui-layer)
- [Testing Strategy](#testing-strategy)
- [Key Decisions](#key-decisions)

## Architecture Principles

Thriftwood follows these core principles:

1. **Separation of Concerns**: Clear boundaries between UI, business logic, and data layers
2. **Type Safety**: Leverage Swift 6's strict concurrency and type system
3. **Testability**: Architecture supports unit, integration, and UI testing
4. **Maintainability**: Code is organized for long-term maintenance by a solo developer
5. **SwiftUI-First**: Embrace SwiftUI's declarative paradigm and native patterns
6. **Progressive Enhancement**: Start simple, add complexity only when needed

## System Architecture

Thriftwood uses a layered architecture with clear separation of concerns:

```text
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                           │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Views      │  │ Coordinators │  │  ViewModels  │  │
│  │  (SwiftUI)  │  │ (Navigation) │  │  (State)     │  │
│  └─────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                   Service Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Profile    │  │     Data     │  │   Keychain   │  │
│  │   Service    │  │   Service    │  │   Service    │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │    Logger    │  │    Theme     │  │    Error     │  │
│  │   Service    │  │   Service    │  │   Handler    │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                    Data Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  SwiftData   │  │   Keychain   │  │ UserDefaults │  │
│  │   Models     │  │   (Secure)   │  │ (Preferences)│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                 External Services                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │    Radarr    │  │    Sonarr    │  │   Tautulli   │  │
│  │   (Movies)   │  │    (TV)      │  │   (Stats)    │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│         (API clients generated from OpenAPI specs)      │
└─────────────────────────────────────────────────────────┘
```

## Design Patterns

### MVVM (Model-View-ViewModel)

- **View**: SwiftUI views (pure UI, no business logic)
- **ViewModel**: Observable objects managing state and business logic
- **Model**: SwiftData models and domain entities

### Coordinator Pattern

- **Purpose**: Separate navigation logic from views
- **Implementation**: Each feature has a coordinator managing its navigation flow
- **Benefits**: Testable navigation, reusable views, clear navigation hierarchy

See [ADR-0001: Single NavigationStack Per Coordinator](decisions/0001-single-navigationstack-per-coordinator.md)

### Dependency Injection

- **Container**: `DIContainer` singleton for service resolution
- **Protocol-Based**: Services defined by protocols for testability
- **Initialization**: Dependencies injected at view/ViewModel creation

### Repository Pattern (Future)

- **Purpose**: Abstract data access from business logic
- **Implementation**: Service layer acts as repositories
- **Status**: Implicit in current service design, will formalize in Milestone 2

## Navigation Architecture

### Coordinator Hierarchy

```text
AppCoordinator
├─ OnboardingCoordinator (first-time setup)
│  ├─ Welcome
│  ├─ Create Profile
│  └─ Add First Service
│
└─ TabCoordinator (main app)
   ├─ DashboardCoordinator
   │  └─ Dashboard screens
   │
   ├─ ServicesCoordinator
   │  └─ Service management screens
   │
   └─ SettingsCoordinator
      ├─ Settings main
      ├─ Profile management
      ├─ Appearance
      └─ About
```

### NavigationStack Strategy

**Rule**: One NavigationStack per coordinator, content-only child views

- Each coordinator view creates a single NavigationStack
- Child views use navigation modifiers (`.navigationTitle()`, `.toolbar()`)
- Modal presentations (sheets/popovers) can have independent stacks
- Back navigation works automatically via SwiftUI

**See**: [ADR-0001](decisions/0001-single-navigationstack-per-coordinator.md)

## Data Layer

### SwiftData Models

- **Profile**: User profile with multi-instance support
- **ServiceConfiguration**: Service connection settings (future)
- **CachedMedia**: Local cache of media items (future)

### Persistence Strategy

- **SwiftData**: Primary data store for structured data
- **Keychain**: Secure storage for API keys and passwords
- **UserDefaults**: App preferences and lightweight settings

### Migration from Flutter

- Flutter used Hive (NoSQL key-value store)
- Swift uses SwiftData (relational, type-safe)
- Profile structure maintained for compatibility

## Service Layer

### Core Services

#### ProfileService

- **Purpose**: Manage user profiles (create, update, delete, switch)
- **Protocol**: `ProfileServiceProtocol`
- **Implementation**: `ProfileService` (SwiftData-backed)

#### DataService

- **Purpose**: SwiftData container and database bootstrap
- **Protocol**: `DataServiceProtocol`
- **Implementation**: `DataService`

#### KeychainService

- **Purpose**: Secure credential storage
- **Protocol**: `KeychainServiceProtocol`
- **Implementation**: `KeychainService` (Security framework wrapper)

#### UserPreferencesService

- **Purpose**: App preferences and settings
- **Protocol**: `UserPreferencesServiceProtocol`
- **Implementation**: `UserPreferencesService` (UserDefaults wrapper)

#### ThemeService

- **Purpose**: App theme and appearance management
- **Protocol**: `ThemeServiceProtocol`
- **Implementation**: `ThemeService`

### Service Characteristics

- **Protocol-first**: All services defined by protocols
- **Testable**: Mock implementations for testing
- **Thread-safe**: Use `@MainActor` where needed
- **Error handling**: Structured errors with `ThriftwoodError`

## UI Layer

### View Organization

```text
Thriftwood/UI/
├── Components/          # Reusable UI components
│   ├── FormComponents/  # Form inputs, toggles, pickers
│   └── Layout/          # Spacing, containers
├── Onboarding/          # First-time user flow
├── Dashboard/           # Main app screens (future)
├── Services/            # Service management (future)
└── Settings/            # App settings and configuration
```

### Component Design

- **Atomic**: Small, single-purpose components
- **Composable**: Build complex UIs from simple components
- **Themed**: Use `Color.theme*` and `Spacing.*` constants
- **Accessible**: Follow accessibility guidelines (see `.github/instructions/a11y.instructions.md`)

### Theme System

- **Dynamic**: Light/dark mode support
- **Customizable**: Accent color selection
- **Consistent**: Centralized color and spacing definitions
- **Semantic**: Named colors (e.g., `themePrimaryText` vs. `.black`)

See: `/docs/THEME_COLOR_ACCESS_PATTERN.md`

## Testing Strategy

### Test Organization

```text
ThriftwoodTests/
├── Core/
│   ├── Services/        # Service layer tests
│   └── ViewModels/      # ViewModel tests
├── Coordinators/        # Navigation tests
└── UI/                  # View logic tests
```

### Testing Patterns

- **Swift Testing**: Using `@Test` macros (not XCTest)
- **Protocol Mocks**: Mock services implement protocols
- **Isolated Tests**: Each test is independent
- **Parameterized**: Use `@Test` with arguments for edge cases

**See**: `.github/instructions/swift-testing-playbook.md`

### Coverage Goals

- **Service Layer**: >90% coverage
- **ViewModels**: >80% coverage
- **Coordinators**: Critical flows covered
- **UI Components**: Visual regression via snapshots (future)

## Key Decisions

### Architectural Decision Records

| ADR                                                              | Title                                  | Status   |
| ---------------------------------------------------------------- | -------------------------------------- | -------- |
| [0001](decisions/0001-single-navigationstack-per-coordinator.md) | Single NavigationStack Per Coordinator | accepted |

### Notable Technical Choices

1. **Swift 6 Strict Concurrency**: Enabled from day one
2. **SwiftData over Core Data**: Modern API, better type safety
3. **Coordinator Pattern**: Separates navigation from views
4. **Protocol-Oriented Services**: Enables testing and modularity
5. **OpenAPI Generation**: Type-safe API clients from specs (future)
6. **MADR Format**: Structured ADRs for decision documentation

## Migration Context

Thriftwood is a **complete rewrite** of LunaSea (Flutter) in Swift 6/SwiftUI.

### Migration Strategy

- **Phase 1 (Current)**: Foundation - navigation, data layer, settings
- **Phase 2**: Service integration - Radarr, Sonarr
- **Phase 3**: Advanced features - calendar, notifications
- **Phase 4**: Polish and launch

**See**: `/docs/migration/` for detailed migration documentation

### Flutter → Swift Mappings

| Flutter        | Swift                          |
| -------------- | ------------------------------ |
| Dio + Retrofit | URLSession + OpenAPI Generator |
| Provider       | @Observable + SwiftUI          |
| Hive           | SwiftData                      |
| Go Router      | NavigationStack + Coordinators |
| JSON files     | String Catalogs                |

## References

### Documentation

- [Migration Requirements](/docs/migration/requirements.md)
- [Design Document](/docs/migration/design.md)
- [Implementation Tasks](/docs/migration/tasks.md)
- [Copilot Instructions](/.github/copilot-instructions.md)

### External Resources

- [Swift 6 Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [SwiftUI Navigation](https://developer.apple.com/documentation/swiftui/navigation)
- [Coordinator Pattern](https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios)
- [MVVM in SwiftUI](https://www.hackingwithswift.com/books/ios-swiftui/introducing-mvvm-into-your-swiftui-project)

## Contributing

When making architectural changes:

1. Create an ADR using the MADR template
2. Document the decision context and alternatives
3. Update this overview if needed
4. Link related documentation
5. Update the decision log in `/docs/architecture/decisions/README.md`

---

**Last Updated**: 2025-10-05  
**Maintainer**: Matthias Wallner Géhri
