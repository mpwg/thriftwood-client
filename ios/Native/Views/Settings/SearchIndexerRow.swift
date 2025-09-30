//
//  SearchIndexerRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

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