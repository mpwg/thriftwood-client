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
final class ServicesCoordinator: Coordinator, @unchecked Sendable {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any Coordinator] = []
    weak var parent: (any Coordinator)?
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
