# OpenAPI Tools Integration Guide

**Project**: Thriftwood (Flutter-to-Swift Migration)  
**Generator**: OpenAPI Generator (OpenAPITools/openapi-generator)  
**Version**: 7.16.0  
**Target**: Swift 6.x with URLSession  
**Date**: October 2025

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Generation Workflow](#generation-workflow)
- [Service Integration](#service-integration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

Thriftwood uses [OpenAPI Generator](https://github.com/OpenAPITools/openapi-generator) to generate Swift 6 API clients for multiple media management services (Radarr, Sonarr, Lidarr, etc.). This approach provides:

- **Type-safe API clients** with Swift 6 concurrency support
- **Committed source files** for code review and version control
- **Multi-service architecture** with clear separation
- **Class prefixes** to distinguish generated code from custom implementations

### Why OpenAPI Generator?

See [ADR-0006](architecture/decisions/0006-openapi-client-generation-strategy.md) for the complete architectural decision record comparing OpenAPI Generator vs. Apple's swift-openapi-generator.

## Installation

### Prerequisites

- macOS (for Swift development)
- Xcode 15+ with Swift 6 support
- Homebrew (recommended for installation)

### Install OpenAPI Generator

```bash
# Install via Homebrew (recommended)
brew install openapi-generator

# Verify installation
openapi-generator version
# Expected: 7.16.0 or later
```

**Alternative Installation Methods**:

```bash
# Via npm
npm install @openapitools/openapi-generator-cli -g

# Via Docker
docker pull openapitools/openapi-generator-cli

# Download JAR directly
# See: https://openapi-generator.tech/docs/installation
```

## Project Structure

```
thriftwood-client/
├── openapi/                          # OpenAPI specifications
│   ├── radarr-v3.yaml               # Radarr API spec (8,505 lines)
│   ├── radarr-config.yaml           # Radarr generator configuration
│   ├── sonarr-v3.yaml               # (Future) Sonarr API spec
│   └── sonarr-config.yaml           # (Future) Sonarr configuration
│
├── scripts/
│   ├── generate-openapi-clients.sh  # Automated generation script
│   └── sync-openapi-spec.sh         # Spec update automation
│
├── Thriftwood/Services/
│   ├── Radarr/
│   │   ├── Generated/               # Generated Swift 6 client
│   │   │   ├── RadarrAPI/
│   │   │   │   └── Classes/OpenAPIs/
│   │   │   │       ├── APIs/        # 76+ API endpoint classes (RadarrMovieAPI, etc.)
│   │   │   │       ├── Models/      # Codable model types
│   │   │   │       └── Infrastructure/  # Helper classes
│   │   │   ├── README.md            # Generated documentation
│   │   │   └── Package.swift        # SPM package definition
│   │   │
│   │   └── RadarrService.swift      # Custom service layer wrapper
│   │
│   └── Sonarr/                      # (Future) Similar structure
│
└── docs/
    ├── OPENAPI_TOOLS_INTEGRATION.md  # This guide
    └── architecture/decisions/
        └── 0006-openapi-client-generation-strategy.md  # ADR
```

## Configuration

### Configuration File Structure

Each service has its own YAML configuration file in `openapi/`:

**Example: `openapi/radarr-config.yaml`**

```yaml
# OpenAPI Generator Configuration for Radarr API
# Generator: swift6 (STABLE)
# Target: Swift 6.x with URLSession

# HTTP Client Library
library: urlsession

# Project Configuration
projectName: RadarrAPI
apiNamePrefix: Radarr # Prefixes API classes (RadarrMovieAPI, etc.)
useSPMFileStructure: false
swiftPackagePath: ""

# Response Handling
responseAs: AsyncAwait # Use Swift async/await

# Model Configuration
hashableModels: true # Models conform to Hashable
identifiableModels: true # Models conform to Identifiable (when ID present)
validatable: true # Enable model validation
generateModelAdditionalProperties: true
sortModelPropertiesByRequiredFlag: true

# Enum Handling
enumUnknownDefaultCase: true # Handle unknown enum values gracefully
oneOfUnknownDefaultCase: false

# Code Generation
hideGenerationTimestamp: false # Include timestamp in README (for tracking)
ensureUniqueParams: true
sortParamsByRequiredFlag: true
# Access Control
# nonPublicApi: false              # Use default (public APIs)

# Additional Options
# useClasses: false                # Use structs (default)
# readonlyProperties: false
# objcCompatible: false
```

### Configuration Options Explained

| Option                    | Value        | Purpose                                              |
| ------------------------- | ------------ | ---------------------------------------------------- |
| `library`                 | `urlsession` | Use native iOS URLSession (no external dependencies) |
| `apiNamePrefix`           | `Radarr`     | Prefix all API class names to distinguish services   |
| `responseAs`              | `AsyncAwait` | Generate modern Swift async/await code               |
| `hashableModels`          | `true`       | Models can be used in Sets/Dictionaries              |
| `identifiableModels`      | `true`       | Models conform to Identifiable (SwiftUI friendly)    |
| `enumUnknownDefaultCase`  | `true`       | Gracefully handle unknown enum values from API       |
| `hideGenerationTimestamp` | `false`      | Show generation timestamp in README.md               |

**Full configuration reference**: Run `openapi-generator config-help -g swift6` for all options.

## Generation Workflow

### Automated Generation (Recommended)

Use the provided script to generate clients for all services:

```bash
# Generate all services
./scripts/generate-openapi-clients.sh

# Output:
# ✓ Radarr client generated successfully
#   Generated 221 Swift files
```

**What the script does**:

1. Validates OpenAPI specs exist
2. Runs `openapi-generator` for each service
3. Uses `--skip-validate-spec` to bypass spec validation issues
4. Reports success/failure with file counts
5. Provides next steps (build, test, commit)

### Manual Generation

For individual service generation or debugging:

```bash
# Navigate to project root
cd /path/to/thriftwood-client

# Generate Radarr client
openapi-generator generate \
  -i openapi/radarr-v3.yaml \
  -g swift6 \
  -o Thriftwood/Services/Radarr/Generated \
  -c openapi/radarr-config.yaml \
  --skip-validate-spec

# View generated files
ls -R Thriftwood/Services/Radarr/Generated/
```

### Generation Output

After successful generation, you'll have:

```
Thriftwood/Services/Radarr/Generated/
├── RadarrAPI/Classes/OpenAPIs/
│   ├── APIs/
│   │   ├── RadarrMovieAPI.swift           # Movie management endpoints
│   │   ├── RadarrQueueAPI.swift           # Download queue endpoints
│   │   ├── RadarrCommandAPI.swift         # System commands
│   │   └── ... (76+ API classes)
│   │
│   ├── Models/
│   │   ├── MovieResource.swift            # Movie data model
│   │   ├── QueueResource.swift            # Queue item model
│   │   └── ... (145+ model classes)
│   │
│   └── Infrastructure/
│       ├── APIHelper.swift                # URL/request helpers
│       ├── URLSessionImplementations.swift # HTTP client
│       ├── CodableHelper.swift            # JSON encoding/decoding
│       └── ... (helper classes)
│
├── README.md                              # Generated documentation
├── Package.swift                          # SPM package (for reference)
└── .openapi-generator/                    # Generator metadata
```

### Class Prefix Behavior

With `apiNamePrefix: Radarr`, the generator adds prefixes to:

✅ **API classes** (service endpoints):

- `AlternativeTitleAPI` → `RadarrAlternativeTitleAPI`
- `MovieAPI` → `RadarrMovieAPI`
- `QueueAPI` → `RadarrQueueAPI`

ℹ️ **Model classes remain unprefixed**:

- `MovieResource` (not `RadarrMovieResource`)
- `QueueResource` (not `RadarrQueueResource`)

**Rationale**: Models are data transfer objects that could potentially be shared across services if data structures are compatible.

## Service Integration

### Step 1: Add Generated Files to Xcode

1. Open `Thriftwood.xcodeproj` in Xcode
2. Right-click `Thriftwood/Services/Radarr/` in Project Navigator
3. Select **Add Files to "Thriftwood"...**
4. Navigate to `Thriftwood/Services/Radarr/Generated/RadarrAPI/Classes/OpenAPIs/`
5. Select **APIs**, **Models**, and **Infrastructure** folders
6. Check **"Create groups"** and **"Add to targets: Thriftwood"**
7. Click **Add**

### Step 2: Create Service Layer Wrapper

**Don't use generated API classes directly in UI code.** Instead, create a service layer wrapper:

**`Thriftwood/Services/Radarr/RadarrService.swift`:**

```swift
//
//  RadarrService.swift
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

import Foundation

/// Service layer for Radarr API interactions
@Observable
final class RadarrService {
    // MARK: - Properties

    private let configuration: RadarrAPIAPIConfiguration
    private let movieAPI: RadarrMovieAPI
    private let queueAPI: RadarrQueueAPI

    // MARK: - Initialization

    init(baseURL: String, apiKey: String) {
        // Configure API client
        self.configuration = RadarrAPIAPIConfiguration(
            basePath: baseURL,
            credential: nil,
            headerParameters: ["X-Api-Key": apiKey]
        )

        // Initialize API clients
        self.movieAPI = RadarrMovieAPI()
        self.queueAPI = RadarrQueueAPI()
    }

    // MARK: - Public Methods

    /// Fetch all movies from Radarr
    func fetchMovies() async throws -> [MovieResource] {
        try await movieAPI.apiV3MovieGet(
            apiConfiguration: configuration
        )
    }

    /// Fetch download queue
    func fetchQueue(page: Int = 1, pageSize: Int = 20) async throws -> QueueResourcePagingResource {
        try await queueAPI.apiV3QueueGet(
            page: page,
            pageSize: pageSize,
            apiConfiguration: configuration
        )
    }

    /// Add a movie to Radarr
    func addMovie(_ movie: MovieResource) async throws -> MovieResource {
        try await movieAPI.apiV3MoviePost(
            movieResource: movie,
            apiConfiguration: configuration
        )
    }
}
```

### Step 3: Register with Dependency Injection

**`Thriftwood/Core/DI/Container.swift`:**

```swift
extension Container {
    func registerRadarrService() {
        register(RadarrService.self) { resolver in
            // Get credentials from Keychain or profile
            let profile = resolver.resolve(ProfileService.self)!
            let radarrProfile = profile.currentProfile.radarrConfig

            return RadarrService(
                baseURL: radarrProfile.baseURL,
                apiKey: radarrProfile.apiKey
            )
        }
        .inObjectScope(.container) // Singleton
    }
}
```

### Step 4: Use in ViewModels

**`Thriftwood/UI/Radarr/ViewModels/MovieListViewModel.swift`:**

```swift
@Observable
final class MovieListViewModel {
    // MARK: - Properties

    private let radarrService: RadarrService
    var movies: [MovieResource] = []
    var isLoading = false
    var error: Error?

    // MARK: - Initialization

    init(radarrService: RadarrService) {
        self.radarrService = radarrService
    }

    // MARK: - Methods

    @MainActor
    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }

        do {
            movies = try await radarrService.fetchMovies()
        } catch {
            self.error = error
        }
    }
}
```

## Best Practices

### DO ✅

1. **Use service layer wrappers** - Don't call generated API classes directly from UI
2. **Commit generated files** - Include in version control for code review
3. **Regenerate when specs change** - Keep clients in sync with API changes
4. **Add class prefixes** - Use `apiNamePrefix` to distinguish service clients
5. **Include timestamps** - Set `hideGenerationTimestamp: false` for tracking
6. **Validate before merging** - Run tests after regeneration
7. **Use async/await** - Configure `responseAs: AsyncAwait` for modern Swift
8. **Enable model features** - Use `hashableModels`, `identifiableModels` for SwiftUI
9. **Handle unknown enums** - Set `enumUnknownDefaultCase: true` for API evolution

### DON'T ❌

1. **Don't modify generated files** - Changes will be lost on regeneration
2. **Don't use build-time generation** - Commit generated files instead
3. **Don't skip validation** - Run tests after regeneration
4. **Don't ignore warnings** - Check generator output for issues
5. **Don't share model classes** - Even if structures match, keep services independent
6. **Don't hardcode credentials** - Use Keychain and profile management
7. **Don't mix service concerns** - Keep Radarr, Sonarr, etc. separate

## Troubleshooting

### OpenAPI Spec Validation Errors

**Problem**: Generator fails with validation errors like:

```
attribute components.schemas.Resource.additionalProperties is not of type `object`
```

**Solution**: Use `--skip-validate-spec` flag (already in generation script):

```bash
openapi-generator generate \
  ... \
  --skip-validate-spec
```

### Empty Operation IDs

**Warning**: `Empty operationId found for path: get /api/v3/movie`

**Impact**: Generator auto-generates operation IDs (e.g., `apiV3MovieGet`)  
**Solution**: This is non-blocking and expected for some APIs. Generated names are still functional.

### Missing Timestamps

**Problem**: No timestamp in generated files

**Check**: Verify `hideGenerationTimestamp: false` in config file  
**Location**: Timestamp appears in `Generated/README.md` under "Build date"

### Xcode Build Errors

**Problem**: Compilation errors after adding generated files

**Common causes**:

1. Missing files (didn't add all folders)
2. File conflicts (multiple targets)
3. Swift version mismatch

**Solution**:

```bash
# Clean build folder
xcodebuild clean -project Thriftwood.xcodeproj -scheme Thriftwood

# Rebuild
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood
```

### URLSession Configuration Issues

**Problem**: API calls fail with authentication errors

**Check service layer configuration**:

```swift
RadarrAPIAPIConfiguration(
    basePath: baseURL,           // ✅ Correct: "https://radarr.example.com"
    credential: nil,             // ❌ Don't use basic auth
    headerParameters: [
        "X-Api-Key": apiKey      // ✅ Radarr uses header-based auth
    ]
)
```

### Generator Not Found

**Problem**: `command not found: openapi-generator`

**Solution**:

```bash
# Check installation
which openapi-generator

# Reinstall if missing
brew reinstall openapi-generator

# Or install via npm
npm install -g @openapitools/openapi-generator-cli
```

## Updating OpenAPI Specifications

### Automated Sync (Recommended)

Use the sync script to update specs from official repositories:

```bash
./scripts/sync-openapi-spec.sh radarr
./scripts/sync-openapi-spec.sh sonarr
```

### Manual Update

```bash
# Download latest Radarr spec
curl -o openapi/radarr-v3.yaml \
  https://raw.githubusercontent.com/Radarr/Radarr/develop/src/Radarr.Api.V3/openapi.json

# Convert JSON to YAML if needed
python3 -c 'import sys, yaml, json; yaml.dump(json.load(sys.stdin), sys.stdout)' \
  < openapi/radarr-v3.json > openapi/radarr-v3.yaml

# Regenerate client
./scripts/generate-openapi-clients.sh

# Test and commit
git add openapi/radarr-v3.yaml Thriftwood/Services/Radarr/Generated/
git commit -m "chore(openapi): update Radarr API spec to latest version"
```

## Adding New Services

To add a new service (e.g., Sonarr):

1. **Obtain OpenAPI spec**:

   ```bash
   # Download from official repo or Sonarr instance
   curl -o openapi/sonarr-v3.yaml \
     https://sonarr.example.com/api/v3/swagger.json
   ```

2. **Create configuration**:

   ```bash
   cp openapi/radarr-config.yaml openapi/sonarr-config.yaml
   # Edit: Change projectName to "SonarrAPI", apiNamePrefix to "Sonarr"
   ```

3. **Update generation script**:

   ```bash
   # Add Sonarr to scripts/generate-openapi-clients.sh
   # Follow the existing Radarr pattern
   ```

4. **Generate client**:

   ```bash
   ./scripts/generate-openapi-clients.sh
   ```

5. **Create service wrapper**:

   ```bash
   # Create Thriftwood/Services/Sonarr/SonarrService.swift
   # Follow RadarrService.swift pattern
   ```

6. **Add to Xcode and register with DI**

## Resources

- **OpenAPI Generator Docs**: https://openapi-generator.tech/docs/generators/swift6
- **Swift 6 Generator GitHub**: https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator/src/main/resources/swift6
- **Radarr API Docs**: https://radarr.video/docs/api
- **Sonarr API Docs**: https://sonarr.tv/docs/api
- **ADR-0006**: `docs/architecture/decisions/0006-openapi-client-generation-strategy.md`

## Support

For issues specific to:

- **OpenAPI Generator**: https://github.com/OpenAPITools/openapi-generator/issues
- **Thriftwood Integration**: Create issue in project repository
- **API Specs**: Check service's official documentation/repository

---

**Last Updated**: October 6, 2025  
**Generator Version**: 7.16.0  
**Swift Version**: 6.x
