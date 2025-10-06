//
//  DashboardCoordinator.swift
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
//  DashboardCoordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator for the dashboard feature
//

import Foundation
import SwiftUI
import OSLog

/// Coordinator that manages navigation within the Dashboard feature.
/// Handles showing service details, media details, and other dashboard-related screens.
@MainActor
@Observable
final class DashboardCoordinator: @MainActor CoordinatorProtocol {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [DashboardRoute] = []
    
    // MARK: - Initialization
    
    init() {
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "DashboardCoordinator",
            details: "Dashboard navigation initialized"
        )
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.logCoordinator(
            event: "start",
            coordinator: "DashboardCoordinator",
            details: "Starting with home"
        )
        
        // Start with empty path - root view represents home
        navigationPath = []
        
        AppLogger.navigation.logStackChange(
            action: "set",
            coordinator: "DashboardCoordinator",
            stackSize: 0,
            route: "home (root)"
        )
    }
    
    // MARK: - Navigation Methods
    
    /// Shows details for a specific service
    /// - Parameter serviceId: The ID of the service to show
    func showServiceDetail(serviceId: String) {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .home),
            to: "ServiceDetail[id:\(serviceId)]",
            coordinator: "DashboardCoordinator"
        )
        navigate(to: .serviceDetail(serviceId: serviceId))
    }
    
    /// Shows details for a specific media item
    /// - Parameters:
    ///   - mediaId: The ID of the media item
    ///   - serviceType: The type of service (e.g., "radarr", "sonarr")
    func showMediaDetail(mediaId: String, serviceType: String) {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .home),
            to: "MediaDetail[id:\(mediaId), type:\(serviceType)]",
            coordinator: "DashboardCoordinator"
        )
        navigate(to: .mediaDetail(mediaId: mediaId, serviceType: serviceType))
    }
}
