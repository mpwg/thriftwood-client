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

/// Separate view to allow @Bindable wrapper
private struct MainAppNavigationView: View {
    @Bindable var coordinator: AppCoordinator
    @State private var radarrCoordinator: RadarrCoordinator?
    @State private var settingsCoordinator: SettingsCoordinator?
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            AppHomeView(
                onNavigateToServices: {
                    coordinator.navigateToServices()
                },
                onNavigateToSettings: {
                    coordinator.navigateToSettings()
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                makeView(for: route)
            }
        }
        .onAppear {
            // Initialize RadarrCoordinator if needed
            if radarrCoordinator == nil {
                let radarrService = DIContainer.shared.resolve((any RadarrServiceProtocol).self)
                let dataService = DIContainer.shared.resolve((any DataServiceProtocol).self)
                radarrCoordinator = RadarrCoordinator(
                    radarrService: radarrService,
                    dataService: dataService
                )
                radarrCoordinator?.start()
            }
            
            // Initialize SettingsCoordinator if needed
            if settingsCoordinator == nil {
                settingsCoordinator = SettingsCoordinator()
                settingsCoordinator?.start()
            }
        }
    }
    
    /// Creates views for app-level routes
    @ViewBuilder
    private func makeView(for route: AppRoute) -> some View {
        switch route {
        case .onboarding:
            // Onboarding is handled via active coordinator, not navigation stack
            EmptyView()
            
        case .services:
            ServicesHomeView(
                onNavigateToRadarr: {
                    AppLogger.navigation.info("Navigating to Radarr")
                    coordinator.navigateToRadarr()
                }
            )
            .navigationTitle("Services")
            .withHomeButton {
                coordinator.popToRoot()
            }
        
        case .radarr:
            if let radarrCoordinator = radarrCoordinator {
                RadarrCoordinatorView(coordinator: radarrCoordinator)
            } else {
                Text("Loading Radarr...")
                    .navigationTitle("Radarr")
                    .withHomeButton {
                        coordinator.popToRoot()
                    }
            }
            
        case .settings:
            if let settingsCoordinator = settingsCoordinator {
                SettingsCoordinatorView(coordinator: settingsCoordinator)
            } else {
                Text("Loading Settings...")
                    .navigationTitle("Settings")
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
