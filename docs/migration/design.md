# Thriftwood Technical Design

## Architecture Overview

### Design Pattern: MVVM-C (Model-View-ViewModel-Coordinator)

```
┌─────────────────────────────────────────────────┐
│                  SwiftUI Views                   │
├─────────────────────────────────────────────────┤
│                  ViewModels                      │
│            (@Observable, @MainActor)             │
├─────────────────────────────────────────────────┤
│                Domain Models                     │
├─────────────────────────────────────────────────┤
│              Service Layer                       │
│        (API Clients, Repositories)               │
├─────────────────────────────────────────────────┤
│           Infrastructure Layer                   │
│    (Networking, Storage, Security)               │
└─────────────────────────────────────────────────┘
```

## Core Components

### 1. Navigation System

- **Coordinator Pattern**: Centralized navigation logic
- **NavigationStack**: SwiftUI native navigation
- **DeepLink Support**: Handle URL schemes and Universal Links

### 2. Dependency Injection

- **Container-based DI**: Using Swift 6 features
- **Protocol-oriented**: Testable and mockable services
- **Environment injection**: SwiftUI environment values

### 3. Networking Layer

```swift
protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]?
    let body: Encodable?
}
```

### 4. Data Models

- **Codable models**: For API responses
- **SwiftData models**: For persistence
- **Domain models**: Clean architecture separation

### 5. State Management

- **@Observable**: Swift 6 observation framework
- **@State/@Binding**: Local UI state
- **@Environment**: Shared dependencies

## Service Architecture

### Base Service Protocol

```swift
protocol MediaService {
    associatedtype Configuration: ServiceConfiguration
    associatedtype Item: MediaItem

    func configure(_ config: Configuration) async throws
    func fetchItems() async throws -> [Item]
    func search(query: String) async throws -> [Item]
    func add(item: Item) async throws
    func update(item: Item) async throws
    func delete(item: Item) async throws
}
```

### Service Implementations

- **RadarrService**: Movie management
- **SonarrService**: TV show management
- **LidarrService**: Music management
- **SABnzbdService**: Usenet downloads
- **NZBGetService**: Alternate downloader
- **TautulliService**: Plex monitoring
- **OverseerrService**: Media requests

## Data Flow

### Unidirectional Data Flow

```
User Action → View → ViewModel → Service → API
                ↑                           ↓
            UI Update ← ViewModel ← Response
```

### Async/Await Pattern

```swift
@Observable
class MediaViewModel {
    func loadContent() async {
        do {
            isLoading = true
            items = try await service.fetchItems()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
```

## Error Handling

### Error Types

```swift
enum ThriftwoodError: LocalizedError {
    case networkError(URLError)
    case apiError(statusCode: Int, message: String)
    case decodingError(DecodingError)
    case authenticationRequired
    case serviceUnavailable

    var errorDescription: String? {
        // Localized descriptions
    }
}
```

### Recovery Strategies

- **Automatic retry**: With exponential backoff
- **Offline mode**: Cache and queue operations
- **User notification**: Clear error messages

## Security Design

### Credential Storage

- **Keychain Services**: For API keys and passwords
- **Biometric authentication**: Optional protection
- **Certificate pinning**: For enhanced security

### Data Protection

```swift
@propertyWrapper
struct Secure<T: Codable> {
    private let key: String

    var wrappedValue: T? {
        get { KeychainService.shared.load(key) }
        set { KeychainService.shared.save(newValue, for: key) }
    }
}
```

## Testing Strategy

### Unit Tests

- ViewModels: Business logic validation
- Services: API interaction mocking
- Models: Encoding/Decoding verification

### Integration Tests

- End-to-end service communication
- Data persistence workflows
- Authentication flows

### UI Tests

- Critical user journeys
- Accessibility validation
- Performance benchmarks

## Performance Optimizations

### Image Loading

- Lazy loading with AsyncImage
- Memory and disk caching
- Progressive loading for large images

### List Performance

- LazyVStack/LazyVGrid usage
- Pagination for large datasets
- View recycling optimization

### Background Tasks

- Background refresh for updates
- Download continuation
- Notification scheduling
