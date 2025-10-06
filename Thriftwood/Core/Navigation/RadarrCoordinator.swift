//
//  RadarrCoordinator.swift
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

import Foundation
import SwiftUI
import OSLog

/// Coordinator that manages navigation within the Radarr feature.
/// Handles movies list, details, adding movies, and configuration.
@MainActor
@Observable
final class RadarrCoordinator: @MainActor CoordinatorProtocol {
    // MARK: - Coordinator Protocol
    
    var childCoordinators: [any CoordinatorProtocol] = []
    weak var parent: (any CoordinatorProtocol)?
    var navigationPath: [RadarrRoute] = []
    
    // MARK: - Dependencies
    
    internal let radarrService: any RadarrServiceProtocol  // Internal for RadarrCoordinatorView access
    internal let dataService: any DataServiceProtocol  // Internal for RadarrCoordinatorView access
    
    // MARK: - ViewModels (created on demand)
    
    private var moviesListViewModel: MoviesListViewModel?
    private var movieDetailViewModel: MovieDetailViewModel?
    private var addMovieViewModel: AddMovieViewModel?
    
    // MARK: - Initialization
    
    init(
        radarrService: any RadarrServiceProtocol,
        dataService: any DataServiceProtocol
    ) {
        self.radarrService = radarrService
        self.dataService = dataService
        
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "RadarrCoordinator",
            details: "Movie management navigation initialized"
        )
    }
    
    // MARK: - Coordinator Protocol Implementation
    
    func start() {
        AppLogger.navigation.logCoordinator(
            event: "start",
            coordinator: "RadarrCoordinator",
            details: "Starting with movies list"
        )
        
        // Start with empty path - moviesListView is the root
        navigationPath = []
        
        AppLogger.navigation.logStackChange(
            action: "set",
            coordinator: "RadarrCoordinator",
            stackSize: 0,
            route: "moviesList (root)"
        )
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the movies list view
    func showMoviesList() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .moviesList),
            to: "MoviesList",
            coordinator: "RadarrCoordinator"
        )
        navigate(to: .moviesList)
    }
    
    /// Shows movie detail view
    /// - Parameter movieId: The ID of the movie to display
    func showMovieDetail(movieId: Int) {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .moviesList),
            to: "MovieDetail[id:\(movieId)]",
            coordinator: "RadarrCoordinator"
        )
        navigate(to: .movieDetail(movieId: movieId))
    }
    
    /// Shows add movie view
    /// - Parameter query: Optional search query to pre-fill
    func showAddMovie(query: String = "") {
        let queryInfo = query.isEmpty ? "" : " with query: '\(query)'"
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .moviesList),
            to: "AddMovie\(queryInfo)",
            coordinator: "RadarrCoordinator"
        )
        navigate(to: .addMovie(query: query))
    }
    
    /// Shows Radarr settings/configuration
    func showSettings() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .moviesList),
            to: "Settings",
            coordinator: "RadarrCoordinator"
        )
        navigate(to: .settings)
    }
    
    /// Shows system status view
    func showSystemStatus() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .moviesList),
            to: "SystemStatus",
            coordinator: "RadarrCoordinator"
        )
        navigate(to: .systemStatus)
    }
    
    /// Shows queue view
    func showQueue() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .moviesList),
            to: "Queue",
            coordinator: "RadarrCoordinator"
        )
        navigate(to: .queue)
    }
    
    /// Shows history view
    func showHistory() {
        AppLogger.navigation.logNavigation(
            from: String(describing: navigationPath.last ?? .moviesList),
            to: "History",
            coordinator: "RadarrCoordinator"
        )
        navigate(to: .history)
    }
    
    // MARK: - ViewModel Factory
    
    /// Gets or creates MoviesListViewModel
    func getMoviesListViewModel() -> MoviesListViewModel {
        if let existing = moviesListViewModel {
            AppLogger.navigation.debug("Reusing existing MoviesListViewModel")
            return existing
        }
        
        AppLogger.navigation.debug("Creating new MoviesListViewModel")
        let viewModel = MoviesListViewModel(radarrService: radarrService)
        moviesListViewModel = viewModel
        return viewModel
    }
    
    /// Gets or creates MovieDetailViewModel
    func getMovieDetailViewModel(movieId: Int) -> MovieDetailViewModel {
        // Always create new instance for different movies
        if let existing = movieDetailViewModel, existing.movieId == movieId {
            return existing
        }
        
        let viewModel = MovieDetailViewModel(
            movieId: movieId,
            radarrService: radarrService
        )
        movieDetailViewModel = viewModel
        return viewModel
    }
    
    /// Gets or creates AddMovieViewModel
    func getAddMovieViewModel() -> AddMovieViewModel {
        if let existing = addMovieViewModel {
            return existing
        }
        
        let viewModel = AddMovieViewModel(radarrService: radarrService)
        addMovieViewModel = viewModel
        return viewModel
    }
    
    // MARK: - Lifecycle
    
    /// Called when a settings save is completed
    func handleSettingsSaved() {
        AppLogger.navigation.info("Settings saved, refreshing data")
        // Refresh movies list if it exists
        Task {
            await moviesListViewModel?.loadMovies()
        }
    }
}
