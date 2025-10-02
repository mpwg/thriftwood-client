//
//  QuickActionsMenu.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 01.10.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI
import Flutter

/// Swift equivalent of Flutter's quick actions functionality
/// Provides refresh, settings access, and other dashboard actions
struct QuickActionsMenu: View {
    @Bindable var viewModel: DashboardViewModel
    @State private var showingServiceErrors = false
    
    var body: some View {
        Menu {
            // Refresh action - Swift equivalent of Flutter's refresh functionality
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                Label("Refresh Services", systemImage: "arrow.clockwise")
            }
            
            Divider()
            
            // Service status overview
            Button {
                showingServiceErrors = true
            } label: {
                if viewModel.hasServiceErrors {
                    Label("Service Status (Issues Found)", systemImage: "exclamationmark.triangle")
                } else {
                    Label("Service Status (All Good)", systemImage: "checkmark.circle")
                }
            }
            
            Divider()
            
            // Settings access
            Button {
                Task {
                    await navigateToSettings()
                }
            } label: {
                Label("Settings", systemImage: "gearshape")
            }
            
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title3)
        }
        .alert("Service Status", isPresented: $showingServiceErrors) {
            Button("OK") { }
        } message: {
            if viewModel.hasServiceErrors {
                Text("Issues found with: \(viewModel.servicesWithErrors.joined(separator: ", "))")
            } else {
                Text("All enabled services are working correctly.")
            }
        }
    }
    
    private func navigateToSettings() async {
        print("QuickActionsMenu: Settings navigation initiated")
        let bridge = FlutterSwiftUIBridge.shared
        let settingsRoute = "/settings"
        
        if bridge.shouldUseNativeView(for: settingsRoute) {
            // Navigate to SwiftUI settings view
            print("QuickActionsMenu: Using SwiftUI navigation for settings")
            await viewModel.navigateToService(Service.createSettingsService())
        } else {
            // Navigate back to Flutter for settings view
            print("QuickActionsMenu: Using Flutter navigation for settings")
            bridge.navigateBackToFlutter(data: [
                "navigateTo": settingsRoute,
                "from": "dashboard_quick_actions"
            ])
        }
    }
}