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
final class AppCoordinator: Coordinator {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any Coordinator] = []
    weak var parent: (any Coordinator)?
    var navigationPath: [AppRoute] = []
    
    // MARK: - Properties
    
    /// Whether the user has completed onboarding
    private var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    /// The current active child coordinator (tab coordinator or onboarding)
    private(set) var activeCoordinator: (any Coordinator)?
    
    // MARK: - Initialization
    
    init() {
        Logger.navigation.info("AppCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        Logger.navigation.info("AppCoordinator starting")
        
        if hasCompletedOnboarding {
            showMainApp()
        } else {
            showOnboarding()
        }
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the onboarding flow for first-time users
    func showOnboarding() {
        Logger.navigation.info("Showing onboarding flow")
        
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
        Logger.navigation.info("Showing main app")
        
        // Create and start tab coordinator
        let tabCoordinator = TabCoordinator()
        tabCoordinator.parent = self
        
        childCoordinators.append(tabCoordinator)
        activeCoordinator = tabCoordinator
        tabCoordinator.start()
        
        navigationPath = [.main]
    }
    
    /// Called when onboarding is completed
    private func onboardingDidComplete() {
        Logger.navigation.info("Onboarding completed")
        
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
        Logger.navigation.info("Resetting onboarding state")
        
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        // Clear all child coordinators
        childCoordinators.removeAll()
        activeCoordinator = nil
        
        // Restart
        start()
    }
}
