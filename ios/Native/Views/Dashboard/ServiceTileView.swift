//
//  ServiceTileView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 01.10.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI
import Flutter

/// Swift equivalent of Flutter's LunaBlock for service modules
/// Maintains identical appearance and behavior to Flutter implementation
struct ServiceTileView: View {
    let service: Service
    @Bindable var viewModel: DashboardViewModel
    
    var body: some View {
        Button {
            Task {
                await viewModel.navigateToService(service)
            }
        } label: {
            HStack(spacing: 16) {
                // Service icon with status indicator - matches Flutter's LunaIconButton
                ZStack {
                    Circle()
                        .fill(service.color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: service.iconName)
                        .font(.title2)
                        .foregroundColor(service.color)
                    
                    // Status indicator - top-right corner
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: viewModel.getServiceStatusIcon(service.key))
                                .font(.caption2)
                                .foregroundColor(viewModel.getServiceStatusColor(service.key))
                                .background(
                                    Circle()
                                        .fill(.background)
                                        .frame(width: 12, height: 12)
                                )
                        }
                        Spacer()
                    }
                    .frame(width: 44, height: 44)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(service.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
        .contentShape(Rectangle())
    }
}