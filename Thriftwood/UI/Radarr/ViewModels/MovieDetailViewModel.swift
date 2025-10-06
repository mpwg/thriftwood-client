//
//  MovieDetailViewModel.swift
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

/// ViewModel for managing movie detail display and interactions
@MainActor
@Observable
final class MovieDetailViewModel {
    // MARK: - Dependencies

    private let radarrService: any RadarrServiceProtocol

    // MARK: - Published Properties

    let movieId: Int
    var movie: MovieResource?
    var isLoading = false
    var error: ThriftwoodError?
    
    // MARK: - Private Properties
    
    /// Cached quality profiles for name lookup
    private var qualityProfiles: [Int: String] = [:]
    
    /// Display model for UI consumption
    /// Converts domain model to display model following MVVM-C pattern
    var displayMovie: MovieDisplayModel? {
        guard let movie = movie else { return nil }
        return convertToDisplayModel(movie)
    }

    // MARK: - Initialization

    init(movieId: Int, radarrService: any RadarrServiceProtocol) {
        self.movieId = movieId
        self.radarrService = radarrService
    }

    // MARK: - Public Methods

    /// Load movie details from the service
    func loadMovie() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        // Load quality profiles first for name lookup
        await loadQualityProfiles()

        do {
            movie = try await radarrService.getMovie(id: movieId)
        } catch let error as ThriftwoodError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
    }

    /// Toggle the monitored state of the movie
    func toggleMonitored() async {
        guard var updatedMovie = movie else {
            error = .validation(message: "No movie loaded")
            return
        }

        isLoading = true
        error = nil
        defer { isLoading = false }

        // Store original state for rollback
        let originalMonitoredState = updatedMovie.monitored ?? false

        // Toggle monitored state
        updatedMovie.monitored = !originalMonitoredState

        do {
            movie = try await radarrService.updateMovie(updatedMovie)
        } catch let error as ThriftwoodError {
            self.error = error
            // Revert to original state on error
            if var revertedMovie = movie {
                revertedMovie.monitored = originalMonitoredState
                movie = revertedMovie
            }
        } catch {
            self.error = .unknown(error)
            // Revert to original state on error
            if var revertedMovie = movie {
                revertedMovie.monitored = originalMonitoredState
                movie = revertedMovie
            }
        }
    }

    /// Refresh movie details
    func refreshMovie() async {
        await loadMovie()
    }

    /// Delete the movie
    /// - Parameter deleteFiles: Whether to delete associated files
    /// - Returns: True if deletion was successful
    func deleteMovie(deleteFiles: Bool = false) async -> Bool {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            try await radarrService.deleteMovie(id: movieId, deleteFiles: deleteFiles)
            return true
        } catch let error as ThriftwoodError {
            self.error = error
            return false
        } catch {
            self.error = .unknown(error)
            return false
        }
    }
    
    // MARK: - Private Methods
    
    /// Convert domain model to display model
    /// This keeps the View layer isolated from RadarrAPI domain models
    private func convertToDisplayModel(_ resource: MovieResource) -> MovieDisplayModel {
        let posterURLString = resource.images?.first(where: { $0.coverType == .poster })?.remoteUrl
        let backdropURLString = resource.images?.first(where: { $0.coverType == .fanart })?.remoteUrl
        
        let posterURL = posterURLString.flatMap { URL(string: $0) }
        let backdropURL = backdropURLString.flatMap { URL(string: $0) }
        
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
            rating: resource.ratings?.tmdb?.value,
            certification: resource.certification,
            genres: resource.genres?.compactMap { $0 } ?? [],
            studio: resource.studio,
            dateAdded: resource.added
        )
    }
    
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
