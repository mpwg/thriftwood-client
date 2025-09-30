//
//  SwiftUINZBGetSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUINZBGetSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Download Client") {
                    Toggle("Enable NZBGet", isOn: Binding(
                        get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateDownloadClientEnabled("NZBGet", enabled: newValue)
                        }
                    ))
                }
                
                if let nzbgetConfig = viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" }), nzbgetConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { nzbgetConfig.host },
                            set: { newValue in
                                viewModel.updateDownloadClientHost("NZBGet", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        TextField("Username", text: Binding(
                            get: { nzbgetConfig.username },
                            set: { newValue in
                                viewModel.updateDownloadClientUsername("NZBGet", username: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        
                        SecureField("Password", text: Binding(
                            get: { nzbgetConfig.password },
                            set: { newValue in
                                viewModel.updateDownloadClientPassword("NZBGet", password: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { nzbgetConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateDownloadClientStrictTLS("NZBGet", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Queue")) {
                            Text("Queue").tag("Queue")
                            Text("History").tag("History")
                            Text("Statistics").tag("Statistics")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("NZBGet")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}