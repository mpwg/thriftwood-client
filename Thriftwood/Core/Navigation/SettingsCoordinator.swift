//
//  SettingsCoordinator.swift
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
@Observable
final class SettingsCoordinator: @MainActor CoordinatorProtocol {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [SettingsRoute] = []
    
    // MARK: - Initialization
    
    init() {
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "SettingsCoordinator",
            details: "Settings navigation initialized"
        )
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.logCoordinator(
            event: "start",
            coordinator: "SettingsCoordinator",
            details: "Starting with main settings"
        )
        
        // Start with empty path - SettingsView is the root/main view
        navigationPath = []
        
        AppLogger.navigation.logStackChange(
            action: "set",
            coordinator: "SettingsCoordinator",
            stackSize: 0,
            route: "main (root)"
        )
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the profiles management screen
    func showProfiles() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .main),
            to: "Profiles",
            coordinator: "SettingsCoordinator"
        )
        navigate(to: .profiles)
    }
    
    /// Shows the add profile screen
    func showAddProfile() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .main),
            to: "AddProfile",
            coordinator: "SettingsCoordinator"
        )
        navigate(to: .addProfile)
    }
    
    /// Shows the edit profile screen
    /// - Parameter profileId: The ID of the profile to edit
    func showEditProfile(profileId: String) {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .main),
            to: "EditProfile[id:\(profileId)]",
            coordinator: "SettingsCoordinator"
        )
        navigate(to: .editProfile(profileId: profileId))
    }
    
    /// Shows the appearance settings screen
    func showAppearance() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .main),
            to: "Appearance",
            coordinator: "SettingsCoordinator"
        )
        navigate(to: .appearance)
    }
    
    /// Shows the notifications settings screen
    func showNotifications() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .main),
            to: "Notifications",
            coordinator: "SettingsCoordinator"
        )
        navigate(to: .notifications)
    }
    
    /// Shows the about screen
    func showAbout() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .main),
            to: "About",
            coordinator: "SettingsCoordinator"
        )
        navigate(to: .about)
    }
    
    /// Shows the logs screen
    func showLogs() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .main),
            to: "Logs",
            coordinator: "SettingsCoordinator"
        )
        navigate(to: .logs)
    }
}
