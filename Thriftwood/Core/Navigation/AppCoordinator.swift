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
//
//  AppCoordinator.swift
//  Thriftwood
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
        AppLogger.navigation.info("AppCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.info("AppCoordinator starting")
        
        if hasCompletedOnboarding {
            showMainApp()
        } else {
            showOnboarding()
        }
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the onboarding flow for first-time users
    func showOnboarding() {
        AppLogger.navigation.info("Showing onboarding flow")
        
        // Create and start onboarding coordinator
        let onboardingCoordinator = OnboardingCoordinator()
        onboardingCoordinator.parent = self
        onboardingCoordinator.onComplete = { [weak self] in
            self?.onboardingDidComplete()
        }
        
        childCoordinators.append(onboardingCoordinator)
        activeCoordinator = onboardingCoordinator
        onboardingCoordinator.start()
        
        navigationPath = [.onboarding]
    }
    
    /// Shows the main app interface with tabs
    func showMainApp() {
        AppLogger.navigation.info("Showing main app")
        
        // Create and start tab coordinator with dependencies
        let tabCoordinator = TabCoordinator(
            preferencesService: preferencesService,
            radarrService: radarrService,
            dataService: dataService
        )
        tabCoordinator.parent = self
        
        childCoordinators.append(tabCoordinator)
        activeCoordinator = tabCoordinator
        tabCoordinator.start()
        
        navigationPath = [.main]
    }
    
    /// Called when onboarding is completed
    private func onboardingDidComplete() {
        AppLogger.navigation.info("Onboarding completed")
        
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Remove onboarding coordinator
        if let onboardingCoordinator = activeCoordinator {
            childDidFinish(onboardingCoordinator)
        }
        
        // Show main app
        showMainApp()
    }
    
    /// Resets the app to show onboarding again (useful for testing)
    func resetOnboarding() {
        AppLogger.navigation.info("Resetting onboarding state")
        
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        // Clear all child coordinators
        childCoordinators.removeAll()
        activeCoordinator = nil
        
        // Restart
        start()
    }
}
