//
//  MainAppCoordinatorView.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-01-02.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI
import Flutter

/// Main SwiftUI coordinator that manages the entire app navigation
/// Replaces Flutter as the primary framework and embeds Flutter views when needed
struct MainAppCoordinatorView: View {
    @State private var settingsViewModel = SettingsViewModel()
    @State private var isFlutterReady = false
    
    var body: some View {
        Group {
            if settingsViewModel.hasValidServices {
                // Show SwiftUI dashboard when services are configured
                DashboardView()
            } else {
                // Show no modules enabled view (directs to settings)
                NoModulesEnabledView()
            }
        }
        .task {
            await initializeApp()
        }
    }
    
    @MainActor
    private func initializeApp() async {
        // Load settings to determine what to show
        await settingsViewModel.loadSettings()
        
        // Initialize Flutter bridge for hybrid functionality
        await initializeFlutterBridge()
    }
    
    private func initializeFlutterBridge() async {
        // Bridge is already initialized by AppDelegate in SwiftUI-first architecture
        // Just mark as ready since initialization happens at app startup
        isFlutterReady = true
    }
}

#Preview {
    MainAppCoordinatorView()
}