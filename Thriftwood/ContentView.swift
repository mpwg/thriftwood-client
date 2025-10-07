//
//  ContentView.swift
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
//
//  ContentView.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 03.10.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    /// App coordinator from DI container
    @State private var coordinator: AppCoordinator?
    
    var body: some View {
        Group {
            if let coordinator = coordinator {
                coordinatorView(coordinator)
            } else {
                ProgressView("Loading...")
            }
        }
        .task {
            // Initialize coordinator from DI container
            if coordinator == nil {
                coordinator = DIContainer.shared.resolve(AppCoordinator.self)
                coordinator?.start()
            }
        }
    }
    
    /// Returns the appropriate view based on coordinator state
    @ViewBuilder
    private func coordinatorView(_ coordinator: AppCoordinator) -> some View {
        if let onboardingCoordinator = coordinator.activeCoordinator as? OnboardingCoordinator {
            // Show onboarding flow
            OnboardingCoordinatorView(coordinator: onboardingCoordinator)
        } else {
            // Show main app with hierarchical navigation
            MainAppNavigationView(coordinator: coordinator)
        }
    }
}

/// Separate view to allow @Bindable wrapper (ADR-0012: Single NavigationStack)
private struct MainAppNavigationView: View {
    @Bindable var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            AppHomeView(
                onNavigateToServices: {
                    coordinator.navigate(to: .services)
                },
                onNavigateToSettings: {
                    coordinator.navigate(to: .settingsMain)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.view(for: route)
                    .withHomeButton {
                        coordinator.popToRoot()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
