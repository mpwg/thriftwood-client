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
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // Configuration Tab (matching Flutter's primary interface)
                configurationView
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Configuration")
                    }
                    .tag(0)
                
                // All Settings Tab (comprehensive menu)
                allSettingsView
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("All Settings")
                    }
                    .tag(1)
            }
            .navigationTitle(selectedTab == 0 ? "Configuration" : "Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
                
                if selectedTab == 0 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(viewModel.currentProfileName) {
                            Task {
                                await FlutterSwiftUIBridge.shared.presentNativeView(
                                    route: "settings_profiles"
                                )
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
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
    
    // MARK: - Configuration View (matches Flutter's main interface)
    
    @ViewBuilder
    private var configurationView: some View {
        List {
            // Services Section (matching first Flutter image)
            Section("Services") {
                ServiceToggleRow(name: "Lidarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Lidarr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Lidarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Radarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Radarr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Radarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Sonarr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Sonarr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Sonarr", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Tautulli", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Tautulli" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Tautulli", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "Overseerr", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Overseerr" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateServiceEnabled("Overseerr", enabled: newValue)
                    }
                ))
            }
            
            // Download Clients Section
            Section("Download Clients") {
                ServiceToggleRow(name: "SABnzbd", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "SABnzbd" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateDownloadClientEnabled("SABnzbd", enabled: newValue)
                    }
                ))
                
                ServiceToggleRow(name: "NZBGet", isEnabled: Binding(
                    get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" })?.enabled ?? false },
                    set: { newValue in
                        viewModel.updateDownloadClientEnabled("NZBGet", enabled: newValue)
                    }
                ))
            }
        }

    }
    
    // MARK: - All Settings View (matches Flutter's settings menu)
    
    @ViewBuilder
    private var allSettingsView: some View {
        List {
            // Configuration Section (matching second Flutter image)
            Section("Configuration") {
                SettingsMenuItem(
                    title: "General",
                    subtitle: "Customize LunaSea",
                    icon: "brush",
                    route: "settings_general"
                )
                
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
                
                SettingsMenuItem(
                    title: "Dashboard",
                    subtitle: "Configure Dashboard",
                    icon: "house",
                    route: "settings_dashboard"
                )
                
                SettingsMenuItem(
                    title: "External Modules",
                    subtitle: "Configure External Modules",
                    icon: "cube.box",
                    route: "settings_external_modules"
                )
            }
            
            // Services Section
            Section("Services") {
                ServiceConfigMenuItem(name: "Lidarr", icon: "music.note.list")
                ServiceConfigMenuItem(name: "NZBGet", icon: "arrow.down.circle")  
                ServiceConfigMenuItem(name: "Radarr", icon: "film")
                ServiceConfigMenuItem(name: "SABnzbd", icon: "arrow.down.square")
                
                SettingsMenuItem(
                    title: "Search",
                    subtitle: "Configure Search",
                    icon: "magnifyingglass", 
                    route: "settings_search"
                )
                
                ServiceConfigMenuItem(name: "Sonarr", icon: "tv")
                ServiceConfigMenuItem(name: "Tautulli", icon: "chart.bar")
                
                SettingsMenuItem(
                    title: "Wake on LAN",
                    subtitle: "Configure Wake on LAN",
                    icon: "wifi.router",
                    route: "settings_wake_on_lan"
                )
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

// MARK: - Service Toggle Row

struct ServiceToggleRow: View {
    let name: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .font(.body)
            
            Spacer()
            
            Text(isEnabled ? "Enabled" : "Disabled")
                .font(.caption)
                .foregroundColor(isEnabled ? .green : .secondary)
            
            Toggle("", isOn: $isEnabled)
        }
    }
}

// MARK: - Service Config Menu Item

struct ServiceConfigMenuItem: View {
    let name: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                
                Text("Configure \(name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                await FlutterSwiftUIBridge.shared.presentNativeView(
                    route: "settings_configuration_\(name.lowercased())"
                )
            }
        }
    }
}

// MARK: - Individual Service Configuration Views

struct SwiftUIRadarrSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Radarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Radarr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Radarr", enabled: newValue)
                        }
                    ))
                }
                
                if let radarrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Radarr" }), radarrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { radarrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Radarr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { radarrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Radarr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { radarrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Radarr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Options") {
                        Picker("Default Quality Profile", selection: .constant("Any")) {
                            Text("Any").tag("Any")
                            Text("HD-720p").tag("HD-720p") 
                            Text("HD-1080p").tag("HD-1080p")
                            Text("Ultra-HD").tag("Ultra-HD")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Root Folder", selection: .constant("/movies")) {
                            Text("/movies").tag("/movies")
                            Text("/media/movies").tag("/media/movies")
                        }
                        .pickerStyle(.menu)
                        
                        Toggle("Monitor New Movies", isOn: .constant(true))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Calendar")) {
                            Text("Calendar").tag("Calendar")
                            Text("Activity").tag("Activity") 
                            Text("History").tag("History")
                            Text("Queue").tag("Queue")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Radarr")
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

struct SwiftUISonarrSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Sonarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Sonarr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Sonarr", enabled: newValue)
                        }
                    ))
                }
                
                if let sonarrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Sonarr" }), sonarrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { sonarrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Sonarr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { sonarrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Sonarr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { sonarrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Sonarr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Options") {
                        Picker("Default Quality Profile", selection: .constant("Any")) {
                            Text("Any").tag("Any")
                            Text("HD-720p").tag("HD-720p")
                            Text("HD-1080p").tag("HD-1080p")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Root Folder", selection: .constant("/tv")) {
                            Text("/tv").tag("/tv")
                            Text("/media/tv").tag("/media/tv")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Series Type", selection: .constant("Standard")) {
                            Text("Standard").tag("Standard")
                            Text("Anime").tag("Anime")
                            Text("Daily").tag("Daily")
                        }
                        .pickerStyle(.menu)
                        
                        Toggle("Monitor New Series", isOn: .constant(true))
                        Toggle("Search for Missing Episodes", isOn: .constant(false))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Calendar")) {
                            Text("Calendar").tag("Calendar")
                            Text("Activity").tag("Activity")
                            Text("History").tag("History")
                            Text("Queue").tag("Queue")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Queue Settings") {
                        Picker("Queue Size", selection: .constant(25)) {
                            Text("25").tag(25)
                            Text("50").tag(50)
                            Text("100").tag(100)
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Sonarr")
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

struct SwiftUILidarrSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Lidarr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Lidarr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Lidarr", enabled: newValue)
                        }
                    ))
                }
                
                if let lidarrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Lidarr" }), lidarrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { lidarrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Lidarr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { lidarrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Lidarr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { lidarrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Lidarr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Options") {
                        Picker("Default Quality Profile", selection: .constant("Any")) {
                            Text("Any").tag("Any")
                            Text("Lossless").tag("Lossless")
                            Text("High Quality").tag("High Quality")
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Default Root Folder", selection: .constant("/music")) {
                            Text("/music").tag("/music")
                            Text("/media/music").tag("/media/music")
                        }
                        .pickerStyle(.menu)
                        
                        Toggle("Monitor New Artists", isOn: .constant(true))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Calendar")) {
                            Text("Calendar").tag("Calendar")
                            Text("Activity").tag("Activity")
                            Text("History").tag("History")
                            Text("Queue").tag("Queue")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Lidarr")
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

struct SwiftUITautulliSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Tautulli", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Tautulli" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Tautulli", enabled: newValue)
                        }
                    ))
                }
                
                if let tautulliConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Tautulli" }), tautulliConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { tautulliConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Tautulli", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { tautulliConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Tautulli", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { tautulliConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Tautulli", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Activity")) {
                            Text("Activity").tag("Activity")
                            Text("History").tag("History")
                            Text("Statistics").tag("Statistics")
                            Text("Users").tag("Users")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Refresh Settings") {
                        Picker("Activity Refresh Rate", selection: .constant(10)) {
                            Text("5 seconds").tag(5)
                            Text("10 seconds").tag(10)
                            Text("15 seconds").tag(15)
                            Text("30 seconds").tag(30)
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Statistics") {
                        Picker("Statistics Item Count", selection: .constant(10)) {
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("25").tag(25)
                            Text("50").tag(50)
                        }
                        .pickerStyle(.menu)
                        
                        TextField("Default Termination Message", text: .constant("Stream terminated"))
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Tautulli")
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

struct SwiftUISABnzbdSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Download Client") {
                    Toggle("Enable SABnzbd", isOn: Binding(
                        get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "SABnzbd" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateDownloadClientEnabled("SABnzbd", enabled: newValue)
                        }
                    ))
                }
                
                if let sabnzbdConfig = viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "SABnzbd" }), sabnzbdConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { sabnzbdConfig.host },
                            set: { newValue in
                                viewModel.updateDownloadClientHost("SABnzbd", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { sabnzbdConfig.apiKey },
                            set: { newValue in
                                viewModel.updateDownloadClientApiKey("SABnzbd", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { sabnzbdConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateDownloadClientStrictTLS("SABnzbd", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Queue")) {
                            Text("Queue").tag("Queue")
                            Text("History").tag("History")
                            Text("Statistics").tag("Statistics")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("SABnzbd")
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

struct SwiftUINZBGetSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Download Client") {
                    Toggle("Enable NZBGet", isOn: Binding(
                        get: { viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateDownloadClientEnabled("NZBGet", enabled: newValue)
                        }
                    ))
                }
                
                if let nzbgetConfig = viewModel.selectedProfile?.downloadClientConfigurations.first(where: { $0.name == "NZBGet" }), nzbgetConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { nzbgetConfig.host },
                            set: { newValue in
                                viewModel.updateDownloadClientHost("NZBGet", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        TextField("Username", text: Binding(
                            get: { nzbgetConfig.username },
                            set: { newValue in
                                viewModel.updateDownloadClientUsername("NZBGet", username: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        
                        SecureField("Password", text: Binding(
                            get: { nzbgetConfig.password },
                            set: { newValue in
                                viewModel.updateDownloadClientPassword("NZBGet", password: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { nzbgetConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateDownloadClientStrictTLS("NZBGet", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Queue")) {
                            Text("Queue").tag("Queue")
                            Text("History").tag("History")
                            Text("Statistics").tag("Statistics")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("NZBGet")
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

struct SwiftUIOverseerrSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Service") {
                    Toggle("Enable Overseerr", isOn: Binding(
                        get: { viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Overseerr" })?.enabled ?? false },
                        set: { newValue in
                            viewModel.updateServiceEnabled("Overseerr", enabled: newValue)
                        }
                    ))
                }
                
                if let overseerrConfig = viewModel.selectedProfile?.serviceConfigurations.first(where: { $0.name == "Overseerr" }), overseerrConfig.enabled {
                    Section("Connection Details") {
                        TextField("Host URL", text: Binding(
                            get: { overseerrConfig.host },
                            set: { newValue in
                                viewModel.updateServiceHost("Overseerr", host: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        
                        SecureField("API Key", text: Binding(
                            get: { overseerrConfig.apiKey },
                            set: { newValue in
                                viewModel.updateServiceApiKey("Overseerr", apiKey: newValue)
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        
                        Toggle("Strict TLS Validation", isOn: Binding(
                            get: { overseerrConfig.strictTLS },
                            set: { newValue in
                                viewModel.updateServiceStrictTLS("Overseerr", strictTLS: newValue)
                            }
                        ))
                    }
                    
                    Section("Default Pages") {
                        Picker("Home Page", selection: .constant("Discover")) {
                            Text("Discover").tag("Discover")
                            Text("Requests").tag("Requests")
                            Text("Users").tag("Users")
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Connection Test") {
                        Button("Test Connection") {
                            // TODO: Implement connection test
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Overseerr")
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