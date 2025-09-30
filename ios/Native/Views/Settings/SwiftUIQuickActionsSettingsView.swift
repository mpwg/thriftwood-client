//
//  SwiftUIQuickActionsSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIQuickActionsSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var showingAddAction = false
    @State private var newActionTitle = ""
    @State private var newActionIcon = ""
    @State private var newActionRoute = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Quick Actions") {
                    Toggle("Enable Quick Actions", isOn: Binding(
                        get: { viewModel.appSettings.enableQuickActions },
                        set: { newValue in
                            viewModel.appSettings.enableQuickActions = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                }
                
                if viewModel.appSettings.enableQuickActions {
                    Section(header: HStack {
                        Text("Home Screen Actions")
                        Spacer()
                        Button("Add") {
                            showingAddAction = true
                        }
                        .font(.caption)
                    }) {
                        if viewModel.appSettings.quickActionItems.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "bolt")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)
                                
                                Text("No Quick Actions")
                                    .font(.headline)
                                
                                Text("Add shortcuts to quickly access features from the home screen")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        } else {
                            ForEach(viewModel.appSettings.quickActionItems) { action in
                                QuickActionRow(
                                    action: action,
                                    onUpdate: { updatedAction in
                                        if let index = viewModel.appSettings.quickActionItems.firstIndex(where: { $0.id == updatedAction.id }) {
                                            viewModel.appSettings.quickActionItems[index] = updatedAction
                                            Task { await viewModel.saveSettings() }
                                        }
                                    },
                                    onDelete: { actionToDelete in
                                        viewModel.appSettings.quickActionItems.removeAll { $0.id == actionToDelete.id }
                                        Task { await viewModel.saveSettings() }
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Quick Actions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
            .sheet(isPresented: $showingAddAction) {
                NavigationStack {
                    Form {
                        Section("Action Details") {
                            TextField("Title", text: $newActionTitle)
                            TextField("SF Symbol Name", text: $newActionIcon)
                            TextField("Route", text: $newActionRoute)
                                .autocapitalization(.none)
                        }
                        
                        Section(footer: Text("Use SF Symbol names for icons (e.g., 'house', 'gear', 'magnifyingglass')")) {
                            EmptyView()
                        }
                    }
                    .navigationTitle("Add Quick Action")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingAddAction = false
                                newActionTitle = ""
                                newActionIcon = ""
                                newActionRoute = ""
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                let newAction = QuickActionItem(
                                    title: newActionTitle,
                                    icon: newActionIcon,
                                    route: newActionRoute
                                )
                                viewModel.appSettings.quickActionItems.append(newAction)
                                Task { await viewModel.saveSettings() }
                                
                                showingAddAction = false
                                newActionTitle = ""
                                newActionIcon = ""
                                newActionRoute = ""
                            }
                            .disabled(newActionTitle.isEmpty || newActionIcon.isEmpty || newActionRoute.isEmpty)
                        }
                    }
                }
            }
        }
    }
}