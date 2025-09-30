//
//  SwiftUILidarrSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct SwiftUILidarrSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                // Information Banner
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lidarr")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new albums from your favorite artists and will grab, sort, and rename them.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            Button("GitHub") {
                                // Open GitHub link
                            }
                            .font(.caption)
                            
                            Button("Website") {
                                // Open website link
                            }
                            .font(.caption)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // Enable Module Toggle
                Section {
                    Toggle("Enable Lidarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.lidarrEnabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Lidarr", enabled: newValue)
                        }
                    ))
                }
                
                if viewModel.selectedProfile?.lidarrEnabled == true {
                    // Connection Details Navigation
                    Section {
                        NavigationLink(destination: LidarrConnectionDetailsView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Connection Details")
                                    .font(.body)
                                Text("Connection Details for Lidarr")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Default Pages Navigation
                    Section {
                        NavigationLink(destination: LidarrDefaultPagesView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Default Pages")
                                    .font(.body)
                                Text("Set Default Landing Pages")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lidarr")
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

// MARK: - Connection Details View

struct LidarrConnectionDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    @State private var isTestingConnection = false
    @State private var connectionTestResult: String?
    
    var body: some View {
        List {
            Section("Connection") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Host")
                        .font(.headline)
                    TextField("https://lidarr.example.com", text: Binding(
                        get: { viewModel.selectedProfile?.lidarrHost ?? "" },
                        set: { newValue in
                            viewModel.updateServiceHost("Lidarr", host: newValue)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("API Key")
                        .font(.headline)
                    SecureField("Enter API Key", text: Binding(
                        get: { viewModel.selectedProfile?.lidarrApiKey ?? "" },
                        set: { newValue in
                            viewModel.updateServiceApiKey("Lidarr", apiKey: newValue)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                
                NavigationLink(destination: LidarrCustomHeadersView(viewModel: viewModel)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Custom Headers")
                            .font(.body)
                        Text("Add Custom Headers to Requests")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if let result = connectionTestResult {
                Section("Test Result") {
                    Text(result)
                        .foregroundColor(result.contains("Success") ? .green : .red)
                }
            }
        }
        .navigationTitle("Connection Details")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: testConnection) {
                    HStack {
                        if isTestingConnection {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "wifi")
                        }
                        Text("Test Connection")
                    }
                }
                .disabled(isTestingConnection || 
                         viewModel.selectedProfile?.lidarrHost.isEmpty == true ||
                         viewModel.selectedProfile?.lidarrApiKey.isEmpty == true)
            }
        }
    }
    
    private func testConnection() {
        guard let profile = viewModel.selectedProfile,
              !profile.lidarrHost.isEmpty,
              !profile.lidarrApiKey.isEmpty else {
            connectionTestResult = "Host and API Key are required"
            return
        }
        
        isTestingConnection = true
        connectionTestResult = nil
        
        // Simulate connection test
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isTestingConnection = false
            connectionTestResult = "Connection successful!"
        }
    }
}

// MARK: - Custom Headers View

struct LidarrCustomHeadersView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var newHeaderKey = ""
    @State private var newHeaderValue = ""
    @State private var showingAddHeader = false
    
    private var headerKeys: [String] {
        guard let headers = viewModel.selectedProfile?.lidarrCustomHeaders else { return [] }
        return Array(headers.keys)
    }
    
    var body: some View {
        List {
            Section("Custom Headers") {
                ForEach(headerKeys, id: \.self) { key in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(key)
                                .font(.headline)
                            Text(viewModel.selectedProfile?.lidarrCustomHeaders[key] ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Delete") {
                            viewModel.selectedProfile?.lidarrCustomHeaders.removeValue(forKey: key)
                            Task {
                                await viewModel.saveSettings()
                            }
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Custom Headers")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAddHeader = true
                }
            }
        }
        .sheet(isPresented: $showingAddHeader) {
            NavigationView {
                Form {
                    TextField("Header Key", text: $newHeaderKey)
                    TextField("Header Value", text: $newHeaderValue)
                }
                .navigationTitle("Add Header")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingAddHeader = false
                            newHeaderKey = ""
                            newHeaderValue = ""
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if !newHeaderKey.isEmpty && !newHeaderValue.isEmpty {
                                viewModel.selectedProfile?.lidarrCustomHeaders[newHeaderKey] = newHeaderValue
                                Task {
                                    await viewModel.saveSettings()
                                }
                                showingAddHeader = false
                                newHeaderKey = ""
                                newHeaderValue = ""
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Default Pages View

struct LidarrDefaultPagesView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            Section("Navigation Defaults") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Home")
                        .font(.headline)
                    Picker("Home", selection: .constant("Calendar")) {
                        Text("Calendar").tag("Calendar")
                        Text("Activity").tag("Activity")
                        Text("History").tag("History")
                        Text("Queue").tag("Queue")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Artist Details")
                        .font(.headline)
                    Picker("Artist Details", selection: .constant("Overview")) {
                        Text("Overview").tag("Overview")
                        Text("Files").tag("Files")
                        Text("History").tag("History")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Artist")
                        .font(.headline)
                    Picker("Add Artist", selection: .constant("Discover")) {
                        Text("Discover").tag("Discover")
                        Text("Search").tag("Search")
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .navigationTitle("Default Pages")
    }
}