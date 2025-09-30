//
//  DownloadClientConfigurationRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

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
                    HStack {
                        Image(systemName: client.icon)
                        Text(client.name)
                            .font(.headline)
                    }
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
