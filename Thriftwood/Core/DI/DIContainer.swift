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

import Foundation
import SwiftData
import Swinject
import AsyncHTTPClient

/// Main dependency injection container for the application
@MainActor
final class DIContainer {
    
    // MARK: - Singleton
    
    /// Shared instance of the DI container
    static let shared = DIContainer()
    
    // MARK: - Properties
    
    /// The underlying Swinject container
    private let container: Container
    
    /// Optional model container to use (for testing)
    private let modelContainer: ModelContainer?
    
    // MARK: - Initialization
    
    private init(modelContainer: ModelContainer? = nil) {
        self.container = Container()
        self.modelContainer = modelContainer
        registerServices()
    }
    
    /// Creates a test instance with custom model container
    static func makeTestContainer(modelContainer: ModelContainer) -> DIContainer {
        return DIContainer(modelContainer: modelContainer)
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
        container.register(ModelContainer.self) { [weak self] _ in
            // Use provided container if available (for tests), otherwise create production container
            if let testContainer = self?.modelContainer {
                return testContainer
            }
            
            do {
                return try ModelContainer.thriftwoodContainer()
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
        .inObjectScope(.container)
        
        // Register HTTPClient (singleton)
        // Per ADR-0004, use AsyncHTTPClient for all HTTP networking
        container.register(HTTPClient.self) { _ in
            HTTPClient(eventLoopGroupProvider: .singleton)
        }
        .inObjectScope(.container)
        
        // Register KeychainService (singleton, using protocol)
        container.register((any KeychainServiceProtocol).self) { _ in
            KeychainService()
        }
        .inObjectScope(.container)
    }
    
    // MARK: - Core Services Registration
    
    /// Registers core business services
    private func registerCoreServices() {
        // Register DataService (singleton, using protocol only)
        // Per ADR-0003, services should be registered by protocol to enable dependency injection and testing
        container.register((any DataServiceProtocol).self) { resolver in
            let modelContainer = resolver.resolve(ModelContainer.self)!
            guard let keychainService = resolver.resolve((any KeychainServiceProtocol).self) else {
                fatalError("Could not resolve KeychainServiceProtocol")
            }
            return DataService(modelContainer: modelContainer, keychainService: keychainService)
        }
        .inObjectScope(.container)
        
        // Register UserPreferencesService (singleton, using protocol)
        // Note: UserPreferencesService requires concrete DataService type for SwiftData operations
        container.register((any UserPreferencesServiceProtocol).self) { resolver in
            guard let dataService = resolver.resolve((any DataServiceProtocol).self) as? DataService else {
                fatalError("Could not resolve DataService (concrete type required)")
            }
            do {
                return try UserPreferencesService(dataService: dataService)
            } catch {
                fatalError("Could not create UserPreferencesService: \(error)")
            }
        }
        .inObjectScope(.container)
        
        // Register ProfileService (singleton, using protocol)
        container.register((any ProfileServiceProtocol).self) { resolver in
            guard let dataService = resolver.resolve((any DataServiceProtocol).self) else {
                fatalError("Could not resolve DataServiceProtocol")
            }
            return ProfileService(dataService: dataService)
        }
        .inObjectScope(.container)
        
        // Register MPWGThemeManager (singleton, using protocol only)
        // SwiftUI can access via protocol through environment or direct resolution
        container.register((any MPWGThemeManagerProtocol).self) { resolver in
            guard let userPreferences = resolver.resolve((any UserPreferencesServiceProtocol).self) else {
                fatalError("Could not resolve UserPreferencesServiceProtocol")
            }
            return MPWGThemeManager(userPreferences: userPreferences)
        }
        .inObjectScope(.container)
    }
    
    // MARK: - Domain Services Registration
    
    /// Registers domain-specific services (Radarr, Sonarr, etc.)
    /// Note: These will be registered when implementations are added
    private func registerDomainServices() {
        // Register RadarrService (singleton, using protocol)
        // Per ADR-0003, services should be registered by protocol to enable dependency injection and testing
        // Note: RadarrService now uses OpenAPI-generated client (ADR-0006), no httpClient needed
        container.register((any RadarrServiceProtocol).self) { _ in
            return RadarrService()
        }
        .inObjectScope(.container)
        
        // Future: Register MediaService implementations (Sonarr, Lidarr)
        // Future: Register DownloadService implementations (SABnzbd, NZBGet)
        // Future: Register other service implementations (Tautulli, Overseerr, etc.)
    }
    
    // MARK: - Coordinators Registration
    
    /// Registers coordinators for navigation (ADR-0012: Logic Coordinators)
    private func registerCoordinators() {
        // Register RadarrLogicCoordinator (singleton - manages ViewModels)
        container.register(RadarrLogicCoordinator.self) { resolver in
            guard let radarrService = resolver.resolve((any RadarrServiceProtocol).self) else {
                fatalError("Could not resolve RadarrServiceProtocol for RadarrLogicCoordinator")
            }
            guard let dataService = resolver.resolve((any DataServiceProtocol).self) else {
                fatalError("Could not resolve DataServiceProtocol for RadarrLogicCoordinator")
            }
            return RadarrLogicCoordinator(
                radarrService: radarrService,
                dataService: dataService
            )
        }
        .inObjectScope(.container)
        
        // Register SettingsLogicCoordinator (singleton)
        container.register(SettingsLogicCoordinator.self) { _ in
            return SettingsLogicCoordinator()
        }
        .inObjectScope(.container)
        
        // Register AppCoordinator (ADR-0012: Single NavigationStack pattern)
        // AppCoordinator is the sole navigation authority, logic coordinators handle business logic
        container.register(AppCoordinator.self) { resolver in
            guard let preferencesService = resolver.resolve((any UserPreferencesServiceProtocol).self) else {
                fatalError("Could not resolve UserPreferencesServiceProtocol for AppCoordinator")
            }
            guard let profileService = resolver.resolve((any ProfileServiceProtocol).self) else {
                fatalError("Could not resolve ProfileServiceProtocol for AppCoordinator")
            }
            guard let radarrLogicCoordinator = resolver.resolve(RadarrLogicCoordinator.self) else {
                fatalError("Could not resolve RadarrLogicCoordinator for AppCoordinator")
            }
            guard let settingsLogicCoordinator = resolver.resolve(SettingsLogicCoordinator.self) else {
                fatalError("Could not resolve SettingsLogicCoordinator for AppCoordinator")
            }
            return AppCoordinator(
                preferencesService: preferencesService,
                profileService: profileService,
                radarrLogicCoordinator: radarrLogicCoordinator,
                settingsLogicCoordinator: settingsLogicCoordinator
            )
        }
        .inObjectScope(.container)
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
    
    /// Shutdown the DI container and cleanup resources
    /// Should be called when the app terminates
    func shutdown() async {
        // Shutdown HTTPClient gracefully
        if let httpClient = container.resolve(HTTPClient.self) {
            do {
                try await httpClient.shutdown()
                AppLogger.general.info("HTTPClient shutdown successfully")
            } catch {
                AppLogger.general.error("Failed to shutdown HTTPClient", error: error)
            }
        }
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
