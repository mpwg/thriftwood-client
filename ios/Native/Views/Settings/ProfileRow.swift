//
//  ProfileRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

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