//
//  SwiftUISearchSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUISearchSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddIndexer = false
    @State private var newIndexerName = ""
    @State private var newIndexerHost = ""
    @State private var newIndexerApiKey = ""
    
    var body: some View {

        List {
                Section("Search Preferences") {
                    Toggle("Search History", isOn: Binding(
                        get: { viewModel.appSettings.enableSearchHistory },
                        set: { newValue in
                            viewModel.appSettings.enableSearchHistory = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    if viewModel.appSettings.enableSearchHistory {
                        HStack {
                            Text("Max History Items")
                            Spacer()
                            Picker("", selection: Binding(
                                get: { viewModel.appSettings.maxSearchHistory },
                                set: { newValue in
                                    viewModel.appSettings.maxSearchHistory = newValue
                                    Task { await viewModel.saveSettings() }
                                }
                            )) {
                                Text("25").tag(25)
                                Text("50").tag(50)
                                Text("100").tag(100)
                                Text("200").tag(200)
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    
                    Picker("Default Category", selection: Binding(
                        get: { viewModel.appSettings.defaultSearchCategory },
                        set: { newValue in
                            viewModel.appSettings.defaultSearchCategory = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    )) {
                        ForEach(SearchCategory.allCases, id: \.self) { category in
                            Text(category.displayName).tag(category.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Search Types") {
                    Toggle("Torrent Searching", isOn: Binding(
                        get: { viewModel.appSettings.enableTorrentSearching },
                        set: { newValue in
                            viewModel.appSettings.enableTorrentSearching = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    Toggle("Usenet Searching", isOn: Binding(
                        get: { viewModel.appSettings.enableUsenetSearching },
                        set: { newValue in
                            viewModel.appSettings.enableUsenetSearching = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                }
                
                Section(header: HStack {
                    Text("Search Indexers")
                    Spacer()
                    Button("Add") {
                        showingAddIndexer = true
                    }
                    .font(.caption)
                }) {
                    if viewModel.appSettings.searchIndexers.isEmpty {
                        Text("No indexers configured")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.appSettings.searchIndexers) { indexer in
                            SearchIndexerRow(
                                indexer: indexer,
                                onUpdate: { updatedIndexer in
                                    if let index = viewModel.appSettings.searchIndexers.firstIndex(where: { $0.id == updatedIndexer.id }) {
                                        viewModel.appSettings.searchIndexers[index] = updatedIndexer
                                        Task { await viewModel.saveSettings() }
                                    }
                                },
                                onDelete: { indexerToDelete in
                                    viewModel.appSettings.searchIndexers.removeAll { $0.id == indexerToDelete.id }
                                    Task { await viewModel.saveSettings() }
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Search Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddIndexer) {
                NavigationView {
                    Form {
                        Section("Indexer Details") {
                            TextField("Name", text: $newIndexerName)
                            TextField("Host URL", text: $newIndexerHost)
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                            SecureField("API Key", text: $newIndexerApiKey)
                        }
                    }
                    .navigationTitle("Add Indexer")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingAddIndexer = false
                                newIndexerName = ""
                                newIndexerHost = ""
                                newIndexerApiKey = ""
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                let newIndexer = SearchIndexer(
                                    name: newIndexerName,
                                    displayName: newIndexerName,
                                    host: newIndexerHost,
                                    apiKey: newIndexerApiKey
                                )
                                viewModel.appSettings.searchIndexers.append(newIndexer)
                                Task { await viewModel.saveSettings() }
                                
                                showingAddIndexer = false
                                newIndexerName = ""
                                newIndexerHost = ""
                                newIndexerApiKey = ""
                            }
                            .disabled(newIndexerName.isEmpty)
                        }
                    }
                }
            }
        }
    }