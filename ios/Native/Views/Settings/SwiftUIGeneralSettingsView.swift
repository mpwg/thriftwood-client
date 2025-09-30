//
//  SwiftUIGeneralSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIGeneralSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Application") {
                    TextField("App Name", text: Binding(
                        get: { viewModel.appSettings.appName },
                        set: { newValue in
                            viewModel.appSettings.appName = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                
                Section("Advanced") {
                    Toggle("Advanced Settings", isOn: Binding(
                        get: { viewModel.appSettings.enableAdvancedSettings },
                        set: { newValue in
                            viewModel.appSettings.enableAdvancedSettings = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    Toggle("Error Reporting", isOn: Binding(
                        get: { viewModel.appSettings.enableErrorReporting },
                        set: { newValue in
                            viewModel.appSettings.enableErrorReporting = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    Toggle("Analytics", isOn: Binding(
                        get: { viewModel.appSettings.enableAnalytics },
                        set: { newValue in
                            viewModel.appSettings.enableAnalytics = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                }
            }
            .navigationTitle("General Settings")
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