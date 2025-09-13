# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Running
```bash
# Open project in Xcode
open ThriftwoodNative/ThriftwoodNative.xcodeproj

# Install Ruby dependencies for Fastlane
bundle install

# Build for CI validation (no signing required)
bundle exec fastlane build

# Build development version
bundle exec fastlane dev

# Build and upload to TestFlight (auto-increments build number)
bundle exec fastlane beta

# Build and upload to App Store (auto-increments version + build, creates git tag)
bundle exec fastlane release

# Sync code signing certificates and provisioning profiles
bundle exec fastlane certificates

# Update certificates and push to Match repository
bundle exec fastlane update_certificates

# Show current app version and build number
bundle exec fastlane version

# Show available lanes with descriptions
bundle exec fastlane show_help
```

### CI/CD Pipeline
The project uses GitHub Actions with comprehensive multi-stage deployment following a structured branch and tag strategy.

**For detailed branching strategy and deployment workflows, see [BRANCHING_STRATEGY.md](./BRANCHING_STRATEGY.md)**

**Quick Reference:**
- **`main`**: Production-ready → TestFlight deployment
- **`develop`**: Development → Dev builds with artifacts  
- **`feature/*`**: Feature work → Build validation only (via PRs)
- **`v*` tags**: Version tags → App Store deployment + GitHub release

**Required Repository Secrets:**
`APPLE_ID`, `DEVELOPMENT_TEAM`, `APPSTORE_TEAM_ID`, `FASTLANE_SESSION`, `MATCH_PASSWORD`, `MATCH_GIT_URL`, `MATCH_GIT_BASIC_AUTHORIZATION`, `KEYCHAIN_PASSWORD`

**Setting up secrets:**
```bash
# Copy the template and fill in your values
cp .env.secrets.example .env

# Import secrets to GitHub repository
./scripts/import-github-secrets.sh
```

## Architecture

This is a SwiftUI application with a clean, modular architecture:

### Core Architecture Patterns
- **MVVM + Coordinator**: Views use ViewModels for presentation logic, Coordinators handle navigation
- **Repository Pattern**: Data access abstracted through repository protocols (`DashboardRepository`, `SettingsRepository`)
- **Dependency Injection**: Simple DI container at `ThriftwoodNative/Core/DependencyInjection/DIContainer.swift`
- **Service Layer**: Network and storage abstracted via protocols (`NetworkService`, `StorageService`)

### Key Architectural Files
- `ThriftwoodNative/Core/SharedTypes.swift`: Central definitions for data models, protocols, service implementations
- `ThriftwoodNative/Core/DependencyInjection/DIContainer.swift`: DI container with singleton and factory registration
- `ThriftwoodNative/Core/Architecture/Coordinator/Coordinator.swift`: Navigation coordination system

### Directory Structure
```
ThriftwoodNative/
├── App/                    # App entry point and root views
├── Core/
│   ├── Architecture/       # Coordinators, repositories, view models
│   ├── DependencyInjection/ # DI container
│   ├── Networking/         # Network service implementations  
│   └── SharedTypes.swift   # Core types, protocols, implementations
├── Features/               # Feature modules (Dashboard, Settings)
└── Resources/              # Assets, localization
```

### Data Flow
1. Views inject ViewModels via `@StateObject` or DI container
2. ViewModels call Repository methods for data operations
3. Repositories use NetworkService (API calls) and StorageService (UserDefaults persistence)
4. All networking goes through `NetworkServiceImpl` with `APIEndpoint` abstraction
5. Navigation handled by `AppCoordinator` with `NavigationDestination` enum

### Service Implementations
- **NetworkServiceImpl**: REST API client with JSON encoding/decoding, error handling
- **StorageServiceImpl**: UserDefaults-backed storage with Codable support
- **Repository Implementations**: Currently return mock data but structured for real API integration

### Error Handling
Structured error types: `NetworkError`, `StorageError`, `ViewModelError` with `LocalizedError` conformance.

## Code Signing & Distribution

Uses Fastlane Match for code signing certificate management. Required environment variables are defined in `.github/workflows/ci-cd.yml` and must be configured as repository secrets:

- `APPLE_ID`, `DEVELOPMENT_TEAM`, `APPSTORE_TEAM_ID`
- `FASTLANE_SESSION` (Session cookie for App Store Connect authentication)
- `MATCH_PASSWORD`, `MATCH_GIT_URL`, `MATCH_GIT_BASIC_AUTHORIZATION`
- `KEYCHAIN_PASSWORD`

## Development Notes

### Dependencies
- **SwiftUI**: UI framework
- **Combine**: Reactive programming for ViewModels
- **Fastlane**: Build automation and code signing
- No external Swift packages - uses system frameworks only

### Platform Support
- Primary: iOS and macOS via shared SwiftUI codebase
- Build targets configured in Xcode project
- Conditional compilation for platform-specific UI (`#if !os(macOS)`)

### Localization
Multi-language support via:
- `assets/localization/` - Translation files  
- `ThriftwoodNative/Resources/en.lproj/Localizable.strings`

### Testing
Test infrastructure appears minimal. CI runs build validation but no explicit test execution found in current setup.