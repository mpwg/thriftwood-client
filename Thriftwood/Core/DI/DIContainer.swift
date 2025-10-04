//
//  DIContainer.swift
//  Thriftwood
//
//  Dependency Injection container using Swinject
//  Manages service registration and resolution
//

import Foundation
import SwiftData
import Swinject

/// Main dependency injection container for the application
@MainActor
final class DIContainer {
    
    // MARK: - Singleton
    
    /// Shared instance of the DI container
    static let shared = DIContainer()
    
    // MARK: - Properties
    
    /// The underlying Swinject container
    private let container: Container
    
    // MARK: - Initialization
    
    private init() {
        self.container = Container()
        registerServices()
    }
    
    // MARK: - Service Registration
    
    /// Registers all services in the container
    private func registerServices() {
        // Register ModelContainer (singleton)
        container.register(ModelContainer.self) { _ in
            do {
                return try ModelContainer.thriftwoodContainer()
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }.inObjectScope(.container)
        
        // Register KeychainService (singleton, using protocol)
        container.register((any KeychainServiceProtocol).self) { _ in
            KeychainService()
        }.inObjectScope(.container)
        
        // Register DataService (singleton)
        container.register(DataService.self) { resolver in
            let modelContainer = resolver.resolve(ModelContainer.self)!
            guard let keychainService = resolver.resolve((any KeychainServiceProtocol).self) else {
                fatalError("Could not resolve KeychainServiceProtocol")
            }
            return DataService(modelContainer: modelContainer, keychainService: keychainService)
        }.inObjectScope(.container)
    }
    
    // MARK: - Service Resolution
    
    /// Resolves a service from the container
    /// - Parameter serviceType: The type of service to resolve
    /// - Returns: The resolved service instance
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = container.resolve(serviceType) else {
            fatalError("Could not resolve service: \(serviceType)")
        }
        return service
    }
    
    /// Resolves a service from the container (optional)
    /// - Parameter serviceType: The type of service to resolve
    /// - Returns: The resolved service instance, or nil if not found
    func resolveOptional<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
    // MARK: - Testing Support
    
    /// Removes all registrations (useful for testing)
    func removeAll() {
        container.removeAll()
    }
    
    /// Registers a mock service (useful for testing)
    /// - Parameters:
    ///   - serviceType: The protocol type to register
    ///   - implementation: The mock implementation
    func registerMock<Service>(_ serviceType: Service.Type, implementation: @escaping (any Resolver) -> Service) {
        container.register(serviceType, factory: implementation).inObjectScope(.container)
    }
}
