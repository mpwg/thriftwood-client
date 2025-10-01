//
//  SwiftUIRadarrSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct SwiftUIRadarrSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                // Information Banner
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Radarr")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.")
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
                    Toggle("Enable Radarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.radarrEnabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Radarr", enabled: newValue)
                        }
                    ))
                }
                
                if viewModel.selectedProfile?.radarrEnabled == true {
                    // Connection Details Navigation
                    Section {
                        NavigationLink(destination: RadarrConnectionDetailsView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Connection Details")
                                    .font(.body)
                                Text("Connection Details for Radarr")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Default Options Navigation  
                    Section {
                        NavigationLink(destination: RadarrDefaultOptionsView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Default Options")
                                    .font(.body)
                                Text("Set Sorting, Filtering, and View Options")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Default Pages Navigation
                    Section {
                        NavigationLink(destination: RadarrDefaultPagesView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Default Pages")
                                    .font(.body)
                                Text("Set Default Landing Pages")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Discover Suggestions
                    Section {
                        Toggle(isOn: .constant(true)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Discover Suggestions")
                                    .font(.body)
                                Text("Add Suggested Releases in Discover")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Queue Size
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Queue Size")
                                    .font(.body)
                                Text("\(viewModel.appSettings.radarrQueuePageSize) Items")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "queue.fill")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showRadarrQueueSizePicker()
                        }
                    }
                }
            }
            .navigationTitle("Radarr")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .alert("Queue Size", isPresented: $viewModel.isShowingRadarrQueueSizePicker) {
                TextField("Enter queue size", text: $viewModel.queueSizeInput)
                    .keyboardType(.numberPad)
                Button("Set") {
                    Task {
                        await viewModel.setRadarrQueueSize()
                    }
                }
                Button("Cancel", role: .cancel) {
                    viewModel.isShowingRadarrQueueSizePicker = false
                }
            } message: {
                Text("Set the amount of items fetched for the queue. Minimum of 1 item.")
            }
        }
    }
}

// MARK: - Connection Details View

struct RadarrConnectionDetailsView: View {
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
                    TextField("https://radarr.example.com", text: Binding(
                        get: { viewModel.selectedProfile?.radarrHost ?? "" },
                        set: { newValue in
                            viewModel.updateServiceHost("Radarr", host: newValue)
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
                        get: { viewModel.selectedProfile?.radarrApiKey ?? "" },
                        set: { newValue in
                            viewModel.updateServiceApiKey("Radarr", apiKey: newValue)
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                
                NavigationLink(destination: RadarrCustomHeadersView(viewModel: viewModel)) {
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
                         viewModel.selectedProfile?.radarrHost.isEmpty == true ||
                         viewModel.selectedProfile?.radarrApiKey.isEmpty == true)
            }
        }
    }
    
    private func testConnection() {
        guard let profile = viewModel.selectedProfile,
              !profile.radarrHost.isEmpty,
              !profile.radarrApiKey.isEmpty else {
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

struct RadarrCustomHeadersView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var newHeaderKey = ""
    @State private var newHeaderValue = ""
    @State private var showingAddHeader = false
    
    private var headerKeys: [String] {
        guard let headers = viewModel.selectedProfile?.radarrCustomHeaders else { return [] }
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
                            Text(viewModel.selectedProfile?.radarrCustomHeaders[key] ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Delete") {
                            viewModel.selectedProfile?.radarrCustomHeaders.removeValue(forKey: key)
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
                                viewModel.selectedProfile?.radarrCustomHeaders[newHeaderKey] = newHeaderValue
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

// MARK: - Default Options View

struct RadarrDefaultOptionsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            Section("Movies") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Filter Category")
                        .font(.headline)
                    Picker("Filter Category", selection: .constant("All")) {
                        Text("All").tag("All")
                        Text("Monitored").tag("Monitored")
                        Text("Unmonitored").tag("Unmonitored")
                        Text("Missing").tag("Missing")
                        Text("Downloaded").tag("Downloaded")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sort Category")
                        .font(.headline)
                    Picker("Sort Category", selection: .constant("Title")) {
                        Text("Title").tag("Title")
                        Text("Added").tag("Added")
                        Text("In Cinemas").tag("In Cinemas")
                        Text("Physical Release").tag("Physical Release")
                        Text("Size").tag("Size")
                    }
                    .pickerStyle(.menu)
                }
                
                Toggle("Sort Direction Ascending", isOn: .constant(true))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("View")
                        .font(.headline)
                    Picker("View", selection: .constant("List")) {
                        Text("List").tag("List")
                        Text("Grid").tag("Grid")
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            Section("Releases") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Filter Category")
                        .font(.headline)
                    Picker("Filter Category", selection: .constant("All")) {
                        Text("All").tag("All")
                        Text("Approved").tag("Approved")
                        Text("Rejected").tag("Rejected")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sort Category")
                        .font(.headline)
                    Picker("Sort Category", selection: .constant("Weight")) {
                        Text("Weight").tag("Weight")
                        Text("Size").tag("Size")
                        Text("Seeders").tag("Seeders")
                        Text("Age").tag("Age")
                    }
                    .pickerStyle(.menu)
                }
                
                Toggle("Sort Direction Ascending", isOn: .constant(false))
            }
        }
        .navigationTitle("Default Options")
    }
}

// MARK: - Default Pages View

struct RadarrDefaultPagesView: View {
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
                    Text("Movie Details")
                        .font(.headline)
                    Picker("Movie Details", selection: .constant("Overview")) {
                        Text("Overview").tag("Overview")
                        Text("Files").tag("Files")
                        Text("History").tag("History")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Movie")
                        .font(.headline)
                    Picker("Add Movie", selection: .constant("Discover")) {
                        Text("Discover").tag("Discover")
                        Text("Search").tag("Search")
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("System Status")
                        .font(.headline)
                    Picker("System Status", selection: .constant("Health")) {
                        Text("Health").tag("Health")
                        Text("Tasks").tag("Tasks")
                        Text("Logs").tag("Logs")
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .navigationTitle("Default Pages")
    }
}