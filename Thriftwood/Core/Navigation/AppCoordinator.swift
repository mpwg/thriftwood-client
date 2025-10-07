//
//  AppCoordinator.swift
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
//  Created on 2025-10-04.
//  Root coordinator for the entire application
//

import Foundation
import SwiftUI

/// Root coordinator that manages the top-level navigation flow.
/// This is equivalent to the MainCoordinator in the Hacking with Swift tutorial,
/// but adapted for SwiftUI's NavigationStack pattern.
@Observable
@MainActor
final class AppCoordinator: @MainActor CoordinatorProtocol {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [AppRoute] = []
    
    // MARK: - Properties
    
    /// User preferences service for configuration
    private let preferencesService: any UserPreferencesServiceProtocol
    
    /// Profile service for checking if profiles exist
    private let profileService: any ProfileServiceProtocol
    
    /// Radarr logic coordinator for business logic (ADR-0012)
    private let radarrLogicCoordinator: RadarrLogicCoordinator
    
    /// Settings logic coordinator for business logic (ADR-0012)
    private let settingsLogicCoordinator: SettingsLogicCoordinator
    
    /// Whether the user has completed onboarding
    private var hasCompletedOnboarding: Bool {
        // Check both UserDefaults flag AND if at least one profile exists
        let hasFlag = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if !hasFlag {
            return false
        }
        
        // Verify at least one profile exists
        do {
            let profiles = try profileService.fetchProfiles()
            return !profiles.isEmpty
        } catch {
            AppLogger.navigation.error("Failed to check profiles during onboarding check: \(error.localizedDescription)")
            return false
        }
    }
    
    /// The current active child coordinator (tab coordinator or onboarding)
    private(set) var activeCoordinator: (any CoordinatorProtocol)?
    
    // MARK: - Initialization
    
    init(
        preferencesService: any UserPreferencesServiceProtocol,
        profileService: any ProfileServiceProtocol,
        radarrLogicCoordinator: RadarrLogicCoordinator,
        settingsLogicCoordinator: SettingsLogicCoordinator
    ) {
        self.preferencesService = preferencesService
        self.profileService = profileService
        self.radarrLogicCoordinator = radarrLogicCoordinator
        self.settingsLogicCoordinator = settingsLogicCoordinator
        
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "AppCoordinator",
            details: "Root coordinator initialized with logic coordinators (ADR-0012)"
        )
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.logCoordinator(
            event: "start",
            coordinator: "AppCoordinator",
            details: "Determining initial flow (onboarding vs main app)"
        )
        
        if hasCompletedOnboarding {
            AppLogger.navigation.info("✅ User has completed onboarding, showing main app")
            showMainApp()
        } else {
            AppLogger.navigation.info("🆕 First-time user detected, showing onboarding")
            showOnboarding()
        }
    }
    
    // MARK: - Navigation Methods
    
    /// Unified navigation method for all routes (ADR-0012)
    /// - Parameter route: The AppRoute to navigate to
    func navigate(to route: AppRoute) {
        AppLogger.navigation.logNavigation(
            from: navigationPath.last.map { String(describing: $0) } ?? "Root",
            to: String(describing: route),
            coordinator: "AppCoordinator"
        )
        
        navigationPath.append(route)
        
        AppLogger.navigation.logStackChange(
            action: "push",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: String(describing: route)
        )
    }
    
    /// Navigates back one level in the stack
    func navigateBack() {
        guard !navigationPath.isEmpty else {
            AppLogger.navigation.warning("Attempted to navigate back from root")
            return
        }
        
        let previous = navigationPath.last
        navigationPath.removeLast()
        
        AppLogger.navigation.logNavigation(
            from: previous.map { String(describing: $0) } ?? "Unknown",
            to: navigationPath.last.map { String(describing: $0) } ?? "Root",
            coordinator: "AppCoordinator"
        )
        
        AppLogger.navigation.logStackChange(
            action: "pop",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: navigationPath.last.map { String(describing: $0) } ?? "root"
        )
    }
    
    /// Pops to root (App Home)
    func popToRoot() {
        AppLogger.navigation.logNavigation(
            from: "Current",
            to: "AppHome (root)",
            coordinator: "AppCoordinator"
        )
        
        navigationPath.removeAll()
        
        AppLogger.navigation.logStackChange(
            action: "pop_to_root",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "root"
        )
    }
    
    // MARK: - Legacy Navigation Methods (Deprecated - Use navigate(to:) instead)
    
    /// Shows the onboarding flow for first-time users
    func showOnboarding() {
        AppLogger.navigation.logNavigation(
            from: "Root",
            to: "Onboarding",
            coordinator: "AppCoordinator"
        )
        
        // Create and start onboarding coordinator
        let onboardingCoordinator = OnboardingCoordinator()
        onboardingCoordinator.parent = self
        onboardingCoordinator.onComplete = { [weak self] in
            self?.onboardingDidComplete()
        }
        
        childCoordinators.append(onboardingCoordinator)
        activeCoordinator = onboardingCoordinator
        
        AppLogger.navigation.logCoordinator(
            event: "add_child",
            coordinator: "OnboardingCoordinator",
            details: "Added to AppCoordinator, total children: \(childCoordinators.count)"
        )
        
        onboardingCoordinator.start()
        
        navigationPath = [.onboarding]
        
        AppLogger.navigation.logStackChange(
            action: "set",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "onboarding"
        )
    }
    
    /// Shows the main app interface with hierarchical navigation
    func showMainApp() {
        AppLogger.navigation.logNavigation(
            from: activeCoordinator != nil ? "Onboarding" : "Root",
            to: "MainApp",
            coordinator: "AppCoordinator"
        )
        
        // Clear navigation path - main app starts at root (AppHomeView)
        navigationPath = []
        
        AppLogger.navigation.logStackChange(
            action: "clear",
            coordinator: "AppCoordinator",
            stackSize: navigationPath.count,
            route: "root"
        )
    }
    
    // MARK: - View Factory
    
    /// Creates the appropriate view for a given route (ADR-0012: Single NavigationStack)
    /// This is the central view resolution for the entire app.
    @MainActor
    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        // MARK: - App Level Routes
        case .onboarding:
            // Onboarding is handled via activeCoordinator, not navigation stack
            EmptyView()
            
        case .services:
            ServicesHomeView(
                onNavigateToRadarr: {
                    self.navigate(to: .radarrHome)
                }
            )
            .navigationTitle("Services")
            
        // MARK: - Radarr Routes
        case .radarrHome:
            RadarrHomeView(
                onNavigateToMovies: {
                    self.navigate(to: .radarrMoviesList)
                },
                onNavigateToAddMovie: {
                    self.navigate(to: .radarrAddMovie())
                },
                onNavigateToQueue: {
                    self.navigate(to: .radarrQueue)
                },
                onNavigateToHistory: {
                    self.navigate(to: .radarrHistory)
                },
                onNavigateToSystemStatus: {
                    self.navigate(to: .radarrSystemStatus)
                }
            )
            .navigationTitle("Radarr")
            
        case .radarrMoviesList:
            MoviesListView(
                onMovieSelected: { movieId in
                    self.navigate(to: .radarrMovieDetail(movieId: movieId))
                },
                onAddMovie: {
                    self.navigate(to: .radarrAddMovie())
                }
            )
            .environment(radarrLogicCoordinator.getMoviesListViewModel())
            .navigationTitle("Movies")
            
        case .radarrMovieDetail(let movieId):
            MovieDetailView(
                onEdit: { movieId in
                    // TODO: Implement movie editing
                    self.navigateBack()
                },
                onDeleted: {
                    self.navigateBack()
                }
            )
            .environment(radarrLogicCoordinator.getMovieDetailViewModel(movieId: movieId))
            .navigationTitle("Movie Details")
            
        case .radarrAddMovie:
            AddMovieView(
                viewModel: radarrLogicCoordinator.getAddMovieViewModel(),
                onMovieAdded: { movieId in
                    self.navigate(to: .radarrMovieDetail(movieId: movieId))
                }
            )
            .navigationTitle("Add Movie")
            
        case .radarrSettings:
            Text("Radarr Settings")
                .navigationTitle("Radarr Settings")
            
        case .radarrSystemStatus:
            Text("System Status")
                .navigationTitle("System Status")
            
        case .radarrQueue:
            Text("Queue")
                .navigationTitle("Queue")
            
        case .radarrHistory:
            Text("History")
                .navigationTitle("History")
            
        // MARK: - Settings Routes
        case .settingsMain:
            SettingsView(
                onNavigateToProfiles: {
                    self.navigate(to: .settingsProfiles)
                },
                onNavigateToAppearance: {
                    self.navigate(to: .settingsAppearance)
                },
                onNavigateToGeneral: {
                    self.navigate(to: .settingsMain)  // TODO: Create settingsGeneral route if needed
                },
                onNavigateToNetworking: {
                    self.navigate(to: .settingsNotifications)
                },
                onNavigateToAbout: {
                    self.navigate(to: .settingsAbout)
                },
                onNavigateToAcknowledgements: {
                    self.navigate(to: .settingsLogs)
                }
            )
            .navigationTitle("Settings")
            
        case .settingsProfiles:
            Text("Profiles Management")
                .navigationTitle("Profiles")
            
        case .settingsAddProfile:
            Text("Add Profile")
                .navigationTitle("Add Profile")
            
        case .settingsEditProfile(let profileId):
            Text("Edit Profile: \(profileId)")
                .navigationTitle("Edit Profile")
            
        case .settingsAppearance:
            Text("Appearance Settings")
                .navigationTitle("Appearance")
            
        case .settingsNotifications:
            Text("Notifications Settings")
                .navigationTitle("Notifications")
            
        case .settingsAbout:
            Text("About Thriftwood")
                .navigationTitle("About")
            
        case .settingsLogs:
            Text("Logs")
                .navigationTitle("Logs")
        }
    }
    
    // MARK: - Coordinator Lifecycle
    
    /// Called when onboarding is completed
    private func onboardingDidComplete() {
        AppLogger.navigation.logCoordinator(
            event: "callback",
            coordinator: "OnboardingCoordinator",
            details: "onComplete callback triggered"
        )
        
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        AppLogger.navigation.info("💾 Saved onboarding completion flag to UserDefaults")
        
        // Remove onboarding coordinator
        if let onboardingCoordinator = activeCoordinator {
            AppLogger.navigation.logCoordinator(
                event: "finish",
                coordinator: "OnboardingCoordinator",
                details: "Cleaning up onboarding coordinator"
            )
            childDidFinish(onboardingCoordinator)
            activeCoordinator = nil  // Clear active coordinator to trigger view update
        }
        
        // Show main app
        AppLogger.navigation.info("🔄 Transitioning from onboarding to main app")
        showMainApp()
    }
    
    /// Resets the app to show onboarding again (useful for testing)
    func resetOnboarding() {
        AppLogger.navigation.logCoordinator(
            event: "reset",
            coordinator: "AppCoordinator",
            details: "Resetting onboarding state (dev/test feature)"
        )
        
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        // Clear all child coordinators
        let childCount = childCoordinators.count
        childCoordinators.removeAll()
        activeCoordinator = nil
        
        AppLogger.navigation.info("🗑️  Removed \(childCount) child coordinators")
        
        // Restart
        AppLogger.navigation.info("🔄 Restarting AppCoordinator flow")
        start()
    }
}
