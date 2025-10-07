//
//  ServicesCoordinator.swift
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
//  ServicesCoordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator for the services feature
//
//  ⚠️ OBSOLETE: This file is deprecated as part of ADR-0012 refactoring
//  AppCoordinator now handles all navigation. This file kept temporarily for reference.
//

#if false
import Foundation
import SwiftUI
import OSLog

/// Coordinator that manages navigation within the Services feature.
/// Handles adding services, configuring them, testing connections, etc.
@MainActor
@Observable
final class ServicesCoordinator: @MainActor CoordinatorProtocol {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [ServicesRoute] = []
    
    // MARK: - Dependencies
    
    private let radarrService: any RadarrServiceProtocol
    private let dataService: any DataServiceProtocol
    
    // MARK: - Child Coordinators
    
    internal var radarrCoordinator: RadarrCoordinator?
    
    // MARK: - Initialization
    
    init(
        radarrService: any RadarrServiceProtocol,
        dataService: any DataServiceProtocol
    ) {
        self.radarrService = radarrService
        self.dataService = dataService
        
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "ServicesCoordinator",
            details: "Initialized with service dependencies"
        )
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.logCoordinator(
            event: "start",
            coordinator: "ServicesCoordinator"
        )
        
        // Start with empty path - servicesListView is the root
        navigationPath = []
        
        AppLogger.navigation.logStackChange(
            action: "set",
            coordinator: "ServicesCoordinator",
            stackSize: 0,
            route: "list (root)"
        )
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the Radarr module
    func showRadarr() {
        AppLogger.navigation.logNavigation(
            from: "ServicesList",
            to: "Radarr",
            coordinator: "ServicesCoordinator"
        )
        navigate(to: .radarr)
    }
    
    /// Shows the Sonarr module
    func showSonarr() {
        AppLogger.navigation.logNavigation(
            from: "ServicesList",
            to: "Sonarr (M3)",
            coordinator: "ServicesCoordinator"
        )
        navigate(to: .sonarr)
    }
    
    /// Shows the add service screen
    func showAddService() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .list),
            to: "AddService",
            coordinator: "ServicesCoordinator"
        )
        navigate(to: .addService)
    }
    
    /// Shows configuration for a specific service
    /// - Parameter serviceId: The ID of the service to configure
    func showServiceConfiguration(serviceId: String) {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .list),
            to: "ServiceConfiguration[\(serviceId)]",
            coordinator: "ServicesCoordinator"
        )
        navigate(to: .serviceConfiguration(serviceId: serviceId))
    }
    
    /// Shows the connection test screen for a service
    /// - Parameter serviceId: The ID of the service to test
    func showTestConnection(serviceId: String) {
        AppLogger.navigation.info("Showing test connection: \(serviceId)")
        navigate(to: .testConnection(serviceId: serviceId))
    }
    
    // MARK: - Child Coordinator Management
    
    /// Gets or creates the Radarr coordinator
    func getRadarrCoordinator() -> RadarrCoordinator {
        if let existing = radarrCoordinator {
            return existing
        }
        
        let coordinator = RadarrCoordinator(
            radarrService: radarrService,
            dataService: dataService
        )
        coordinator.parent = self
        childCoordinators.append(coordinator)
        radarrCoordinator = coordinator
        coordinator.start()
        
        return coordinator
    }
}
#endif  // Obsolete: ADR-0012
