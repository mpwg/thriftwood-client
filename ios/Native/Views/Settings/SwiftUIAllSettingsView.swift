//
//  SwiftUIAllSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIAllSettingsView: View {
    @State private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                // Configuration Section
                Section("Configuration") {
                    SettingsMenuItem(
                        title: "General",
                        subtitle: "Customize LunaSea",
                        icon: "paintbrush",
                        route: "settings_general"
                    )
                    
                    SettingsMenuItem(
                        title: "Dashboard",
                        subtitle: "Configure Dashboard",
                        icon: "house",
                        route: "settings_dashboard"
                    )
                    
                    SettingsMenuItem(
                        title: "Service Configuration", 
                        subtitle: "Configure Services & Download Clients",
                        icon: "gear",
                        route: "settings_configuration"
                    )
                }
                
                // Services Section
                Section("Services & Features") {
                    SettingsMenuItem(
                        title: "Wake on LAN",
                        subtitle: "Configure Wake on LAN",
                        icon: "wifi.router",
                        route: "settings_wake_on_lan"
                    )
                    
                    SettingsMenuItem(
                        title: "Search",
                        subtitle: "Configure Search & Indexers",
                        icon: "magnifyingglass",
                        route: "settings_search"
                    )
                    
                    SettingsMenuItem(
                        title: "External Modules",
                        subtitle: "Configure External Modules",
                        icon: "cube.box",
                        route: "settings_external_modules"
                    )
                }
                
                // Interface Section
                Section("Interface") {
                    SettingsMenuItem(
                        title: "Drawer",
                        subtitle: "Customize the Drawer",
                        icon: "sidebar.left",
                        route: "settings_drawer"
                    )
                    
                    SettingsMenuItem(
                        title: "Quick Actions",
                        subtitle: "Quick Actions on the Home Screen",
                        icon: "bolt",
                        route: "settings_quick_actions"
                    )
                }
                
                // System Section 
                Section("System") {
                    SettingsMenuItem(
                        title: "Profiles",
                        subtitle: "Manage Profiles",
                        icon: "person.2",
                        route: "settings_profiles"
                    )
                    
                    SettingsMenuItem(
                        title: "System Logs",
                        subtitle: "View Application Logs",
                        icon: "doc.text",
                        route: "settings_system_logs"
                    )
                }
            }
            .navigationTitle("All Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
        }
    }
}
