import Combine
import Foundation

/// A simple dependency injection container using modern Swift features
@MainActor
final class DIContainer: ObservableObject {
    static let shared = DIContainer()

    private var dependencies: [ObjectIdentifier: Any] = [:]
    private let lock = NSLock()

    private init() {
        registerDependencies()
    }

    /// Register a dependency with automatic type inference
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.withLock {
            dependencies[ObjectIdentifier(type)] = factory
        }
    }

    /// Register a singleton dependency
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.withLock {
            let instance = factory()
            dependencies[ObjectIdentifier(type)] = { instance }
        }
    }

    /// Resolve a dependency
    func resolve<T>(_ type: T.Type) -> T {
        lock.withLock {
            guard let factory = dependencies[ObjectIdentifier(type)] as? () -> T else {
                fatalError("Dependency of type \(type) not registered")
            }
            return factory()
        }
    }

    /// Register all application dependencies
    private func registerDependencies() {
        // Core services
        registerSingleton(NetworkService.self) { NetworkServiceImpl() }
        registerSingleton(StorageService.self) { StorageServiceImpl() }

        // Repository layer
        register(DashboardRepository.self) { [weak self] in
            guard let self = self else { fatalError("DIContainer deallocated") }
            return DashboardRepositoryImpl(
                networkService: self.resolve(NetworkService.self),
                storageService: self.resolve(StorageService.self)
            )
        }

        register(SettingsRepository.self) { [weak self] in
            guard let self = self else { fatalError("DIContainer deallocated") }
            return SettingsRepositoryImpl(
                storageService: self.resolve(StorageService.self)
            )
        }

        // ViewModels are registered on-demand as they're typically created per view
    }

    /// Convenience method to create view models
    func makeViewModel<T: ObservableObject>(_ type: T.Type) -> T {
        return resolve(type)
    }
}
