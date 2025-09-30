//
//  SwiftUIRadarrSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIRadarrSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Radarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Radarr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Radarr", enabled: newValue)
                        }
                    ))
                }
                
                if let radarrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Radarr" }), radarrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { radarrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Radarr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { radarrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Radarr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { radarrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Radarr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Options") {
                        Picker("Default Quality Profile", selection: .constant("Any")) {
                            Text("Any").tag("Any")
                            Text("HD-720p").tag("HD-720p") 
                            Text("HD-1080p").tag("HD-1080p")
                            Text("Ultra-HD").tag("Ultra-HD")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Root Folder", selection: .constant("/movies")) {
                            Text("/movies").tag("/movies")
                            Text("/media/movies").tag("/media/movies")
                        }
                        .pickerStyle(.menu)
                        
                        Toggle("Monitor New Movies", isOn: .constant(true))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Calendar")) {
                            Text("Calendar").tag("Calendar")
                            Text("Activity").tag("Activity") 
                            Text("History").tag("History")
                            Text("Queue").tag("Queue")
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
            .navigationTitle("Radarr")
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