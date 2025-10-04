# Copilot Instructions for Thriftwood

## Project Context: Flutter-to-Swift Migration

**Critical**: This is a **complete rewrite** of LunaSea (Flutter) to Thriftwood (Swift 6/SwiftUI). The `/legacy` directory contains the original Flutter codebase that **MUST be consulted** before implementing any feature. You are migrating functionality, not creating from scratch.

### Before Implementing ANY Task

1. **Check `/legacy`** for the Flutter implementation
2. **Review `/docs/migration/`** for requirements, design, and task specifications
3. **Understand the original behavior** before translating to Swift

## Architecture Overview

### Migration Documentation Structure (READ FIRST)

- **`/docs/migration/requirements.md`**: EARS-formatted functional requirements
- **`/docs/migration/design.md`**: Swift 6 architecture (MVVM-C, protocols, service layer)
- **`/docs/migration/tasks.md`**: 6-milestone roadmap with weekly tasks
- **`/docs/migration/milestones/*.md`**: Detailed task breakdowns with acceptance criteria

### Legacy Codebase Structure (`/legacy`)

**Flutter/Dart Application** - The source of truth for feature behavior:

```
/legacy/lib/
├── api/              # Service API clients (Radarr, Sonarr, Tautulli, etc.)
│   ├── radarr/      # Movie management API (Retrofit + Dio)
│   ├── sonarr/      # TV show management API
│   ├── lidarr/      # Music management API
│   └── ...          # NZBGet, SABnzbd, Tautulli, etc.
├── database/        # Hive NoSQL storage (models, tables, configuration)
├── modules/         # Feature modules (dashboard, search, settings, per-service)
├── router/          # Go Router navigation
└── widgets/         # Reusable UI components
```

**Key Legacy Patterns**:

- **HTTP**: Dio client with Retrofit for API calls
- **State**: Provider pattern for state management
- **Storage**: Hive for data persistence, profiles for multi-instance support
- **Modules**: Each service (Radarr, Sonarr, etc.) is self-contained in `lib/modules/`

### New Swift Architecture (`/Thriftwood`)

**Target**: Swift 6 + SwiftUI + MVVM-C pattern

- **Navigation**: Coordinator pattern + NavigationStack
- **DI**: Container-based dependency injection
- **State**: @Observable (Swift 6) for ViewModels
- **Storage**: SwiftData for persistence, Keychain for credentials
- **Networking**: URLSession with protocol-oriented APIClient

## Development Workflow

### License Headers - MANDATORY

**Every Swift file MUST include the GPL-3.0 license header:**

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

**When creating new files:**

- Always include the GPL-3.0 header at the top of every Swift file
- Replace `FileName.swift` with the actual filename
- Use 2025 as the copyright year (or current year if later)
- See `.github/instructions/license-header.instructions.md` for full details

**Verification:**

```bash
# Check for missing headers
./scripts/check-license-headers.sh --check

# Add headers to new files
./scripts/check-license-headers.sh --add
```

CI will **block merges** if headers are missing.

### Build & Test Commands

**Important**: CI runs on every push to `main`/`rety` (excludes docs/legacy changes)

```bash
# Build
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood -configuration Debug

# Test
xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood

# Lint (must pass CI)
swiftlint lint --strict

# Format (optional)
swiftlint --fix

# Check license headers
./scripts/check-license-headers.sh --check
```

**GitHub Actions CI** (`.github/workflows/ci.yml`):

- Validates GPL-3.0 license headers (blocks if missing)
- Runs lint, build, test on macOS-14
- Caches Swift packages for speed
- Auto-cancels old runs on new push
- See `.github/CI_README.md` for details

### SwiftLint Configuration

**Philosophy**: Maintainable for solo indie development

- Enforces consistency without being overly strict
- Disabled: `todo`, `line_length` (flexible during development)
- Opt-in: Performance rules (`first_where`, `empty_count`, `toggle_bool`)
- Custom: Documentation and logging best practices
- Limits: 300-line types, 200-line functions (maintainability focus)

See `.swiftlint.yml` for full configuration.

### Testing Requirements - MANDATORY

**Before completing ANY task, you MUST verify:**

1. ✅ **All changes have appropriate tests**

   - New functionality must have corresponding test coverage
   - Bug fixes must include regression tests
   - Modified code must have updated tests

2. ✅ **All tests pass**

   - Run `xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood -destination 'platform=macOS'`
   - Verify no test failures before marking task complete
   - Check that CI will pass with your changes

3. ✅ **Tests follow the Swift Testing pattern**
   - Refer to `.github/instructions/swift-testing-playbook.md` for patterns
   - Use `@Test` macro instead of XCTest classes
   - Use `#expect()` and `#require()` instead of `XCTAssert*`
   - Use `@Suite` for test organization
   - Use `@MainActor` where needed for UI/coordinator tests
   - Follow parameterized testing patterns where applicable

**This is not optional.** Tests are your contract that the code works correctly.

## Critical Migration Patterns

### Service API Translation (Flutter → Swift)

**Legacy Pattern** (`/legacy/lib/api/radarr/radarr.dart`):

```dart
// Dio-based client with Retrofit
final radarr = RadarrAPI.from(
  host: 'https://radarr.example.com',
  apiKey: 'xxx',
);
final movies = await radarr.movie.getAll();
```

**Swift Target** - **USE OPENAPI SPECIFICATIONS** (`/docs/migration/design.md`):

**CRITICAL**: Prefer OpenAPI-generated clients over custom HTTP implementations.

1. **First**: Check if service has OpenAPI/Swagger specifications:

   - Radarr: API docs available at `/api/v3/swagger`
   - Sonarr: API docs available at `/api/v3/swagger`
   - Use Apple's `swift-openapi-generator` package (see `.github/instructions/Swift_OpenAPI_Generator.md`)

2. **Generate type-safe clients** using OpenAPI specs:

```swift
// Generated from OpenAPI spec
import OpenAPIURLSession

let client = Client(
    serverURL: try Servers.server1(),
    transport: URLSessionTransport()
)
let movies = try await client.getMovies()
```

3. **Only use custom URLSession calls** when:
   - Service lacks OpenAPI specification
   - Specification is incomplete or outdated
   - Custom behavior required beyond spec

**Benefits of OpenAPI approach**:

- Type-safe request/response models
- Auto-generated at build time (always in sync)
- Reduces manual HTTP code
- Better error handling and validation
- Matches spec-driven development workflow

### Multi-Profile Support

**Legacy**: Hive database with profile switching (`/legacy/lib/database/`)
**Swift**: SwiftData models with profile relationships

### Localization Patterns

**Legacy**: JSON files in `/legacy/assets/localization/` and `/legacy/localization/`

- Format: `"sonarr.AddSeries": "Add Series"`
- Structured per-service (e.g., `sonarr/en.json`)

**Swift**: Use legacy strings as reference for String catalogs

## Project-Specific Conventions

### Milestone Workflow

Follow the 6-milestone structure in `/docs/migration/tasks.md`:

1. **Foundation** (Weeks 1-3): Architecture, navigation, data layer
2. **Services 1** (Weeks 4-6): Radarr & Sonarr
3. **Services 2** (Weeks 7-9): Download clients (SABnzbd, NZBGet)
4. **Services 3** (Weeks 10-12): Tautulli, Overseerr, search
5. **Advanced** (Weeks 13-15): Calendar, notifications
6. **Polish** (Weeks 16-18): Testing, optimization, launch

### Code Organization

**Swift Module Structure** (target):

```
Thriftwood/
├── Core/
│   ├── Networking/    # APIClient, Endpoint
│   ├── Storage/       # SwiftData, Keychain
│   └── DI/            # Dependency injection
├── Services/
│   ├── Radarr/        # Movie management
│   ├── Sonarr/        # TV shows
│   └── ...
└── UI/
    ├── Components/    # Reusable views
    └── Screens/       # Feature screens
```

## Key Files & References

### Essential Legacy Files to Understand

- **`/legacy/CLAUDE.md`**: Original Flutter project documentation
- **`/legacy/lib/api/*/`**: API client implementations (Retrofit pattern)
- **`/legacy/lib/modules/*/`**: Feature modules (UI + logic per service)
- **`/legacy/lib/database/`**: Hive storage models (profiles, configs)

### Migration Documents

- **`/docs/migration/requirements.md`**: EARS requirements (WHEN/THEN format)
- **`/docs/migration/design.md`**: Swift architecture decisions
- **`/docs/migration/milestones/milestone-1-foundation.md`**: Current phase (foundation)

### CI/CD Configuration

- **`.github/workflows/ci.yml`**: Simple indie-focused CI (lint, build, test)
- **`.github/CI_README.md`**: CI documentation
- **`.swiftlint.yml`**: Linting rules

## Package Dependencies & Custom Implementations

### MANDATORY: Search Swift Package Manager First

**Before implementing ANY custom solution**, you MUST:

1. **Search Swift Package Manager** for existing, well-maintained packages
2. **Evaluate standard community solutions** (Alamofire, Swift Collections, etc.)
3. **Only implement custom code** if no suitable package exists or package adds excessive complexity

### Common Patterns - Use Packages

#### Dependency Injection

- ✅ **Use**: [Swinject](https://github.com/Swinject/Swinject), [Factory](https://github.com/hmlongco/Factory)
- ❌ **Don't**: Build custom DI container unless requirements are unique

#### HTTP Networking

- ✅ **Use**: [Alamofire](https://github.com/Alamofire/Alamofire) for complex needs, URLSession for simple cases
- ✅ **Use**: [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) for API specs (see design.md)
- ❌ **Don't**: Build custom HTTP client from scratch

#### JSON Handling

- ✅ **Use**: Built-in `Codable`, [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) for dynamic JSON
- ❌ **Don't**: Write custom JSON parsers

#### Keychain Access

- ✅ **Use**: [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
- ❌ **Don't**: Directly use Security framework APIs (error-prone)

#### Image Loading/Caching

- ✅ **Use**: [Kingfisher](https://github.com/onevcat/Kingfisher), [Nuke](https://github.com/kean/Nuke)
- ❌ **Don't**: Build custom image cache

#### Logging

- ✅ **Use**: [swift-log](https://github.com/apple/swift-log), [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)
- ❌ **Don't**: Use `print()` statements or custom loggers

#### Date/Time Formatting

- ✅ **Use**: Built-in `DateFormatter`, `ISO8601DateFormatter`, `RelativeDateTimeFormatter`
- ❌ **Don't**: Write custom date parsing logic

### Evaluation Criteria for Packages

When selecting a package, verify:

1. **Maintenance**: Active development (commits in last 3-6 months)
2. **Popularity**: High star count and real-world usage
3. **Swift 6 Compatibility**: Explicitly supports Swift 6 strict concurrency
4. **License**: Compatible with MIT/Apache 2.0 (avoid GPL)
5. **Dependencies**: Minimal dependency tree (avoid deep chains)
6. **Documentation**: Clear README, API docs, and examples
7. **Testing**: High test coverage and CI setup

### Search Process

```bash
# 1. Search GitHub for Swift packages
gh search repos "swift dependency injection" --language=swift --sort=stars

# 2. Check Swift Package Index
open "https://swiftpackageindex.com/search?query=dependency+injection"

# 3. Verify package quality
gh repo view Swinject/Swinject --json stargazerCount,pushedAt,license

# 4. Check Swift 6 compatibility in README/Package.swift
```

### When Custom Implementation Is Acceptable

Implement custom solutions ONLY when:

1. **No package exists** for the specific use case
2. **Package adds excessive bloat** (e.g., 10+ transitive dependencies)
3. **Performance requirements** demand optimized custom code
4. **Package is unmaintained** (no commits in 12+ months)
5. **Swift 6 incompatibility** and no migration path available

**Document the decision** using a Decision Record (see spec-driven-workflow):

```markdown
### Decision - [TIMESTAMP]

**Decision**: Implement custom [X] instead of using package [Y]
**Context**: Evaluated packages [list], but none met requirements because [reason]
**Rationale**: Custom implementation provides [benefits] without [package drawbacks]
**Trade-offs**: We accept [maintenance burden] in exchange for [performance/size/control]
**Review**: Re-evaluate when Swift 6 ecosystem matures (Q3 2025)
```

### Package.swift Management

- **Keep dependencies minimal**: Only add packages that solve real problems
- **Pin versions**: Use exact versions for stability (`from: "1.2.3"`)
- **Document why**: Add comments explaining each dependency's purpose
- **Regular audits**: Review dependencies quarterly for updates/alternatives

```swift
// filepath: Package.swift (example)
dependencies: [
    // HTTP networking - chosen for Combine integration and Swift 6 support
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),

    // API client generation from OpenAPI specs (Radarr, Sonarr)
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),

    // Keychain access - avoids Security framework boilerplate
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
]
```

## Common Gotchas

1. **Don't assume feature behavior** - Always check `/legacy` implementation first
2. **Profile support is critical** - Every service must support multiple instances via profiles
3. **Authentication varies** - Each service has different auth (API keys, basic auth, etc.)
4. **Error handling matters** - Legacy has detailed error messages per service; preserve UX
5. **Localization is extensive** - 20+ languages in legacy; maintain string keys

## Testing Strategy

- **Unit Tests**: Business logic, networking, data persistence (>80% coverage goal)
- **UI Tests**: Critical flows (profile switching, service config, media search)
- **Reference**: Legacy has comprehensive API coverage - match that scope

## Questions to Ask

When stuck, check:

1. How did the Flutter app handle this? (`/legacy/lib/`)
2. What do the requirements say? (`/docs/migration/requirements.md`)
3. What's the Swift architecture pattern? (`/docs/migration/design.md`)
4. Is this part of the current milestone? (`/docs/migration/milestones/*.md`)

## Tool Usage

- **GitHub CLI (`gh`)**: Always use `--json` flag + `jq` for reliable output parsing
- **OpenAPI Generator**: Use `swift-openapi-generator` for Radarr, Sonarr, and other services with OpenAPI specs
  - Reference: `.github/instructions/Swift_OpenAPI_Generator.md`
  - Add to Package.swift dependencies
  - Place OpenAPI specs in project (e.g., `openapi/radarr.yaml`)
  - Configure with `openapi-generator-config.yaml`
- **Fastlane**: iOS build automation (check `/legacy/ios/fastlane/` for patterns)
- **Swift Package Manager**: Dependency management (no CocoaPods in new app)

---

**Remember**: This is a migration, not a greenfield project. The Flutter app is your specification.
