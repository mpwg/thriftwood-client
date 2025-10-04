//
//  SettingsCoordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator for the settings feature
//

import Foundation
import SwiftUI

/// Coordinator that manages navigation within the Settings feature.
/// Handles profiles, appearance, notifications, and other settings screens.
@Observable
@MainActor
final class SettingsCoordinator: Coordinator {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any Coordinator] = []
    weak var parent: (any Coordinator)?
    var navigationPath: [SettingsRoute] = []
    
    // MARK: - Initialization
    
    init() {
        Logger.navigation.info("SettingsCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        Logger.navigation.info("SettingsCoordinator starting")
        navigationPath = [.main]
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the profiles management screen
    func showProfiles() {
        Logger.navigation.info("Showing profiles")
        navigate(to: .profiles)
    }
    
    /// Shows the add profile screen
    func showAddProfile() {
        Logger.navigation.info("Showing add profile")
        navigate(to: .addProfile)
    }
    
    /// Shows the edit profile screen
    /// - Parameter profileId: The ID of the profile to edit
    func showEditProfile(profileId: String) {
        Logger.navigation.info("Showing edit profile: \(profileId)")
        navigate(to: .editProfile(profileId: profileId))
    }
    
    /// Shows the appearance settings screen
    func showAppearance() {
        Logger.navigation.info("Showing appearance settings")
        navigate(to: .appearance)
    }
    
    /// Shows the notifications settings screen
    func showNotifications() {
        Logger.navigation.info("Showing notifications settings")
        navigate(to: .notifications)
    }
    
    /// Shows the about screen
    func showAbout() {
        Logger.navigation.info("Showing about")
        navigate(to: .about)
    }
    
    /// Shows the logs screen
    func showLogs() {
        Logger.navigation.info("Showing logs")
        navigate(to: .logs)
    }
}
