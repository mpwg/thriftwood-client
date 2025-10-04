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
    
    @Test("Parse dashboard home URL")
    func testParseDashboardHomeURL() {
        let url = URL(string: "thriftwood://dashboard")!
        let route = DashboardRoute.parse(from: url)
        
        #expect(route == .home)
    }
    
    @Test("Parse dashboard service detail URL")
    func testParseDashboardServiceDetailURL() {
        let url = URL(string: "thriftwood://dashboard/service/radarr-1")!
        let route = DashboardRoute.parse(from: url)
        
        #expect(route == .serviceDetail(serviceId: "radarr-1"))
    }
    
    @Test("Parse dashboard media detail URL")
    func testParseDashboardMediaDetailURL() {
        let url = URL(string: "thriftwood://dashboard/media/12345/radarr")!
        let route = DashboardRoute.parse(from: url)
        
        #expect(route == .mediaDetail(mediaId: "12345", serviceType: "radarr"))
    }
    
    @Test("Generate dashboard home URL")
    func testGenerateDashboardHomeURL() {
        let route = DashboardRoute.home
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://dashboard")
    }
    
    @Test("Generate dashboard service detail URL")
    func testGenerateDashboardServiceDetailURL() {
        let route = DashboardRoute.serviceDetail(serviceId: "sonarr-2")
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://dashboard/service/sonarr-2")
    }
    
    @Test("Generate dashboard media detail URL")
    func testGenerateDashboardMediaDetailURL() {
        let route = DashboardRoute.mediaDetail(mediaId: "67890", serviceType: "sonarr")
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://dashboard/media/67890/sonarr")
    }
    
    // MARK: - ServicesRoute Deep Link Tests
    
    @Test("Parse services list URL")
    func testParseServicesListURL() {
        let url = URL(string: "thriftwood://services")!
        let route = ServicesRoute.parse(from: url)
        
        #expect(route == .list)
    }
    
    @Test("Parse services add URL")
    func testParseServicesAddURL() {
        let url = URL(string: "thriftwood://services/add")!
        let route = ServicesRoute.parse(from: url)
        
        #expect(route == .addService)
    }
    
    @Test("Parse services configure URL")
    func testParseServicesConfigureURL() {
        let url = URL(string: "thriftwood://services/configure/radarr-1")!
        let route = ServicesRoute.parse(from: url)
        
        #expect(route == .serviceConfiguration(serviceId: "radarr-1"))
    }
    
    @Test("Parse services test URL")
    func testParseServicesTestURL() {
        let url = URL(string: "thriftwood://services/test/radarr-1")!
        let route = ServicesRoute.parse(from: url)
        
        #expect(route == .testConnection(serviceId: "radarr-1"))
    }
    
    @Test("Generate services list URL")
    func testGenerateServicesListURL() {
        let route = ServicesRoute.list
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://services")
    }
    
    @Test("Generate services add URL")
    func testGenerateServicesAddURL() {
        let route = ServicesRoute.addService
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://services/add")
    }
    
    // MARK: - SettingsRoute Deep Link Tests
    
    @Test("Parse settings main URL")
    func testParseSettingsMainURL() {
        let url = URL(string: "thriftwood://settings")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .main)
    }
    
    @Test("Parse settings profiles URL")
    func testParseSettingsProfilesURL() {
        let url = URL(string: "thriftwood://settings/profiles")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .profiles)
    }
    
    @Test("Parse settings add profile URL")
    func testParseSettingsAddProfileURL() {
        let url = URL(string: "thriftwood://settings/profiles/add")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .addProfile)
    }
    
    @Test("Parse settings edit profile URL")
    func testParseSettingsEditProfileURL() {
        let url = URL(string: "thriftwood://settings/profiles/edit/profile-123")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .editProfile(profileId: "profile-123"))
    }
    
    @Test("Parse settings appearance URL")
    func testParseSettingsAppearanceURL() {
        let url = URL(string: "thriftwood://settings/appearance")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .appearance)
    }
    
    @Test("Parse settings notifications URL")
    func testParseSettingsNotificationsURL() {
        let url = URL(string: "thriftwood://settings/notifications")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .notifications)
    }
    
    @Test("Parse settings about URL")
    func testParseSettingsAboutURL() {
        let url = URL(string: "thriftwood://settings/about")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .about)
    }
    
    @Test("Parse settings logs URL")
    func testParseSettingsLogsURL() {
        let url = URL(string: "thriftwood://settings/logs")!
        let route = SettingsRoute.parse(from: url)
        
        #expect(route == .logs)
    }
    
    @Test("Generate settings main URL")
    func testGenerateSettingsMainURL() {
        let route = SettingsRoute.main
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://settings")
    }
    
    @Test("Generate settings profiles URL")
    func testGenerateSettingsProfilesURL() {
        let route = SettingsRoute.profiles
        let url = route.toURL()
        
        #expect(url?.absoluteString == "thriftwood://settings/profiles")
    }
    
    // MARK: - TabCoordinator Deep Link Handling Tests
    
    @Test("TabCoordinator handles dashboard deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorHandlesDashboardDeepLink() async {
        let coordinator = TabCoordinator()
        coordinator.start()
        
        let url = URL(string: "thriftwood://dashboard/service/test-service")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == true)
        #expect(coordinator.selectedTab == .dashboard)
        #expect(coordinator.dashboardCoordinator?.navigationPath.last == .serviceDetail(serviceId: "test-service"))
    }
    
    @Test("TabCoordinator handles services deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorHandlesServicesDeepLink() async {
        let coordinator = TabCoordinator()
        coordinator.start()
        
        let url = URL(string: "thriftwood://services/add")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == true)
        #expect(coordinator.selectedTab == .services)
        #expect(coordinator.servicesCoordinator?.navigationPath.last == .addService)
    }
    
    @Test("TabCoordinator handles settings deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorHandlesSettingsDeepLink() async {
        let coordinator = TabCoordinator()
        coordinator.start()
        
        let url = URL(string: "thriftwood://settings/profiles")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == true)
        #expect(coordinator.selectedTab == .settings)
        #expect(coordinator.settingsCoordinator?.navigationPath.last == .profiles)
    }
    
    @Test("TabCoordinator rejects invalid deep link", .tags(.navigationTag))
    @MainActor
    func testTabCoordinatorRejectsInvalidDeepLink() async {
        let coordinator = TabCoordinator()
        coordinator.start()
        
        let url = URL(string: "thriftwood://invalid/path")!
        let handled = coordinator.handleDeepLink(url)
        
        #expect(handled == false)
    }
    
    // MARK: - Round-trip Tests
    
    @Test("Dashboard route round-trip conversion")
    func testDashboardRouteRoundTrip() {
        let originalRoute = DashboardRoute.mediaDetail(mediaId: "12345", serviceType: "radarr")
        let url = originalRoute.toURL()!
        let parsedRoute = DashboardRoute.parse(from: url)
        
        #expect(parsedRoute == originalRoute)
    }
    
    @Test("Services route round-trip conversion")
    func testServicesRouteRoundTrip() {
        let originalRoute = ServicesRoute.serviceConfiguration(serviceId: "test-123")
        let url = originalRoute.toURL()!
        let parsedRoute = ServicesRoute.parse(from: url)
        
        #expect(parsedRoute == originalRoute)
    }
    
    @Test("Settings route round-trip conversion")
    func testSettingsRouteRoundTrip() {
        let originalRoute = SettingsRoute.editProfile(profileId: "profile-456")
        let url = originalRoute.toURL()!
        let parsedRoute = SettingsRoute.parse(from: url)
        
        #expect(parsedRoute == originalRoute)
    }
}

// MARK: - Test Tags

extension Tag {
    @Tag static var navigationTag: Self
}
