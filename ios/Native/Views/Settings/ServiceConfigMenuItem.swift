//
//  ServiceConfigMenuItem.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct ServiceConfigMenuItem: View {
    let name: String
    let icon: String
    
    @State private var isNavigating = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                
                Text("Configure \(name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isNavigating = true
        }
        .fullScreenCover(isPresented: $isNavigating) {
            FlutterSwiftUIBridge.shared.createSwiftUIView(
                for: "settings_configuration_\(name.lowercased())",
                data: [:]
            )
        }
    }
}