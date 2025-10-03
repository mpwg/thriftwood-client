//
//  QuickActionsMenu.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 01.10.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

/// Quick actions menu for dashboard functionality
/// Provides refresh, settings access, and other dashboard actions
struct QuickActionsMenu: View {
    @Bindable var viewModel: DashboardViewModel
    @State private var showingServiceErrors = false
    
    var body: some View {
        Menu {
            // Refresh action
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                Label("Refresh Services", systemImage: "arrow.clockwise")
            }
            
            Divider()
            
            // Service status overview
            Button {
                showingServiceErrors = true
            } label: {
                if viewModel.hasServiceErrors {
                    Label("Service Status (Issues Found)", systemImage: "exclamationmark.triangle")
                } else {
                    Label("Service Status (All Good)", systemImage: "checkmark.circle")
                }
            }
            
            Divider()
            
            // Settings access - Use SwiftUI NavigationLink
            NavigationLink(destination: SwiftUIAllSettingsView()) {
                Label("Settings", systemImage: "gearshape")
            }
            
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title3)
        }
        .alert("Service Status", isPresented: $showingServiceErrors) {
            Button("OK") { }
        } message: {
            if viewModel.hasServiceErrors {
                Text("Issues found with: \(viewModel.servicesWithErrors.joined(separator: ", "))")
            } else {
                Text("All enabled services are working correctly.")
            }
        }
    }
    

}