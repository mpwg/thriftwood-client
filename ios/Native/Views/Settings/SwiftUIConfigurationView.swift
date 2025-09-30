//
//  SwiftUIConfigurationView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIConfigurationView: View {
    let viewModel: ConfigurationViewModel
    @State private var expandedServices: Set<String> = []
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.selectedProfile == nil {
                    Section {
                        VStack(spacing: 16) {
                            Image(systemName: "gear.badge.questionmark")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            
                            Text("No Profile Selected")
                                .font(.headline)
                            
                            Text("Select a profile to configure services")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                } else {
                    // General Configuration Options (matching Flutter configuration screen)
                    Section {
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
                    
                    // Service configurations
                    Section("Services") {
                        ForEach(viewModel.serviceConfigurations) { service in
                            ServiceConfigurationRow(
                                service: service,
                                isExpanded: expandedServices.contains(service.name),
                                onToggleExpanded: {
                                    if expandedServices.contains(service.name) {
                                        expandedServices.remove(service.name)
                                    } else {
                                        expandedServices.insert(service.name)
                                    }
                                },
                                onUpdate: { updatedService in
                                    Task {
                                        await viewModel.updateServiceConfiguration(updatedService)
                                    }
                                },
                                onTestConnection: { service in
                                    Task {
                                        let success = await viewModel.testConnection(for: service)
                                        // Show feedback
                                    }
                                }
                            )
                        }
                    }
                    
                    // Download client configurations
                    Section("Download Clients") {
                        ForEach(viewModel.downloadClientConfigurations) { client in
                            DownloadClientConfigurationRow(
                                client: client,
                                isExpanded: expandedServices.contains(client.name),
                                onToggleExpanded: {
                                    if expandedServices.contains(client.name) {
                                        expandedServices.remove(client.name)
                                    } else {
                                        expandedServices.insert(client.name)
                                    }
                                },
                                onUpdate: { updatedClient in
                                    Task {
                                        await viewModel.updateDownloadClientConfiguration(updatedClient)
                                    }
                                },
                                onTestConnection: { client in
                                    Task {
                                        let success = await viewModel.testDownloadClientConnection(for: client)
                                        // Show feedback
                                    }
                                }
                            )
                        }
                    }
                    
                    // Individual Service Configuration (matching Flutter's service list)
                    Section("Configure Services") {
                        SettingsMenuItem(
                            title: "Lidarr",
                            subtitle: "Configure Lidarr",
                            icon: "music.note.list",
                            route: "settings_lidarr"
                        )
                        
                        SettingsMenuItem(
                            title: "NZBGet",
                            subtitle: "Configure NZBGet",
                            icon: "arrow.down.circle",
                            route: "settings_nzbget"
                        )
                        
                        SettingsMenuItem(
                            title: "Radarr",
                            subtitle: "Configure Radarr",
                            icon: "film",
                            route: "settings_radarr"
                        )
                        
                        SettingsMenuItem(
                            title: "SABnzbd",
                            subtitle: "Configure SABnzbd",
                            icon: "arrow.down.square",
                            route: "settings_sabnzbd"
                        )
                        
                        SettingsMenuItem(
                            title: "Search",
                            subtitle: "Configure Search",
                            icon: "magnifyingglass",
                            route: "settings_search"
                        )
                        
                        SettingsMenuItem(
                            title: "Sonarr",
                            subtitle: "Configure Sonarr",
                            icon: "tv",
                            route: "settings_sonarr"
                        )
                        
                        SettingsMenuItem(
                            title: "Tautulli",
                            subtitle: "Configure Tautulli",
                            icon: "chart.bar",
                            route: "settings_tautulli"
                        )
                        
                        SettingsMenuItem(
                            title: "Wake on LAN",
                            subtitle: "Configure Wake on LAN",
                            icon: "wifi.router",
                            route: "settings_wake_on_lan"
                        )
                    }
                }
            }
            .navigationTitle("Configuration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
            .task {
                await viewModel.loadConfiguration()
            }
        }
    }
}