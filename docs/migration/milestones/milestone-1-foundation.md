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

- [ ] Create folder structure following clean architecture
- [ ] Implement base protocols for services
- [ ] Setup dependency injection container
- [ ] Create base ViewModel protocol with @Observable
- [ ] Implement error handling framework

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
