//
//  SettingsCoordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator for the settings feature
//

import Foundation
import SwiftUI
import OSLog

/// Coordinator that manages navigation within the Settings feature.
/// Handles navigation to various settings screens and preferences.
@MainActor
final class SettingsCoordinator: Coordinator, @unchecked Sendable {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any Coordinator] = []
    weak var parent: (any Coordinator)?
    var navigationPath: [SettingsRoute] = []
    
    // MARK: - Initialization
    
    init() {
        AppLogger.navigation.info("SettingsCoordinator initialized")
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.info("SettingsCoordinator starting")
        navigationPath = [.main]
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the profiles management screen
    func showProfiles() {
        AppLogger.navigation.info("Showing profiles")
        navigate(to: .profiles)
    }
    
    /// Shows the add profile screen
    func showAddProfile() {
        AppLogger.navigation.info("Showing add profile")
        navigate(to: .addProfile)
    }
    
    /// Shows the edit profile screen
    /// - Parameter profileId: The ID of the profile to edit
    func showEditProfile(profileId: String) {
        AppLogger.navigation.info("Showing edit profile: \(profileId)")
        navigate(to: .editProfile(profileId: profileId))
    }
    
    /// Shows the appearance settings screen
    func showAppearance() {
        AppLogger.navigation.info("Showing appearance settings")
        navigate(to: .appearance)
    }
    
    /// Shows the notifications settings screen
    func showNotifications() {
        AppLogger.navigation.info("Showing notifications settings")
        navigate(to: .notifications)
    }
    
    /// Shows the about screen
    func showAbout() {
        AppLogger.navigation.info("Showing about")
        navigate(to: .about)
    }
    
    /// Shows the logs screen
    func showLogs() {
        AppLogger.navigation.info("Showing logs")
        navigate(to: .logs)
    }
}
