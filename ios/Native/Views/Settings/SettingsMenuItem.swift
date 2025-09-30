//
//  SettingsMenuItem.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SettingsMenuItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let route: String
    var isEnabled: Bool = true
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isEnabled ? .blue : .gray)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isEnabled ? .primary : .gray)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isEnabled {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isEnabled {
                Task {
                    await FlutterSwiftUIBridge.shared.presentNativeView(route: route)
                }
            }
        }
        .disabled(!isEnabled)
    }
}