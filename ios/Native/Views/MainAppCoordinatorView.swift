//
//  MainAppCoordinatorView.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-01-02.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

import SwiftUI

/// Main SwiftUI coordinator that manages the entire app navigation
/// Root view that coordinates between different app states and views
struct MainAppCoordinatorView: View {
    @State private var settingsViewModel = SettingsViewModel()
    @State private var isInitializing = true
    
    var body: some View {
        Group {
            if isInitializing {
                // Initial loading state
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
            } else if settingsViewModel.hasValidServices {
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
        
        // Brief delay for smooth loading experience
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        isInitializing = false
    }
}

#Preview {
    MainAppCoordinatorView()
}