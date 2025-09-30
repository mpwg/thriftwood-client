//
//  SwiftUISettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUISettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // Configuration Tab (matching Flutter's primary interface)
                configurationView
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Configuration")
                    }
                    .tag(0)
                
                // All Settings Tab (comprehensive menu)
                allSettingsView
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("All Settings")
                    }
                    .tag(1)
            }
            .navigationTitle(selectedTab == 0 ? "Configuration" : "Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
                
                if selectedTab == 0 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(viewModel.currentProfileName) {
                            Task {
                                await FlutterSwiftUIBridge.shared.presentNativeView(
                                    route: "settings_profiles"
                                )
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.isShowingError) {
                Button("OK") {
                    viewModel.isShowingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .alert("Clear Configuration", isPresented: $viewModel.showingClearConfigConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All Data", role: .destructive) {
                    Task {
                        await viewModel.clearConfiguration()
                    }
                }
            } message: {
                Text("This will reset all settings to default and cannot be undone. Are you sure?")
            }
        }
    }
    
    // MARK: - Configuration View (matches Flutter's main interface)
    
    @ViewBuilder
    private var configurationView: some View {
        List {
            // Services Section (matching first Flutter image)
            Section("Services") {
                ServiceToggleRow(name: "Lidarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Lidarr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Lidarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Radarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Radarr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Radarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Sonarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Sonarr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Sonarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Tautulli", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Tautulli" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Tautulli", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Overseerr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Overseerr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Overseerr", enabled: newValue)
                    }
                ))
            }
            
            // Download Clients Section
            Section("Download Clients") {
                ServiceToggleRow(name: "SABnzbd", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "SABnzbd" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateDownloadClientEnabled("SABnzbd", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "NZBGet", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateDownloadClientEnabled("NZBGet", enabled: newValue)
                    }
                ))
            }
        }

    }
    
    // MARK: - All Settings View (matches Flutter's settings menu)
    
    @ViewBuilder
    private var allSettingsView: some View {
        List {
            // Configuration Section (matching second Flutter image)
            Section("Configuration") {
                SettingsMenuItem(
                    title: "General",
                    subtitle: "Customize LunaSea",
                    icon: "brush",
                    route: "settings_general"
                )
                
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
                
                SettingsMenuItem(
                    title: "Dashboard",
                    subtitle: "Configure Dashboard",
                    icon: "house",
                    route: "settings_dashboard"
                )
                
                SettingsMenuItem(
                    title: "External Modules",
                    subtitle: "Configure External Modules",
                    icon: "cube.box",
                    route: "settings_external_modules"
                )
            }
            
            // Services Section
            Section("Services") {
                ServiceConfigMenuItem(name: "Lidarr", icon: "music.note.list")
                ServiceConfigMenuItem(name: "NZBGet", icon: "arrow.down.circle")  
                ServiceConfigMenuItem(name: "Radarr", icon: "film")
                ServiceConfigMenuItem(name: "SABnzbd", icon: "arrow.down.square")
                
                SettingsMenuItem(
                    title: "Search",
                    subtitle: "Configure Search",
                    icon: "magnifyingglass", 
                    route: "settings_search"
                )
                
                ServiceConfigMenuItem(name: "Sonarr", icon: "tv")
                ServiceConfigMenuItem(name: "Tautulli", icon: "chart.bar")
                
                SettingsMenuItem(
                    title: "Wake on LAN",
                    subtitle: "Configure Wake on LAN",
                    icon: "wifi.router",
                    route: "settings_wake_on_lan"
                )
            }
        }
    }
}