//
//  WakeOnLANTileView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 01.10.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI
import Flutter

/// Swift equivalent of Flutter's _buildWakeOnLAN
/// Special handling for Wake on LAN service with direct action
struct WakeOnLANTileView: View {
    let service: Service
    @Bindable var viewModel: DashboardViewModel
    @State private var isTriggering = false
    
    var body: some View {
        Button {
            Task {
                isTriggering = true
                await viewModel.triggerWakeOnLAN()
                isTriggering = false
            }
        } label: {
            HStack(spacing: 16) {
                // Service icon with loading state
                ZStack {
                    Circle()
                        .fill(service.color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    if isTriggering {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: service.iconName)
                            .font(.title2)
                            .foregroundColor(service.color)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(isTriggering ? "Waking devices..." : service.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "power")
                    .font(.caption)
                    .foregroundColor(service.color)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
        .contentShape(Rectangle())
        .disabled(isTriggering)
    }
}