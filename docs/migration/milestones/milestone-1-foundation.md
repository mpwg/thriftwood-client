# Milestone 1: Foundation

**Duration**: Weeks 1-3  
**Goal**: Establish core architecture and infrastructure  
**Deliverable**: Basic app shell with navigation and data layer

## Week 1: Project Setup & Architecture

### Task 1.1: Project Initialization

**Estimated Time**: 2 hours  
**Status**: ✅ COMPLETE  
**Implementation Focus**: Easy maintenance for indie development

- [x] Create new Xcode project with Swift 6
- [x] Configure project settings and capabilities
- [x] Setup Git repository and .gitignore
  - Enhanced .gitignore with comprehensive macOS, Xcode, SPM, and dev tool exclusions
  - Documented structure for easy maintenance
- [x] Configure SwiftLint rules
  - Created `.swiftlint.yml` with maintainability-focused rules
  - Balanced strictness: catches errors without being overly restrictive
  - Custom rules for documentation and logging best practices
- [x] Setup CI/CD pipeline (GitHub Actions)
  - Simple, single-pipeline workflow in `.github/workflows/ci.yml`
  - Runs on every push: lint, build, test
  - Fast feedback with caching and automatic cancellation
  - Documentation in `.github/CI_README.md`

### Task 1.2: Core Architecture Setup

**Estimated Time**: 8 hours  
**Actual Time**: 6 hours  
**Status**: ✅ COMPLETE  
**Implementation Date**: 2025-10-03

**Implementation Summary**:

Implemented complete core architecture following clean architecture principles with Swift 6.2's Approachable Concurrency.

**Completed Components**:

1. **Folder Structure** (`/Thriftwood/Core/`, `/Services/`, `/UI/`)

   - Clean separation of concerns
   - Modular organization for scalability

2. **Dependency Injection** (Swinject framework)

   - Added Swinject 2.10.0 via Swift Package Manager
   - Documentation in `/docs/SWINJECT_SETUP.md`
   - Type-safe dependency resolution
   - Support for singletons and factories via Swinject's Container API
   - Will be configured in app initialization as services are implemented

3. **Error Handling** (`Core/Error/ThriftwoodError.swift`)

   - Comprehensive error types (network, API, authentication, data, etc.)
   - User-friendly localized error messages
   - Retry logic support with `isRetryable` property
   - Error conversion utilities for mapping platform errors

4. **Logging Framework** (`Core/Logging/Logger.swift`)

   - OSLog-based structured logging with subsystem organization
   - Multiple categories (networking, storage, authentication, UI, services, general)
   - Privacy-aware logging with automatic redaction
   - Debug/Info/Warning/Error/Critical severity levels
   - Convenience static loggers for common use cases
   - All methods marked `nonisolated` for use from any context

5. **Base Protocols** (`Services/ServiceProtocols.swift`)

   - `ServiceConfiguration` for service setup
   - `ServiceProtocol` base interface
   - Foundation for service implementations

6. **Networking Layer** (`Core/Networking/`)

   - `APIClient` protocol for HTTP operations
   - `Endpoint` structure for request configuration
   - `HTTPMethod` and `HTTPHeaders` type aliases
   - Request/Response generic types

7. **Base ViewModel** (`Core/DI/BaseViewModel.swift`)
   - `@Observable` protocol using Swift 6 Observation framework
   - `@MainActor` isolated for UI safety
   - Lifecycle methods (load, reload, cleanup)
   - Error handling and loading state management

**Key Architectural Decisions**:

1. **Approachable Concurrency**:

   - Leverages Swift 6.2's more pragmatic concurrency checking
   - Uses `nonisolated(unsafe)` with locks where needed
   - Avoids excessive `@preconcurrency` and `@unchecked Sendable`
   - See `/docs/CONCURRENCY.md` for detailed rationale

2. **Lock-Based DI with Swinject**:

   - Using Swinject directly for dependency injection
   - Well-established iOS/macOS DI framework
   - Will configure Container in app delegate/initialization
   - No custom wrapper needed - direct Swinject API usage

3. **OSLog for Logging**:
   - Native Apple framework with zero dependencies
   - Automatic privacy redaction in release builds
   - Integrated with macOS Console.app for debugging

**Known Issues**:

- None - all tests passing (34 Swift Testing tests)
- Swinject Container will be configured when services are implemented in Milestone 2

**Files Created**:

- `Thriftwood/Core/DI/BaseViewModel.swift` (94 lines)
- `Thriftwood/Core/Error/ThriftwoodError.swift` (167 lines)
- `Thriftwood/Core/Logging/Logger.swift` (124 lines)
- `Thriftwood/Core/Networking/APIClient.swift` (86 lines)
- `Thriftwood/Core/Networking/Endpoint.swift` (37 lines)
- `Thriftwood/Core/Networking/HTTPMethod.swift` (15 lines)
- `Thriftwood/Services/ServiceProtocols.swift` (24 lines)
- `ThriftwoodTests/LoggerSwiftTests.swift` (Swift Testing - 19 tests)
- `ThriftwoodTests/ThriftwoodErrorSwiftTests.swift` (Swift Testing - 14 tests)
- `ThriftwoodTests/ThriftwoodTests.swift` (1 basic test)
- `docs/CONCURRENCY.md` (concurrency strategy documentation)
- `docs/SWINJECT_SETUP.md` (Swinject integration guide)

**Next Steps**:

- Proceed to Task 1.3: Navigation Framework
- Configure Swinject Container in Task 1.3 or when first services are implemented

### Task 1.3: Navigation Framework

**Estimated Time**: 6 hours

- [ ] Implement coordinator pattern
- [ ] Setup NavigationStack with path-based routing
- [ ] Create navigation destinations enum
- [ ] Implement deep linking support structure
- [ ] Add tab bar navigation structure

### Task 1.4: Networking Layer

**Estimated Time**: 8 hours

- [ ] Create APIClient protocol and implementation
- [ ] Implement Endpoint structure
- [ ] Add request/response logging
- [ ] Setup SSL pinning framework
- [ ] Create mock networking for testing

## Week 2: Data Layer & Storage

### Task 2.1: SwiftData Setup

**Estimated Time**: 6 hours

- [ ] Define SwiftData models for profiles
- [ ] Define models for service configurations
- [ ] Setup model container and context
- [ ] Implement migration support
- [ ] Create data persistence service

### Task 2.2: Keychain Integration

**Estimated Time**: 4 hours

- [ ] Implement KeychainService wrapper
- [ ] Create secure storage for API keys
- [ ] Add biometric authentication support
- [ ] Implement credential migration from legacy app

### Task 2.3: User Preferences

**Estimated Time**: 4 hours

- [ ] Create UserDefaults wrapper with @AppStorage
- [ ] Define app settings structure
- [ ] Implement theme preferences
- [ ] Setup language/locale preferences

### Task 2.4: Profile Management

**Estimated Time**: 6 hours

- [ ] Create Profile model and repository
- [ ] Implement profile CRUD operations
- [ ] Add profile switching logic
- [ ] Create profile export/import functionality

## Week 3: UI Foundation & Common Components

### Task 3.1: Design System

**Estimated Time**: 6 hours

- [ ] Define color scheme (light/dark mode)
- [ ] Create typography scales
- [ ] Setup spacing and sizing constants
- [ ] Create app icon and launch screen
- [ ] Define animation constants

### Task 3.2: Common UI Components

**Estimated Time**: 8 hours

- [ ] Create LoadingView component
- [ ] Implement ErrorView with retry
- [ ] Build EmptyStateView
- [ ] Create custom navigation bar
- [ ] Implement pull-to-refresh modifier

### Task 3.3: Form Components

**Estimated Time**: 6 hours

- [ ] Create TextFieldRow for settings
- [ ] Build SecureFieldRow for passwords
- [ ] Implement ToggleRow
- [ ] Create PickerRow for selections
- [ ] Add form validation helpers

### Task 3.4: Main App Structure

**Estimated Time**: 8 hours

- [ ] Implement MainTabView
- [ ] Create SettingsView skeleton
- [ ] Build ProfileListView
- [ ] Add AddProfileView
- [ ] Implement launch/onboarding flow

## Testing & Documentation

### Task T1: Unit Tests

**Estimated Time**: 8 hours

- [ ] Test networking layer
- [ ] Test data persistence
- [ ] Test profile management
- [ ] Test keychain operations
- [ ] Test navigation logic

### Task D1: Documentation

**Estimated Time**: 4 hours

- [ ] Document architecture decisions
- [ ] Create API documentation
- [ ] Write setup guide
- [ ] Document coding conventions

## Acceptance Criteria

### Functional Criteria

- [ ] App launches successfully
- [ ] Can create and switch profiles
- [ ] Settings are persisted
- [ ] Navigation works correctly
- [ ] Error states are handled

### Technical Criteria

- [ ] No compiler warnings
- [ ] SwiftLint passes
- [ ] > 80% test coverage for foundation
- [ ] All TODO items resolved
- [ ] Documentation complete

## Risks & Mitigations

| Risk                    | Mitigation                     |
| ----------------------- | ------------------------------ |
| SwiftData instability   | Have CoreData fallback plan    |
| Swift 6 adoption issues | Keep compatibility mode option |
| Complex navigation      | Simplify if needed             |

## Next Milestone Preview

With foundation complete, Milestone 2 will focus on implementing the first two services (Radarr and Sonarr) with full CRUD functionality.
