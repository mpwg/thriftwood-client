//
//  SwiftUIAllSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIAllSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        List {
                // Configuration Section
                Section("Configuration") {
                    SettingsMenuItem(
                        title: "General",
                        subtitle: "Customize LunaSea",
                        icon: "paintbrush",
                        route: "/settings/general"
                    )
                    
                    SettingsMenuItem(
                        title: "Dashboard",
                        subtitle: "Configure Dashboard",
                        icon: "house",
                        route: "/settings/dashboard"
                    )
                    
                    SettingsMenuItem(
                        title: "Service Configuration", 
                        subtitle: "Configure Services & Download Clients",
                        icon: "gear",
                        route: "/settings/configuration"
                    )
                }
                
                // Services Section
                Section("Services & Features") {
                    SettingsMenuItem(
                        title: "Wake on LAN",
                        subtitle: "Configure Wake on LAN",
                        icon: "wifi.router",
                        route: "/settings/wake_on_lan"
                    )
                    
                    SettingsMenuItem(
                        title: "Search",
                        subtitle: "Configure Search & Indexers",
                        icon: "magnifyingglass",
                        route: "/settings/search"
                    )
                    
                    SettingsMenuItem(
                        title: "External Modules",
                        subtitle: "Configure External Modules",
                        icon: "cube.box",
                        route: "/settings/external_modules"
                    )
                }
                
                // Interface Section
                Section("Interface") {
                    SettingsMenuItem(
                        title: "Drawer",
                        subtitle: "Customize the Drawer",
                        icon: "sidebar.left",
                        route: "/settings/drawer"
                    )
                    
                    SettingsMenuItem(
                        title: "Quick Actions",
                        subtitle: "Quick Actions on the Home Screen",
                        icon: "bolt",
                        route: "/settings/quick_actions"
                    )
                }
                
                // System Section 
                Section("System") {
                    SettingsMenuItem( 
                        title: "Profiles",
                        subtitle: "Manage Profiles",
                        icon: "person.2",
                        route: "/settings/profiles"
                    )
                    
                    SettingsMenuItem(
                        title: "System Logs",
                        subtitle: "View Application Logs",
                        icon: "doc.text",
                        route: "/settings/system/logs"
                    )
                }
            }
            .navigationTitle("All Settings")
            .navigationBarTitleDisplayMode(.large)
    }
}
