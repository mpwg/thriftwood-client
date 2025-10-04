//
//  DashboardCoordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator for the dashboard feature
//

import Foundation
import SwiftUI

/// Coordinator that manages navigation within the Dashboard feature.
/// Handles showing service details, media details, and other dashboard-related screens.
@Observable
@MainActor
final class DashboardCoordinator: Coordinator {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any Coordinator] = []
    weak var parent: (any Coordinator)?
    var navigationPath: [DashboardRoute] = []
    
    // MARK: - Initialization
    
    init() {
        Logger.navigation.info("DashboardCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        Logger.navigation.info("DashboardCoordinator starting")
        navigationPath = [.home]
    }
    
    // MARK: - Navigation Methods
    
    /// Shows details for a specific service
    /// - Parameter serviceId: The ID of the service to show
    func showServiceDetail(serviceId: String) {
        Logger.navigation.info("Showing service detail: \(serviceId)")
        navigate(to: .serviceDetail(serviceId: serviceId))
    }
    
    /// Shows details for a specific media item
    /// - Parameters:
    ///   - mediaId: The ID of the media item
    ///   - serviceType: The type of service (e.g., "radarr", "sonarr")
    func showMediaDetail(mediaId: String, serviceType: String) {
        Logger.navigation.info("Showing media detail: \(mediaId) from \(serviceType)")
        navigate(to: .mediaDetail(mediaId: mediaId, serviceType: serviceType))
    }
}
