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
        let coordinator = AppCoordinator()
        
        #expect(coordinator.childCoordinators.isEmpty)
        #expect(coordinator.navigationPath.isEmpty)
        #expect(coordinator.parent == nil)
        #expect(coordinator.activeCoordinator == nil)
    }
    
    @Test("AppCoordinator starts with onboarding when not completed")
    func testAppCoordinatorStartsWithOnboarding() async {
        // Reset onboarding state
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        let coordinator = AppCoordinator()
        coordinator.start()
        
        #expect(coordinator.navigationPath == [.onboarding])
        #expect(coordinator.childCoordinators.count == 1)
        #expect(coordinator.activeCoordinator is OnboardingCoordinator)
    }
    
    @Test("AppCoordinator starts with main app when onboarding completed")
    func testAppCoordinatorStartsWithMainApp() async {
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        let coordinator = AppCoordinator()
        coordinator.start()
        
        #expect(coordinator.navigationPath == [.main])
        #expect(coordinator.childCoordinators.count == 1)
        #expect(coordinator.activeCoordinator is TabCoordinator)
        
        // Clean up
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
    }
    
    @Test("AppCoordinator can reset onboarding")
    func testAppCoordinatorResetOnboarding() async {
        // Set onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        let coordinator = AppCoordinator()
        coordinator.start()
        
        // Reset onboarding
        coordinator.resetOnboarding()
        
        #expect(coordinator.navigationPath == [.onboarding])
        #expect(coordinator.activeCoordinator is OnboardingCoordinator)
        
        // Clean up
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
    }
    
    // MARK: - TabCoordinator Tests
    
    @Test("TabCoordinator initializes correctly")
    func testTabCoordinatorInitialization() async {
        let coordinator = TabCoordinator()
        
        #expect(coordinator.childCoordinators.isEmpty)
        #expect(coordinator.navigationPath.isEmpty)
        #expect(coordinator.parent == nil)
        #expect(coordinator.selectedTab == .dashboard)
    }
    
    @Test("TabCoordinator creates child coordinators on start")
    func testTabCoordinatorStartCreatesChildren() async {
        let coordinator = TabCoordinator()
        coordinator.start()
        
        #expect(coordinator.childCoordinators.count == 3)
        #expect(coordinator.dashboardCoordinator != nil)
        #expect(coordinator.servicesCoordinator != nil)
        #expect(coordinator.settingsCoordinator != nil)
    }
    
    @Test("TabCoordinator can switch tabs")
    func testTabCoordinatorSwitchTab() async {
        let coordinator = TabCoordinator()
        coordinator.start()
        
        coordinator.select(tab: .services)
        #expect(coordinator.selectedTab == .services)
        
        coordinator.select(tab: .settings)
        #expect(coordinator.selectedTab == .settings)
        
        coordinator.select(tab: .dashboard)
        #expect(coordinator.selectedTab == .dashboard)
    }
    
    // MARK: - DashboardCoordinator Tests
    
    @Test("DashboardCoordinator navigates to service detail")
    func testDashboardCoordinatorServiceDetail() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showServiceDetail(serviceId: "test-service")
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .serviceDetail(serviceId: "test-service"))
    }
    
    @Test("DashboardCoordinator navigates to media detail")
    func testDashboardCoordinatorMediaDetail() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showMediaDetail(mediaId: "test-media", serviceType: "radarr")
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .mediaDetail(mediaId: "test-media", serviceType: "radarr"))
    }
    
    @Test("DashboardCoordinator can pop navigation")
    func testDashboardCoordinatorPop() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showServiceDetail(serviceId: "test-service")
        #expect(coordinator.navigationPath.count == 2)
        
        coordinator.pop()
        #expect(coordinator.navigationPath.count == 1)
        #expect(coordinator.navigationPath.last == .home)
    }
    
    @Test("DashboardCoordinator can pop to root")
    func testDashboardCoordinatorPopToRoot() async {
        let coordinator = DashboardCoordinator()
        coordinator.start()
        
        coordinator.showServiceDetail(serviceId: "test-service-1")
        coordinator.showMediaDetail(mediaId: "test-media", serviceType: "radarr")
        #expect(coordinator.navigationPath.count == 3)
        
        coordinator.popToRoot()
        #expect(coordinator.navigationPath.isEmpty)
    }
    
    // MARK: - ServicesCoordinator Tests
    
    @Test("ServicesCoordinator navigates to add service")
    func testServicesCoordinatorAddService() async {
        let coordinator = ServicesCoordinator()
        coordinator.start()
        
        coordinator.showAddService()
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .addService)
    }
    
    @Test("ServicesCoordinator navigates to configuration")
    func testServicesCoordinatorConfiguration() async {
        let coordinator = ServicesCoordinator()
        coordinator.start()
        
        coordinator.showServiceConfiguration(serviceId: "test-service")
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .serviceConfiguration(serviceId: "test-service"))
    }
    
    @Test("ServicesCoordinator navigates to test connection")
    func testServicesCoordinatorTestConnection() async {
        let coordinator = ServicesCoordinator()
        coordinator.start()
        
        coordinator.showTestConnection(serviceId: "test-service")
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .testConnection(serviceId: "test-service"))
    }
    
    // MARK: - SettingsCoordinator Tests
    
    @Test("SettingsCoordinator navigates to profiles")
    func testSettingsCoordinatorProfiles() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showProfiles()
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .profiles)
    }
    
    @Test("SettingsCoordinator navigates to add profile")
    func testSettingsCoordinatorAddProfile() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showAddProfile()
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .addProfile)
    }
    
    @Test("SettingsCoordinator navigates to edit profile")
    func testSettingsCoordinatorEditProfile() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showEditProfile(profileId: "test-profile")
        
        #expect(coordinator.navigationPath.count == 2)
        #expect(coordinator.navigationPath.last == .editProfile(profileId: "test-profile"))
    }
    
    @Test("SettingsCoordinator navigates to appearance")
    func testSettingsCoordinatorAppearance() async {
        let coordinator = SettingsCoordinator()
        coordinator.start()
        
        coordinator.showAppearance()
        
        #expect(coordinator.navigationPath.count == 2)
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
    func testParentRemovesChildCoordinator() async {
        let parent = TabCoordinator()
        parent.start()
        
        let initialCount = parent.childCoordinators.count
        
        // Remove the first child
        if let firstChild = parent.childCoordinators.first {
            parent.childDidFinish(firstChild)
            #expect(parent.childCoordinators.count == initialCount - 1)
        }
    }
}
