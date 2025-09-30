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