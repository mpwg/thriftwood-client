//
//  ServiceConfigurationRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

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