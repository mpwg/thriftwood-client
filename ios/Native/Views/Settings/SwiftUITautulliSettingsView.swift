//
//  SwiftUITautulliSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct SwiftUITautulliSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {

        List {
                // Information Banner
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tautulli")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Tautulli is a 3rd party application that you can run alongside your Plex Media Server to monitor activity and track various statistics. Most importantly, these statistics include what has been watched, who watched it, when and where they watched it.")
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
                    Toggle("Enable Tautulli", isOn: Binding(
                        get: { viewModel.selectedProfile?.tautulliEnabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Tautulli", enabled: newValue)
                        }
                    ))
                }
                
                if viewModel.selectedProfile?.tautulliEnabled == true {
                    // Connection Details Navigation
                    Section {
                        NavigationLink(destination: TautulliConnectionDetailsView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Connection Details")
                                    .font(.body)
                                Text("Connection Details for Tautulli")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Activity Refresh Rate
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Activity Refresh Rate")
                                    .font(.body)
                                Text("Every \(viewModel.appSettings.tautulliRefreshRate) Seconds")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showTautulliRefreshRatePicker()
                        }
                    }
                    
                    // Default Pages Navigation
                    Section {
                        NavigationLink(destination: TautulliDefaultPagesView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Default Pages")
                                    .font(.body)
                                Text("Set Default Landing Pages")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Default Termination Message
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Default Termination Message")
                                    .font(.body)
                                Text("Not Set")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "videocam.slash")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showTautulliTerminationMessageDialog()
                        }
                    }
                    
                    // Statistics Item Count
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Statistics Item Count")
                                    .font(.body)
                                Text("\(viewModel.appSettings.tautulliStatisticsCount) Items")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "list.number")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showTautulliStatisticsCountPicker()
                        }
                    }
                }
            }
            .navigationTitle("Tautulli")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .alert("Activity Refresh Rate", isPresented: $viewModel.isShowingTautulliRefreshRatePicker) {
                TextField("Refresh rate (seconds)", text: $viewModel.tautulliRefreshRateInput)
                    .keyboardType(.numberPad)
                Button("Set") {
                    Task {
                        await viewModel.setTautulliRefreshRate()
                    }
                }
                Button("Cancel", role: .cancel) {
                    viewModel.isShowingTautulliRefreshRatePicker = false
                }
            } message: {
                Text("Set the refresh rate for activity updates. Minimum of 1 second.")
            }
            .alert("Termination Message", isPresented: $viewModel.isShowingTautulliTerminationMessageDialog) {
                TextField("Enter termination message", text: $viewModel.tautulliTerminationMessageInput)
                Button("Set") {
                    Task {
                        await viewModel.setTautulliTerminationMessage()
                    }
                }
                Button("Cancel", role: .cancel) {
                    viewModel.isShowingTautulliTerminationMessageDialog = false
                }
            } message: {
                Text("Set a custom message to display when playback is terminated.")
            }
            .alert("Statistics Item Count", isPresented: $viewModel.isShowingTautulliStatisticsCountPicker) {
                TextField("Number of items", text: $viewModel.tautulliStatisticsCountInput)
                    .keyboardType(.numberPad)
                Button("Set") {
                    Task {
                        await viewModel.setTautulliStatisticsCount()
                    }
                }
                Button("Cancel", role: .cancel) {
                    viewModel.isShowingTautulliStatisticsCountPicker = false
                }
            } message: {
                Text("Set the number of items to display in statistics. Minimum of 1 item.")
            }
        }
    }

// MARK: - Connection Details View

struct TautulliConnectionDetailsView: View {
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
                    TextField("https://tautulli.example.com", text: Binding(
                        get: { viewModel.selectedProfile?.tautulliHost ?? "" },
                        set: { newValue in
                            viewModel.updateServiceHost("Tautulli", host: newValue)
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
                        get: { viewModel.selectedProfile?.tautulliApiKey ?? "" },
                        set: { newValue in
                            viewModel.updateServiceApiKey("Tautulli", apiKey: newValue)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                
                NavigationLink(destination: TautulliCustomHeadersView(viewModel: viewModel)) {
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
                         viewModel.selectedProfile?.tautulliHost.isEmpty == true ||
                         viewModel.selectedProfile?.tautulliApiKey.isEmpty == true)
            }
        }
    }
    
    private func testConnection() {
        guard let profile = viewModel.selectedProfile,
              !profile.tautulliHost.isEmpty,
              !profile.tautulliApiKey.isEmpty else {
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

struct TautulliCustomHeadersView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var newHeaderKey = ""
    @State private var newHeaderValue = ""
    @State private var showingAddHeader = false
    
    private var headerKeys: [String] {
        guard let headers = viewModel.selectedProfile?.tautulliCustomHeaders else { return [] }
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
                            Text(viewModel.selectedProfile?.tautulliCustomHeaders[key] ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Delete") {
                            viewModel.selectedProfile?.tautulliCustomHeaders.removeValue(forKey: key)
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
                                viewModel.selectedProfile?.tautulliCustomHeaders[newHeaderKey] = newHeaderValue
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

struct TautulliDefaultPagesView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            Section("Navigation Defaults") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Home")
                        .font(.headline)
                    Picker("Home", selection: .constant("Activity")) {
                        Text("Activity").tag("Activity")
                        Text("History").tag("History")
                        Text("Statistics").tag("Statistics")
                        Text("Users").tag("Users")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("User Details")
                        .font(.headline)
                    Picker("User Details", selection: .constant("Profile")) {
                        Text("Profile").tag("Profile")
                        Text("History").tag("History")
                        Text("Statistics").tag("Statistics")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Media Details")
                        .font(.headline)
                    Picker("Media Details", selection: .constant("Overview")) {
                        Text("Overview").tag("Overview")
                        Text("History").tag("History")
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .navigationTitle("Default Pages")
    }
}