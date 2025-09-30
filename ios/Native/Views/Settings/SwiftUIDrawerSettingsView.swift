//
//  SwiftUIDrawerSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIDrawerSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Drawer Behavior") {
                    Toggle("Auto Expand", isOn: Binding(
                        get: { viewModel.appSettings.drawerAutoExpand },
                        set: { newValue in
                            viewModel.appSettings.drawerAutoExpand = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    Toggle("Group Modules", isOn: Binding(
                        get: { viewModel.appSettings.drawerGroupModules },
                        set: { newValue in
                            viewModel.appSettings.drawerGroupModules = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    Toggle("Show Version", isOn: Binding(
                        get: { viewModel.appSettings.drawerShowVersion },
                        set: { newValue in
                            viewModel.appSettings.drawerShowVersion = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                }
                
                Section(footer: Text("These settings customize how the navigation drawer behaves and what information it displays")) {
                    EmptyView()
                }
            }
            .navigationTitle("Drawer Settings")
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