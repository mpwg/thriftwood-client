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

    var movies: [MovieDisplayModel] = []
    var isLoading = false
    var error: ThriftwoodError?
    var filterOption: MovieFilter = .all
    var sortOption: MovieSort = .title
    
    // MARK: - Private Properties
    
    /// Cached quality profiles for name lookup
    private var qualityProfiles: [Int: String] = [:]

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
        
        // Load quality profiles first for name lookup
        await loadQualityProfiles()

        do {
            let allMovies = try await radarrService.getMovies()
            movies = allMovies.map { convertToDisplayModel($0) }
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
    func deleteMovie(_ movie: MovieDisplayModel, deleteFiles: Bool = false) async {
        let movieId = movie.id

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
        // Re-apply filter and sort to existing movies array
        let allMovies = movies
        movies = filterAndSort(allMovies)
    }

    // MARK: - Private Methods

    private func filterAndSort(_ moviesList: [MovieDisplayModel]) -> [MovieDisplayModel] {
        var filtered = filterMovies(moviesList)
        filtered = sortMovies(filtered)
        return filtered
    }

    private func filterMovies(_ moviesList: [MovieDisplayModel]) -> [MovieDisplayModel] {
        switch filterOption {
        case .all:
            return moviesList
        case .monitored:
            return moviesList.filter { $0.monitored }
        case .unmonitored:
            return moviesList.filter { !$0.monitored }
        case .missing:
            return moviesList.filter { !$0.hasFile }
        case .downloaded:
            return moviesList.filter { $0.hasFile }
        }
    }

    private func sortMovies(_ moviesList: [MovieDisplayModel]) -> [MovieDisplayModel] {
        switch sortOption {
        case .title:
            return moviesList.sorted { $0.title < $1.title }
        case .dateAdded:
            // Note: MovieDisplayModel doesn't have dateAdded yet, using title as fallback
            return moviesList.sorted { $0.title < $1.title }
        case .releaseDate:
            return moviesList.sorted {
                guard let year1 = $0.year, let year2 = $1.year else { return false }
                return year1 > year2
            }
        case .rating:
            return moviesList.sorted {
                guard let rating1 = $0.rating, let rating2 = $1.rating else { return false }
                return rating1 > rating2
            }
        }
    }
    
    /// Convert MovieResource (domain model) to MovieDisplayModel (UI model)
    private func convertToDisplayModel(_ resource: MovieResource) -> MovieDisplayModel {
        // Extract poster URL from images array
        let posterURL: URL? = {
            guard let images = resource.images else { return nil }
            let posterImage = images.first { $0.coverType == .poster }
            if let urlString = posterImage?.url ?? posterImage?.remoteUrl {
                return URL(string: urlString)
            }
            return nil
        }()
        
        // Extract backdrop URL from images array
        let backdropURL: URL? = {
            guard let images = resource.images else { return nil }
            let backdropImage = images.first { $0.coverType == .fanart }
            if let urlString = backdropImage?.url ?? backdropImage?.remoteUrl {
                return URL(string: urlString)
            }
            return nil
        }()
        
        return MovieDisplayModel(
            id: resource.id ?? 0,
            title: resource.title ?? "Unknown",
            year: resource.year,
            overview: resource.overview,
            runtime: resource.runtime,
            posterURL: posterURL,
            backdropURL: backdropURL,
            monitored: resource.monitored ?? false,
            hasFile: resource.hasFile ?? false,
            qualityProfileId: resource.qualityProfileId,
            qualityProfileName: lookupQualityProfileName(resource.qualityProfileId),
            rating: resource.ratings?.imdb?.value,
            certification: resource.certification,
            genres: resource.genres?.compactMap { $0 } ?? [],
            studio: resource.studio
        )
    }
    
    // MARK: - Private Methods
    
    /// Load quality profiles for name lookup
    private func loadQualityProfiles() async {
        do {
            let profiles = try await radarrService.getQualityProfiles()
            qualityProfiles = Dictionary(uniqueKeysWithValues: profiles.compactMap { profile in
                guard let id = profile.id, let name = profile.name else { return nil }
                return (id, name)
            })
        } catch {
            // Log error but don't fail the whole load - quality profile names are nice-to-have
            AppLogger.networking.warning("Failed to load quality profiles: \(error.localizedDescription)")
        }
    }
    
    /// Look up quality profile name by ID
    private func lookupQualityProfileName(_ profileId: Int?) -> String? {
        guard let profileId = profileId else { return nil }
        return qualityProfiles[profileId]
    }
}
