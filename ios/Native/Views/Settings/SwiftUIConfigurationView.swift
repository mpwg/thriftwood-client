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
    @Environment(\.dismiss) private var dismiss
    
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
                            icon: "paintbrush",
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
                            ServiceConfigurationTile(service: service, settingsViewModel: viewModel.settingsViewModel)
                        }
                    }
                    
                    // Download client configurations
                    Section("Download Clients") {
                        ForEach(viewModel.downloadClientConfigurations) { client in
                            DownloadClientTile(client: client, settingsViewModel: viewModel.settingsViewModel)
                        }
                    }
                    
                    
                }
            }
            .navigationTitle("Configuration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.loadConfiguration()
            }
        }
    }
}
