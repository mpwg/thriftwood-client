//
//  OnboardingView.swift
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

/// Welcome screen shown during first app launch
struct OnboardingView: View {
    let coordinator: OnboardingCoordinator
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // App Icon
            Image(systemName: "leaf.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.themeAccent)
            
            // Welcome Text
            VStack(spacing: Spacing.sm) {
                Text("Welcome to Thriftwood")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.themePrimaryText)
                
                Text("Your central hub for managing media services")
                    .font(.title3)
                    .foregroundStyle(Color.themeSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            Spacer()
            
            // Features List
            VStack(alignment: .leading, spacing: Spacing.md) {
                FeatureRow(
                    icon: "person.2.fill",
                    title: "Multiple Profiles",
                    description: "Organize services into profiles for home, work, or different locations"
                )
                
                FeatureRow(
                    icon: "network",
                    title: "Service Integration",
                    description: "Connect Radarr, Sonarr, Tautulli, and more from one place"
                )
                
                FeatureRow(
                    icon: "paintbrush.fill",
                    title: "Customizable Themes",
                    description: "Choose from light, dark, or black themes to match your style"
                )
            }
            .padding(.horizontal, Spacing.xl)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: Spacing.md) {
                Button {
                    coordinator.showCreateProfile()
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.themeAccent)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                
                Button {
                    coordinator.skipOnboarding()
                } label: {
                    Text("Skip for Now")
                        .font(.subheadline)
                        .foregroundStyle(Color.themeSecondaryText)
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.themePrimaryBackground)
    }
}

// MARK: - Feature Row

private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.themeAccent)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.themePrimaryText)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color.themeSecondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview

#Preview("Onboarding View") {
    let coordinator = OnboardingCoordinator()
    coordinator.start()
    
    return OnboardingView(coordinator: coordinator)
}
