//
//  SwiftUIOverseerrSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIOverseerrSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Overseerr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Overseerr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Overseerr", enabled: newValue)
                        }
                    ))
                }
                
                if let overseerrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Overseerr" }), overseerrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { overseerrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Overseerr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { overseerrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Overseerr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { overseerrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Overseerr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Discover")) {
                            Text("Discover").tag("Discover")
                            Text("Requests").tag("Requests")
                            Text("Users").tag("Users")
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
            .navigationTitle("Overseerr")
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