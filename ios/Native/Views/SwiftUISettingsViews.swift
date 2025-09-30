//
//  SwiftUISettingsViews.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  SwiftUI Settings Views following MVVM pattern with @Observable
//

import SwiftUI

// MARK: - Main Settings View

struct SwiftUISettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                profileSection
                
                // Appearance Section
                appearanceSection
                
                // Security Section
                securitySection
                
                // Notifications Section
                notificationsSection
                
                // System Section
                systemSection
                
                // About Section
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("All Settings") {
                            Task {
                                await FlutterSwiftUIBridge.shared.presentNativeView(
                                    route: "settings_all"
                                )
                            }
                        }
                        
                        Button("System Logs") {
                            Task {
                                await FlutterSwiftUIBridge.shared.presentNativeView(
                                    route: "settings_system_logs"
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.isShowingError) {
                Button("OK") {
                    viewModel.isShowingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .alert("Clear Configuration", isPresented: $viewModel.showingClearConfigConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All Data", role: .destructive) {
                    Task {
                        await viewModel.clearConfiguration()
                    }
                }
            } message: {
                Text("This will reset all settings to default and cannot be undone. Are you sure?")
            }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var profileSection: some View {
        Section("Profile") {
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Profile")
                        .font(.headline)
                    Text(viewModel.currentProfileName)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if viewModel.hasValidServices {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.orange)
                }
            }
            .onTapGesture {
                Task {
                    await FlutterSwiftUIBridge.shared.presentNativeView(
                        route: "/settings/profiles"
                    )
                }
            }
            
            if viewModel.hasValidServices {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enabled Services")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80, maximum: 120))
                    ], spacing: 8) {
                        ForEach(viewModel.enabledServices, id: \.self) { service in
                            ServiceBadge(name: service)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: Binding(
                get: { viewModel.appSettings.selectedTheme },
                set: { newValue in
                    Task {
                        await viewModel.updateTheme(newValue)
                    }
                }
            )) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Label(theme.displayName, systemImage: theme.systemImage)
                        .tag(theme)
                }
            }
            .pickerStyle(.menu)
            
            Toggle("Image Headers", isOn: Binding(
                get: { viewModel.appSettings.enableImageHeaders },
                set: { newValue in
                    viewModel.appSettings.enableImageHeaders = newValue
                    Task { await viewModel.saveSettings() }
                }
            ))
            
            Toggle("Custom Headers", isOn: Binding(
                get: { viewModel.appSettings.enableCustomHeaders },
                set: { newValue in
                    viewModel.appSettings.enableCustomHeaders = newValue
                    Task { await viewModel.saveSettings() }
                }
            ))
        }
    }
    
    @ViewBuilder
    private var securitySection: some View {
        Section("Security") {
            Toggle("Enable Biometrics", isOn: Binding(
                get: { viewModel.appSettings.enableBiometrics },
                set: { newValue in
                    Task {
                        await viewModel.toggleBiometrics(newValue)
                    }
                }
            ))
            
            if viewModel.appSettings.enableBiometrics {
                Toggle("Require on Launch", isOn: Binding(
                    get: { viewModel.appSettings.requireBiometricsOnLaunch },
                    set: { newValue in
                        viewModel.appSettings.requireBiometricsOnLaunch = newValue
                        Task { await viewModel.saveSettings() }
                    }
                ))
                
                Toggle("Require on Unlock", isOn: Binding(
                    get: { viewModel.appSettings.requireBiometricsOnUnlock },
                    set: { newValue in
                        viewModel.appSettings.requireBiometricsOnUnlock = newValue
                        Task { await viewModel.saveSettings() }
                    }
                ))
            }
        }
    }
    
    @ViewBuilder
    private var notificationsSection: some View {
        Section("Notifications") {
            Toggle("Enable Notifications", isOn: Binding(
                get: { viewModel.appSettings.enableNotifications },
                set: { newValue in
                    viewModel.appSettings.enableNotifications = newValue
                    Task { await viewModel.saveSettings() }
                }
            ))
            
            Toggle("Broadcast Notifications", isOn: Binding(
                get: { viewModel.appSettings.enableBroadcastNotifications },
                set: { newValue in
                    viewModel.appSettings.enableBroadcastNotifications = newValue
                    Task { await viewModel.saveSettings() }
                }
            ))
        }
    }
    
    @ViewBuilder
    private var systemSection: some View {
        Section("System") {
            // Debug: Test Hive sync button (development only)
            Button(action: {
                Task {
                    await viewModel.testReloadFromHive()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("🔄 Test Hive Sync")
                            .foregroundColor(.primary)
                        Text("Debug: Reload profile data from Flutter storage")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.orange)
                }
            }
            
            // Backup functionality
            Button(action: {
                Task {
                    await viewModel.performBackup()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Backup Configuration")
                            .foregroundColor(.primary)
                        Text("Create a backup of your current configuration")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if viewModel.isBackingUp {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                    }
                }
            }
            .disabled(viewModel.isBackingUp)
            
            // Restore functionality
            Button(action: {
                Task {
                    await viewModel.performRestore()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Restore Configuration")
                            .foregroundColor(.primary)
                        Text("Restore configuration from a backup file")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if viewModel.isRestoring {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.blue)
                    }
                }
            }
            .disabled(viewModel.isRestoring)
            
            // System Logs
            Button(action: {
                Task {
                    await FlutterSwiftUIBridge.shared.presentNativeView(
                        route: "settings_system_logs"
                    )
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("System Logs")
                            .foregroundColor(.primary)
                        Text("View application logs and debug information")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue)
                }
            }
            
            // Clear Image Cache
            Button(action: {
                Task {
                    await viewModel.clearImageCache()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Clear Image Cache")
                            .foregroundColor(.primary)
                        Text("Remove cached images to free up storage")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if viewModel.isClearingCache {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .disabled(viewModel.isClearingCache)
            
            // Clear Configuration
            Button(action: {
                viewModel.showingClearConfigConfirmation = true
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Clear Configuration")
                            .foregroundColor(.red)
                        Text("Reset all settings to default (clean slate)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if viewModel.isClearingConfig {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                    }
                }
            }
            .disabled(viewModel.isClearingConfig)
        }
    }
    
    @ViewBuilder
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0 (SwiftUI)")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Build")
                Spacer()
                Text(Bundle.main.buildNumber)
                    .foregroundStyle(.secondary)
            }
            
            Button("View on GitHub") {
                if let url = URL(string: "https://github.com/mpwg/thriftwood-client") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

// MARK: - Profiles View

struct SwiftUIProfilesView: View {
    let viewModel: ProfilesViewModel
    @State private var showingCreateProfile = false
    @State private var showingRenameProfile = false
    @State private var showingDeleteConfirmation = false
    @State private var newProfileName = ""
    @State private var selectedProfileToRename: ThriftwoodProfile?
    @State private var selectedProfileToDelete: ThriftwoodProfile?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Current Profile") {
                    ForEach(viewModel.profiles) { profile in
                        ProfileRow(
                            profile: profile,
                            isSelected: profile.name == viewModel.currentProfile,
                            onSelect: {
                                Task {
                                    await viewModel.selectProfile(profile.name)
                                }
                            },
                            onRename: {
                                selectedProfileToRename = profile
                                newProfileName = profile.name
                                showingRenameProfile = true
                            },
                            onDelete: profile.name != "default" ? {
                                selectedProfileToDelete = profile
                                showingDeleteConfirmation = true
                            } : nil
                        )
                    }
                }
            }
            .navigationTitle("Profiles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Profile") {
                        showingCreateProfile = true
                    }
                }
            }
            .alert("Create Profile", isPresented: $showingCreateProfile) {
                TextField("Profile Name", text: $newProfileName)
                Button("Create") {
                    Task {
                        await viewModel.createProfile(newProfileName)
                        newProfileName = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    newProfileName = ""
                }
            }
            .alert("Rename Profile", isPresented: $showingRenameProfile) {
                TextField("New Name", text: $newProfileName)
                Button("Rename") {
                    if let profile = selectedProfileToRename {
                        Task {
                            await viewModel.renameProfile(from: profile.name, to: newProfileName)
                            selectedProfileToRename = nil
                            newProfileName = ""
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    selectedProfileToRename = nil
                    newProfileName = ""
                }
            }
            .alert("Delete Profile", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let profile = selectedProfileToDelete {
                        Task {
                            await viewModel.deleteProfile(profile.name)
                            selectedProfileToDelete = nil
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    selectedProfileToDelete = nil
                }
            } message: {
                if let profile = selectedProfileToDelete {
                    Text("Are you sure you want to delete the profile '\(profile.name)'? This action cannot be undone.")
                }
            }
        }
        .task {
            await viewModel.loadProfiles()
        }
    }
}

// MARK: - Configuration View

struct SwiftUIConfigurationView: View {
    let viewModel: ConfigurationViewModel
    @State private var expandedServices: Set<String> = []
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.selectedProfile == nil {
                    Section {
                        VStack(spacing: 16) {
                            Image(systemName: "gear.badge.questionmark")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            
                            Text("No Profile Selected")
                                .font(.headline)
                            
                            Text("Select a profile to configure services")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                } else {
                    // Service configurations
                    Section("Services") {
                        ForEach(viewModel.serviceConfigurations) { service in
                            ServiceConfigurationRow(
                                service: service,
                                isExpanded: expandedServices.contains(service.name),
                                onToggleExpanded: {
                                    if expandedServices.contains(service.name) {
                                        expandedServices.remove(service.name)
                                    } else {
                                        expandedServices.insert(service.name)
                                    }
                                },
                                onUpdate: { updatedService in
                                    Task {
                                        await viewModel.updateServiceConfiguration(updatedService)
                                    }
                                },
                                onTestConnection: { service in
                                    Task {
                                        let success = await viewModel.testConnection(for: service)
                                        // Show feedback
                                    }
                                }
                            )
                        }
                    }
                    
                    // Download client configurations
                    Section("Download Clients") {
                        ForEach(viewModel.downloadClientConfigurations) { client in
                            DownloadClientConfigurationRow(
                                client: client,
                                isExpanded: expandedServices.contains(client.name),
                                onToggleExpanded: {
                                    if expandedServices.contains(client.name) {
                                        expandedServices.remove(client.name)
                                    } else {
                                        expandedServices.insert(client.name)
                                    }
                                },
                                onUpdate: { updatedClient in
                                    Task {
                                        await viewModel.updateDownloadClientConfiguration(updatedClient)
                                    }
                                },
                                onTestConnection: { client in
                                    Task {
                                        let success = await viewModel.testDownloadClientConnection(for: client)
                                        // Show feedback
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Configuration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
            .task {
                await viewModel.loadConfiguration()
            }
        }
    }
}

// MARK: - Supporting Views

struct ServiceBadge: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.blue.opacity(0.2))
            .foregroundColor(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct ProfileRow: View {
    let profile: ThriftwoodProfile
    let isSelected: Bool
    let onSelect: () -> Void
    let onRename: () -> Void
    let onDelete: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(profile.name)
                        .font(.headline)
                    
                    if profile.isDefault {
                        Text("DEFAULT")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                
                Text("\(profile.serviceConfigurations.filter(\.enabled).count) services enabled")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if let onDelete = onDelete {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
            }
            
            Button("Rename") {
                onRename()
            }
            .tint(.blue)
        }
    }
}

struct ServiceConfigurationRow: View {
    @Bindable var service: ServiceConfiguration
    let isExpanded: Bool
    let onToggleExpanded: () -> Void
    let onUpdate: (ServiceConfiguration) -> Void
    let onTestConnection: (ServiceConfiguration) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(service.name)
                        .font(.headline)
                    
                    if service.enabled && !service.host.isEmpty {
                        Text(service.host)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else if service.enabled {
                        Text("Not configured")
                            .font(.caption)
                            .foregroundColor(.orange)
                    } else {
                        Text("Disabled")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: $service.enabled)
                    .onChange(of: service.enabled) { _, _ in
                        onUpdate(service)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onToggleExpanded()
            }
            
            if isExpanded && service.enabled {
                VStack(spacing: 12) {
                    TextField("Host URL", text: $service.host)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                    
                    SecureField("API Key", text: $service.apiKey)
                        .textFieldStyle(.roundedBorder)
                    
                    Toggle("Strict TLS", isOn: $service.strictTLS)
                    
                    HStack {
                        Button("Test Connection") {
                            onTestConnection(service)
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Save") {
                            onUpdate(service)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.leading)
            }
        }
    }
}

struct DownloadClientConfigurationRow: View {
    @Bindable var client: DownloadClientConfiguration
    let isExpanded: Bool
    let onToggleExpanded: () -> Void
    let onUpdate: (DownloadClientConfiguration) -> Void
    let onTestConnection: (DownloadClientConfiguration) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(client.name)
                        .font(.headline)
                    
                    if client.enabled && !client.host.isEmpty {
                        Text(client.host)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else if client.enabled {
                        Text("Not configured")
                            .font(.caption)
                            .foregroundColor(.orange)
                    } else {
                        Text("Disabled")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: $client.enabled)
                    .onChange(of: client.enabled) { _, _ in
                        onUpdate(client)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onToggleExpanded()
            }
            
            if isExpanded && client.enabled {
                VStack(spacing: 12) {
                    TextField("Host URL", text: $client.host)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                    
                    if client.name.lowercased() == "sabnzbd" {
                        SecureField("API Key", text: $client.apiKey)
                            .textFieldStyle(.roundedBorder)
                    } else if client.name.lowercased() == "nzbget" {
                        TextField("Username", text: $client.username)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $client.password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Toggle("Strict TLS", isOn: $client.strictTLS)
                    
                    HStack {
                        Button("Test Connection") {
                            onTestConnection(client)
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Save") {
                            onUpdate(client)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.leading)
            }
        }
    }
}

// MARK: - Extensions

extension AppTheme {
    var systemImage: String {
        switch self {
        case .light: return "sun.max"
        case .dark: return "moon"
        case .system: return "circle.lefthalf.filled"
        }
    }
}

extension Bundle {
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

// MARK: - System Logs View (MVVM Pattern)

struct SwiftUISystemLogsView: View {
    @Bindable var viewModel: SystemLogsViewModel
    
    init(viewModel: SystemLogsViewModel = SystemLogsViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Log type filter
                Picker("Log Type", selection: $viewModel.selectedLogType) {
                    ForEach(LunaLogType.allCases, id: \.self) { type in
                        Text(type.title)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Logs list
                if viewModel.isLoading {
                    ProgressView("Loading logs...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredLogs.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        
                        Text("No Logs Found")
                            .font(.headline)
                        
                        Text("No logs match the selected filter")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.filteredLogs, id: \.id) { log in
                        LunaLogEntryRow(log: log)
                    }
                    .refreshable {
                        await viewModel.refreshLogs()
                    }
                }
            }
            .navigationTitle("System Logs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Refresh") {
                            Task {
                                await viewModel.refreshLogs()
                            }
                        }
                        
                        Button("Clear All") {
                            Task {
                                await viewModel.clearLogs()
                            }
                        }
                        
                        Button("Export Logs") {
                            Task {
                                if let url = await viewModel.exportLogs() {
                                    // Show share sheet for exported logs
                                    // This would typically use UIActivityViewController
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.isShowingError) {
                Button("OK") {
                    viewModel.isShowingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .task {
                await viewModel.loadLogs()
            }
        }
    }
}

// MARK: - Log Supporting Views

struct LunaLogEntryRow: View {
    let log: LunaLogEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Log type badge with icon
                HStack(spacing: 4) {
                    Image(systemName: log.type.icon)
                        .font(.caption)
                    Text(log.type.title)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(log.type.color.opacity(0.2))
                .foregroundColor(log.type.color)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Spacer()
                
                // Timestamp (Flutter style)
                Text(log.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Message
            Text(log.message)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            // Additional Flutter log details
            if let className = log.className, !className.isEmpty {
                Text("Class: \(className)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let methodName = log.methodName, !methodName.isEmpty {
                Text("Method: \(methodName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let error = log.error, !error.isEmpty {
                Text("Error: \(error)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview Support

// MARK: - General Settings View

struct SwiftUIGeneralSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
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
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
        }
    }
}

// MARK: - Dashboard Settings View

struct SwiftUIDashboardSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Refresh") {
                    HStack {
                        Text("Refresh Interval")
                        Spacer()
                        Picker("", selection: Binding(
                            get: { viewModel.appSettings.dashboardRefreshInterval },
                            set: { newValue in
                                viewModel.appSettings.dashboardRefreshInterval = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        )) {
                            Text("1 minute").tag(60)
                            Text("5 minutes").tag(300)
                            Text("10 minutes").tag(600)
                            Text("15 minutes").tag(900)
                            Text("30 minutes").tag(1800)
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section("Calendar") {
                    Toggle("Enable Calendar View", isOn: Binding(
                        get: { viewModel.appSettings.enableCalendarView },
                        set: { newValue in
                            viewModel.appSettings.enableCalendarView = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    if viewModel.appSettings.enableCalendarView {
                        HStack {
                            Text("Days Ahead")
                            Spacer()
                            Picker("", selection: Binding(
                                get: { viewModel.appSettings.calendarDaysAhead },
                                set: { newValue in
                                    viewModel.appSettings.calendarDaysAhead = newValue
                                    Task { await viewModel.saveSettings() }
                                }
                            )) {
                                Text("7 days").tag(7)
                                Text("14 days").tag(14)
                                Text("30 days").tag(30)
                                Text("60 days").tag(60)
                            }
                            .pickerStyle(.menu)
                        }
                        
                        Picker("Starting Day", selection: Binding(
                            get: { viewModel.appSettings.calendarStartingDay },
                            set: { newValue in
                                viewModel.appSettings.calendarStartingDay = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        )) {
                            ForEach(CalendarStartDay.allCases, id: \.self) { day in
                                Text(day.displayName).tag(day)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Starting View", selection: Binding(
                            get: { viewModel.appSettings.calendarStartingType },
                            set: { newValue in
                                viewModel.appSettings.calendarStartingType = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        )) {
                            ForEach(CalendarStartType.allCases, id: \.self) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Dashboard Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
        }
    }
}

// MARK: - Wake on LAN Settings View

struct SwiftUIWakeOnLANSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Wake on LAN Configuration") {
                    Toggle("Enable Wake on LAN", isOn: Binding(
                        get: { viewModel.selectedProfile?.wakeOnLanEnabled ?? false },
                        set: { newValue in
                            viewModel.selectedProfile?.wakeOnLanEnabled = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    if viewModel.selectedProfile?.wakeOnLanEnabled == true {
                        TextField("MAC Address", text: Binding(
                            get: { viewModel.selectedProfile?.wakeOnLanMACAddress ?? "" },
                            set: { newValue in
                                viewModel.selectedProfile?.wakeOnLanMACAddress = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.allCharacters)
                        
                        TextField("Broadcast Address", text: Binding(
                            get: { viewModel.selectedProfile?.wakeOnLanBroadcastAddress ?? "" },
                            set: { newValue in
                                viewModel.selectedProfile?.wakeOnLanBroadcastAddress = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    }
                }
                
                if viewModel.selectedProfile?.wakeOnLanEnabled == true {
                    Section("Test") {
                        Button("Send Wake Signal") {
                            Task {
                                // TODO: Implement actual wake on LAN functionality
                                await viewModel.testWakeOnLAN()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Wake on LAN")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
        }
    }
}

// MARK: - Search Settings View

struct SwiftUISearchSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var showingAddIndexer = false
    @State private var newIndexerName = ""
    @State private var newIndexerHost = ""
    @State private var newIndexerApiKey = ""
    
    var body: some View {
        NavigationStack {
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
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
            .sheet(isPresented: $showingAddIndexer) {
                NavigationStack {
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
}

struct SearchIndexerRow: View {
    @Bindable var indexer: SearchIndexer
    let onUpdate: (SearchIndexer) -> Void
    let onDelete: (SearchIndexer) -> Void
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(indexer.displayName)
                        .font(.headline)
                    
                    if !indexer.host.isEmpty {
                        Text(indexer.host)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: $indexer.isEnabled)
                    .onChange(of: indexer.isEnabled) { _, _ in
                        onUpdate(indexer)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isExpanded.toggle()
            }
            
            if isExpanded {
                VStack(spacing: 12) {
                    TextField("Host URL", text: $indexer.host)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    
                    SecureField("API Key", text: $indexer.apiKey)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Button("Delete", role: .destructive) {
                            onDelete(indexer)
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Save") {
                            onUpdate(indexer)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.leading)
            }
        }
    }
}

// MARK: - External Modules Settings View

struct SwiftUIExternalModulesSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @State private var showingAddModule = false
    @State private var newModuleName = ""
    @State private var newModuleDisplayName = ""
    @State private var newModuleHost = ""
    
    var body: some View {
        NavigationStack {
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
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
            .sheet(isPresented: $showingAddModule) {
                NavigationStack {
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
}

struct ExternalModuleRow: View {
    @Bindable var module: ExternalModule
    let onUpdate: (ExternalModule) -> Void
    let onDelete: (ExternalModule) -> Void
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(module.displayName)
                        .font(.headline)
                    
                    if !module.host.isEmpty {
                        Text(module.host)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: $module.isEnabled)
                    .onChange(of: module.isEnabled) { _, _ in
                        onUpdate(module)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isExpanded.toggle()
            }
            
            if isExpanded {
                VStack(spacing: 12) {
                    TextField("Internal Name", text: $module.name)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    TextField("Display Name", text: $module.displayName)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Host URL", text: $module.host)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    
                    HStack {
                        Button("Delete", role: .destructive) {
                            onDelete(module)
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Save") {
                            onUpdate(module)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.leading)
            }
        }
    }
}

// MARK: - Drawer Settings View

struct SwiftUIDrawerSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
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
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
        }
    }
}

// MARK: - Quick Actions Settings View

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

struct QuickActionRow: View {
    @Bindable var action: QuickActionItem
    let onUpdate: (QuickActionItem) -> Void
    let onDelete: (QuickActionItem) -> Void
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: action.icon)
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading) {
                    Text(action.title)
                        .font(.headline)
                    
                    Text(action.route)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $action.isEnabled)
                    .onChange(of: action.isEnabled) { _, _ in
                        onUpdate(action)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isExpanded.toggle()
            }
            
            if isExpanded {
                VStack(spacing: 12) {
                    TextField("Title", text: $action.title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("SF Symbol Name", text: $action.icon)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Route", text: $action.route)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    HStack {
                        Button("Delete", role: .destructive) {
                            onDelete(action)
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Save") {
                            onUpdate(action)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.leading)
            }
        }
    }
}

// MARK: - All Settings Menu View (Flutter-like hierarchy)

struct SwiftUIAllSettingsView: View {
    @State private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                // Configuration Section
                Section("Configuration") {
                    SettingsMenuItem(
                        title: "General",
                        subtitle: "Customize LunaSea",
                        icon: "brush",
                        route: "settings_general"
                    )
                    
                    SettingsMenuItem(
                        title: "Dashboard",
                        subtitle: "Configure Dashboard",
                        icon: "house",
                        route: "settings_dashboard"
                    )
                    
                    SettingsMenuItem(
                        title: "Service Configuration", 
                        subtitle: "Configure Services & Download Clients",
                        icon: "gear",
                        route: "settings_configuration"
                    )
                }
                
                // Services Section
                Section("Services & Features") {
                    SettingsMenuItem(
                        title: "Wake on LAN",
                        subtitle: "Configure Wake on LAN",
                        icon: "wifi.router",
                        route: "settings_wake_on_lan"
                    )
                    
                    SettingsMenuItem(
                        title: "Search",
                        subtitle: "Configure Search & Indexers",
                        icon: "magnifyingglass",
                        route: "settings_search"
                    )
                    
                    SettingsMenuItem(
                        title: "External Modules",
                        subtitle: "Configure External Modules",
                        icon: "cube.box",
                        route: "settings_external_modules"
                    )
                }
                
                // Interface Section
                Section("Interface") {
                    SettingsMenuItem(
                        title: "Drawer",
                        subtitle: "Customize the Drawer",
                        icon: "sidebar.left",
                        route: "settings_drawer"
                    )
                    
                    SettingsMenuItem(
                        title: "Quick Actions",
                        subtitle: "Quick Actions on the Home Screen",
                        icon: "bolt",
                        route: "settings_quick_actions"
                    )
                }
                
                // System Section 
                Section("System") {
                    SettingsMenuItem(
                        title: "Profiles",
                        subtitle: "Manage Profiles",
                        icon: "person.2",
                        route: "settings_profiles"
                    )
                    
                    SettingsMenuItem(
                        title: "System Logs",
                        subtitle: "View Application Logs",
                        icon: "doc.text",
                        route: "settings_system_logs"
                    )
                }
            }
            .navigationTitle("All Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
        }
    }
}

struct SettingsMenuItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let route: String
    var isEnabled: Bool = true
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isEnabled ? .blue : .gray)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isEnabled ? .primary : .gray)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isEnabled {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isEnabled {
                Task {
                    await FlutterSwiftUIBridge.shared.presentNativeView(route: route)
                }
            }
        }
        .disabled(!isEnabled)
    }
}

#if DEBUG
struct SwiftUISettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISettingsView(viewModel: SettingsViewModel())
    }
}

struct SwiftUIProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIProfilesView(viewModel: ProfilesViewModel(settingsViewModel: SettingsViewModel()))
    }
}

struct SwiftUIConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIConfigurationView(viewModel: ConfigurationViewModel(settingsViewModel: SettingsViewModel()))
    }
}

struct SwiftUISystemLogsView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISystemLogsView(viewModel: SystemLogsViewModel())
    }
}
#endif