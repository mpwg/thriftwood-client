//
//  CoordinatorTests.swift
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
//  CoordinatorTests.swift
//  ThriftwoodTests
//
//  Created on 2025-10-04.
//  Tests for the coordinator pattern implementation
//

import Testing
import Foundation
@testable import Thriftwood

/// Tests for the base Coordinator protocol and its implementations
@Suite("Coordinator Tests", .serialized)
@MainActor
struct CoordinatorTests {
    
    // MARK: - AppCoordinator Tests
    
    @Test("AppCoordinator initializes correctly")
    func testAppCoordinatorInitialization() async {
        let mockPrefs = MockUserPreferencesService()
        let mockProfiles = MockProfileService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = AppCoordinator(
            preferencesService: mockPrefs,
            profileService: mockProfiles,
            radarrService: mockRadarr,
            dataService: mockData
        )
        
        #expect(coordinator.childCoordinators.isEmpty)
        #expect(coordinator.navigationPath.isEmpty)
        #expect(coordinator.parent == nil)
        #expect(coordinator.activeCoordinator == nil)
    }
    
    @Test("AppCoordinator starts with onboarding when not completed")
    @MainActor
    func testAppCoordinatorStartsWithOnboarding() async {
        // Reset onboarding state
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        let mockPrefs = MockUserPreferencesService()
        let mockProfiles = MockProfileService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = AppCoordinator(
            preferencesService: mockPrefs,
            profileService: mockProfiles,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        #expect(coordinator.navigationPath == [AppRoute.onboarding])
        #expect(coordinator.childCoordinators.count == 1)
        #expect(coordinator.activeCoordinator is OnboardingCoordinator)
    }
    
    @Test("AppCoordinator starts with main app when onboarding completed")
    @MainActor
    func testAppCoordinatorStartsWithMainApp() async {
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        let mockPrefs = MockUserPreferencesService()
        let mockProfiles = MockProfileService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = AppCoordinator(
            preferencesService: mockPrefs,
            profileService: mockProfiles,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        #expect(coordinator.navigationPath == [AppRoute.main])
        #expect(coordinator.childCoordinators.count == 1)
        #expect(coordinator.activeCoordinator is TabCoordinator)
        
        // Clean up
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
    }
    
    @Test("AppCoordinator can reset onboarding")
    @MainActor
    func testAppCoordinatorResetOnboarding() async {
        // Set onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        let mockPrefs = MockUserPreferencesService()
        let mockProfiles = MockProfileService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = AppCoordinator(
            preferencesService: mockPrefs,
            profileService: mockProfiles,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        // Reset onboarding
        coordinator.resetOnboarding()
        
        #expect(coordinator.navigationPath == [AppRoute.onboarding])
        #expect(coordinator.activeCoordinator is OnboardingCoordinator)
        
        // Clean up
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
    }
    
    // MARK: - TabCoordinator Tests
    
    @Test("TabCoordinator initializes correctly")
    @MainActor
    func testTabCoordinatorInitialization() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        
        #expect(coordinator.childCoordinators.isEmpty)
        #expect(coordinator.navigationPath.isEmpty)
        #expect(coordinator.parent == nil)
        #expect(coordinator.selectedTab == TabRoute.dashboard)
    }
    
    @Test("TabCoordinator creates child coordinators on start")
    @MainActor
    func testTabCoordinatorStartCreatesChildren() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        #expect(coordinator.childCoordinators.count == 3)
        #expect(coordinator.dashboardCoordinator != nil)
        #expect(coordinator.servicesCoordinator != nil)
        #expect(coordinator.settingsCoordinator != nil)
    }
    
    @Test("TabCoordinator can switch tabs")
    @MainActor
    func testTabCoordinatorSwitchTab() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        coordinator.select(tab: TabRoute.services)
        #expect(coordinator.selectedTab == TabRoute.services)
        
        coordinator.select(tab: TabRoute.settings)
        #expect(coordinator.selectedTab == TabRoute.settings)
        
        coordinator.select(tab: .dashboard)
        #expect(coordinator.selectedTab == .dashboard)
    }
    
    @Test("TabCoordinator pops to root when tab is re-selected")
    @MainActor
    func testTabCoordinatorPopToRootOnReselect() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        // Navigate deep into services
        if let servicesCoordinator = coordinator.servicesCoordinator {
            servicesCoordinator.navigate(to: .radarr)
            servicesCoordinator.navigate(to: .serviceConfiguration(serviceId: "test"))
            // After start() sets empty path and two navigate() calls append, we have 2 items
            #expect(servicesCoordinator.navigationPath.count == 2)
        }
        
        // Tap on services tab again (simulating re-selection)
        coordinator.popToRoot(for: .services)
        
        // Should pop to root
        #expect(coordinator.servicesCoordinator?.navigationPath.isEmpty == true)
    }
    
    // MARK: - DashboardCoordinator Tests
    
    @Test("DashboardCoordinator navigates to service detail")
    func testDashboardCoordinatorServiceDetail() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showServiceDetail(serviceId: "test-service")
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .serviceDetail(serviceId: "test-service"))
    }
    
    @Test("DashboardCoordinator navigates to media detail")
    func testDashboardCoordinatorMediaDetail() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showMediaDetail(mediaId: "test-media", serviceType: "radarr")
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .mediaDetail(mediaId: "test-media", serviceType: "radarr"))
    }
    
    @Test("DashboardCoordinator can pop navigation")
    func testDashboardCoordinatorPop() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showServiceDetail(serviceId: "test-service")
        #expect(coordinator.navigationPath.count == 1)
        
        coordinator.pop()
        #expect(coordinator.navigationPath.count == 0)
        #expect(coordinator.navigationPath.isEmpty)
    }
    
    @Test("DashboardCoordinator can pop to root")
    func testDashboardCoordinatorPopToRoot() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showServiceDetail(serviceId: "test-service-1")
        coordinator.showMediaDetail(mediaId: "test-media", serviceType: "radarr")
        #expect(coordinator.navigationPath.count == 2)
        
        coordinator.popToRoot()
        #expect(coordinator.navigationPath.isEmpty)
    }
    
    // MARK: - ServicesCoordinator Tests
    
    @Test("ServicesCoordinator navigates to add service")
    func testServicesCoordinatorAddService() async {
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = ServicesCoordinator(
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        coordinator.showAddService()
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .addService)
    }
    
    @Test("ServicesCoordinator navigates to configuration")
    func testServicesCoordinatorConfiguration() async {
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = ServicesCoordinator(
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        coordinator.showServiceConfiguration(serviceId: "test-service")
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .serviceConfiguration(serviceId: "test-service"))
    }
    
    @Test("ServicesCoordinator navigates to test connection")
    func testServicesCoordinatorTestConnection() async {
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let coordinator = ServicesCoordinator(
            radarrService: mockRadarr,
            dataService: mockData
        )
        coordinator.start()
        
        coordinator.showTestConnection(serviceId: "test-service")
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .testConnection(serviceId: "test-service"))
    }
    
    // MARK: - SettingsCoordinator Tests
    
    @Test("SettingsCoordinator navigates to profiles")
    func testSettingsCoordinatorProfiles() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showProfiles()
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .profiles)
    }
    
    @Test("SettingsCoordinator navigates to add profile")
    func testSettingsCoordinatorAddProfile() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showAddProfile()
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .addProfile)
    }
    
    @Test("SettingsCoordinator navigates to edit profile")
    func testSettingsCoordinatorEditProfile() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showEditProfile(profileId: "test-profile")
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .editProfile(profileId: "test-profile"))
    }
    
    @Test("SettingsCoordinator navigates to appearance")
    func testSettingsCoordinatorAppearance() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showAppearance()
        
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .appearance)
    }
    
    // MARK: - OnboardingCoordinator Tests
    
    @Test("OnboardingCoordinator completes onboarding flow")
    func testOnboardingCoordinatorComplete() async {
        var completionCalled = false
        
        let coordinator = OnboardingCoordinator()
        coordinator.onComplete = {
            completionCalled = true
        }
        coordinator.start()
        
        coordinator.completeOnboarding()
        
        #expect(completionCalled)
    }
    
    @Test("OnboardingCoordinator can skip onboarding")
    func testOnboardingCoordinatorSkip() async {
        var completionCalled = false
        
        let coordinator = OnboardingCoordinator()
        coordinator.onComplete = {
            completionCalled = true
        }
        coordinator.start()
        
        coordinator.skipOnboarding()
        
        #expect(completionCalled)
    }
    
    // MARK: - Child Coordinator Tests
    
    @Test("Parent coordinator removes child coordinator")
    @MainActor
    func testParentRemovesChildCoordinator() async {
        let mockPrefs = MockUserPreferencesService()
        let mockRadarr = MockRadarrService()
        let mockData = MockDataService()
        let parent = TabCoordinator(
            preferencesService: mockPrefs,
            radarrService: mockRadarr,
            dataService: mockData
        )
        parent.start()
        
        let initialCount = parent.childCoordinators.count
        
        // Remove the first child
        if let firstChild = parent.childCoordinators.first {
            parent.childDidFinish(firstChild)
            #expect(parent.childCoordinators.count == initialCount - 1)
        }
    }
}
