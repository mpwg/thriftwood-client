//
//  SettingsMenuItem.swift
//  Runner
//
//  Created by GitHub Copilot on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SettingsMenuItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let route: String
    var isEnabled: Bool = true
    
    var body: some View {
        if isEnabled, let destination = destinationView {
            // Use SwiftUI NavigationLink for native navigation
            NavigationLink(destination: destination) {
                SettingsMenuItemContent(
                    title: title,
                    subtitle: subtitle,
                    icon: icon,
                    isEnabled: isEnabled
                )
            }
        } else if !isEnabled {
            // Disabled item - no navigation
            SettingsMenuItemContent(
                title: title,
                subtitle: subtitle,
                icon: icon,
                isEnabled: isEnabled
            )
        } else {
            // Fall back to Flutter bridge for routes not yet implemented in SwiftUI
            Button(action: navigateToFlutterRoute) {
                SettingsMenuItemContent(
                    title: title,
                    subtitle: subtitle,
                    icon: icon,
                    isEnabled: isEnabled,
                    showChevron: true
                )
            }
        }
    }
    
    private var destinationView: AnyView? {
        // Map routes to SwiftUI views for native navigation
        switch route {
        case "/settings":
            AnyView(SwiftUIAllSettingsView())
        case "/settings/configuration":
            AnyView(SwiftUIConfigurationView(viewModel: ConfigurationViewModel(settingsViewModel: SettingsViewModel())))
        case "/settings/profiles":
            AnyView(SwiftUIProfilesView(viewModel: SettingsViewModel()))
        case "/settings/general":
            AnyView(SwiftUIGeneralSettingsView(viewModel: SettingsViewModel()))
        case "/settings/dashboard":
            AnyView(SwiftUIDashboardSettingsView(viewModel: SettingsViewModel()))
        case "/settings/drawer":
            AnyView(SwiftUIDrawerSettingsView(viewModel: SettingsViewModel()))
        case "/settings/quick_actions":
            AnyView(SwiftUIQuickActionsSettingsView(viewModel: SettingsViewModel()))
        default:
            nil // Route not implemented in SwiftUI, will fall back to Flutter
        }
    }
    
    private func navigateToFlutterRoute() {
        print("SettingsMenuItem: Navigating to Flutter route: \(route)")
        // Use Flutter navigation for routes not yet implemented in SwiftUI
        // For now, we'll use a simple approach and delegate to Flutter
        Task {
            await MainActor.run {
                // This would need to be implemented in the bridge
                print("TODO: Navigate to Flutter route: \(route)")
            }
        }
    }
}

// Separate view for the menu item content to reduce code duplication
struct SettingsMenuItemContent: View {
    let title: String
    let subtitle: String
    let icon: String
    let isEnabled: Bool
    var showChevron: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isEnabled ? .blue : .gray)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isEnabled ? .primary : .gray)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isEnabled && showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }
}