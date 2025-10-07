//
//  AppCoordinator.swift
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
//  Created on 2025-10-04.
//  Root coordinator for the entire application
//

import Foundation
import SwiftUI

/// Root coordinator that manages the top-level navigation flow.
/// This is equivalent to the MainCoordinator in the Hacking with Swift tutorial,
/// but adapted for SwiftUI's NavigationStack pattern.
@Observable
@MainActor
final class AppCoordinator: @MainActor CoordinatorProtocol {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [AppRoute] = []
    
    // MARK: - Properties
    
    /// User preferences service for configuration
    private let preferencesService: any UserPreferencesServiceProtocol
    
    /// Profile service for checking if profiles exist
    private let profileService: any ProfileServiceProtocol
    
    /// Radarr service for TabCoordinator's ServicesCoordinator
    private let radarrService: any RadarrServiceProtocol
    
    /// Data service for TabCoordinator's ServicesCoordinator
    private let dataService: any DataServiceProtocol
    
    /// Whether the user has completed onboarding
    private var hasCompletedOnboarding: Bool {
        // Check both UserDefaults flag AND if at least one profile exists
        let hasFlag = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if !hasFlag {
            return false
        }
        
        // Verify at least one profile exists
        do {
            let profiles = try profileService.fetchProfiles()
            return !profiles.isEmpty
        } catch {
            AppLogger.navigation.error("Failed to check profiles during onboarding check: \(error.localizedDescription)")
            return false
        }
    }
    
    /// The current active child coordinator (tab coordinator or onboarding)
    private(set) var activeCoordinator: (any CoordinatorProtocol)?
    
    // MARK: - Initialization
    
    init(
        preferencesService: any UserPreferencesServiceProtocol,
        profileService: any ProfileServiceProtocol,
        radarrService: any RadarrServiceProtocol,
        dataService: any DataServiceProtocol
    ) {
        self.preferencesService = preferencesService
        self.profileService = profileService
        self.radarrService = radarrService
        self.dataService = dataService
        
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "AppCoordinator",
            details: "Root coordinator initialized with dependencies"
        )
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.logCoordinator(
            event: "start",
            coordinator: "AppCoordinator",
            details: "Determining initial flow (onboarding vs main app)"
        )
        
        if hasCompletedOnboarding {
            AppLogger.navigation.info("✅ User has completed onboarding, showing main app")
            showMainApp()
        } else {
            AppLogger.navigation.info("🆕 First-time user detected, showing onboarding")
            showOnboarding()
        }
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the onboarding flow for first-time users
    func showOnboarding() {
        AppLogger.navigation.logNavigation(
            from: "Root",
            to: "Onboarding",
            coordinator: "AppCoordinator"
        )
        
        // Create and start onboarding coordinator
        let onboardingCoordinator = OnboardingCoordinator()
        onboardingCoordinator.parent = self
        onboardingCoordinator.onComplete = { [weak self] in
            self?.onboardingDidComplete()
        }
        
        childCoordinators.append(onboardingCoordinator)
        activeCoordinator = onboardingCoordinator
        
        AppLogger.navigation.logCoordinator(
            event: "add_child",
            coordinator: "OnboardingCoordinator",
            details: "Added to AppCoordinator, total children: \(childCoordinators.count)"
        )
        
        onboardingCoordinator.start()
        
        navigationPath = [.onboarding]
        
        AppLogger.navigation.logStackChange(
            action: "set",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "onboarding"
        )
    }
    
    /// Shows the main app interface with hierarchical navigation
    func showMainApp() {
        AppLogger.navigation.logNavigation(
            from: activeCoordinator != nil ? "Onboarding" : "Root",
            to: "MainApp",
            coordinator: "AppCoordinator"
        )
        
        // Clear navigation path - main app starts at root (AppHomeView)
        navigationPath = []
        
        AppLogger.navigation.logStackChange(
            action: "clear",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "root"
        )
    }
    
    /// Navigate to Services view
    func navigateToServices() {
        AppLogger.navigation.logNavigation(
            from: "AppHome",
            to: "Services",
            coordinator: "AppCoordinator"
        )
        
        navigationPath.append(.services)
        
        AppLogger.navigation.logStackChange(
            action: "push",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "services"
        )
    }
    
    /// Navigate to Radarr feature
    func navigateToRadarr() {
        AppLogger.navigation.logNavigation(
            from: "Current",
            to: "Radarr",
            coordinator: "AppCoordinator"
        )
        
        navigationPath.append(.radarr)
        
        AppLogger.navigation.logStackChange(
            action: "push",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "radarr"
        )
    }
    
    /// Navigate to Settings view
    func navigateToSettings() {
        AppLogger.navigation.logNavigation(
            from: "Current",
            to: "Settings",
            coordinator: "AppCoordinator"
        )
        
        navigationPath.append(.settings)
        
        AppLogger.navigation.logStackChange(
            action: "push",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "settings"
        )
    }
    
    /// Pops to root (App Home)
    func popToRoot() {
        AppLogger.navigation.logNavigation(
            from: "Current",
            to: "AppHome (root)",
            coordinator: "AppCoordinator"
        )
        
        navigationPath.removeAll()
        
        AppLogger.navigation.logStackChange(
            action: "pop_to_root",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "root"
        )
    }
    
    /// Called when onboarding is completed
    private func onboardingDidComplete() {
        AppLogger.navigation.logCoordinator(
            event: "callback",
            coordinator: "OnboardingCoordinator",
            details: "onComplete callback triggered"
        )
        
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        AppLogger.navigation.info("💾 Saved onboarding completion flag to UserDefaults")
        
        // Remove onboarding coordinator
        if let onboardingCoordinator = activeCoordinator {
            AppLogger.navigation.logCoordinator(
                event: "finish",
                coordinator: "OnboardingCoordinator",
                details: "Cleaning up onboarding coordinator"
            )
            childDidFinish(onboardingCoordinator)
            activeCoordinator = nil  // Clear active coordinator to trigger view update
        }
        
        // Show main app
        AppLogger.navigation.info("🔄 Transitioning from onboarding to main app")
        showMainApp()
    }
    
    /// Resets the app to show onboarding again (useful for testing)
    func resetOnboarding() {
        AppLogger.navigation.logCoordinator(
            event: "reset",
            coordinator: "AppCoordinator",
            details: "Resetting onboarding state (dev/test feature)"
        )
        
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        // Clear all child coordinators
        let childCount = childCoordinators.count
        childCoordinators.removeAll()
        activeCoordinator = nil
        
        AppLogger.navigation.info("🗑️  Removed \(childCount) child coordinators")
        
        // Restart
        AppLogger.navigation.info("🔄 Restarting AppCoordinator flow")
        start()
    }
}
