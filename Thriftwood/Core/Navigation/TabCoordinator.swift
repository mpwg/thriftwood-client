//
//  TabCoordinator.swift
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
///
/// Tabs are dynamically configurable via UserPreferencesService, allowing users
/// to enable/disable tabs and customize their order.
@Observable
@MainActor
final class TabCoordinator: @MainActor CoordinatorProtocol {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [TabRoute] = []
    
    // MARK: - Properties
    
    /// User preferences service for tab configuration
    private let preferencesService: any UserPreferencesServiceProtocol
    
    /// Radarr service for services coordinator
    private let radarrService: any RadarrServiceProtocol
    
    /// Data service for services coordinator
    private let dataService: any DataServiceProtocol
    
    /// The currently selected tab
    var selectedTab: TabRoute = .dashboard
    
    /// Ordered list of enabled tabs (computed from preferences)
    var enabledTabs: [TabRoute] {
        TabRoute.from(ids: preferencesService.getOrderedTabIDs())
    }
    
    /// Coordinators for each tab (created on demand)
    /// Internal for testing purposes
    internal var dashboardCoordinator: DashboardCoordinator?
    internal var calendarCoordinator: DashboardCoordinator? // TODO [Milestone 5]: Create CalendarCoordinator
    internal var servicesCoordinator: ServicesCoordinator?
    internal var searchCoordinator: DashboardCoordinator? // TODO [Milestone 4]: Create SearchCoordinator
    internal var settingsCoordinator: SettingsCoordinator?
    
    // MARK: - Initialization
    
    init(
        preferencesService: any UserPreferencesServiceProtocol,
        radarrService: any RadarrServiceProtocol,
        dataService: any DataServiceProtocol
    ) {
        self.preferencesService = preferencesService
        self.radarrService = radarrService
        self.dataService = dataService
        AppLogger.navigation.info("TabCoordinator initialized with customizable tabs")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.info("TabCoordinator starting")
        
        // Setup coordinators for enabled tabs
        setupEnabledCoordinators()
        
        // Start with the first enabled tab (or dashboard as fallback)
        if let firstTab = enabledTabs.first {
            selectedTab = firstTab
        } else {
            selectedTab = .dashboard
        }
    }
    
    // MARK: - Tab Setup
    
    private func setupEnabledCoordinators() {
        let enabled = enabledTabs
        
        AppLogger.navigation.debug("Setting up coordinators for enabled tabs: \(enabled.map { $0.rawValue })")
        
        for tab in enabled {
            switch tab {
            case .dashboard:
                setupDashboardCoordinator()
            case .calendar:
                setupCalendarCoordinator()
            case .services:
                setupServicesCoordinator()
            case .search:
                setupSearchCoordinator()
            case .settings:
                setupSettingsCoordinator()
            }
        }
    }
    
    private func setupDashboardCoordinator() {
        guard dashboardCoordinator == nil else { return }
        let coordinator = DashboardCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        dashboardCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Dashboard coordinator set up")
    }
    
    private func setupCalendarCoordinator() {
        guard calendarCoordinator == nil else { return }
        // TODO [Milestone 5]: Create CalendarCoordinator - using DashboardCoordinator as placeholder
        let coordinator = DashboardCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        calendarCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Calendar coordinator set up (placeholder)")
    }
    
    private func setupServicesCoordinator() {
        guard servicesCoordinator == nil else { return }
        let coordinator = ServicesCoordinator(
            radarrService: radarrService,
            dataService: dataService
        )
        coordinator.parent = self
        childCoordinators.append(coordinator)
        servicesCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Services coordinator set up")
    }
    
    private func setupSearchCoordinator() {
        guard searchCoordinator == nil else { return }
        // TODO [Milestone 4]: Create SearchCoordinator - using DashboardCoordinator as placeholder
        let coordinator = DashboardCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        searchCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Search coordinator set up (placeholder)")
    }
    
    private func setupSettingsCoordinator() {
        guard settingsCoordinator == nil else { return }
        let coordinator = SettingsCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        settingsCoordinator = coordinator
        coordinator.start()
        
        AppLogger.navigation.debug("Settings coordinator set up")
    }
    
    // MARK: - Coordinator Access
    
    /// Get coordinator for a specific tab (lazy-initialized if needed)
    /// - Parameter tab: The tab to get coordinator for
    /// - Returns: The coordinator for the tab, or nil if not enabled
    func coordinator(for tab: TabRoute) -> (any CoordinatorProtocol)? {
        // Check if tab is enabled
        guard enabledTabs.contains(tab) else {
            return nil
        }
        
        // Return or create coordinator
        switch tab {
        case .dashboard:
            if dashboardCoordinator == nil {
                setupDashboardCoordinator()
            }
            return dashboardCoordinator
        case .calendar:
            if calendarCoordinator == nil {
                setupCalendarCoordinator()
            }
            return calendarCoordinator
        case .services:
            if servicesCoordinator == nil {
                setupServicesCoordinator()
            }
            return servicesCoordinator
        case .search:
            if searchCoordinator == nil {
                setupSearchCoordinator()
            }
            return searchCoordinator
        case .settings:
            if settingsCoordinator == nil {
                setupSettingsCoordinator()
            }
            return settingsCoordinator
        }
    }
    
    // MARK: - Tab Selection
    
    /// Switches to the specified tab
    /// - Parameter tab: The tab to switch to
    func select(tab: TabRoute) {
        AppLogger.navigation.info("Switching to tab: \(String(describing: tab))")
        selectedTab = tab
    }
    
    /// Pops the navigation stack to root for the specified tab
    /// This is called when a user taps on an already-selected tab
    /// - Parameter tab: The tab to pop to root
    func popToRoot(for tab: TabRoute) {
        AppLogger.navigation.debug("Popping to root for tab: \(String(describing: tab))")
        
        switch tab {
        case .dashboard:
            dashboardCoordinator?.popToRoot()
        case .calendar:
            calendarCoordinator?.popToRoot()
        case .services:
            servicesCoordinator?.popToRoot()
        case .search:
            searchCoordinator?.popToRoot()
        case .settings:
            settingsCoordinator?.popToRoot()
        }
    }
    
    /// Handles deep links by routing to the appropriate tab coordinator
    /// - Parameter url: The deep link URL to handle
    /// - Returns: true if the URL was handled, false otherwise
    func handleDeepLink(_ url: URL) -> Bool {
        AppLogger.navigation.info("Handling deep link: \(url.absoluteString)")
        
        // Try to parse as dashboard route
        if let dashboardRoute = DashboardRoute.parse(from: url), enabledTabs.contains(.dashboard) {
            selectedTab = .dashboard
            (coordinator(for: .dashboard) as? DashboardCoordinator)?.navigate(to: dashboardRoute)
            return true
        }
        
        // Try to parse as services route
        if let servicesRoute = ServicesRoute.parse(from: url), enabledTabs.contains(.services) {
            selectedTab = .services
            (coordinator(for: .services) as? ServicesCoordinator)?.navigate(to: servicesRoute)
            return true
        }
        
        // Try to parse as settings route
        if let settingsRoute = SettingsRoute.parse(from: url), enabledTabs.contains(.settings) {
            selectedTab = .settings
            (coordinator(for: .settings) as? SettingsCoordinator)?.navigate(to: settingsRoute)
            return true
        }
        
        AppLogger.navigation.warning("Deep link could not be parsed: \(url.absoluteString)")
        return false
    }
}
