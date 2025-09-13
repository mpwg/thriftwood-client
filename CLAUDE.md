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
- `APPLE_ID` - Apple Developer account email
- `DEVELOPMENT_TEAM` - Apple Developer Team ID
- `APPSTORE_TEAM_ID` - App Store Connect Team ID (usually same as DEVELOPMENT_TEAM)
- `APP_STORE_CONNECT_API_KEY_KEY_ID` - App Store Connect API Key ID (recommended)
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID` - App Store Connect API Key Issuer ID
- `APP_STORE_CONNECT_API_KEY_CONTENT` - Private key content for App Store Connect API
- `FASTLANE_SESSION` - Session cookie for App Store Connect (alternative to API key)
- `MATCH_PASSWORD` - Password for Fastlane Match certificate repository
- `MATCH_GIT_URL` - Git repository URL for storing certificates
- `MATCH_GIT_BASIC_AUTHORIZATION` - Base64 encoded GitHub token for certificate repo access
- `KEYCHAIN_PASSWORD` - Password for CI keychain setup

### Setting up Environment Variables and GitHub Secrets

#### Step 1: Create Local Environment File
```bash
# Copy the template and fill in your actual values
cp .env.example .env
```

#### Step 2: Configure Your Values
Edit `.env` with your actual credentials. The file is organized into sections:

- **Apple Developer Account**: Your Apple ID and team information
- **App Store Connect Authentication**: Either API key (recommended) or session cookie
- **Code Signing**: Fastlane Match configuration for certificate management
- **CI/CD Environment**: GitHub Actions specific settings
- **Fastlane Configuration**: Optional settings to reduce noise

#### Step 3: Import to GitHub Repository Secrets
```bash
# Run the import script to push all variables to GitHub repository secrets
./scripts/import-github-secrets.sh
```

This script will:
- Read all variables from your `.env` file
- Create corresponding GitHub repository secrets
- Verify the secrets were created successfully

#### App Store Connect Authentication Options

**Option 1: API Key (Recommended)**
- More secure and doesn't expire like session cookies
- Set `APP_STORE_CONNECT_API_KEY_KEY_ID`, `APP_STORE_CONNECT_API_KEY_ISSUER_ID`, and `APP_STORE_CONNECT_API_KEY_CONTENT`
- Generate API key from App Store Connect → Users and Access → API Keys

**Option 2: Session Cookie (Alternative)**
- Set `FASTLANE_SESSION` with your App Store Connect session cookie
- Expires regularly and needs manual renewal
- Get by logging into App Store Connect and copying session cookie from browser

#### Security Notes
- Never commit `.env` file to version control (already in `.gitignore`)
- The import script only reads from `.env` - it doesn't store secrets locally
- GitHub repository secrets are encrypted and only accessible to authorized workflows

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