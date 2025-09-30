//
//  QuickActionRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

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