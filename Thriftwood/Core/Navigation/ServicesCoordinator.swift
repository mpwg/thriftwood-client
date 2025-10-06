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
    
    // MARK: - Initialization
    
    init() {
        AppLogger.navigation.info("ServicesCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.info("ServicesCoordinator starting")
        navigationPath = [.list]
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the add service screen
    func showAddService() {
        AppLogger.navigation.info("Showing add service screen")
        navigate(to: .addService)
    }
    
    /// Shows configuration for a specific service
    /// - Parameter serviceId: The ID of the service to configure
    func showServiceConfiguration(serviceId: String) {
        AppLogger.navigation.info("Showing service configuration: \(serviceId)")
        navigate(to: .serviceConfiguration(serviceId: serviceId))
    }
    
    /// Shows the connection test screen for a service
    /// - Parameter serviceId: The ID of the service to test
    func showTestConnection(serviceId: String) {
        AppLogger.navigation.info("Showing test connection: \(serviceId)")
        navigate(to: .testConnection(serviceId: serviceId))
    }
}
