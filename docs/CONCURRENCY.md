# Concurrency Approach in Thriftwood

## Swift 6.2 Approachable Concurrency

This project uses **Approachable Concurrency**, a feature introduced in Swift 6.2 and
Xcode 16.2 that makes Swift's concurrency checking more pragmatic and less strict.

### What is Approachable Concurrency?

Approachable Concurrency is Swift's acknowledgment that:

1. Not all code needs to be perfectly strict about concurrency
2. Traditional synchronization primitives (locks, serial queues) are valid and safe
3. Excessive isolation annotations (`@MainActor`, `nonisolated`, etc.) can make code
   harder to read
4. Developers should be trusted to use locks correctly without compiler enforcement

**Key Resource**: [What is Approachable Concurrency in Xcode 16.2?](https://www.donnywals.com/what-is-approachable-concurrency-in-xcode-26/)

### How We Use It

With Approachable Concurrency enabled:

- **No `@preconcurrency`** - This is an old attribute for gradual migration, not needed
  with Approachable Concurrency
- **No `@unchecked Sendable`** - We don't need to bypass safety checks
- **No `nonisolated(unsafe)`** - We don't need to mark storage as unsafe
- **Traditional locks work naturally** - `NSLock`, `DispatchQueue`, etc. just work
- **Less ceremony, more clarity** - Code is simpler and more maintainable

### Pattern: Lock-Based DependencyContainer

With Approachable Concurrency, we still need some isolation annotations, but they're simpler:

```swift
final class DependencyContainer: Sendable {
    nonisolated(unsafe) private var services: [String: Any] = [:]
    private let lock = NSLock()

    nonisolated func register<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        // Accessing nonisolated(unsafe) storage from nonisolated method
        services[String(describing: type)] = instance
    }
}
```

Key points:

- `nonisolated(unsafe)` on mutable storage that's protected by a lock
- `nonisolated` on methods so they can be called from any context
- Lock ensures thread safety at runtime
- Approachable Concurrency makes this less ceremonious than Swift 6.0

### When to Still Use Isolation

We still use actors and `@MainActor` when appropriate:

- **Actors**: For types that naturally need serialized access (e.g., complex stateful
  services)
- **@MainActor**: For UI components that must run on the main thread
- **async/await**: For asynchronous operations that benefit from structured concurrency

### Guidelines

1. **Default to simplicity**: Use locks and queues for synchronization without annotations
2. **Use actors when natural**: When a type's purpose is to serialize access to state
3. **Use @MainActor for UI**: UI code should be explicitly main-thread
4. **Trust the compiler**: With Approachable Concurrency, less annotation is better
5. **Document assumptions**: Comment why synchronization is safe when not obvious

### Configuration

Approachable Concurrency is enabled by default in Xcode 16.2+ with Swift 6.2+.
No special project settings required.

### Examples in This Project

- **DependencyContainer** (`Core/DI/`): Lock-based singleton with no isolation annotations
- **AppLogger** (`Core/Logging/`): Struct wrapper around OSLog, no isolation needed
- **ViewModels** (`UI/`): Use `@Observable` and `@MainActor` when UI-bound
- **Services** (`Services/`): Use actors when managing complex async state

### Migration Notes

If you see old patterns in the codebase:

- ❌ `@preconcurrency` - Remove it, not needed
- ❌ `@unchecked Sendable` - Refactor to proper pattern
- ❌ `nonisolated(unsafe)` - Trust Approachable Concurrency instead
- ✅ Simple locks - Keep them, they work great

### Further Reading

- [Approachable Concurrency by Donny Wals](https://www.donnywals.com/what-is-approachable-concurrency-in-xcode-26/)
- [Swift 6.2 Release Notes](https://www.swift.org/blog/swift-6.2-released/)
- [Swift Concurrency Documentation](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
