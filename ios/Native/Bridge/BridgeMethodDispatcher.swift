//
//  BridgeMethodDispatcher.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-01.
//  Central method channel dispatcher to prevent handler conflicts (Rule 13 enforcement)
//

import Foundation
import Flutter

/// Central dispatcher for all method channel calls to prevent handler conflicts
/// Implements Swift-first migration Rule 13: No silent navigation errors
@MainActor
class BridgeMethodDispatcher {
    static let shared = BridgeMethodDispatcher()
    
    private var methodHandlers: [String: (FlutterMethodCall, @escaping FlutterResult) -> Void] = [:]
    private var flutterViewController: FlutterViewController?
    private var bridgeChannel: FlutterMethodChannel?
    
    private init() {}
    
    /// Initialize the central dispatcher
    func initialize(with flutterViewController: FlutterViewController) {
        self.flutterViewController = flutterViewController
        
        bridgeChannel = FlutterMethodChannel(
            name: "com.thriftwood.bridge",
            binaryMessenger: flutterViewController.binaryMessenger
        )
        
        bridgeChannel?.setMethodCallHandler { [weak self] call, result in
            Task { @MainActor in
                await self?.dispatch(call, result: result)
            }
        }
        
        print("✅ BridgeMethodDispatcher initialized - preventing handler conflicts")
    }
    
    /// Register a method handler
    func registerHandler(for method: String, handler: @escaping (FlutterMethodCall, @escaping FlutterResult) -> Void) {
        if methodHandlers[method] != nil {
            print("⚠️ WARNING: Overriding existing handler for method: \(method)")
        }
        methodHandlers[method] = handler
        print("📝 Registered handler for method: \(method)")
    }
    
    /// Dispatch method calls to appropriate handlers
    private func dispatch(_ call: FlutterMethodCall, result: @escaping FlutterResult) async {
        let method = call.method
        
        print("🔍 BridgeMethodDispatcher received: \(method)")
        
        guard let handler = methodHandlers[method] else {
            // RULE 13 ENFORCEMENT: No silent failures - show actionable error
            print("❌ No handler found for method: \(method)")
            result(FlutterError(
                code: "UNIMPLEMENTED",
                message: "Method \(method) not implemented by any service",
                details: [
                    "method": method,
                    "availableMethods": Array(methodHandlers.keys),
                    "suggestion": "Check if the native view is properly registered"
                ]
            ))
            return
        }
        
        // Execute handler
        handler(call, result)
    }
    
    /// Get all registered methods for debugging
    func getRegisteredMethods() -> [String] {
        return Array(methodHandlers.keys).sorted()
    }
}

/// MARK: - Bridge registration helper
extension BridgeMethodDispatcher {
    
    /// Register all core bridge methods
    func registerCoreBridgeMethods() {
        // Navigation methods
        registerHandler(for: "navigateToNative") { call, result in
            guard let args = call.arguments as? [String: Any],
                  let route = args["route"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Route is required", details: nil))
                return
            }
            
            let data = args["data"] as? [String: Any] ?? [:]
            FlutterSwiftUIBridge.shared.presentNativeView(route: route, data: data)
            result(true)
        }
        
        registerHandler(for: "isNativeViewAvailable") { call, result in
            guard let args = call.arguments as? [String: Any],
                  let route = args["route"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Route is required", details: nil))
                return
            }
            
            result(FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route))
        }
        
        registerHandler(for: "getAllNativeViews") { call, result in
            result(FlutterSwiftUIBridge.shared.getAllNativeViews())
        }
        
        // Return navigation
        registerHandler(for: "onReturnFromNative") { call, result in
            // Handle return data from native views
            print("📱 Received return data from native view: \(call.arguments ?? [:])")
            result(nil)
        }
    }
}