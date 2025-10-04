# AsyncHTTPClient Integration

## Status: ✅ Successfully Integrated - Use Directly

AsyncHTTPClient from Swift Server Workgroup has been successfully added to the Thriftwood project. **Use it directly** - no custom wrappers needed.

## Package Information

- **Package**: [swift-server/async-http-client](https://github.com/swift-server/async-http-client)
- **Version**: 1.28.0
- **Documentation**: [Swift Package Index](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient)

## Why AsyncHTTPClient?

AsyncHTTPClient is the **industry-standard HTTP client** for Swift server and cross-platform applications, providing:

- **Fully async/await** native Swift concurrency support
- **Built on SwiftNIO** - proven, high-performance networking
- **HTTP/2 support** - modern protocol support
- **Connection pooling** - efficient resource management
- **Streaming support** - handle large responses efficiently
- **TLS/SSL** - secure connections with certificate validation
- **Timeout handling** - configurable request and response timeouts
- **Redirect handling** - automatic or manual redirect control

## Why No Custom Wrapper?

AsyncHTTPClient is **complete and production-ready**. Creating a custom `APIClient` protocol wrapper would:

- ❌ Add unnecessary abstraction
- ❌ Increase maintenance burden
- ❌ Hide AsyncHTTPClient's features
- ❌ Make debugging harder
- ❌ Violate "use standard frameworks" principle

Instead: ✅ **Use AsyncHTTPClient directly in services**

## Direct Usage

### Basic Usage Pattern

```swift
import AsyncHTTPClient
import HTTPTypes

// 1. Register HTTPClient in DI container (AppDelegate or similar)
container.register(HTTPClient.self) { _ in
    HTTPClient(
        eventLoopGroupProvider: .singleton,
        configuration: HTTPClient.Configuration(
            timeout: HTTPClient.Configuration.Timeout(
                connect: .seconds(10),
                read: .seconds(30)
            ),
            redirectConfiguration: .follow(max: 5, allowCycles: false)
        )
    )
}.inObjectScope(.container)

// 2. Use directly in service implementations (Milestone 2)
actor RadarrService {
    private let httpClient: HTTPClient
    private let baseURL: String
    private let apiKey: String

    init(httpClient: HTTPClient, profile: ServiceProfile) {
        self.httpClient = httpClient
        self.baseURL = profile.baseURL
        self.apiKey = profile.apiKey
    }

    func getMovies() async throws -> [Movie] {
        // Create request with HTTPTypes
        var request = HTTPClientRequest(url: "\(baseURL)/api/v3/movie")
        request.method = .GET
        request.headers.add(name: "X-Api-Key", value: apiKey)

        // Execute request
        let response = try await httpClient.execute(request, timeout: .seconds(30))

        // Handle response
        guard response.status == .ok else {
            throw ThriftwoodError.apiError(
                code: response.status.code,
                message: "Failed to fetch movies"
            )
        }

        // Stream body data
        let body = try await response.body.collect(upTo: 10 * 1024 * 1024) // 10MB max

        // Decode JSON
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Movie].self, from: Data(buffer: body))
    }
}
```

## Testing with Direct Usage

```swift
import Testing
@testable import Thriftwood

@Suite("Radarr Service Tests")
struct RadarrServiceTests {
    // Use real HTTPClient with mock server for integration tests
    @Test("Fetch movies returns valid data")
    func testFetchMovies() async throws {
        let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
        defer { try? httpClient.syncShutdown() }

        let profile = ServiceProfile(
            baseURL: "http://localhost:7878",
            apiKey: "test-key"
        )

        let service = RadarrService(
            httpClient: httpClient,
            profile: profile
        )

        // Start mock server or use real test instance
        let movies = try await service.getMovies()
        #expect(!movies.isEmpty)
    }
}
```

## Error Handling

AsyncHTTPClient integrates naturally with `ThriftwoodError`:

```swift
func performRequest<T: Decodable>(
    _ request: HTTPClientRequest,
    as type: T.Type
) async throws -> T {
    do {
        let response = try await httpClient.execute(request, timeout: .seconds(30))

        guard response.status == .ok else {
            // Map HTTP errors to ThriftwoodError
            throw ThriftwoodError.apiError(
                code: response.status.code,
                message: response.status.reasonPhrase
            )
        }

        let body = try await response.body.collect(upTo: 10 * 1024 * 1024)
        return try JSONDecoder().decode(T.self, from: Data(buffer: body))

    } catch let error as HTTPClientError {
        // Map connection errors
        throw ThriftwoodError.networkError(error.localizedDescription)
    } catch {
        throw error // Re-throw ThriftwoodError or decoding errors
    }
}
```

## Configuration Options

### Production Configuration

```swift
HTTPClient.Configuration(
    // TLS configuration
    tlsConfiguration: .makeClientConfiguration(),

    // Redirect handling
    redirectConfiguration: .follow(max: 5, allowCycles: false),

    // Timeout settings
    timeout: HTTPClient.Configuration.Timeout(
        connect: .seconds(10),
        read: .seconds(30)
    ),

    // Connection pool
    connectionPool: HTTPClient.Configuration.ConnectionPool(
        idleTimeout: .seconds(60),
        concurrentHTTP1ConnectionsPerHostSoftLimit: 8
    ),

    // Proxy settings (if needed)
    proxy: nil,

    // HTTP version preference
    httpVersion: .automatic // Prefers HTTP/2
)
```

### Testing Configuration

```swift
HTTPClient.Configuration(
    timeout: HTTPClient.Configuration.Timeout(
        connect: .seconds(5),
        read: .seconds(10)
    ),
    redirectConfiguration: .disallow,
    httpVersion: .http1Only // Simpler for local testing
)
```

## Benefits Summary

✅ **Industry-standard client** - used by Vapor, Hummingbird, and major Swift projects  
✅ **Feature-complete** - HTTP/2, streaming, connection pooling, TLS  
✅ **Well-tested** - extensive test suite and production usage  
✅ **Active maintenance** - Swift Server Workgroup support  
✅ **Excellent documentation** - comprehensive API docs and examples  
✅ **Performance** - built on SwiftNIO for high throughput  
✅ **Type-safe** - integrates with HTTPTypes for compile-time safety  
✅ **No custom wrappers needed** - use directly in services

## Next Steps

1. **Milestone 2 (Week 4-6)**: Implement Radarr and Sonarr services using AsyncHTTPClient directly
2. **OpenAPI Integration**: Combine with `swift-openapi-generator` for type-safe API clients
3. **Service Layer**: Inject HTTPClient via Swinject, use in service implementations
4. **Testing**: Write integration tests using real HTTPClient with mock servers

## References

- [AsyncHTTPClient Documentation](https://swiftpackageindex.com/swift-server/async-http-client/main/documentation/asynchttpclient)
- [HTTPTypes Documentation](https://swiftpackageindex.com/apple/swift-http-types/main/documentation/httptypes)
- [Swift Server Workgroup](https://github.com/swift-server)
- [OpenAPI Generator Integration](https://github.com/apple/swift-openapi-generator)

---

**Date**: 2025-10-04  
**Status**: ✅ Complete - Ready for direct usage in Milestone 2  
**Build Status**: ✅ All dependencies resolved and building successfully
