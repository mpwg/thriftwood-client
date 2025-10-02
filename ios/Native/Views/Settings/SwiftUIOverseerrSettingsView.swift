//
//  SwiftUIOverseerrSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct SwiftUIOverseerrSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {

        List {
                // Information Banner
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overseerr")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Overseerr is a request management and media discovery tool built to work with your existing Plex ecosystem. It helps you discover media you want to watch and makes it easy to request new content.")
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
                    Toggle("Enable Overseerr", isOn: Binding(
                        get: { viewModel.selectedProfile?.overseerrEnabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Overseerr", enabled: newValue)
                        }
                    ))
                }
                
                if viewModel.selectedProfile?.overseerrEnabled == true {
                    // Connection Details Navigation
                    Section {
                        NavigationLink(destination: OverseerrConnectionDetailsView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Connection Details")
                                    .font(.body)
                                Text("Connection Details for Overseerr")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Overseerr")
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

// MARK: - Connection Details View

struct OverseerrConnectionDetailsView: View {
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
                    TextField("https://overseerr.example.com", text: Binding(
                        get: { viewModel.selectedProfile?.overseerrHost ?? "" },
                        set: { newValue in
                            viewModel.updateServiceHost("Overseerr", host: newValue)
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
                        get: { viewModel.selectedProfile?.overseerrApiKey ?? "" },
                        set: { newValue in
                            viewModel.updateServiceApiKey("Overseerr", apiKey: newValue)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                
                NavigationLink(destination: OverseerrCustomHeadersView(viewModel: viewModel)) {
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
                         viewModel.selectedProfile?.overseerrHost.isEmpty == true ||
                         viewModel.selectedProfile?.overseerrApiKey.isEmpty == true)
            }
        }
    }
    
    private func testConnection() {
        guard let profile = viewModel.selectedProfile,
              !profile.overseerrHost.isEmpty,
              !profile.overseerrApiKey.isEmpty else {
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

struct OverseerrCustomHeadersView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var newHeaderKey = ""
    @State private var newHeaderValue = ""
    @State private var showingAddHeader = false
    
    private var headerKeys: [String] {
        guard let headers = viewModel.selectedProfile?.overseerrCustomHeaders else { return [] }
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
                            Text(viewModel.selectedProfile?.overseerrCustomHeaders[key] ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Delete") {
                            viewModel.selectedProfile?.overseerrCustomHeaders.removeValue(forKey: key)
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
                                viewModel.selectedProfile?.overseerrCustomHeaders[newHeaderKey] = newHeaderValue
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