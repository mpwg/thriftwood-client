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
        
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "TabCoordinator",
            details: "Initialized with dependencies for tab management"
        )
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.logCoordinator(
            event: "start",
            coordinator: "TabCoordinator",
            details: "Setting up tab-based navigation"
        )
        
        // Setup coordinators for enabled tabs
        setupEnabledCoordinators()
        
        // Start with the first enabled tab (or dashboard as fallback)
        if let firstTab = enabledTabs.first {
            selectedTab = firstTab
            AppLogger.navigation.info("📍 Initial tab set to: \(firstTab.rawValue)")
        } else {
            selectedTab = .dashboard
            AppLogger.navigation.warning("⚠️ No tabs enabled, defaulting to dashboard")
        }
    }
    
    // MARK: - Tab Setup
    
    private func setupEnabledCoordinators() {
        let enabled = enabledTabs
        
        AppLogger.navigation.info("🔧 Setting up \(enabled.count) enabled tabs: [\(enabled.map { $0.rawValue }.joined(separator: ", "))]")
        
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
        
        AppLogger.navigation.info("✅ Tab coordinator setup complete with \(childCoordinators.count) child coordinators")
    }
    
    private func setupDashboardCoordinator() {
        guard dashboardCoordinator == nil else {
            AppLogger.navigation.debug("Dashboard coordinator already exists, skipping setup")
            return
        }
        let coordinator = DashboardCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        dashboardCoordinator = coordinator
        
        AppLogger.navigation.logCoordinator(
            event: "add_child",
            coordinator: "DashboardCoordinator",
            details: "Added to TabCoordinator"
        )
        
        coordinator.start()
    }
    
    private func setupCalendarCoordinator() {
        guard calendarCoordinator == nil else {
            AppLogger.navigation.debug("Calendar coordinator already exists, skipping setup")
            return
        }
        // TODO [Milestone 5]: Create CalendarCoordinator - using DashboardCoordinator as placeholder
        let coordinator = DashboardCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        calendarCoordinator = coordinator
        
        AppLogger.navigation.logCoordinator(
            event: "add_child",
            coordinator: "CalendarCoordinator (placeholder)",
            details: "Added to TabCoordinator"
        )
        
        coordinator.start()
    }
    
    private func setupServicesCoordinator() {
        guard servicesCoordinator == nil else {
            AppLogger.navigation.debug("Services coordinator already exists, skipping setup")
            return
        }
        let coordinator = ServicesCoordinator(
            radarrService: radarrService,
            dataService: dataService
        )
        coordinator.parent = self
        childCoordinators.append(coordinator)
        servicesCoordinator = coordinator
        
        AppLogger.navigation.logCoordinator(
            event: "add_child",
            coordinator: "ServicesCoordinator",
            details: "Added to TabCoordinator with Radarr service"
        )
        
        coordinator.start()
    }
    
    private func setupSearchCoordinator() {
        guard searchCoordinator == nil else {
            AppLogger.navigation.debug("Search coordinator already exists, skipping setup")
            return
        }
        // TODO [Milestone 4]: Create SearchCoordinator - using DashboardCoordinator as placeholder
        let coordinator = DashboardCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        searchCoordinator = coordinator
        
        AppLogger.navigation.logCoordinator(
            event: "add_child",
            coordinator: "SearchCoordinator (placeholder)",
            details: "Added to TabCoordinator"
        )
        
        coordinator.start()
    }
    
    private func setupSettingsCoordinator() {
        guard settingsCoordinator == nil else {
            AppLogger.navigation.debug("Settings coordinator already exists, skipping setup")
            return
        }
        let coordinator = SettingsCoordinator()
        coordinator.parent = self
        childCoordinators.append(coordinator)
        settingsCoordinator = coordinator
        
        AppLogger.navigation.logCoordinator(
            event: "add_child",
            coordinator: "SettingsCoordinator",
            details: "Added to TabCoordinator"
        )
        
        coordinator.start()
    }
    
    // MARK: - Coordinator Access
    
    /// Get coordinator for a specific tab (lazy-initialized if needed)
    /// - Parameter tab: The tab to get coordinator for
    /// - Returns: The coordinator for the tab, or nil if not enabled
    func coordinator(for tab: TabRoute) -> (any CoordinatorProtocol)? {
        // Check if tab is enabled
        guard enabledTabs.contains(tab) else {
            AppLogger.navigation.warning("⚠️ Attempted to access disabled tab: \(tab.rawValue)")
            return nil
        }
        
        AppLogger.navigation.debug("🔍 Accessing coordinator for tab: \(tab.rawValue)")
        
        // Return or create coordinator
        switch tab {
        case .dashboard:
            if dashboardCoordinator == nil {
                AppLogger.navigation.debug("Lazy-initializing DashboardCoordinator")
                setupDashboardCoordinator()
            }
            return dashboardCoordinator
        case .calendar:
            if calendarCoordinator == nil {
                AppLogger.navigation.debug("Lazy-initializing CalendarCoordinator")
                setupCalendarCoordinator()
            }
            return calendarCoordinator
        case .services:
            if servicesCoordinator == nil {
                AppLogger.navigation.debug("Lazy-initializing ServicesCoordinator")
                setupServicesCoordinator()
            }
            return servicesCoordinator
        case .search:
            if searchCoordinator == nil {
                AppLogger.navigation.debug("Lazy-initializing SearchCoordinator")
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
        let previousTab = selectedTab.rawValue
        let newTab = tab.rawValue
        
        AppLogger.navigation.logTabSwitch(from: previousTab, to: newTab)
        
        selectedTab = tab
        
        AppLogger.navigation.debug("✅ Tab selection updated, coordinator for '\(newTab)' will be activated")
    }
    
    /// Pops the navigation stack to root for the specified tab
    /// This is called when a user taps on an already-selected tab
    /// - Parameter tab: The tab to pop to root
    func popToRoot(for tab: TabRoute) {
        AppLogger.navigation.info("🔙 User tapped active tab '\(tab.rawValue)' - popping to root")
        
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
        AppLogger.navigation.logDeepLink(
            url: url.absoluteString,
            action: "parsing",
            coordinator: "TabCoordinator"
        )
        
        // Try to parse as dashboard route
        if let dashboardRoute = DashboardRoute.parse(from: url), enabledTabs.contains(.dashboard) {
            AppLogger.navigation.logDeepLink(
                url: url.absoluteString,
                action: "routing to Dashboard",
                coordinator: "DashboardCoordinator"
            )
            selectedTab = .dashboard
            (coordinator(for: .dashboard) as? DashboardCoordinator)?.navigate(to: dashboardRoute)
            return true
        }
        
        // Try to parse as services route
        if let servicesRoute = ServicesRoute.parse(from: url), enabledTabs.contains(.services) {
            AppLogger.navigation.logDeepLink(
                url: url.absoluteString,
                action: "routing to Services",
                coordinator: "ServicesCoordinator"
            )
            selectedTab = .services
            (coordinator(for: .services) as? ServicesCoordinator)?.navigate(to: servicesRoute)
            return true
        }
        
        // Try to parse as settings route
        if let settingsRoute = SettingsRoute.parse(from: url), enabledTabs.contains(.settings) {
            AppLogger.navigation.logDeepLink(
                url: url.absoluteString,
                action: "routing to Settings",
                coordinator: "SettingsCoordinator"
            )
            selectedTab = .settings
            (coordinator(for: .settings) as? SettingsCoordinator)?.navigate(to: settingsRoute)
            return true
        }
        
        AppLogger.navigation.logDeepLink(
            url: url.absoluteString,
            action: "failed - no matching route",
            coordinator: "TabCoordinator"
        )
        AppLogger.navigation.warning("⚠️ Deep link could not be parsed or routed: \(url.absoluteString)")
        return false
    }
}
