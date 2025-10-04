//
//  OnboardingCoordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator for the onboarding flow
//

import Foundation
import SwiftUI

/// Routes within the onboarding flow
enum OnboardingRoute: Hashable {
    case welcome
    case createProfile
    case addFirstService
    case complete
}

/// Coordinator that manages the onboarding flow for new users.
/// This is a child coordinator that reports back to AppCoordinator when complete.
@Observable
@MainActor
final class OnboardingCoordinator: Coordinator {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any Coordinator] = []
    weak var parent: (any Coordinator)?
    var navigationPath: [OnboardingRoute] = []
    
    // MARK: - Properties
    
    /// Closure called when onboarding is complete
    var onComplete: (() -> Void)?
    
    // MARK: - Initialization
    
    init() {
        Logger.navigation.info("OnboardingCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        Logger.navigation.info("OnboardingCoordinator starting")
        navigationPath = [.welcome]
    }
    
    // MARK: - Navigation Methods
    
    /// Proceeds to the create profile step
    func showCreateProfile() {
        Logger.navigation.info("Showing create profile")
        navigate(to: .createProfile)
    }
    
    /// Proceeds to adding the first service
    func showAddFirstService() {
        Logger.navigation.info("Showing add first service")
        navigate(to: .addFirstService)
    }
    
    /// Completes the onboarding flow
    func completeOnboarding() {
        Logger.navigation.info("Completing onboarding")
        onComplete?()
    }
    
    /// Skips onboarding and goes straight to the main app
    func skipOnboarding() {
        Logger.navigation.info("Skipping onboarding")
        onComplete?()
    }
}
