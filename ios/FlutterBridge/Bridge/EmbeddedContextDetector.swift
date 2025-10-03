//
//  EmbeddedContextDetector.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-03.
//  Detects if Flutter is running embedded within SwiftUI
//

import Foundation
import Flutter

/// Extension to BridgeMethodDispatcher for embedded context detection
extension BridgeMethodDispatcher {
    
    /// Register embedded context detection method
    func registerEmbeddedContextMethods() {
        registerHandler(for: "isEmbeddedContext") { [weak self] call, result in
            // Detect if Flutter is running embedded in SwiftUI vs. Flutter-primary
            let isEmbedded = self?.detectEmbeddedContext() ?? false
            result(isEmbedded)
        }
    }
    
    /// Detect if Flutter is running in an embedded SwiftUI context
    private func detectEmbeddedContext() -> Bool {
        // Check if we're running in a SwiftUI-primary context
        // This can be determined by checking if the root view controller is not a FlutterViewController
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = window.rootViewController else {
            return false
        }
        
        // If the root view controller is not a FlutterViewController, 
        // then Flutter is embedded within SwiftUI
        let isEmbedded = !(rootViewController is FlutterViewController)
        
        print("🔍 Embedded context detection: isEmbedded=\(isEmbedded), rootVC=\(type(of: rootViewController))")
        
        return isEmbedded
    }
}