//
//  SwiftUISettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

// MARK: - Supporting Types

struct ConfigurationModule: Hashable {
    let title: String
    let icon: String
}

struct SwiftUISettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingProfiles = false
    
    var body: some View {

        List {
                // Configuration Section
                SettingsMenuItem(
                    title: "Configuration",
                    subtitle: "Configure application and modules", 
                    icon: "gear",
                    route: "/settings/configuration",
                    viewModel: viewModel
                )
                .accessibilityLabel("Configuration")
                .accessibilityHint("Configure application and module settings")
                
                // Profiles Section (matches _profilesBlock)  
                SettingsMenuItem(
                    title: "Profiles",
                    subtitle: "Switch profiles and add new ones",
                    icon: "person.2",
                    route: "/settings/profiles",
                    viewModel: viewModel
                )
                .accessibilityLabel("Profiles")
                .accessibilityHint("Switch between profiles or add new ones")
                
                // System Section (matches _systemBlock)
                SettingsMenuItem(
                    title: "System", 
                    subtitle: "System utilities and logs",
                    icon: "gear.badge",
                    route: "/settings/system",
                    viewModel: viewModel
                )
                .accessibilityLabel("System")
                .accessibilityHint("Access system utilities and logs")
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .accessibilityLabel("Back")
                    .accessibilityHint("Return to the previous screen")
                }
                
                // Profile selector in top right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.currentProfileName) {
                        showingProfiles = true
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Current profile: \(viewModel.currentProfileName)")
                    .accessibilityHint("Tap to switch profiles")
                }
            }
            .alert("Error", isPresented: $viewModel.isShowingError) {
                Button("OK") {
                    viewModel.isShowingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .fullScreenCover(isPresented: $showingProfiles) {
                SwiftUIProfilesView(viewModel: viewModel)
            }
        }
    }