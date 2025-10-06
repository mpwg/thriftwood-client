//
//  CoordinatorProtocol.swift
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

import Foundation
import SwiftUI

/// Protocol defining the core requirements for all coordinators in the app.
///
/// **File Naming Note**: This file is named `CoordinatorProtocol.swift` rather than
/// `Coordinator.swift` to clearly distinguish it from concrete coordinator implementations
/// (AppCoordinator, TabCoordinator, etc.). This naming convention helps avoid confusion
/// when navigating the codebase and makes it immediately clear that this file contains
/// the protocol definition.
///
/// Based on the coordinator pattern from Hacking with Swift, adapted for SwiftUI.
/// Coordinators are responsible for managing navigation flow, removing this
/// responsibility from views and view models.
///
/// References:
/// - https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
/// - https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios
///
@MainActor
protocol CoordinatorProtocol: AnyObject {
    /// The type of route this coordinator handles
    associatedtype Route: Hashable
    
    /// Array of child coordinators managed by this coordinator.
    /// Child coordinators should be added when creating sub-flows and removed when finished.
    var childCoordinators: [any CoordinatorProtocol] { get set }
    
    /// Reference to the parent coordinator (if this is a child coordinator).
    /// Use `weak` to avoid retain cycles since parent owns the child.
    var parent: (any CoordinatorProtocol)? { get set }
    
    /// The navigation path used with SwiftUI's NavigationStack.
    /// This replaces UINavigationController from the UIKit version.
    var navigationPath: [Route] { get set }
    
    /// Starts the coordinator, typically by showing the initial view.
    /// This is called when the coordinator is ready to take control.
    func start()
    
    /// Navigates to the specified route by adding it to the navigation path.
    /// - Parameter route: The destination route to navigate to
    func navigate(to route: Route)
    
    /// Removes the last route from the navigation path (equivalent to back button).
    func pop()
    
    /// Clears the entire navigation path, returning to the root view.
    func popToRoot()
    
    /// Called when a child coordinator has finished its work.
    /// The parent should remove the child from its childCoordinators array.
    /// - Parameter child: The child coordinator that finished
    func childDidFinish(_ child: any CoordinatorProtocol)
}

// MARK: - Default Implementations

extension CoordinatorProtocol {
    /// Default implementation for navigating to a route
    func navigate(to route: Route) {
        navigationPath.append(route)
    }
    
    /// Default implementation for popping the navigation stack
    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    /// Default implementation for popping to root
    func popToRoot() {
        navigationPath.removeAll()
    }
    
    /// Default implementation for cleaning up child coordinators.
    /// Uses identity comparison (===) to find the specific child coordinator.
    func childDidFinish(_ child: any CoordinatorProtocol) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
