//
//  SwiftUIExternalModulesSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct SwiftUIExternalModulesSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    @State private var showingAddModule = false
    @State private var newModuleName = ""
    @State private var newModuleDisplayName = ""
    @State private var newModuleHost = ""

    var body: some View {

        List {
                Section(header: HStack {
                    Text("External Modules")
                    Spacer()
                    Button("Add") {
                        showingAddModule = true
                    }
                    .font(.caption)
                }) {
                    if viewModel.appSettings.externalModules.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "cube.box")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            
                            Text("No External Modules")
                                .font(.headline)
                            
                            Text("Add external web applications to access them from the dashboard")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ForEach(viewModel.appSettings.externalModules) { module in
                            ExternalModuleRow(
                                module: module,
                                onUpdate: { updatedModule in
                                    if let index = viewModel.appSettings.externalModules.firstIndex(where: { $0.id == updatedModule.id }) {
                                        viewModel.appSettings.externalModules[index] = updatedModule
                                        Task { await viewModel.saveSettings() }
                                    }
                                },
                                onDelete: { moduleToDelete in
                                    viewModel.appSettings.externalModules.removeAll { $0.id == moduleToDelete.id }
                                    Task { await viewModel.saveSettings() }
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("External Modules")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddModule) {
                NavigationView {
                    Form {
                        Section("Module Details") {
                            TextField("Internal Name", text: $newModuleName)
                                .autocapitalization(.none)
                            TextField("Display Name", text: $newModuleDisplayName)
                            TextField("Host URL", text: $newModuleHost)
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                        }
                        
                        Section(footer: Text("The internal name is used for identification, while the display name is shown in the UI")) {
                            EmptyView()
                        }
                    }
                    .navigationTitle("Add Module")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingAddModule = false
                                newModuleName = ""
                                newModuleDisplayName = ""
                                newModuleHost = ""
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                let newModule = ExternalModule(
                                    name: newModuleName,
                                    displayName: newModuleDisplayName,
                                    host: newModuleHost
                                )
                                viewModel.appSettings.externalModules.append(newModule)
                                Task { await viewModel.saveSettings() }
                                
                                showingAddModule = false
                                newModuleName = ""
                                newModuleDisplayName = ""
                                newModuleHost = ""
                            }
                            .disabled(newModuleName.isEmpty || newModuleDisplayName.isEmpty)
                        }
                    }
                }
            }
        }
    }