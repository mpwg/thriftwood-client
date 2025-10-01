//
//  ModulesView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 01.10.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI
import Flutter

/// Swift equivalent of Flutter's ModulesPage
/// Displays service tiles in a list format matching Flutter implementation
struct ModulesView: View {
    @Bindable var viewModel: DashboardViewModel
    
    var body: some View {
        if !viewModel.isAnyServiceEnabled {
            // Swift equivalent of Flutter's LunaMessage for no modules enabled
            NoModulesEnabledView()
        } else {
            LazyVStack(spacing: 0) {
                // Enabled services - matches Flutter's service list
                ForEach(viewModel.enabledServices, id: \.key) { service in
                    if service.key == "wake_on_lan" {
                        WakeOnLANTileView(service: service, viewModel: viewModel)
                    } else {
                        ServiceTileView(service: service, viewModel: viewModel)
                    }
                }
                
                // Settings tile - always at bottom (matches Flutter)
                ServiceTileView(service: viewModel.settingsService, viewModel: viewModel)
            }
        }
    }
}