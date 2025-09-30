//
//  ExternalModuleRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

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