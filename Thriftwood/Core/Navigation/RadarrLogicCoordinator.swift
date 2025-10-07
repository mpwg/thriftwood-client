//
//  RadarrLogicCoordinator.swift
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

/// Logic coordinator for Radarr feature (ADR-0012: Simple MVVM)
///
/// **Role**: Business logic, service coordination, and view model management for Radarr
/// **Navigation**: Handled by AppCoordinator (single NavigationStack pattern)
///
/// This coordinator manages:
/// - Radarr service interactions
/// - ViewModel lifecycle and caching
/// - Business logic for movies, queue, history, etc.
///
/// **It does NOT manage navigation** - that's handled by AppCoordinator with unified AppRoute enum.
@MainActor
@Observable
final class RadarrLogicCoordinator {
    // MARK: - Dependencies
    
    internal let radarrService: any RadarrServiceProtocol  // Internal for view access
    internal let dataService: any DataServiceProtocol  // Internal for view access
    
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
            coordinator: "RadarrLogicCoordinator",
            details: "Movie management logic coordinator initialized (no navigation path)"
        )
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
    
    // MARK: - Business Logic
    
    /// Called when settings are saved - refreshes data
    func handleSettingsSaved() {
        AppLogger.navigation.info("RadarrLogicCoordinator: Settings saved, refreshing data")
        // Refresh movies list if it exists
        Task {
            await moviesListViewModel?.loadMovies()
        }
    }
}
