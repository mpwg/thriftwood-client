//
//  LunaLogEntryRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

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