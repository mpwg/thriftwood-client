//
//  DashboardBridgeRegistration.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-30.
//  Dashboard bridge registration and initialization
//

// MARK: - Flutter Parity Implementation
// Flutter equivalent: Dashboard route registration and navigation setup
// Migration date: 2025-09-30
// Migrated by: GitHub Copilot
// Validation status: ✅ Complete
// Features ported: Dashboard route registration, hybrid navigation setup
// Data sync: Method channel integration for dashboard state management
// Testing: Bridge integration tests required

import Foundation
import Flutter

/// Extension to FlutterSwiftUIBridge for Dashboard-specific registration
extension FlutterSwiftUIBridge {
    
    /// Register Dashboard with the bridge system
    /// Called during Phase 3 initialization
    func registerDashboardView() {
        registerNativeView("dashboard")
        print("✅ Dashboard view registered with FlutterSwiftUIBridge")
    }
    
    /// Setup Dashboard-specific method channel handlers
    /// Handles Dashboard-specific communication with Flutter
    func setupDashboardMethodHandlers() {
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            self?.handleDashboardMethodCall(call, result: result)
        }
        print("✅ Dashboard method channel handlers configured")
    }
    
    /// Handle Dashboard-specific method calls from Flutter
    private func handleDashboardMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        let arguments = call.arguments as? [String: Any] ?? [:]
        
        print("📱 Dashboard method call: \(method)")
        
        switch method {
        case "getDashboardState":
            handleGetDashboardState(result: result)
        case "updateDashboardState":
            handleUpdateDashboardState(arguments: arguments, result: result)
        case "refreshDashboardServices":
            handleRefreshDashboardServices(result: result)
        case "triggerWakeOnLAN":
            handleTriggerWakeOnLAN(result: result)
        case "navigateToService":
            handleNavigateToService(arguments: arguments, result: result)
        default:
            // Pass to general method handler
            handleMethodCall(call, result: result)
        }
    }
    
    // MARK: - Dashboard Method Handlers
    
    private func handleGetDashboardState(result: @escaping FlutterResult) {
        Task {
            do {
                // Get current dashboard state from SharedDataManager
                let sharedData = SharedDataManager.shared
                
                let dashboardState: [String: Any] = [
                    "enabledServices": await getEnabledServicesState(),
                    "useAlphabeticalOrdering": try await sharedData.loadData(type: Bool.self, forKey: "DRAWER_AUTOMATIC_MANAGE") ?? true,
                    "timestamp": Date().timeIntervalSince1970
                ]
                
                result(dashboardState)
            } catch {
                result(FlutterError(
                    code: "DASHBOARD_STATE_ERROR",
                    message: "Failed to get dashboard state: \(error.localizedDescription)",
                    details: nil
                ))
            }
        }
    }
    
    private func handleUpdateDashboardState(arguments: [String: Any], result: @escaping FlutterResult) {
        guard let serviceStates = arguments["serviceStates"] as? [String: Bool] else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS", 
                message: "Service states are required", 
                details: nil
            ))
            return
        }
        
        Task {
            do {
                let sharedData = SharedDataManager.shared
                
                // Update service states
                for (serviceKey, isEnabled) in serviceStates {
                    try await sharedData.saveData(isEnabled, forKey: "\(serviceKey)Enabled")
                }
                
                // Update ordering preference if provided
                if let alphabetical = arguments["useAlphabeticalOrdering"] as? Bool {
                    try await sharedData.saveData(alphabetical, forKey: "DRAWER_AUTOMATIC_MANAGE")
                }
                
                result(true)
            } catch {
                result(FlutterError(
                    code: "DASHBOARD_UPDATE_ERROR",
                    message: "Failed to update dashboard state: \(error.localizedDescription)",
                    details: nil
                ))
            }
        }
    }
    
    private func handleRefreshDashboardServices(result: @escaping FlutterResult) {
        Task {
            do {
                // Trigger service status refresh in Flutter
                methodChannel?.invokeMethod("refreshAllServices", arguments: nil)
                result(true)
            } catch {
                result(FlutterError(
                    code: "REFRESH_ERROR",
                    message: "Failed to refresh services: \(error.localizedDescription)",
                    details: nil
                ))
            }
        }
    }
    
    private func handleTriggerWakeOnLAN(result: @escaping FlutterResult) {
        Task {
            do {
                // Invoke Flutter's Wake on LAN functionality
                methodChannel?.invokeMethod("executeWakeOnLAN", arguments: nil) { response in
                    if let error = response as? FlutterError {
                        result(error)
                    } else {
                        result(true)
                    }
                }
            }
        }
    }
    
    private func handleNavigateToService(arguments: [String: Any], result: @escaping FlutterResult) {
        guard let serviceRoute = arguments["route"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS", 
                message: "Service route is required", 
                details: nil
            ))
            return
        }
        
        let serviceData = arguments["data"] as? [String: Any] ?? [:]
        
        // Check if service should use native SwiftUI or Flutter
        if shouldUseNativeView(for: serviceRoute) {
            // Navigate to SwiftUI service view
            presentNativeView(route: serviceRoute, data: serviceData)
        } else {
            // Return to Flutter for service navigation
            navigateBackToFlutter(data: [
                "navigateTo": serviceRoute,
                "serviceData": serviceData
            ])
        }
        
        result(true)
    }
    
    // MARK: - Helper Methods
    
    private func getEnabledServicesState() async -> [String: Bool] {
        let sharedData = SharedDataManager.shared
        let serviceKeys = ["radarr", "sonarr", "lidarr", "sabnzbd", "nzbget", "tautulli", "search", "wake_on_lan"]
        
        var enabledStates: [String: Bool] = [:]
        
        for serviceKey in serviceKeys {
            do {
                let isEnabled = try await sharedData.loadData(type: Bool.self, forKey: "\(serviceKey)Enabled") ?? false
                enabledStates[serviceKey] = isEnabled
            } catch {
                print("Failed to load enabled state for \(serviceKey): \(error)")
                enabledStates[serviceKey] = false
            }
        }
        
        return enabledStates
    }
}