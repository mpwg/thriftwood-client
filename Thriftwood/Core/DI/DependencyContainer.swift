//
//  DependencyContainer.swift
//  Thriftwood
//
//  Simple dependency injection container for managing service dependencies
//
//  CONCURRENCY NOTES:
//  - This project uses Swift 6.2's "Approachable Concurrency" feature
//  - See: https://www.donnywals.com/what-is-approachable-concurrency-in-xcode-26/
//  - With Approachable Concurrency enabled, Swift is more lenient about concurrency checking
//  - We can use traditional synchronization (locks) without excessive isolation annotations
//  - No @preconcurrency, @unchecked Sendable, or nonisolated(unsafe) needed
//  - The compiler trusts that our lock-based synchronization is correct
//

import Foundation

/// Protocol for services that can be registered in the DI container
protocol Injectable {
    /// Type identifier for the service
    static var identifier: String { get }
}

extension Injectable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

/// Dependency injection container for registering and resolving dependencies
///
/// Thread Safety: Uses NSLock for synchronization. Safe to access from any context.
/// With Approachable Concurrency enabled, traditional lock-based patterns work naturally.
final class DependencyContainer: Sendable {
    
    // MARK: - Singleton
    
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Storage
    
    // With Approachable Concurrency, we still need nonisolated(unsafe) for mutable state
    // that's protected by locks, but the compiler is more lenient about usage patterns.
    // The lock ensures thread safety even though we're accessing from any context.
    nonisolated(unsafe) private var services: [String: Any] = [:]
    nonisolated(unsafe) private var factories: [String: () -> Any] = [:]
    private let lock = NSLock()
    
    // MARK: - Registration
    
    /// Register a singleton instance
    /// - Parameters:
    ///   - type: The protocol or type to register
    ///   - instance: The instance to register
    nonisolated func register<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        services[key] = instance
        #if DEBUG
        print("[DI] Registered singleton: \(key)")
        #endif
    }
    
    /// Register a factory for creating instances on-demand
    /// - Parameters:
    ///   - type: The protocol or type to register
    ///   - factory: Factory closure that creates new instances
    nonisolated func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        factories[key] = factory
        #if DEBUG
        print("[DI] Registered factory: \(key)")
        #endif
    }
    
    /// Register a singleton instance with automatic type inference
    /// - Parameter instance: The instance to register (type inferred)
    nonisolated func register<T>(_ instance: T) {
        register(T.self, instance: instance)
    }
    
    // MARK: - Resolution
    
    /// Resolve a dependency
    /// - Parameter type: The type to resolve
    /// - Returns: The resolved instance
    /// - Throws: DependencyError if not found
    nonisolated func resolve<T>(_ type: T.Type) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        
        // Check for singleton instance first
        if let instance = services[key] as? T {
            return instance
        }
        
        // Try factory
        if let factory = factories[key] {
            let instance = factory() as! T
            #if DEBUG
            print("[DI] Created instance from factory: \(key)")
            #endif
            return instance
        }
        
        #if DEBUG
        print("[DI] Failed to resolve dependency: \(key)")
        #endif
        throw DependencyError.notRegistered(String(describing: type))
    }
    
    /// Resolve a dependency (optional variant)
    /// - Parameter type: The type to resolve
    /// - Returns: The resolved instance or nil if not found
    nonisolated func resolveOptional<T>(_ type: T.Type) -> T? {
        try? resolve(type)
    }
    
    // MARK: - Cleanup
    
    /// Remove a registered dependency
    /// - Parameter type: The type to remove
    nonisolated func unregister<T>(_ type: T.Type) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        services.removeValue(forKey: key)
        factories.removeValue(forKey: key)
        #if DEBUG
        print("[DI] Unregistered: \(key)")
        #endif
    }
    
    /// Remove all registered dependencies (useful for testing)
    nonisolated func reset() {
        lock.lock()
        defer { lock.unlock() }
        
        services.removeAll()
        factories.removeAll()
        #if DEBUG
        print("[DI] Container reset")
        #endif
    }
}

// MARK: - Dependency Error

enum DependencyError: LocalizedError {
    case notRegistered(String)
    
    var errorDescription: String? {
        switch self {
        case .notRegistered(let type):
            return "Dependency not registered: \(type)"
        }
    }
}

// MARK: - Property Wrapper

/// Property wrapper for injecting dependencies
@propertyWrapper
struct Injected<T> {
    private var dependency: T?
    
    public var wrappedValue: T {
        mutating get {
            if dependency == nil {
                dependency = try? DependencyContainer.shared.resolve(T.self)
            }
            return dependency!
        }
        mutating set {
            dependency = newValue
        }
    }
    
    public init() {}
}
