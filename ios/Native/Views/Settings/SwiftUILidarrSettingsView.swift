//
//  SwiftUILidarrSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUILidarrSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Lidarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Lidarr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Lidarr", enabled: newValue)
                        }
                    ))
                }
                
                if let lidarrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Lidarr" }), lidarrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { lidarrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Lidarr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { lidarrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Lidarr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { lidarrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Lidarr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Options") {
                        Picker("Default Quality Profile", selection: .constant("Any")) {
                            Text("Any").tag("Any")
                            Text("Lossless").tag("Lossless")
                            Text("High Quality").tag("High Quality")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Root Folder", selection: .constant("/music")) {
                            Text("/music").tag("/music")
                            Text("/media/music").tag("/media/music")
                        }
                        .pickerStyle(.menu)
                        
                        Toggle("Monitor New Artists", isOn: .constant(true))
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
            .navigationTitle("Lidarr")
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