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
    var viewModel: SettingsViewModel? = nil
    
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
            // Route not yet implemented in SwiftUI
            Button(action: showNotImplementedAlert) {
                SettingsMenuItemContent(
                    title: title,
                    subtitle: subtitle,
                    icon: icon,
                    isEnabled: false,
                    showChevron: false
                )
            }
            .disabled(true)
        }
    }
    
    private var destinationView: AnyView? {
        // Map routes to SwiftUI views for native navigation
        // CRITICAL: Always use provided viewModel to prevent creating new instances
        guard let settingsVM = viewModel else {
            print("⚠️ SettingsMenuItem: No viewModel provided for route \(route)")
            return nil
        }
        
        switch route {
        case "/settings":
            return AnyView(SwiftUIAllSettingsView())
        case "/settings/configuration":
            return AnyView(SwiftUIConfigurationView(viewModel: ConfigurationViewModel(settingsViewModel: settingsVM)))
        case "/settings/profiles":
            return AnyView(SwiftUIProfilesView(viewModel: settingsVM))
        case "/settings/general":
            return AnyView(SwiftUIGeneralSettingsView(viewModel: settingsVM))
        case "/settings/dashboard":
            return AnyView(SwiftUIDashboardSettingsView(viewModel: settingsVM))
        case "/settings/drawer":
            return AnyView(SwiftUIDrawerSettingsView(viewModel: settingsVM))
        case "/settings/quick_actions":
            return AnyView(SwiftUIQuickActionsSettingsView(viewModel: settingsVM))
        case "/settings/system":
            return AnyView(SwiftUISystemView(viewModel: settingsVM))
        default:
            return nil // Route not implemented in SwiftUI yet
        }
    }
    
    private func showNotImplementedAlert() {
        print("SettingsMenuItem: Route not implemented in SwiftUI: \(route)")
        // TODO: Show alert or implement missing SwiftUI views
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