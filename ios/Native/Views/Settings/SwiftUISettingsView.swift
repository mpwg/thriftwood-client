//
//  SwiftUISettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

// MARK: - Supporting Types

struct ConfigurationModule: Hashable {
    let title: String
    let icon: String
}

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
                
                // All Settings Tab (comprehensive service toggles)
                allSettingsView
                    .tabItem {
                        Image(systemName: "switch.2")
                        Text("Services")
                    }
                    .tag(1)
            }
            .navigationTitle(selectedTab == 0 ? "Configuration" : "Services")
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
            // General Configuration Options (matching Flutter structure)
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
            
            Divider()
            
            // Dashboard Configuration
            SettingsMenuItem(
                title: "Dashboard",
                subtitle: "Configure Dashboard",
                icon: "house",
                route: "settings_dashboard"
            )
            
            // Dynamic Module List (matching Flutter's behavior - only enabled modules)
            ForEach(enabledModules, id: \.self) { module in
                SettingsMenuItem(
                    title: module.title,
                    subtitle: "Configure \(module.title)",
                    icon: module.icon,
                    route: "settings_\(module.title.lowercased())"
                )
            }
        }
    }
    
    // MARK: - Helper Properties
    
    private var enabledModules: [ConfigurationModule] {
        guard let profile = viewModel.selectedProfile else { return [] }
        
        var modules: [ConfigurationModule] = []
        
        // Add enabled services (matching Flutter's LunaModule.active logic)
        if profile.lidarrEnabled {
            modules.append(ConfigurationModule(title: "Lidarr", icon: "music.note.list"))
        }
        if profile.radarrEnabled {
            modules.append(ConfigurationModule(title: "Radarr", icon: "film"))
        }
        if profile.sonarrEnabled {
            modules.append(ConfigurationModule(title: "Sonarr", icon: "tv"))
        }
        if profile.tautulliEnabled {
            modules.append(ConfigurationModule(title: "Tautulli", icon: "chart.bar"))
        }
        if profile.overseerrEnabled {
            modules.append(ConfigurationModule(title: "Overseerr", icon: "star"))
        }
        if profile.nzbgetEnabled {
            modules.append(ConfigurationModule(title: "NZBGet", icon: "arrow.down.circle"))
        }
        if profile.sabnzbdEnabled {
            modules.append(ConfigurationModule(title: "SABnzbd", icon: "arrow.down.square"))
        }
        
        // Always add Search (matches Flutter logic - shows if any indexers exist)
        modules.append(ConfigurationModule(title: "Search", icon: "magnifyingglass"))
        
        // Always add Wake on LAN if supported
        modules.append(ConfigurationModule(title: "Wake on LAN", icon: "wifi.router"))
        
        // Add External Modules
        modules.append(ConfigurationModule(title: "External Modules", icon: "cube.box"))
        
        return modules
    }
    
    // MARK: - All Settings View (matches Flutter's comprehensive settings menu)
    
    @ViewBuilder
    private var allSettingsView: some View {
        List {
            // Services Section (matching first Flutter image - service toggles)
            Section("Services") {
                ServiceToggleRow(name: "Lidarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.lidarrEnabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Lidarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Radarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.radarrEnabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Radarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Sonarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.sonarrEnabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Sonarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Tautulli", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.tautulliEnabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Tautulli", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Overseerr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.overseerrEnabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Overseerr", enabled: newValue)
                    }
                ))
            }
            
            // Download Clients Section
            Section("Download Clients") {
                ServiceToggleRow(name: "SABnzbd", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.sabnzbdEnabled ?? false },
                    set: { newValue in
                        viewModel.updateDownloadClientEnabled("SABnzbd", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "NZBGet", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.nzbgetEnabled ?? false },
                    set: { newValue in
                        viewModel.updateDownloadClientEnabled("NZBGet", enabled: newValue)
                    }
                ))
            }
            
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
            
            // Individual Service Configuration (matching second Flutter image)
            Section("Service Configuration") {
                ForEach(allModules, id: \.self) { module in
                    SettingsMenuItem(
                        title: module.title,
                        subtitle: "Configure \(module.title)",
                        icon: module.icon,
                        route: "settings_\(module.title.lowercased().replacingOccurrences(of: " ", with: "_"))"
                    )
                }
            }
        }
    }
    
    // MARK: - All Modules (including disabled ones for configuration)
    
    private var allModules: [ConfigurationModule] {
        return [
            ConfigurationModule(title: "Lidarr", icon: "music.note.list"),
            ConfigurationModule(title: "NZBGet", icon: "arrow.down.circle"),
            ConfigurationModule(title: "Radarr", icon: "film"),
            ConfigurationModule(title: "SABnzbd", icon: "arrow.down.square"),
            ConfigurationModule(title: "Search", icon: "magnifyingglass"),
            ConfigurationModule(title: "Sonarr", icon: "tv"),
            ConfigurationModule(title: "Tautulli", icon: "chart.bar"),
            ConfigurationModule(title: "Wake on LAN", icon: "wifi.router")
        ]
    }
}