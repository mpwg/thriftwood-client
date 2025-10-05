# Networking Architecture

## Overview

Thriftwood's networking layer follows ADR-0004's decision to use AsyncHTTPClient for HTTP communication. The architecture is designed to support multiple media management services (Radarr, Sonarr, Lidarr, etc.) with type-safe, testable HTTP clients.

## Current Status (Milestone 1)

### ✅ Completed

- **AsyncHTTPClient Integration**: HTTPClient registered in DIContainer as singleton
- **Dependency Injection**: HTTPClient available for injection into service implementations
- **Lifecycle Management**: HTTPClient shutdown handled in DIContainer.shutdown()

### 📋 Planned (Milestone 2+)

- **OpenAPI Client Generation**: For services with OpenAPI/Swagger specifications
- **Service Implementations**: Radarr, Sonarr, Lidarr, SABnzbd, NZBGet, Tautulli, Overseerr
- **Request/Response Models**: Generated from OpenAPI specs where available
- **Custom HTTP Clients**: For services without OpenAPI specifications

## Architecture Decisions

### ADR-0004: Use AsyncHTTPClient

**Decision**: Use AsyncHTTPClient (Swift Server Workgroup) over custom networking implementations.

**Rationale**:

- Production-ready framework built on SwiftNIO
- Native async/await support
- HTTP/2 and connection pooling
- Cross-platform (macOS, Linux, iOS)
- Active maintenance by Swift.org
- No custom wrapper needed - direct usage

**Implementation**:

```swift
// DIContainer.swift
container.register(HTTPClient.self) { _ in
    HTTPClient(eventLoopGroupProvider: .singleton)
}.inObjectScope(.container)
```

### OpenAPI-First Approach

**Per .github/copilot-instructions.md**: Prefer OpenAPI-generated clients over custom implementations.

**Process**:

1. Check if service has OpenAPI/Swagger specification
2. If yes: Use `swift-openapi-generator` to generate type-safe client
3. If no: Implement custom client using AsyncHTTPClient directly

**Dependencies Added**:

- `swift-openapi-generator` (build plugin)
- `swift-openapi-runtime` (runtime support)

**Status**: Prepared for Milestone 2, awaiting service implementations

## Service Implementation Pattern

### For Services WITH OpenAPI Specs (Radarr, Sonarr, Lidarr)

```swift
// 1. Add OpenAPI spec to project
// openapi/radarr.yaml

// 2. Configure openapi-generator-config.yaml
// 3. Build generates client automatically

// 4. Use generated client
import OpenAPIURLSession

final class RadarrService: MediaServiceProtocol {
    private let client: Client

    init(httpClient: HTTPClient, configuration: RadarrConfiguration) {
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
    }

    func getMovies() async throws -> [Movie] {
        let response = try await client.getMovies()
        return response.movies
    }
}
```

### For Services WITHOUT OpenAPI Specs

```swift
import AsyncHTTPClient

final class CustomService: ServiceProtocol {
    private let httpClient: HTTPClient
    private let baseURL: String
    private let apiKey: String

    init(httpClient: HTTPClient, configuration: ServiceConfiguration) {
        self.httpClient = httpClient
        self.baseURL = configuration.baseURL
        self.apiKey = configuration.apiKey
    }

    func getData() async throws -> Data {
        var request = HTTPClientRequest(url: "\(baseURL)/api/data")
        request.method = .GET
        request.headers.add(name: "X-Api-Key", value: apiKey)

        let response = try await httpClient.execute(request, timeout: .seconds(30))
        let data = try await response.body.collect(upTo: 10 * 1024 * 1024) // 10MB limit

        return Data(buffer: data)
    }
}
```

## Testing Strategy

### Unit Tests

```swift
import Testing
@testable import Thriftwood

@Suite("Service Tests")
struct ServiceTests {
    @Test("Fetches data successfully")
    func testFetchData() async throws {
        // Use in-memory HTTPClient for testing
        let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
        defer { try? await httpClient.shutdown() }

        let service = CustomService(httpClient: httpClient, configuration: testConfig)
        let data = try await service.getData()

        #expect(data != nil)
    }
}
```

### Mock Services

```swift
protocol MediaServiceProtocol {
    func getMovies() async throws -> [Movie]
}

final class MockMediaService: MediaServiceProtocol {
    var mockMovies: [Movie] = []
    var shouldThrowError = false

    func getMovies() async throws -> [Movie] {
        if shouldThrowError {
            throw ThriftwoodError.serviceUnavailable
        }
        return mockMovies
    }
}
```

## Migration from Flutter (Dio/Retrofit)

### Flutter Pattern (Legacy)

```dart
// lib/api/radarr/radarr.dart
final radarr = RadarrAPI.from(
  host: 'https://radarr.example.com',
  apiKey: 'xxx',
);
final movies = await radarr.movie.getAll();
```

### Swift Pattern (Target)

```swift
// Injected via DI
let radarrService = container.resolve((any MediaServiceProtocol).self)
let movies = try await radarrService.getMovies()
```

## Error Handling

All network errors are mapped to `ThriftwoodError`:

```swift
enum ThriftwoodError {
    case networkError(URLError)
    case apiError(statusCode: Int, message: String)
    case decodingError(DecodingError)
    case authenticationRequired
    case serviceUnavailable
    case invalidURL
    case invalidResponse
}
```

## Performance Considerations

- **Connection Pooling**: AsyncHTTPClient reuses connections automatically
- **HTTP/2**: Multiplexing reduces latency for multiple requests
- **Timeouts**: Default 30s timeout, configurable per request
- **Body Limits**: 10MB default limit to prevent memory exhaustion
- **Lifecycle**: Single HTTPClient instance per app lifetime

## Next Steps (Milestone 2)

1. **Add OpenAPI Specs**:

   - Download Radarr OpenAPI spec
   - Download Sonarr OpenAPI spec
   - Store in `openapi/` directory

2. **Configure Generation**:

   - Create `openapi-generator-config.yaml`
   - Configure types, operations, and package names

3. **Implement Services**:

   - RadarrService (OpenAPI)
   - SonarrService (OpenAPI)
   - SABnzbdService (custom)
   - NZBGetService (custom)

4. **Register in DI**:

   - Add service registrations to DIContainer
   - Inject HTTPClient into each service

5. **Write Tests**:
   - Unit tests for each service
   - Integration tests with mock servers
   - Error handling tests

## References

- [ADR-0004: Use AsyncHTTPClient](../decisions/0004-use-asynchttpclient-over-custom-networking.md)
- [AsyncHTTPClient Documentation](https://github.com/swift-server/async-http-client)
- [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator)
- [Copilot Instructions - Service API Translation](.github/copilot-instructions.md#service-api-translation-flutter--swift)
