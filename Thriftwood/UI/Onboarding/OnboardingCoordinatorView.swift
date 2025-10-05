//
//  OnboardingCoordinatorView.swift
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

/// Coordinator view that manages navigation for the onboarding flow
struct OnboardingCoordinatorView: View {
    @Bindable var coordinator: OnboardingCoordinator
    @State private var viewModel: OnboardingViewModel
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
        
        // Initialize ViewModel from DI container
        let profileService = DIContainer.shared.resolve((any ProfileServiceProtocol).self)
        let preferences = DIContainer.shared.resolve((any UserPreferencesServiceProtocol).self)
        self.viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferences
        )
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            OnboardingView(
                coordinator: coordinator,
                viewModel: viewModel
            )
            .navigationDestination(for: OnboardingRoute.self) { route in
                destinationView(for: route)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: OnboardingRoute) -> some View {
        switch route {
        case .welcome:
            OnboardingView(
                coordinator: coordinator,
                viewModel: viewModel
            )
            
        case .createProfile:
            // Use SettingsCoordinator temporarily for profile creation
            // In a real app, this might be a dedicated onboarding profile view
            let settingsCoordinator = SettingsCoordinator()
            AddProfileView(coordinator: settingsCoordinator)
                .onDisappear {
                    // Check if a profile was created via ViewModel
                    Task {
                        let hasProfile = await viewModel.checkProfileCreated()
                        if hasProfile {
                            coordinator.showAddFirstService()
                        }
                    }
                }
            
        case .addFirstService:
            // Placeholder for service configuration (Milestone 2)
            VStack(spacing: Spacing.lg) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                
                Text("Profile Created!")
                    .font(.title)
                    .foregroundStyle(Color.themePrimaryText)
                
                Text("You can add services later from the Settings tab")
                    .foregroundStyle(Color.themeSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                
                Button {
                    viewModel.handleOnboardingComplete()
                    coordinator.completeOnboarding()
                } label: {
                    Text("Continue to App")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.themeAccent)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xl)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.themePrimaryBackground)
            
        case .complete:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview("Onboarding Flow") {
    let coordinator = OnboardingCoordinator()
    coordinator.start()
    
    return OnboardingCoordinatorView(coordinator: coordinator)
}
