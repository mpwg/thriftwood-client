//
//  DownloadClientTile.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

import SwiftUI

/// Download client tile for overview - shows only enable/disable toggle
/// All detailed configuration moved to dedicated settings views
struct DownloadClientTile: View {
    @Bindable var client: DownloadClientConfiguration
    var settingsViewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            // Client info
            HStack(spacing: 12) {
                Image(systemName: client.icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(client.name)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Text(client.enabled ? "Enabled" : "Disabled")
                        .font(.caption)
                        .foregroundStyle(client.enabled ? .green : .secondary)
                }
            }
            
            Spacer()
            
            // Enable/Disable toggle
            Toggle("", isOn: $client.enabled)
                .onChange(of: client.enabled) { _, _ in
                    settingsViewModel.updateDownloadClientEnabled(client.name, enabled: client.enabled)
                }
        }
        .contentShape(Rectangle())
        .background(
            // Navigation to detailed settings (only when enabled)
            NavigationLink(destination: destinationView) {
                EmptyView()
            }
            .opacity(0)
            .disabled(!client.enabled)
        )
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch client.name {
        case "SABnzbd":
            SwiftUISABnzbdSettingsView(viewModel: settingsViewModel)
        case "NZBGet":
            SwiftUINZBGetSettingsView(viewModel: settingsViewModel)
        default:
            Text("Settings for \(client.name)")
                .navigationTitle(client.name)
        }
    }
}