//
//  TabConfigurationTests.swift
//  ThriftwoodTests
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


import Testing
import Foundation
import SwiftData
@testable import Thriftwood

@Suite("Tab Configuration Tests")
struct TabConfigurationTests {
    
    // MARK: - TabConfiguration Model Tests
    
    @Test("TabConfiguration has correct default values")
    @MainActor
    func testTabConfigurationDefaults() async throws {
        let config = TabConfiguration.dashboard
        
        #expect(config.id == "dashboard")
        #expect(config.title == "Dashboard")
        #expect(config.iconName == "square.grid.2x2")
        #expect(config.isEnabled == true)
    }
    
    @Test("All required tabs cannot be disabled")
    @MainActor
    func testRequiredTabsCannotBeDisabled() async throws {
        #expect(TabConfiguration.dashboard.canBeDisabled == false)
        #expect(TabConfiguration.settings.canBeDisabled == false)
    }
    
    @Test("Optional tabs can be disabled")
    @MainActor
    func testOptionalTabsCanBeDisabled() async throws {
        #expect(TabConfiguration.calendar.canBeDisabled == true)
        #expect(TabConfiguration.services.canBeDisabled == true)
        #expect(TabConfiguration.search.canBeDisabled == true)
    }
    
    @Test("Tab configurations can be sorted alphabetically")
    @MainActor
    func testAlphabeticalSorting() async throws {
        let tabs = TabConfiguration.allTabs
        let sorted = TabConfiguration.alphabetical(tabs)
        
        // Calendar < Dashboard < Search < Services < Settings
        #expect(sorted[0].id == "calendar")
        #expect(sorted[1].id == "dashboard")
        #expect(sorted[2].id == "search")
        #expect(sorted[3].id == "services")
        #expect(sorted[4].id == "settings")
    }
    
    @Test("Tab configurations can be filtered to enabled only")
    @MainActor
    func testEnabledFiltering() async throws {
        var tabs = TabConfiguration.allTabs
        tabs[1].isEnabled = false // Disable calendar
        
        let enabled = TabConfiguration.enabledOnly(tabs)
        
        #expect(enabled.count == 4)
        #expect(!enabled.contains { $0.id == "calendar" })
    }
    
    // MARK: - TabRoute Tests
    
    @Test("TabRoute can be created from string ID")
    @MainActor
    func testTabRouteFromID() async throws {
        #expect(TabRoute.from(id: "dashboard") == .dashboard)
        #expect(TabRoute.from(id: "calendar") == .calendar)
        #expect(TabRoute.from(id: "services") == .services)
        #expect(TabRoute.from(id: "search") == .search)
        #expect(TabRoute.from(id: "settings") == .settings)
        #expect(TabRoute.from(id: "invalid") == nil)
    }
    
    @Test("TabRoute array can be created from string IDs")
    @MainActor
    func testTabRouteArrayFromIDs() async throws {
        let ids = ["dashboard", "services", "settings"]
        let routes = TabRoute.from(ids: ids)
        
        #expect(routes.count == 3)
        #expect(routes[0] == .dashboard)
        #expect(routes[1] == .services)
        #expect(routes[2] == .settings)
    }
    
    @Test("TabRoute has correct properties")
    @MainActor
    func testTabRouteProperties() async throws {
        #expect(TabRoute.dashboard.title == "Dashboard")
        #expect(TabRoute.dashboard.iconName == "square.grid.2x2")
        #expect(TabRoute.dashboard.canBeDisabled == false)
        
        #expect(TabRoute.calendar.canBeDisabled == true)
        #expect(TabRoute.services.canBeDisabled == true)
    }
    
    // MARK: - UserPreferencesService Tab Configuration Tests
    
    @Test("Default tab configuration is all tabs enabled")
    @MainActor
    func testDefaultTabConfiguration() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        
        #expect(preferencesService.tabAutomaticManage == true)
        #expect(preferencesService.enabledTabs.count == 5)
        #expect(preferencesService.enabledTabs.contains("dashboard"))
        #expect(preferencesService.enabledTabs.contains("calendar"))
        #expect(preferencesService.enabledTabs.contains("services"))
        #expect(preferencesService.enabledTabs.contains("search"))
        #expect(preferencesService.enabledTabs.contains("settings"))
    }
    
    @Test("Tab can be disabled")
    @MainActor
    func testTabCanBeDisabled() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        
        preferencesService.toggleTabEnabled("calendar")
        
        #expect(!preferencesService.enabledTabs.contains("calendar"))
        #expect(preferencesService.enabledTabs.count == 4)
    }
    
    @Test("Required tabs cannot be disabled")
    @MainActor
    func testRequiredTabsProtected() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        
        let beforeDashboard = preferencesService.enabledTabs.contains("dashboard")
        let beforeSettings = preferencesService.enabledTabs.contains("settings")
        
        // Try to disable required tabs
        preferencesService.toggleTabEnabled("dashboard")
        preferencesService.toggleTabEnabled("settings")
        
        // Should still be enabled
        #expect(preferencesService.enabledTabs.contains("dashboard") == beforeDashboard)
        #expect(preferencesService.enabledTabs.contains("settings") == beforeSettings)
    }
    
    @Test("Automatic tab ordering returns alphabetical order")
    @MainActor
    func testAutomaticTabOrdering() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        preferencesService.tabAutomaticManage = true
        
        let orderedTabs = preferencesService.getOrderedTabIDs()
        
        // Should be alphabetical
        #expect(orderedTabs[0] == "calendar")
        #expect(orderedTabs[1] == "dashboard")
        #expect(orderedTabs[2] == "search")
        #expect(orderedTabs[3] == "services")
        #expect(orderedTabs[4] == "settings")
    }
    
    @Test("Manual tab ordering returns custom order")
    @MainActor
    func testManualTabOrdering() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        preferencesService.tabAutomaticManage = false
        preferencesService.updateTabOrder(["settings", "dashboard", "services", "calendar", "search"])
        
        let orderedTabs = preferencesService.getOrderedTabIDs()
        
        // Should match custom order
        #expect(orderedTabs[0] == "settings")
        #expect(orderedTabs[1] == "dashboard")
        #expect(orderedTabs[2] == "services")
        #expect(orderedTabs[3] == "calendar")
        #expect(orderedTabs[4] == "search")
    }
    
    @Test("Ordered tabs only include enabled tabs")
    @MainActor
    func testOrderedTabsFilterDisabled() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        
        // Disable calendar and search
        preferencesService.toggleTabEnabled("calendar")
        preferencesService.toggleTabEnabled("search")
        
        let orderedTabs = preferencesService.getOrderedTabIDs()
        
        #expect(orderedTabs.count == 3)
        #expect(!orderedTabs.contains("calendar"))
        #expect(!orderedTabs.contains("search"))
    }
    
    @Test("Tab enabled state check works correctly")
    @MainActor
    func testTabEnabledCheck() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        
        #expect(preferencesService.isTabEnabled("dashboard") == true)
        
        preferencesService.toggleTabEnabled("calendar")
        #expect(preferencesService.isTabEnabled("calendar") == false)
    }
    
    @Test("Tab order persists across reload")
    @MainActor
    func testTabOrderPersistence() async throws {
        let container = try ModelContainer.inMemoryContainer()
        let dataService = DataService(modelContainer: container, keychainService: KeychainService())
        try dataService.bootstrap()
        
        let preferencesService = try UserPreferencesService(dataService: dataService)
        preferencesService.tabAutomaticManage = false
        preferencesService.updateTabOrder(["settings", "dashboard", "services"])
        
        // Reload
        try preferencesService.reload()
        
        let orderedTabs = preferencesService.getOrderedTabIDs()
        #expect(orderedTabs[0] == "settings")
        #expect(orderedTabs[1] == "dashboard")
        #expect(orderedTabs[2] == "services")
    }
}
