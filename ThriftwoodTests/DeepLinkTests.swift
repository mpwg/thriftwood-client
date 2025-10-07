//
//  DeepLinkTests.swift
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
//  DeepLinkTests.swift
//  ThriftwoodTests
//
//  Created on 2025-10-04.
//  Tests for deep linking functionality
//

import Testing
import Foundation
@testable import Thriftwood

/// Tests for deep link parsing and URL generation
@Suite("Deep Link Tests")
struct DeepLinkTests {
    
    // MARK: - DashboardRoute Deep Link Tests
    
    @MainActor @Test("Parse dashboard home URL")
    func testParseDashboardHomeURL() {
        let url = URL(string: "thriftwood://dashboard")!
        let route = DashboardRoute.parse(from: url)
        
        #expect(route == .home)
    }
    
    @MainActor @Test("Parse dashboard service detail URL")
    func testParseDashboardServiceDetailURL() {
        let url = URL(string: "thriftwood://dashboard/service/radarr-1")!
        let route = DashboardRoute.parse(from: url)
        
        #expect(route == .serviceDetail(serviceId: "radarr-1"))
    }
    
    @MainActor @Test("Parse dashboard media detail URL")
    func testParseDashboardMediaDetailURL() {
        let url = URL(string: "thriftwood://dashboard/media/12345/radarr")!
        let route = DashboardRoute.parse(from: url)
        
        #expect(route == .mediaDetail(mediaId: "12345", serviceType: "radarr"))
    }
    
    @MainActor @Test("Generate dashboard home URL")
    func testGenerateDashboardHomeURL() {
        let route = DashboardRoute.home
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://dashboard")
    }
    
    @MainActor @Test("Generate dashboard service detail URL")
    func testGenerateDashboardServiceDetailURL() {
        let route = DashboardRoute.serviceDetail(serviceId: "sonarr-2")
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://dashboard/service/sonarr-2")
    }
    
    @MainActor @Test("Generate dashboard media detail URL")
    func testGenerateDashboardMediaDetailURL() {
        let route = DashboardRoute.mediaDetail(mediaId: "67890", serviceType: "sonarr")
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://dashboard/media/67890/sonarr")
    }
    
    // MARK: - Obsolete Route Tests Removed
    // ServicesRoute and SettingsRoute were consolidated into AppRoute (ADR-0012)
    // Deep link tests for those routes have been removed
    // TODO: Add AppRoute deep link tests when deep linking is implemented
    
    // MARK: - TabCoordinator Tests (Disabled - Phase 1 removed tabs)
    
    // TODO: Phase 2 - Update these tests for new hierarchical navigation structure
    // These tests were written for the old TabCoordinator which was removed in Phase 1.
    // They need to be rewritten to test the new AppCoordinator and hierarchical navigation.
    
    /*
    @Test("TabCoordinator handles dashboard deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorHandlesDashboardDeepLink() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        let url = URL(string: "thriftwood://dashboard/service/test-service")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == true)
        #expect(coordinator.selectedTab == TabRoute.dashboard)
        #expect(coordinator.dashboardCoordinator?.navigationPath.last == .serviceDetail(serviceId: "test-service"))
    }
    
    @Test("TabCoordinator handles services deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorHandlesServicesDeepLink() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        let url = URL(string: "thriftwood://services/add")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == true)
        #expect(coordinator.selectedTab == TabRoute.services)
        #expect(coordinator.servicesCoordinator?.navigationPath.last == .addService)
    }
    
    @Test("TabCoordinator handles settings deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorHandlesSettingsDeepLink() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        let url = URL(string: "thriftwood://settings/profiles")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == true)
        #expect(coordinator.selectedTab == TabRoute.settings)
        #expect(coordinator.settingsCoordinator?.navigationPath.last == .profiles)
    }
    
    @Test("TabCoordinator rejects invalid deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorRejectsInvalidDeepLink() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        let url = URL(string: "thriftwood://invalid/path")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == false)
    }
    */
    
    // MARK: - Round-trip Tests
    
    @MainActor @Test("Dashboard route round-trip conversion")
    func testDashboardRouteRoundTrip() {
        let originalRoute = DashboardRoute.mediaDetail(mediaId: "12345", serviceType: "radarr")
        let url = originalRoute.toURL()!
        let parsedRoute = DashboardRoute.parse(from: url)
        
        #expect(parsedRoute == originalRoute)
    }
    
    // ServicesRoute and SettingsRoute round-trip tests removed (routes consolidated into AppRoute)
}

// MARK: - Test Tags

extension Tag {
    @Tag static var navigationTag: Self
}
