//
//  Coordinator.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Coordinator pattern implementation for app navigation
//

import Foundation
import SwiftUI

/// Protocol defining the core requirements for all coordinators in the app.
///
/// Based on the coordinator pattern from Hacking with Swift, adapted for SwiftUI.
/// Coordinators are responsible for managing navigation flow, removing this
/// responsibility from views and view models.
///
/// References:
/// - https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
/// - https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios
///
/// Note: This protocol is not marked as @MainActor to allow flexibility in conformance.
/// Individual coordinators should be marked @MainActor as needed.
protocol Coordinator: AnyObject {
    /// The type of route this coordinator handles
    associatedtype Route: Hashable
    
    /// Array of child coordinators managed by this coordinator.
    /// Child coordinators should be added when creating sub-flows and removed when finished.
    var childCoordinators: [any Coordinator] { get set }
    
    /// Reference to the parent coordinator (if this is a child coordinator).
    /// Use `weak` to avoid retain cycles since parent owns the child.
    var parent: (any Coordinator)? { get set }
    
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
    func childDidFinish(_ child: any Coordinator)
}

// MARK: - Default Implementations

extension Coordinator {
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
    func childDidFinish(_ child: any Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
