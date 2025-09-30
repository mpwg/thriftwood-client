//
//  SwiftUITautulliSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUITautulliSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Tautulli", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Tautulli" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Tautulli", enabled: newValue)
                        }
                    ))
                }
                
                if let tautulliConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Tautulli" }), tautulliConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { tautulliConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Tautulli", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { tautulliConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Tautulli", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { tautulliConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Tautulli", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Activity")) {
                            Text("Activity").tag("Activity")
                            Text("History").tag("History")
                            Text("Statistics").tag("Statistics")
                            Text("Users").tag("Users")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Refresh Settings") {
                        Picker("Activity Refresh Rate", selection: .constant(10)) {
                            Text("5 seconds").tag(5)
                            Text("10 seconds").tag(10)
                            Text("15 seconds").tag(15)
                            Text("30 seconds").tag(30)
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Statistics") {
                        Picker("Statistics Item Count", selection: .constant(10)) {
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("25").tag(25)
                            Text("50").tag(50)
                        }
                        .pickerStyle(.menu)
                        
                        TextField("Default Termination Message", text: .constant("Stream terminated"))
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Tautulli")
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