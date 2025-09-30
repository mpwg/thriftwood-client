//
//  ServiceToggleRow.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct ServiceToggleRow: View {
    let name: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .font(.body)
            
            Spacer()
            
            Text(isEnabled ? "Enabled" : "Disabled")
                .font(.caption)
                .foregroundColor(isEnabled ? .green : .secondary)
            
            Toggle("", isOn: $isEnabled)
        }
    }
}