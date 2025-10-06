//
//  AddMovieViewModel.swift
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

/// ViewModel for adding new movies to Radarr
@MainActor
@Observable
final class AddMovieViewModel {
    // MARK: - Dependencies

    private let radarrService: any RadarrServiceProtocol

    // MARK: - Published Properties

    var searchQuery = ""
    private var searchResults: [MovieResource] = []
    var isSearching = false
    private var qualityProfiles: [QualityProfileResource] = []
    private var rootFolders: [RootFolderResource] = []
    var selectedQualityProfile: Int?
    var selectedRootFolder: Int?
    var monitored = true
    var error: ThriftwoodError?
    var isLoading = false
    
    /// Display models for search results
    /// Exposed to Views to avoid importing RadarrAPI
    var displayResults: [MovieDisplayModel] {
        searchResults.map { convertToDisplayModel($0) }
    }
    
    /// Quality profile names for picker
    var qualityProfileNames: [(id: Int, name: String)] {
        qualityProfiles.compactMap { profile in
            guard let id = profile.id else { return nil }
            return (id, profile.name ?? "Unknown")
        }
    }
    
    /// Root folder paths for picker
    var rootFolderPaths: [(id: Int, path: String)] {
        rootFolders.compactMap { folder in
            guard let id = folder.id else { return nil }
            return (id, folder.path ?? "Unknown")
        }
    }

    // MARK: - Initialization

    init(radarrService: any RadarrServiceProtocol) {
        self.radarrService = radarrService
    }

    // MARK: - Public Methods

    /// Search for movies by query
    func searchMovies() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        error = nil
        defer { isSearching = false }

        do {
            searchResults = try await radarrService.searchMovies(query: searchQuery)
        } catch let error as ThriftwoodError {
            self.error = error
            searchResults = []
        } catch {
            self.error = .unknown(error)
            searchResults = []
        }
    }

    /// Load available quality profiles
    func loadQualityProfiles() async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            qualityProfiles = try await radarrService.getQualityProfiles()
            // Auto-select first profile if none selected
            if selectedQualityProfile == nil, let firstProfile = qualityProfiles.first {
                selectedQualityProfile = firstProfile.id
            }
        } catch let error as ThriftwoodError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
    }

    /// Load available root folders
    func loadRootFolders() async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            rootFolders = try await radarrService.getRootFolders()
            // Auto-select first folder if none selected
            if selectedRootFolder == nil, let firstFolder = rootFolders.first {
                selectedRootFolder = firstFolder.id
            }
        } catch let error as ThriftwoodError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
    }

    /// Load both quality profiles and root folders
    func loadConfiguration() async {
        await loadQualityProfiles()
        await loadRootFolders()
    }

    /// Add a movie to Radarr
    /// - Parameter searchResult: The movie search result to add
    /// - Throws: ThriftwoodError if validation fails or service call fails
    func addMovie(_ searchResult: MovieResource) async throws {
        // Validate configuration
        guard let qualityProfileId = selectedQualityProfile else {
            throw ThriftwoodError.validation(message: "Please select a quality profile")
        }

        guard let rootFolderId = selectedRootFolder,
              let rootFolder = rootFolders.first(where: { $0.id == rootFolderId }) else {
            throw ThriftwoodError.validation(message: "Please select a root folder")
        }

        isLoading = true
        error = nil
        defer { isLoading = false }

        // Prepare movie for addition
        var movieToAdd = searchResult
        movieToAdd.monitored = monitored
        movieToAdd.qualityProfileId = qualityProfileId
        movieToAdd.rootFolderPath = rootFolder.path

        do {
            _ = try await radarrService.addMovie(movieToAdd)
        } catch let error as ThriftwoodError {
            self.error = error
            throw error
        } catch {
            let wrappedError = ThriftwoodError.unknown(error)
            self.error = wrappedError
            throw wrappedError
        }
    }
    
    /// Add a movie to Radarr by ID
    /// Used by Views to avoid importing RadarrAPI types
    /// - Parameter movieId: The movie ID to add
    /// - Throws: ThriftwoodError if validation fails or service call fails
    func addMovieById(_ movieId: Int) async throws {
        guard let searchResult = searchResults.first(where: { $0.id == movieId }) else {
            throw ThriftwoodError.validation(message: "Movie not found in search results")
        }
        try await addMovie(searchResult)
    }

    /// Clear search results and query
    func clearSearch() {
        searchQuery = ""
        searchResults = []
        error = nil
    }

    /// Reset configuration selections
    func resetConfiguration() {
        selectedQualityProfile = qualityProfiles.first?.id
        selectedRootFolder = rootFolders.first?.id
        monitored = true
    }
    
    // MARK: - Private Methods
    
    /// Convert domain model to display model
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
            qualityProfileName: nil,
            rating: resource.ratings?.tmdb?.value,
            certification: resource.certification,
            genres: resource.genres?.compactMap { $0 } ?? [],
            studio: resource.studio,
            dateAdded: resource.added
        )
    }
}
