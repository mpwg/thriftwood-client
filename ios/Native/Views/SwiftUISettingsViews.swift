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
                        Button("Configuration") {
                            Task {
                                await FlutterSwiftUIBridge.shared.presentNativeView(
                                    route: "/settings/configuration"
                                )
                            }
                        }
                        
                        Button("System Logs") {
                            // TODO: Navigate to system logs
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
                            DownloadClientConfigurationRow(client: client)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(client.name)
                    .font(.headline)
                
                Spacer()
                
                Toggle("", isOn: $client.enabled)
            }
            
            if client.enabled {
                Text("Configuration coming soon...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
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

// MARK: - Preview Support

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
#endif