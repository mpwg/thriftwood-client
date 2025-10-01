//
//  ServiceBadge.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct ServiceBadge: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.blue.opacity(0.2))
            .foregroundColor(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}