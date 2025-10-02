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

            Form {
                // Information banner
                Section {
                    Text("Configure your NZBGet download client to enable automatic NZB downloads and queue management.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }
                
                // Enable/Disable Toggle
                Section {
                    Toggle("Enable NZBGet", isOn: Binding(
                        get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateDownloadClientEnabled("NZBGet", enabled: newValue)
                        }
                    ))
                    .toggleStyle(SwitchToggleStyle())
                }
                
                if let nzbgetConfig = viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" }), nzbgetConfig.enabled {
                    // Connection Details Navigation
                    Section {
                        NavigationLink(destination: NZBGetConnectionDetailsView(viewModel: viewModel)) {
                            Label("Connection Details", systemImage: "network")
                        }
                    }
                    
                    // Default Pages Navigation
                    Section {
                        NavigationLink(destination: NZBGetDefaultPagesView(viewModel: viewModel)) {
                            Label("Default Pages", systemImage: "doc.text")
                        }
                    }
                    
                    // Connection Test
                    Section("Connection Test") {
                        Button(action: {
                            Task {
                                await viewModel.testNZBGetConnection()
                            }
                        }) {
                            HStack {
                                if viewModel.isTestingNZBGetConnection {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "network.badge.shield.half.filled")
                                }
                                Text("Test Connection")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(viewModel.isTestingNZBGetConnection)
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

struct NZBGetConnectionDetailsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            if let nzbgetConfig = viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" }) {
                Section("Connection") {
                    HStack {
                        Text("Host")
                        Spacer()
                        TextField("Required", text: Binding(
                            get: { nzbgetConfig.host },
                            set: { newValue in
                                viewModel.updateDownloadClientHost("NZBGet", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    }
                    
                    HStack {
                        Text("Username")
                        Spacer()
                        TextField("Optional", text: Binding(
                            get: { nzbgetConfig.username },
                            set: { newValue in
                                viewModel.updateDownloadClientUsername("NZBGet", username: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                    }
                    
                    HStack {
                        Text("Password")
                        Spacer()
                        SecureField("Optional", text: Binding(
                            get: { nzbgetConfig.password },
                            set: { newValue in
                                viewModel.updateDownloadClientPassword("NZBGet", password: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Security") {
                    Toggle("Strict TLS", isOn: Binding(
                        get: { nzbgetConfig.strictTLS },
                        set: { newValue in
                            viewModel.updateDownloadClientStrictTLS("NZBGet", strictTLS: newValue)
                        }
                    ))
                }
                
                Section("Headers") {
                    Text("Custom Headers")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    // Headers management would go here - simplified for now
                }
            }
        }
        .navigationTitle("Connection Details")
    }
}

struct NZBGetDefaultPagesView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Default Pages") {
                Picker("Home Page", selection: .constant("Queue")) {
                    Text("Queue").tag("Queue")
                    Text("History").tag("History")
                    Text("Statistics").tag("Statistics")
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle("Default Pages")
    }
}