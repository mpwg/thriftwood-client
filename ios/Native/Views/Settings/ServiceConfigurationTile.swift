//
//  ServiceConfigurationTile.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

/// Service configuration tile for overview - shows only enable/disable toggle
/// All detailed configuration moved to dedicated settings views
struct ServiceConfigurationTile: View {
    @Bindable var service: ServiceConfiguration
    var settingsViewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            // Service info
            HStack(spacing: 12) {
                Image(systemName: service.icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(service.name)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Text(service.enabled ? "Enabled" : "Disabled")
                        .font(.caption)
                        .foregroundStyle(service.enabled ? .green : .secondary)
                }
            }
            
            Spacer()
            
            // Enable/Disable toggle
            Toggle("", isOn: $service.enabled)
                .onChange(of: service.enabled) { _, _ in
                    settingsViewModel.updateServiceEnabled(service.name, enabled: service.enabled)
                }
        }
        .contentShape(Rectangle())
        .background(
            // Navigation to detailed settings (only when enabled)
            NavigationLink(destination: destinationView) {
                EmptyView()
            }
            .opacity(0)
            .disabled(!service.enabled)
        )
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch service.name {
        case "Radarr":
            SwiftUIRadarrSettingsView(viewModel: settingsViewModel)
        case "Sonarr":
            SwiftUISonarrSettingsView(viewModel: settingsViewModel)
        case "Lidarr":
            SwiftUILidarrSettingsView(viewModel: settingsViewModel)
        case "Tautulli":
            SwiftUITautulliSettingsView(viewModel: settingsViewModel)
        case "Overseerr":
            SwiftUIOverseerrSettingsView(viewModel: settingsViewModel)
        default:
            Text("Settings for \(service.name)")
                .navigationTitle(service.name)
        }
    }
}