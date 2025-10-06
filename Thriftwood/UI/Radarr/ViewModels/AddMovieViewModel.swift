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
    var searchResults: [MovieResource] = []
    var isSearching = false
    var qualityProfiles: [QualityProfileResource] = []
    var rootFolders: [RootFolderResource] = []
    var selectedQualityProfile: QualityProfileResource?
    var selectedRootFolder: RootFolderResource?
    var monitored = true
    var error: ThriftwoodError?
    var isLoading = false

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
                selectedQualityProfile = firstProfile
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
                selectedRootFolder = firstFolder
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
        guard let qualityProfile = selectedQualityProfile else {
            throw ThriftwoodError.validation(message: "Please select a quality profile")
        }

        guard let rootFolder = selectedRootFolder else {
            throw ThriftwoodError.validation(message: "Please select a root folder")
        }

        isLoading = true
        error = nil
        defer { isLoading = false }

        // Prepare movie for addition
        var movieToAdd = searchResult
        movieToAdd.monitored = monitored
        movieToAdd.qualityProfileId = qualityProfile.id
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

    /// Clear search results and query
    func clearSearch() {
        searchQuery = ""
        searchResults = []
        error = nil
    }

    /// Reset configuration selections
    func resetConfiguration() {
        selectedQualityProfile = qualityProfiles.first
        selectedRootFolder = rootFolders.first
        monitored = true
    }
}
