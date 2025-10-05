//
//  DIContainer.swift
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
        registerInfrastructure()
        registerCoreServices()
        registerDomainServices()
        registerCoordinators()
    }
    
    // MARK: - Infrastructure Registration
    
    /// Registers infrastructure services (storage, logging, etc.)
    private func registerInfrastructure() {
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
    }
    
    // MARK: - Core Services Registration
    
    /// Registers core business services
    private func registerCoreServices() {
        // Register DataService (singleton, using protocol)
        container.register((any DataServiceProtocol).self) { resolver in
            let modelContainer = resolver.resolve(ModelContainer.self)!
            guard let keychainService = resolver.resolve((any KeychainServiceProtocol).self) else {
                fatalError("Could not resolve KeychainServiceProtocol")
            }
            return DataService(modelContainer: modelContainer, keychainService: keychainService)
        }.inObjectScope(.container)
        
        // Register DataService as concrete type (for services that need concrete DataService)
        container.register(DataService.self) { resolver in
            let modelContainer = resolver.resolve(ModelContainer.self)!
            guard let keychainService = resolver.resolve((any KeychainServiceProtocol).self) else {
                fatalError("Could not resolve KeychainServiceProtocol")
            }
            return DataService(modelContainer: modelContainer, keychainService: keychainService)
        }.inObjectScope(.container)
        
        // Register UserPreferencesService (singleton, using protocol)
        container.register((any UserPreferencesServiceProtocol).self) { resolver in
            let dataService = resolver.resolve(DataService.self)!
            do {
                return try UserPreferencesService(dataService: dataService)
            } catch {
                fatalError("Could not create UserPreferencesService: \(error)")
            }
        }.inObjectScope(.container)
        
        // Register ProfileService (singleton, using protocol)
        container.register((any ProfileServiceProtocol).self) { resolver in
            guard let dataService = resolver.resolve((any DataServiceProtocol).self) else {
                fatalError("Could not resolve DataServiceProtocol")
            }
            return ProfileService(dataService: dataService)
        }.inObjectScope(.container)
        
        // Register MPWGThemeManager (singleton, using protocol)
        container.register((any MPWGThemeManagerProtocol).self) { resolver in
            guard let userPreferences = resolver.resolve((any UserPreferencesServiceProtocol).self) else {
                fatalError("Could not resolve UserPreferencesServiceProtocol")
            }
            return MPWGThemeManager(userPreferences: userPreferences)
        }.inObjectScope(.container)
        
        // Register MPWGThemeManager as concrete type (for SwiftUI environment)
        container.register(MPWGThemeManager.self) { resolver in
            // Alias to the protocol registration to ensure singleton consistency
            guard let themeManager = resolver.resolve((any MPWGThemeManagerProtocol).self) as? MPWGThemeManager else {
                fatalError("Could not resolve MPWGThemeManagerProtocol as MPWGThemeManager")
            }
            return themeManager
        }.inObjectScope(.container)
    }
    
    // MARK: - Domain Services Registration
    
    /// Registers domain-specific services (Radarr, Sonarr, etc.)
    /// Note: These will be registered when implementations are added
    private func registerDomainServices() {
        // Future: Register MediaService implementations (Radarr, Sonarr, Lidarr)
        // Future: Register DownloadService implementations (SABnzbd, NZBGet)
        // Future: Register other service implementations (Tautulli, Overseerr, etc.)
    }
    
    // MARK: - Coordinators Registration
    
    /// Registers coordinators for navigation
    /// Note: Coordinators are typically created with transient scope since they manage navigation state
    private func registerCoordinators() {
        // Note: Coordinators will be registered here when they need DI
        // Most coordinators currently use simple init() and don't require services
        // Future: Register coordinators that need DataService or other dependencies
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
