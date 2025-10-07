//
//  RadarrCoordinatorView.swift
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

/// Radarr coordinator view that handles navigation within the Radarr module
struct RadarrCoordinatorView: View {
    @Bindable var coordinator: RadarrCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            // Root view is Radarr home with button navigation
            radarrHomeView()
                .navigationDestination(for: RadarrRoute.self) { route in
                    destination(for: route)
                }
                .logViewLifecycle(view: "RadarrCoordinatorView", metadata: ["coordinator": "RadarrCoordinator"])
        }
    }
    
    // MARK: - Root View
    
    @ViewBuilder
    private func radarrHomeView() -> some View {
        RadarrHomeView(
            onNavigateToMovies: {
                coordinator.showMoviesList()
            },
            onNavigateToAddMovie: {
                coordinator.showAddMovie()
            },
            onNavigateToQueue: {
                coordinator.showQueue()
            },
            onNavigateToHistory: {
                coordinator.showHistory()
            },
            onNavigateToSystemStatus: {
                coordinator.showSystemStatus()
            }
        )
    }
    
    @ViewBuilder
    private func moviesListView() -> some View {
        let viewModel = coordinator.getMoviesListViewModel()
        MoviesListView(
            onMovieSelected: { movieId in
                coordinator.showMovieDetail(movieId: movieId)
            },
            onAddMovie: {
                coordinator.showAddMovie()
            }
        )
        .environment(viewModel)
    }
    
    // MARK: - Destination Views
    
    @ViewBuilder
    private func destination(for route: RadarrRoute) -> some View {
        switch route {
        case .home:
            // .home should not be pushed - it's the root radarrHomeView
            // This case exists only for enum completeness
            EmptyView()
            
        case .moviesList:
            // Movies list is pushed from home
            moviesListView()
            
        case .movieDetail(let movieId):
            let viewModel = coordinator.getMovieDetailViewModel(movieId: movieId)
            MovieDetailView(
                onEdit: { movieId in
                    coordinator.showMovieDetail(movieId: movieId) // TODO [#204]: Navigate to edit when implemented
                },
                onDeleted: {
                    coordinator.pop()
                }
            )
            .environment(viewModel)
            
        case .addMovie(let query):
            let viewModel = coordinator.getAddMovieViewModel()
            AddMovieView(
                viewModel: viewModel,
                onMovieAdded: { movieId in
                    coordinator.pop()
                    coordinator.showMovieDetail(movieId: movieId)
                }
            )
            .task {
                // Pre-populate search if query provided
                if !query.isEmpty {
                    viewModel.searchQuery = query
                    // Trigger search
                    await viewModel.searchMovies()
                }
            }
            
        case .settings:
            // Get enabled profile from coordinator's dataService
            if let profile = try? coordinator.dataService.fetchEnabledProfile() {
                let viewModel = RadarrSettingsViewModel(
                    radarrService: coordinator.radarrService,
                    dataService: coordinator.dataService
                )
                
                RadarrSettingsView(
                    viewModel: viewModel,
                    profile: profile,
                    onSave: {
                        coordinator.pop()
                        coordinator.handleSettingsSaved()
                    }
                )
                .task {
                    await viewModel.loadConfiguration(for: profile)
                }
            } else {
                Text("No active profile")
                    .foregroundColor(.secondary)
            }
            
        case .systemStatus:
            // TODO [#205]: Implement system status view
            placeholderView(title: "System Status", icon: "info.circle")
            
        case .queue:
            // TODO [#205]: Implement queue view
            placeholderView(title: "Queue", icon: "arrow.down.circle")
            
        case .history:
            // TODO [#205]: Implement history view
            placeholderView(title: "History", icon: "clock")
        }
    }
    
    // MARK: - Placeholder
    
    private func placeholderView(title: String, icon: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(title)
                .font(.title)
            Text("Coming soon...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .navigationTitle(title)
    }
}

// MARK: - Preview

#Preview("Radarr Coordinator") {
    let coordinator = RadarrCoordinator(
        radarrService: PreviewRadarrService(),
        dataService: PreviewDataService()
    )
    coordinator.start()
    
    return RadarrCoordinatorView(coordinator: coordinator)
}
