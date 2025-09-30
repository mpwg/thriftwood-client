//
//  SwiftUISonarrSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUISonarrSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Sonarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Sonarr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Sonarr", enabled: newValue)
                        }
                    ))
                }
                
                if let sonarrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Sonarr" }), sonarrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { sonarrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Sonarr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { sonarrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Sonarr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { sonarrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Sonarr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Options") {
                        Picker("Default Quality Profile", selection: .constant("Any")) {
                            Text("Any").tag("Any")
                            Text("HD-720p").tag("HD-720p")
                            Text("HD-1080p").tag("HD-1080p")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Root Folder", selection: .constant("/tv")) {
                            Text("/tv").tag("/tv")
                            Text("/media/tv").tag("/media/tv")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Series Type", selection: .constant("Standard")) {
                            Text("Standard").tag("Standard")
                            Text("Anime").tag("Anime")
                            Text("Daily").tag("Daily")
                        }
                        .pickerStyle(.menu)
                        
                        Toggle("Monitor New Series", isOn: .constant(true))
                        Toggle("Search for Missing Episodes", isOn: .constant(false))
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
                    
                    Section("Queue Settings") {
                        Picker("Queue Size", selection: .constant(25)) {
                            Text("25").tag(25)
                            Text("50").tag(50)
                            Text("100").tag(100)
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
            .navigationTitle("Sonarr")
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