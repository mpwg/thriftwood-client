//
//  MoviesListViewModel.swift
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
import Observation
import RadarrAPI

/// Filter options for movies list
enum MovieFilter {
    case all
    case monitored
    case unmonitored
    case missing
    case downloaded
}

/// Sort options for movies list
enum MovieSort {
    case title
    case dateAdded
    case releaseDate
    case rating
}

/// ViewModel for managing movies list display and interactions
@MainActor
@Observable
final class MoviesListViewModel {
    // MARK: - Dependencies

    private let radarrService: any RadarrServiceProtocol

    // MARK: - Published Properties

    var movies: [MovieResource] = []
    var isLoading = false
    var error: ThriftwoodError?
    var filterOption: MovieFilter = .all
    var sortOption: MovieSort = .title

    // MARK: - Initialization

    init(radarrService: any RadarrServiceProtocol) {
        self.radarrService = radarrService
    }

    // MARK: - Public Methods

    /// Load all movies from the service
    func loadMovies() async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            let allMovies = try await radarrService.getMovies()
            movies = filterAndSort(allMovies)
        } catch let error as ThriftwoodError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
    }

    /// Refresh movies list
    func refreshMovies() async {
        await loadMovies()
    }

    /// Delete a movie
    /// - Parameters:
    ///   - movie: The movie to delete
    ///   - deleteFiles: Whether to delete associated files
    func deleteMovie(_ movie: MovieResource, deleteFiles: Bool = false) async {
        guard let movieId = movie.id else {
            error = .validation(message: "Movie ID is missing")
            return
        }

        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            try await radarrService.deleteMovie(id: movieId, deleteFiles: deleteFiles)
            // Remove from local list
            movies.removeAll { $0.id == movieId }
        } catch let error as ThriftwoodError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
    }

    /// Apply filter and sorting to movies
    func applyFilterAndSort() {
        movies = filterAndSort(movies)
    }

    // MARK: - Private Methods

    private func filterAndSort(_ moviesList: [MovieResource]) -> [MovieResource] {
        var filtered = filterMovies(moviesList)
        filtered = sortMovies(filtered)
        return filtered
    }

    private func filterMovies(_ moviesList: [MovieResource]) -> [MovieResource] {
        switch filterOption {
        case .all:
            return moviesList
        case .monitored:
            return moviesList.filter { $0.monitored == true }
        case .unmonitored:
            return moviesList.filter { $0.monitored == false }
        case .missing:
            return moviesList.filter { $0.hasFile == false }
        case .downloaded:
            return moviesList.filter { $0.hasFile == true }
        }
    }

    private func sortMovies(_ moviesList: [MovieResource]) -> [MovieResource] {
        switch sortOption {
        case .title:
            return moviesList.sorted { ($0.title ?? "") < ($1.title ?? "") }
        case .dateAdded:
            return moviesList.sorted {
                ($0.added ?? Date.distantPast) > ($1.added ?? Date.distantPast)
            }
        case .releaseDate:
            return moviesList.sorted {
                ($0.physicalRelease ?? Date.distantPast) >
                    ($1.physicalRelease ?? Date.distantPast)
            }
        case .rating:
            return moviesList.sorted {
                let rating1 = $0.ratings?.tmdb?.value ?? 0
                let rating2 = $1.ratings?.tmdb?.value ?? 0
                return rating1 > rating2
            }
        }
    }
}
