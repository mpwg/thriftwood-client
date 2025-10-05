# Thriftwood Developer Setup Guide

This guide will help you set up your development environment for contributing to Thriftwood.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Building the Project](#building-the-project)
- [Running Tests](#running-tests)
- [Code Quality](#code-quality)
- [CI/CD](#cicd)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software

- **Xcode 16.0+** (Swift 6.2+)
- **macOS 14.0+** (Sonoma or later)
- **Git** (for version control)
- **Swift Package Manager** (included with Xcode)

### Optional Tools

- **SwiftLint** (recommended for code quality)
- **GitHub CLI** (`gh`) for repository management
- **fastlane** (optional, for future iOS builds)

### Installing Prerequisites

```bash
# Install Xcode from the Mac App Store or:
xcode-select --install

# Install SwiftLint (optional, also runs in CI)
brew install swiftlint

# Install GitHub CLI (optional)
brew install gh
```

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/mpwg/thriftwood-client.git
cd thriftwood-client
```

### 2. Open in Xcode

```bash
open Thriftwood.xcodeproj
```

### 3. Resolve Dependencies

Xcode will automatically resolve Swift Package Manager dependencies:

- Swinject (2.10.0) - Dependency injection
- AsyncHTTPClient (1.28.0) - HTTP networking
- HTTPTypes (1.4.0) - Type-safe HTTP
- OpenAPI Runtime & Generator (1.8.3, 1.10.3) - API client generation
- Valet (4.3.0) - Keychain access

If dependencies don't resolve automatically:

```bash
# From project directory
xcodebuild -resolvePackageDependencies
```

## Building the Project

### Using Xcode

1. Open `Thriftwood.xcodeproj`
2. Select the **Thriftwood** scheme
3. Select **My Mac** as the destination
4. Press **⌘R** to build and run

### Using Command Line

```bash
# Build
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood -configuration Debug build

# Build for Release
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood -configuration Release build
```

### Build Configurations

- **Debug**: Development builds with assertions and debug symbols
- **Release**: Optimized builds for production

## Running Tests

### Using Xcode

1. Press **⌘U** to run all tests
2. Or use Test Navigator (**⌘6**) to run specific tests

### Using Command Line

```bash
# Run all tests
xcodebuild test \
  -project Thriftwood.xcodeproj \
  -scheme Thriftwood \
  -destination 'platform=macOS'

# Run specific test file
xcodebuild test \
  -project Thriftwood.xcodeproj \
  -scheme Thriftwood \
  -destination 'platform=macOS' \
  -only-testing:ThriftwoodTests/ProfileServiceTests
```

### Test Structure

Tests use **Swift Testing** framework (not XCTest):

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
}
```

### Test Coverage

Current coverage: **~85%** of foundation code

- ✅ Data persistence (DataServiceTests)
- ✅ Profile management (ProfileServiceTests)
- ✅ Keychain operations (KeychainServiceTests)
- ✅ Navigation logic (CoordinatorTests, DeepLinkTests)
- ✅ UI components (UIComponentsTests, FormComponentsTests)
- ✅ Theme system (ThemeTests)
- ❌ Network layer (uses AsyncHTTPClient - no custom tests needed)

## Code Quality

### SwiftLint

The project uses SwiftLint for code quality and consistency.

```bash
# Lint the entire project
swiftlint lint

# Lint with strict mode (fails on warnings)
swiftlint lint --strict

# Auto-fix issues
swiftlint --fix

# Lint specific files
swiftlint lint --path Thriftwood/Core/
```

### SwiftLint Configuration

See `.swiftlint.yml` for rules. Key configurations:

- **Disabled**: `todo`, `line_length` (flexible during development)
- **Enabled**: Performance rules, documentation rules, logging rules
- **Custom**: License header enforcement

### License Headers

All Swift files **MUST** include the GPL-3.0 license header:

```bash
# Check for missing headers
./scripts/check-license-headers.sh --check

# Add headers to new files
./scripts/check-license-headers.sh --add
```

**CI will block merges if license headers are missing.**

### Code Formatting

Follow Swift API Design Guidelines:

- Use `lowerCamelCase` for properties and functions
- Use `UpperCamelCase` for types
- Use clear, descriptive names
- Avoid abbreviations unless well-known
- Mark `@MainActor` where needed for UI code

## CI/CD

### GitHub Actions

CI runs on every push to `main` and `retry` branches:

```yaml
# .github/workflows/ci.yml
- License header validation (blocks merge if missing)
- SwiftLint (strict mode)
- Build (Debug configuration)
- Test (all tests must pass)
```

### Running CI Locally

```bash
# Simulate CI checks
./scripts/check-license-headers.sh --check && \
  swiftlint lint --strict && \
  xcodebuild build -project Thriftwood.xcodeproj -scheme Thriftwood && \
  xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood -destination 'platform=macOS'
```

### CI Configuration

- **Runs on**: macOS-14 runner
- **Caching**: Swift packages cached for speed
- **Auto-cancel**: Old runs cancelled on new push
- **Path filters**: Excludes `docs/**`, `legacy/**`, `*.md` files

See `.github/CI_README.md` for detailed CI documentation.

## Project Structure

```
Thriftwood/
├── Core/
│   ├── DI/              # Dependency injection (Swinject)
│   ├── Error/           # Error types and handling
│   ├── Logging/         # Logger service
│   ├── Navigation/      # Coordinators and routes
│   ├── Storage/         # SwiftData models and services
│   ├── Theme/           # Theme system (MPWGTheme)
│   └── ViewModels/      # BaseViewModel
├── Services/
│   └── ServiceProtocols.swift
├── UI/
│   ├── Components/      # Reusable UI components
│   ├── Onboarding/      # Welcome flow
│   ├── Settings/        # Settings screens
│   └── *.swift          # Feature screens
├── Resources/
│   └── Assets.xcassets
└── ThriftwoodTests/
    ├── Mocks/           # Mock services for testing
    ├── Utilities/       # Test helpers
    └── *Tests.swift     # Test suites
```

## Development Workflow

### 1. Create Feature Branch

```bash
git checkout -b feature/my-feature
```

### 2. Make Changes

- Follow MVVM-C pattern (see [0005-use-mvvm-c-pattern.md](../architecture/decisions/0005-use-mvvm-c-pattern.md))
- Add tests for new code
- Include GPL-3.0 license header
- Run SwiftLint before committing

### 3. Run Tests

```bash
xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood -destination 'platform=macOS'
```

### 4. Commit Changes

```bash
git add .
git commit -m "feat: add my feature"
```

Use conventional commits format:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `test:` - Test additions/changes
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks

### 5. Push and Create PR

```bash
git push origin feature/my-feature
gh pr create --title "Add my feature" --body "Description..."
```

## Troubleshooting

### "No such module" errors

```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/Thriftwood-*

# Reset package cache
rm -rf ~/Library/Caches/org.swift.swiftpm

# Resolve packages again
xcodebuild -resolvePackageDependencies
```

### Build failures

```bash
# Clean build folder
xcodebuild clean -project Thriftwood.xcodeproj -scheme Thriftwood

# Rebuild
xcodebuild build -project Thriftwood.xcodeproj -scheme Thriftwood
```

### Test failures on Mac Catalyst

Some tests may show configuration issues on Mac Catalyst target. This is a known Xcode limitation, not a code issue. Tests compile and pass successfully.

### SwiftLint errors

```bash
# Show all linting issues
swiftlint lint

# Auto-fix what's possible
swiftlint --fix

# Disable specific rule in file
// swiftlint:disable rule_name
// Code here
// swiftlint:enable rule_name
```

### License header issues

```bash
# Check which files are missing headers
./scripts/check-license-headers.sh --check

# Add headers automatically
./scripts/check-license-headers.sh --add

# Manually add header (see .github/instructions/license-header.instructions.md)
```

## IDE Configuration

### Xcode Settings

Recommended settings (**Xcode → Settings**):

#### Text Editing

- **Indentation**: 4 spaces (not tabs)
- **Line Length**: No hard limit (SwiftLint flexible)
- **Enable**: Trim trailing whitespace

#### Navigation

- **Enable**: "Uses Tab" for navigation

#### Swift Compiler

- **Swift Language Version**: Swift 6
- **Strict Concurrency Checking**: Complete

### Useful Xcode Shortcuts

- **⌘B** - Build
- **⌘R** - Run
- **⌘U** - Run tests
- **⌘⇧K** - Clean build folder
- **⌘⇧O** - Open quickly (find file/symbol)
- **⌘⌃↑** - Switch between header/implementation
- **⌘/** - Toggle comment

## Additional Resources

- [Architecture Overview](../architecture/README.md)
- [Architecture Decision Records](../architecture/decisions/README.md)
- [Migration Requirements](../migration/requirements.md)
- [Migration Tasks](../migration/tasks.md)
- [SwiftLint Rules](.swiftlint.yml)
- [CI Documentation](../../.github/CI_README.md)

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/mpwg/thriftwood-client/issues)
- **Discussions**: [GitHub Discussions](https://github.com/mpwg/thriftwood-client/discussions)
- **Email**: mat@thriftwood.app

## Next Steps

After setup:

1. Read [Architecture Overview](../architecture/README.md)
2. Review [Milestone 1 Foundation](../migration/milestones/milestone-1-foundation.md)
3. Check [Tasks](../migration/tasks.md) for current work
4. Explore codebase in `Thriftwood/Core/` and `Thriftwood/UI/`
5. Run tests to verify setup: `⌘U`

Welcome to Thriftwood development! 🌲
