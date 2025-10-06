//
//  RadarrSettingsView.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI

/// View for configuring Radarr service settings
///
/// Based on legacy Flutter ConfigurationRadarrRoute with modernized SwiftUI patterns.
/// Follows MVVM-C architecture - ViewModel handles business logic, Coordinator handles navigation.
///
/// Features:
/// - Server URL configuration
/// - API key input (secure)
/// - Test connection with status feedback
/// - Enable/disable service toggle
/// - System status display
/// - Save/Cancel actions
///
/// Usage:
/// ```swift
/// RadarrSettingsView(
///     viewModel: viewModel,
///     profile: profile,
///     onSave: {
///         coordinator.pop()
///     }
/// )
/// ```
struct RadarrSettingsView: View {
    // MARK: - Properties
    
    @Bindable var viewModel: RadarrSettingsViewModel
    let profile: Profile
    let onSave: () -> Void
    
    @State private var showTestResult = false
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
    
    var body: some View {
        Form {
            enabledSection
            connectionSection
            
            if let statusDisplay = viewModel.systemStatusDisplay {
                systemStatusSection(statusDisplay)
            }
            
            if viewModel.connectionTestResult != nil {
                testResultSection
            }
        }
        .navigationTitle("Radarr Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    // Navigation handled by coordinator
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveSettings()
                }
                .disabled(viewModel.isLoading || !isValid)
            }
        }
        .task {
            await viewModel.loadConfiguration(for: profile)
        }
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    VStack(spacing: Spacing.md) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Testing connection...")
                            .font(.body)
                            .foregroundStyle(Color.themePrimaryText)
                    }
                    .padding(Spacing.xl)
                    .background(Color.themeSecondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
                }
            }
        }
    }
    
    // MARK: - Enabled Section
    
    private var enabledSection: some View {
        Section {
            Toggle("Enable Radarr", isOn: $viewModel.isEnabled)
        } footer: {
            Text("Enable or disable Radarr integration for this profile")
                .font(.caption)
                .foregroundStyle(Color.themeSecondaryText)
        }
    }
    
    // MARK: - Connection Section
    
    private var connectionSection: some View {
        Section {
            // Host URL
            TextField(
                "Host URL",
                text: $viewModel.host,
                prompt: Text("https://radarr.example.com")
            )
            .keyboardType(.URL)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused($focusedField, equals: .host)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .apiKey
            }
            
            // API Key
            SecureField(
                "API Key",
                text: $viewModel.apiKey,
                prompt: Text("Enter API key")
            )
            .focused($focusedField, equals: .apiKey)
            .submitLabel(.done)
            .onSubmit {
                focusedField = nil
            }
            
            // Test Connection Button
            Button(action: testConnection) {
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .accessibilityHidden(true)
                    Text("Test Connection")
                }
            }
            .disabled(viewModel.isLoading || viewModel.host.isEmpty || viewModel.apiKey.isEmpty)
            .accessibilityLabel("Test connection")
            .accessibilityHint(viewModel.host.isEmpty || viewModel.apiKey.isEmpty ? "Enter host URL and API key to test connection" : "Tests the connection to your Radarr server")
        } header: {
            Text("Connection Details")
        } footer: {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Enter your Radarr server URL and API key")
                    .font(.caption)
                    .foregroundStyle(Color.themeSecondaryText)
                
                if let error = viewModel.error {
                    Text(error.errorDescription ?? "Unknown error")
                        .font(.caption)
                        .foregroundStyle(Color.red)
                }
            }
        }
    }
    
    // MARK: - System Status Section
    
    private func systemStatusSection(_ statusDisplay: RadarrSystemStatusDisplayModel) -> some View {
        Section("System Information") {
            ForEach(statusDisplay.displayItems) { item in
                LabeledContent(item.label, value: item.value)
                    .font(item.isCaption ? .caption : .body)
            }
        }
    }
    
    // MARK: - Test Result Section
    
    private var testResultSection: some View {
        Section {
            if case .success = viewModel.connectionTestResult {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.green)
                        .accessibilityHidden(true)
                    Text("Connection successful")
                        .foregroundStyle(Color.themePrimaryText)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Success: Connection successful")
            } else if case .failure(let message) = viewModel.connectionTestResult {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.red)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Connection failed")
                            .foregroundStyle(Color.themePrimaryText)
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Error: Connection failed. \(message)")
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isValid: Bool {
        !viewModel.host.isEmpty && !viewModel.apiKey.isEmpty
    }
    
    // MARK: - Actions
    
    private func testConnection() {
        focusedField = nil
        Task {
            let success = await viewModel.testConnection()
            showTestResult = true
            
            // Auto-dismiss success message after 3 seconds
            if success {
                try? await Task.sleep(for: .seconds(3))
                showTestResult = false
            }
        }
    }
    
    private func saveSettings() {
        focusedField = nil
        Task {
            await viewModel.saveSettings(for: profile)
            if viewModel.error == nil {
                onSave()
            }
        }
    }
}

// MARK: - Supporting Types

private enum Field {
    case host
    case apiKey
}

// MARK: - Previews

#Preview("Radarr Settings - Empty") {
    @Previewable @State var viewModel = RadarrSettingsViewModel(
        radarrService: PreviewRadarrService(),
        dataService: PreviewDataService()
    )
    
    let profile = Profile(name: "Default", isEnabled: true)
    
    NavigationStack {
        RadarrSettingsView(
            viewModel: viewModel,
            profile: profile,
            onSave: {}
        )
    }
}

#Preview("Radarr Settings - Configured") {
    @Previewable @State var viewModel = {
        let vm = RadarrSettingsViewModel(
            radarrService: PreviewRadarrService(),
            dataService: PreviewDataService()
        )
        vm.host = "https://radarr.example.com"
        vm.apiKey = "test-api-key-123"
        vm.isEnabled = true
        return vm
    }()
    
    let profile = Profile(name: "Default", isEnabled: true)
    
    NavigationStack {
        RadarrSettingsView(
            viewModel: viewModel,
            profile: profile,
            onSave: {}
        )
    }
}

#Preview("Radarr Settings - Testing") {
    @Previewable @State var viewModel = {
        let vm = RadarrSettingsViewModel(
            radarrService: PreviewRadarrService(),
            dataService: PreviewDataService()
        )
        vm.host = "https://radarr.example.com"
        vm.apiKey = "test-api-key-123"
        vm.isLoading = true
        return vm
    }()
    
    let profile = Profile(name: "Default", isEnabled: true)
    
    NavigationStack {
        RadarrSettingsView(
            viewModel: viewModel,
            profile: profile,
            onSave: {}
        )
    }
}

#Preview("Radarr Settings - Success") {
    @Previewable @State var viewModel = {
        let vm = RadarrSettingsViewModel(
            radarrService: PreviewRadarrService(),
            dataService: PreviewDataService()
        )
        vm.host = "https://radarr.example.com"
        vm.apiKey = "test-api-key-123"
        vm.connectionTestResult = .success
        return vm
    }()
    
    let profile = Profile(name: "Default", isEnabled: true)
    
    NavigationStack {
        RadarrSettingsView(
            viewModel: viewModel,
            profile: profile,
            onSave: {}
        )
    }
}

#Preview("Radarr Settings - Error") {
    @Previewable @State var viewModel = {
        let vm = RadarrSettingsViewModel(
            radarrService: PreviewRadarrService(),
            dataService: PreviewDataService()
        )
        vm.host = "https://radarr.example.com"
        vm.apiKey = "wrong-key"
        vm.connectionTestResult = .failure(message: "Invalid API key")
        vm.error = .networkError(URLError(.userAuthenticationRequired))
        return vm
    }()
    
    let profile = Profile(name: "Default", isEnabled: true)
    
    NavigationStack {
        RadarrSettingsView(
            viewModel: viewModel,
            profile: profile,
            onSave: {}
        )
    }
}
