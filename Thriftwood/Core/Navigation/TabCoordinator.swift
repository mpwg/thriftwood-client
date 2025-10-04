//
//  TabCoordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator for managing tab-based navigation
//

import Foundation
import SwiftUI

/// Coordinator that manages the main tab bar navigation.
/// Each tab gets its own child coordinator to manage its navigation flow.
///
/// This follows the pattern from the advanced tutorial where each tab
/// has its own coordinator managing its navigation stack independently.
@Observable
@MainActor
final class TabCoordinator: Coordinator, @unchecked Sendable {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any Coordinator] = []
    weak var parent: (any Coordinator)?
    var navigationPath: [TabRoute] = []
    
    // MARK: - Properties
    
    /// The currently selected tab
    var selectedTab: TabRoute = .dashboard
    
    /// Coordinators for each tab
    private(set) var dashboardCoordinator: DashboardCoordinator?
    private(set) var servicesCoordinator: ServicesCoordinator?
    private(set) var settingsCoordinator: SettingsCoordinator?
    
    // MARK: - Initialization
    
    init() {
        AppLogger.navigation.info("TabCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.info("TabCoordinator starting")
        
        // Create coordinators for each tab
        setupDashboardCoordinator()
        setupServicesCoordinator()
        setupSettingsCoordinator()
        
        // Start with dashboard tab
        selectedTab = .dashboard
    }
    
    // MARK: - Tab Setup
    
    private func setupDashboardCoordinator() {
        let coordinator = DashboardCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        dashboardCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Dashboard coordinator set up")
    }
    
    private func setupServicesCoordinator() {
        let coordinator = ServicesCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        servicesCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Services coordinator set up")
    }
    
    private func setupSettingsCoordinator() {
        let coordinator = SettingsCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        settingsCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Settings coordinator set up")
    }
    
    // MARK: - Tab Selection
    
    /// Switches to the specified tab
    /// - Parameter tab: The tab to switch to
    func select(tab: TabRoute) {
        AppLogger.navigation.info("Switching to tab: \(String(describing: tab))")
        selectedTab = tab
    }
    
    /// Handles deep links by routing to the appropriate tab coordinator
    /// - Parameter url: The deep link URL to handle
    /// - Returns: true if the URL was handled, false otherwise
    func handleDeepLink(_ url: URL) -> Bool {
        AppLogger.navigation.info("Handling deep link: \(url.absoluteString)")
        
        // Try to parse as dashboard route
        if let dashboardRoute = DashboardRoute.parse(from: url) {
            selectedTab = .dashboard
            dashboardCoordinator?.navigate(to: dashboardRoute)
            return true
        }
        
        // Try to parse as services route
        if let servicesRoute = ServicesRoute.parse(from: url) {
            selectedTab = .services
            servicesCoordinator?.navigate(to: servicesRoute)
            return true
        }
        
        // Try to parse as settings route
        if let settingsRoute = SettingsRoute.parse(from: url) {
            selectedTab = .settings
            settingsCoordinator?.navigate(to: settingsRoute)
            return true
        }
        
        AppLogger.navigation.warning("Deep link could not be parsed: \(url.absoluteString)")
        return false
    }
}
