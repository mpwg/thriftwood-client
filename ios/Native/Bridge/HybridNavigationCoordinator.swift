//
//  HybridNavigationCoordinator.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  Navigation coordinator for managing hybrid Flutter/SwiftUI navigation
//

import Foundation
import SwiftUI
import Flutter

/// Coordinates navigation between Flutter and SwiftUI views
@Observable
class HybridNavigationCoordinator {
    
    // MARK: - Properties
    
    /// Current navigation stack for SwiftUI views
    var navigationPath = NavigationPath()
    
    /// Current active route
    var currentRoute: String = "/"
    
    /// Navigation history for back button handling
    private var navigationHistory: [NavigationEntry] = []
    
    // MARK: - Navigation Entry
    
    struct NavigationEntry {
        let route: String
        let data: [String: Any]
        let timestamp: Date
        let isNative: Bool
        
        init(route: String, data: [String: Any] = [:], isNative: Bool) {
            self.route = route
            self.data = data
            self.timestamp = Date()
            self.isNative = isNative
        }
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate from Flutter to either SwiftUI or another Flutter view
    /// - Parameters:
    ///   - route: Target route
    ///   - data: Navigation data
    func navigateFromFlutter(to route: String, data: [String: Any] = [:]) {
        print("Navigation request from Flutter to: \(route)")
        
        let entry = NavigationEntry(
            route: route,
            data: data,
            isNative: FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route)
        )
        
        addToHistory(entry)
        
        if entry.isNative {
            // Show SwiftUI view
            print("Navigating to native SwiftUI view: \(route)")
            FlutterSwiftUIBridge.shared.presentNativeView(route: route, data: data)
        } else {
            // Continue with Flutter navigation
            print("Continuing with Flutter navigation: \(route)")
            navigateInFlutter(to: route, data: data)
        }
        
        currentRoute = route
    }
    
    /// Navigate from SwiftUI to either another SwiftUI view or Flutter
    /// - Parameters:
    ///   - route: Target route
    ///   - data: Navigation data
    func navigateFromSwiftUI(to route: String, data: [String: Any] = [:]) {
        print("Navigation request from SwiftUI to: \(route)")
        
        let entry = NavigationEntry(
            route: route,
            data: data,
            isNative: FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route)
        )
        
        addToHistory(entry)
        
        if entry.isNative {
            // Navigate to another SwiftUI view
            print("Navigating to another SwiftUI view: \(route)")
            navigateInSwiftUI(to: route, data: data)
        } else {
            // Navigate back to Flutter for this view
            print("Returning to Flutter for route: \(route)")
            FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
                "navigateTo": route,
                "navigationData": data
            ])
        }
        
        currentRoute = route
    }
    
    /// Handle back navigation
    /// - Returns: True if back navigation was handled, false otherwise
    func navigateBack() -> Bool {
        guard navigationHistory.count > 1 else {
            print("No navigation history available for back navigation")
            return false
        }
        
        // Remove current entry
        navigationHistory.removeLast()
        
        // Get previous entry
        let previousEntry = navigationHistory.last!
        
        print("Navigating back to: \(previousEntry.route)")
        
        if previousEntry.isNative {
            // Navigate back to SwiftUI view
            navigateInSwiftUI(to: previousEntry.route, data: previousEntry.data)
        } else {
            // Navigate back to Flutter view
            FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
                "navigateTo": previousEntry.route,
                "navigationData": previousEntry.data
            ])
        }
        
        currentRoute = previousEntry.route
        return true
    }
    
    // MARK: - Private Navigation Methods
    
    private func navigateInFlutter(to route: String, data: [String: Any]) {
        // Use the method channel from the bridge
        guard let methodChannel = FlutterSwiftUIBridge.shared.methodChannel else {
            print("Error: Method channel not available for Flutter navigation")
            presentError(
                title: "Navigation not available",
                message: "Unable to communicate with Flutter for route \(route).",
                actions: [.backToFlutter]
            )
            return
        }
        
        methodChannel.invokeMethod("navigateInFlutter", arguments: [
            "route": route,
            "data": data
        ]) { result in
            if let error = result as? FlutterError {
                print("Flutter navigation error: \(error.message ?? "Unknown error")")
                self.presentError(
                    title: "Navigation failed",
                    message: "Could not open \(route) in Flutter.",
                    actions: [.retry, .backToFlutter],
                    retryRoute: route,
                    data: data
                )
            } else {
                print("Flutter navigation successful to: \(route)")
            }
        }
    }
    
    private func navigateInSwiftUI(to route: String, data: [String: Any]) {
        // Handle SwiftUI-to-SwiftUI navigation
        DispatchQueue.main.async { [weak self] in
            // For now, we'll handle this by updating the navigation path
            // In a real implementation, this would integrate with SwiftUI's NavigationStack
            self?.navigationPath.append(route)
        }
    }
    
    // MARK: - History Management
    
    private func addToHistory(_ entry: NavigationEntry) {
        navigationHistory.append(entry)
        
        // Limit history size to prevent memory issues
        if navigationHistory.count > 50 {
            navigationHistory.removeFirst(10)
        }
    }
    
    /// Get navigation history for debugging
    /// - Returns: Array of navigation entries
    func getNavigationHistory() -> [NavigationEntry] {
        return navigationHistory
    }
    
    /// Clear navigation history
    func clearHistory() {
        navigationHistory.removeAll()
        navigationPath = NavigationPath()
        currentRoute = "/"
        print("Navigation history cleared")
    }
    
    // MARK: - Route Utilities
    
    /// Check if we can navigate back
    /// - Returns: True if back navigation is possible
    func canNavigateBack() -> Bool {
        return navigationHistory.count > 1
    }
    
    /// Get the current navigation depth
    /// - Returns: Number of navigation entries
    func getNavigationDepth() -> Int {
        return navigationHistory.count
    }
    
    /// Get the previous route if available
    /// - Returns: Previous route or nil
    func getPreviousRoute() -> String? {
        guard navigationHistory.count > 1 else { return nil }
        return navigationHistory[navigationHistory.count - 2].route
    }

    // MARK: - Error Presentation

    enum ErrorAction {
        case retry
        case backToFlutter
    }

    /// Present an actionable error to the user with optional retry/back actions
    /// Falls back to Flutter with an instruction to show an error snackbar
    func presentError(
        title: String,
        message: String,
        actions: [ErrorAction] = [.backToFlutter],
        retryRoute: String? = nil,
        data: [String: Any] = [:]
    ) {
        var payload: [String: Any] = [
            "showErrorSnackbar": true,
            "errorTitle": title,
            "errorMessage": message
        ]

        if let retry = retryRoute, actions.contains(.retry) {
            payload["navigateTo"] = retry
            payload["navigationData"] = data
        }

        // Return to Flutter with error context for user-facing UI
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: payload)
    }
}

// MARK: - Navigation Extensions

extension HybridNavigationCoordinator {
    
    /// Deep link handler for external navigation
    /// - Parameters:
    ///   - url: Deep link URL
    ///   - sourceApplication: Source application (optional)
    /// - Returns: True if the deep link was handled
    func handleDeepLink(_ url: URL, sourceApplication: String? = nil) -> Bool {
        print("Handling deep link: \(url.absoluteString)")
        
        // Extract route from URL
        guard let route = extractRouteFromURL(url) else {
            print("Could not extract route from URL: \(url)")
            return false
        }
        
        // Extract parameters
        let parameters = extractParametersFromURL(url)
        
        // Special handling for dashboard routes
        if route == "/dashboard" || route.hasPrefix("/dashboard/") {
            handleDashboardDeepLink(route: route, parameters: parameters)
        } else {
            // Navigate to the deep link route
            navigateFromFlutter(to: route, data: parameters)
        }
        
        return true
    }
    
    /// Handle dashboard-specific deep links
    /// - Parameters:
    ///   - route: Dashboard route
    ///   - parameters: URL parameters
    private func handleDashboardDeepLink(route: String, parameters: [String: Any]) {
        // If dashboard is native, present it directly
        if FlutterSwiftUIBridge.shared.shouldUseNativeView(for: "/dashboard") {
            var dashboardData = parameters
            
            // Handle specific dashboard deep link scenarios
            if route == "/dashboard" {
                // Main dashboard
                dashboardData["selectedTab"] = 0
            } else if route == "/dashboard/calendar" {
                // Calendar tab
                dashboardData["selectedTab"] = 1
            } else if route.hasPrefix("/dashboard/service/") {
                // Service-specific navigation
                let serviceKey = String(route.dropFirst("/dashboard/service/".count))
                dashboardData["navigateToService"] = serviceKey
            }
            
            FlutterSwiftUIBridge.shared.presentNativeView(route: "/dashboard", data: dashboardData)
        } else {
            // Fallback to Flutter navigation
            navigateFromFlutter(to: route, data: parameters)
        }
    }
    
    private func extractRouteFromURL(_ url: URL) -> String? {
        // Implementation for extracting route from URL
        // This would depend on your URL scheme
        return url.path
    }
    
    private func extractParametersFromURL(_ url: URL) -> [String: Any] {
        // Implementation for extracting parameters from URL
        var parameters: [String: Any] = [:]
        
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                parameters[item.name] = item.value
            }
        }
        
        return parameters
    }
}