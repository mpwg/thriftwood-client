//
//  NoModulesEnabledView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 01.10.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI
import Flutter

/// Swift equivalent of Flutter's LunaMessage for no modules enabled state
struct NoModulesEnabledView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Modules Enabled")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Configure your services in Settings to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                Task {
                    await navigateToSettings()
                }
            } label: {
                Text("Go to Settings")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .frame(maxWidth: 200)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func navigateToSettings() async {
        print("NoModulesEnabledView: Settings navigation initiated")
        
        // Use the hybrid bridge system to navigate to settings
        // This will present the SwiftUI settings view that's already registered
        FlutterSwiftUIBridge.shared.presentNativeView(route: "/settings")
    }
}