//
//  SwiftUISABnzbdSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUISABnzbdSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Download Client") {
                    Toggle("Enable SABnzbd", isOn: Binding(
                        get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "SABnzbd" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateDownloadClientEnabled("SABnzbd", enabled: newValue)
                        }
                    ))
                }
                
                if let sabnzbdConfig = viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "SABnzbd" }), sabnzbdConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { sabnzbdConfig.host },
                            set: { newValue in
                                viewModel.updateDownloadClientHost("SABnzbd", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { sabnzbdConfig.apiKey },
                            set: { newValue in
                                viewModel.updateDownloadClientApiKey("SABnzbd", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { sabnzbdConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateDownloadClientStrictTLS("SABnzbd", strictTLS: newValue)
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
            .navigationTitle("SABnzbd")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
        }
    }
}