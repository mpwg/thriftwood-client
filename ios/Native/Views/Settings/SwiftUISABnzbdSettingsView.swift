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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {

            Form {
                // Information banner
                Section {
                    Text("Configure your SABnzbd download client to enable automatic NZB downloads and queue management.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }
                
                // Enable/Disable Toggle
                Section {
                    Toggle("Enable SABnzbd", isOn: Binding(
                        get: { viewModel.selectedProfile?.sabnzbdEnabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("SABnzbd", enabled: newValue)
                        }
                    ))
                    .toggleStyle(SwitchToggleStyle())
                }
                
                if viewModel.selectedProfile?.sabnzbdEnabled == true {
                    // Connection Details Navigation
                    Section {
                        NavigationLink(destination: SABnzbdConnectionDetailsView(viewModel: viewModel)) {
                            Label("Connection Details", systemImage: "network")
                        }
                    }
                    
                    // Default Pages Navigation
                    Section {
                        NavigationLink(destination: SABnzbdDefaultPagesView(viewModel: viewModel)) {
                            Label("Default Pages", systemImage: "doc.text")
                        }
                    }
                    
                    // Connection Test
                    Section("Connection Test") {
                        Button(action: {
                            Task {
                                await viewModel.testSABnzbdConnection()
                            }
                        }) {
                            HStack {
                                if viewModel.isTestingSABnzbdConnection {
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
                        .disabled(viewModel.isTestingSABnzbdConnection)
                    }
                }
            }
            .navigationTitle("SABnzbd")
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

struct SABnzbdConnectionDetailsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Connection") {
                HStack {
                    Text("Host")
                    Spacer()
                    TextField("Required", text: Binding(
                        get: { viewModel.selectedProfile?.sabnzbdHost ?? "" },
                        set: { newValue in
                            viewModel.updateServiceHost("SABnzbd", host: newValue)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("API Key")
                    Spacer()
                    SecureField("Required", text: Binding(
                        get: { viewModel.selectedProfile?.sabnzbdApiKey ?? "" },
                        set: { newValue in
                            viewModel.updateServiceApiKey("SABnzbd", apiKey: newValue)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                }
            }
            
            Section("Security") {
                Toggle("Strict TLS", isOn: Binding(
                    get: { viewModel.selectedProfile?.sabnzbdStrictTLS ?? false },
                    set: { newValue in
                        viewModel.updateServiceStrictTLS("SABnzbd", strictTLS: newValue)
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
        .navigationTitle("Connection Details")
    }
}

struct SABnzbdDefaultPagesView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Default Pages") {
                Picker("Home Page", selection: .constant("History")) {
                    Text("History").tag("History")
                    Text("Queue").tag("Queue")
                    Text("Statistics").tag("Statistics")
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle("Default Pages")
    }
}