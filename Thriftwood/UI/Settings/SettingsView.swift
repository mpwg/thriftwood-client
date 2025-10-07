//
//  SettingsView.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI

/// Main settings view with navigation to all settings screens (ADR-0012: Simple MVVM)
/// Navigation is handled by AppCoordinator, this view just displays settings options
@MainActor
struct SettingsView: View {
    private let preferences: any UserPreferencesServiceProtocol
    private let profileService: any ProfileServiceProtocol
    @State private var showResetConfirmation = false
    
    // Navigation callbacks (provided by AppCoordinator)
    let onNavigateToProfiles: () -> Void
    let onNavigateToAppearance: () -> Void
    let onNavigateToGeneral: () -> Void
    let onNavigateToNetworking: () -> Void
    let onNavigateToAbout: () -> Void
    let onNavigateToAcknowledgements: () -> Void
    
    init(
        onNavigateToProfiles: @escaping () -> Void,
        onNavigateToAppearance: @escaping () -> Void,
        onNavigateToGeneral: @escaping () -> Void,
        onNavigateToNetworking: @escaping () -> Void,
        onNavigateToAbout: @escaping () -> Void,
        onNavigateToAcknowledgements: @escaping () -> Void
    ) {
        // Resolve services from DI container
        let container = DIContainer.shared
        self.preferences = container.resolve((any UserPreferencesServiceProtocol).self)
        self.profileService = container.resolve((any ProfileServiceProtocol).self)
        
        // Store navigation callbacks
        self.onNavigateToProfiles = onNavigateToProfiles
        self.onNavigateToAppearance = onNavigateToAppearance
        self.onNavigateToGeneral = onNavigateToGeneral
        self.onNavigateToNetworking = onNavigateToNetworking
        self.onNavigateToAbout = onNavigateToAbout
        self.onNavigateToAcknowledgements = onNavigateToAcknowledgements
    }
    
    var body: some View {
        List {
            // Profile Section
            Section {
                Button {
                    onNavigateToProfiles()
                } label: {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(Color.themeAccent)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Profiles")
                                .foregroundStyle(Color.themePrimaryText)
                            Text("Manage service configurations")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
                
                let currentProfile = preferences.enabledProfileName
                if !currentProfile.isEmpty {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Current Profile")
                                .foregroundStyle(Color.themePrimaryText)
                            Text(currentProfile)
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                    }
                }
            } header: {
                Text("Profiles")
            }
            
            // Appearance Section
            Section {
                Button {
                    onNavigateToAppearance()
                } label: {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundStyle(Color.themeAccent)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Appearance")
                                .foregroundStyle(Color.themePrimaryText)
                            Text("Theme and display settings")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
            } header: {
                Text("Appearance")
            }
            
            // General Section
            Section {
                Button {
                    onNavigateToGeneral()
                } label: {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(Color.themeAccent)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("General")
                                .foregroundStyle(Color.themePrimaryText)
                            Text("App preferences and behavior")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
                
                Button {
                    onNavigateToNetworking()
                } label: {
                    HStack {
                        Image(systemName: "network")
                            .foregroundStyle(Color.themeAccent)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Networking")
                                .foregroundStyle(Color.themePrimaryText)
                            Text("Connection and security settings")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
            } header: {
                Text("General")
            }
            
            // About Section
            Section {
                Button {
                    onNavigateToAbout()
                } label: {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(Color.themeAccent)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("About")
                                .foregroundStyle(Color.themePrimaryText)
                            Text("Version and credits")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
                
                Button {
                    onNavigateToAcknowledgements()
                } label: {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(Color.themeAccent)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Acknowledgements")
                                .foregroundStyle(Color.themePrimaryText)
                            Text("Open source licenses")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
            } header: {
                Text("About")
            }
            
            // Advanced Section
            Section {
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .foregroundStyle(.red)
                            .frame(width: Sizing.iconMedium)
                        
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("Reset Onboarding")
                                .foregroundStyle(.red)
                            Text("Return to welcome screen")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                    }
                }
            } header: {
                Text("Advanced")
            } footer: {
                Text("Reset onboarding will restart the app and show the welcome screen. Your profiles and settings will be preserved.")
                    .font(.caption)
            }
        }
        .navigationTitle("Settings")
        .alert("Reset Onboarding Confirmation", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetOnboarding()
            }
        } message: {
            Text("This will return you to the welcome screen. Your profiles and settings will not be deleted.")
        }
    }
    
    // MARK: - Actions
    
    /// Resets the onboarding flow and restarts the app
    private func resetOnboarding() {
        // Get AppCoordinator from DI container and reset
        let appCoordinator = DIContainer.shared.resolve(AppCoordinator.self)
        appCoordinator.resetOnboarding()
    }
}

// MARK: - Preview

#Preview("Settings View") {
    NavigationStack {
        SettingsView(
            onNavigateToProfiles: {},
            onNavigateToAppearance: {},
            onNavigateToGeneral: {},
            onNavigateToNetworking: {},
            onNavigateToAbout: {},
            onNavigateToAcknowledgements: {}
        )
    }
}
