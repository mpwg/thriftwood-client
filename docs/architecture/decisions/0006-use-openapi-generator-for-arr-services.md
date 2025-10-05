---
status: accepted
date: 2025-10-05
decision-makers: Matthias Wallner Géhri
---

# Use OpenAPI Generator for \*arr Service Clients

## Context and Problem Statement

The \*arr services (Radarr, Sonarr, Lidarr) provide comprehensive OpenAPI/Swagger specifications for their APIs at `/api/v3/swagger`. How should we implement HTTP clients for these services? Should we manually code request/response models and endpoints, or leverage OpenAPI code generation for type-safe, spec-driven clients?

This decision impacts Milestone 2 (Radarr, Sonarr), Milestone 4 (Lidarr), and sets precedent for future service integrations.

## Decision Drivers

- **Type Safety**: Compile-time guarantees for API requests/responses reduce runtime errors
- **Maintainability**: API changes reflected in generated code, not manual updates
- **Spec-Driven Development**: Aligns with project's specification-driven workflow (see `.github/instructions/spec-driven-workflow-v1.instructions.md`)
- **Reduced Boilerplate**: Eliminate ~300+ lines of manual model/endpoint definitions per service
- **Testing**: Auto-generated protocol-based interfaces enable easy mocking
- **Swift 6 Compatibility**: Generated code must support strict concurrency checking
- **Package Philosophy**: Prefer Apple's official packages over third-party or custom solutions
- **Build Integration**: Generation must integrate with Xcode build system

## Considered Options

- **Option 1**: Swift OpenAPI Generator (Apple) with URLSession transport
- **Option 2**: Manual AsyncHTTPClient implementation with Codable models
- **Option 3**: Third-party OpenAPI generator (OpenAPI Generator CLI)
- **Option 4**: Hybrid approach (generated models, custom HTTP layer)

## Decision Outcome

Chosen option: **Option 1 - Swift OpenAPI Generator**

Apple's swift-openapi-generator provides native Swift 6 support, integrates with the build system, and generates idiomatic Swift code directly from OpenAPI specifications. This aligns with the project's "use packages first" philosophy and spec-driven workflow.

### Consequences

- **Good**: Type-safe API clients generated at build time
- **Good**: API changes cause compile-time errors (not runtime failures)
- **Good**: Reduces manual HTTP/model code by ~70%
- **Good**: Official Apple package with Swift 6 concurrency support
- **Good**: Integrated with Xcode build system (no external tools)
- **Good**: Auto-updates when OpenAPI spec changes
- **Good**: Generated code includes API documentation
- **Good**: Protocol-based design enables easy mocking for tests
- **Neutral**: Requires maintaining OpenAPI spec files in repo
- **Neutral**: Generated code must be reviewed (but not edited)
- **Bad**: Learning curve for OpenAPI Generator configuration
- **Bad**: Build time increases slightly (generation step)
- **Bad**: Cannot use for services without OpenAPI specs (SABnzbd, NZBGet)

### Implementation Approach

#### 1. Add Dependencies

Already completed in Milestone 1:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.10.3"),
    .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.8.3"),
]
```

#### 2. Obtain OpenAPI Specifications

```bash
# Radarr API spec
curl https://radarr.video/docs/api/v3/openapi.json > openapi/radarr-v3.yaml

# Sonarr API spec
curl https://sonarr.tv/docs/api/v3/openapi.json > openapi/sonarr-v3.yaml

# Lidarr API spec
curl https://lidarr.audio/docs/api/v1/openapi.json > openapi/lidarr-v1.yaml

# Overseerr API spec (check https://api-docs.overseerr.dev for OpenAPI spec download)
# May be available at: https://api-docs.overseerr.dev/openapi.json
```

#### 3. Configure Generator

```yaml
# openapi-generator-config.yaml
generate:
  - types
  - client
accessModifier: public
additionalImports:
  - Foundation
```

#### 4. Use Generated Client

```swift
import OpenAPIRuntime
import OpenAPIURLSession

final class RadarrService: ObservableObject {
    private let client: APIClient

    init(baseURL: URL, apiKey: String) throws {
        self.client = Client(
            serverURL: baseURL,
            transport: URLSessionTransport(),
            middlewares: [
                AuthenticationMiddleware(apiKey: apiKey)
            ]
        )
    }

    func getMovies() async throws -> [Movie] {
        let response = try await client.getMovies()
        return response.body.json.movies
    }

    func addMovie(_ movie: AddMovieRequest) async throws -> Movie {
        let response = try await client.addMovie(body: .json(movie))
        return response.body.json
    }
}
```

#### 5. Testing with Generated Protocols

```swift
protocol RadarrAPIClient {
    func getMovies() async throws -> MoviesResponse
    func addMovie(body: AddMovieRequest) async throws -> MovieResponse
}

// Generated client conforms to protocol automatically
extension Client: RadarrAPIClient {}

// Mock for testing
final class MockRadarrClient: RadarrAPIClient {
    var moviesResponse: MoviesResponse?

    func getMovies() async throws -> MoviesResponse {
        guard let response = moviesResponse else {
            throw TestError.notConfigured
        }
        return response
    }
}
```

## Pros and Cons of the Options

### Option 1: Swift OpenAPI Generator

- **Good**: Official Apple package, Swift 6 native
- **Good**: Build-time generation (no manual updates)
- **Good**: Type-safe, spec-driven development
- **Good**: Automatic API documentation
- **Good**: Protocol-based design for testing
- **Good**: Integrates with existing AsyncHTTPClient (via URLSession transport)
- **Neutral**: Requires OpenAPI specs in repository
- **Bad**: Not usable for services without OpenAPI specs
- **Bad**: Adds build-time generation step

### Option 2: Manual AsyncHTTPClient Implementation

- **Good**: Full control over implementation
- **Good**: Works for any API (spec or no spec)
- **Good**: No code generation dependencies
- **Neutral**: Direct use of AsyncHTTPClient (per ADR-0004)
- **Bad**: Manual model definitions (error-prone)
- **Bad**: No compile-time API validation
- **Bad**: ~300+ lines of boilerplate per service
- **Bad**: Manual updates when API changes

### Option 3: Third-Party OpenAPI Generator

- **Good**: Supports more OpenAPI features
- **Good**: Customizable templates
- **Neutral**: External CLI tool (not Xcode-integrated)
- **Bad**: Not officially supported by Apple
- **Bad**: May not support Swift 6 concurrency
- **Bad**: Additional toolchain dependencies
- **Bad**: Non-idiomatic Swift output

### Option 4: Hybrid Approach

- **Good**: Generated models reduce boilerplate
- **Good**: Custom HTTP layer for flexibility
- **Neutral**: Mix of generated and manual code
- **Bad**: Complexity of maintaining both
- **Bad**: No end-to-end type safety
- **Bad**: Violates "use packages first" principle

## Service Applicability

### ✅ Use OpenAPI Generator

- **Radarr**: OpenAPI v3 spec available (`/api/v3/swagger`)
- **Sonarr**: OpenAPI v3 spec available (`/api/v3/swagger`)
- **Lidarr**: OpenAPI v1 spec available (`/api/v1/swagger`)
- **Overseerr**: OpenAPI spec available (GitHub repo)

### ❌ Use Manual AsyncHTTPClient

- **SABnzbd**: No OpenAPI spec (custom XML-based API)
- **NZBGet**: JSON-RPC API (not REST, no OpenAPI)
- **Tautulli**: Custom REST API (no OpenAPI spec)

## More Information

- **Related ADRs**:
  - ADR-0004: Use AsyncHTTPClient - OpenAPI clients use URLSessionTransport (which can wrap AsyncHTTPClient if needed)
  - ADR-0003: Dependency Injection - Generated clients will be registered in DIContainer
- **References**:
  - [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator)
  - [Swift OpenAPI Runtime](https://github.com/apple/swift-openapi-runtime)
  - [Radarr API Docs](https://radarr.video/docs/api/)
  - [Sonarr API Docs](https://sonarr.tv/docs/api/)
  - [Overseerr API Docs](https://api-docs.overseerr.dev)
  - `.github/copilot-instructions.md` - OpenAPI-first guidance
  - `.github/instructions/Swift_OpenAPI_Generator.md` - Usage patterns
- **Implementation Timeline**:
  - Milestone 2 Week 4: Radarr OpenAPI integration
  - Milestone 2 Week 5: Sonarr OpenAPI integration
  - Milestone 4 Week 11: Lidarr OpenAPI integration
- **Review Date**: After Milestone 2 completion (Week 6) - evaluate effectiveness and developer experience
