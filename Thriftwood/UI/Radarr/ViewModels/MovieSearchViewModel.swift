//
//  MovieSearchViewModel.swift
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

/// ViewModel for quick movie search with debouncing
@MainActor
@Observable
final class MovieSearchViewModel {
    // MARK: - Dependencies

    private let radarrService: any RadarrServiceProtocol

    // MARK: - Published Properties

    var searchQuery = "" {
        didSet {
            scheduleSearch()
        }
    }
    var searchResults: [MovieResource] = []
    var isSearching = false
    var error: ThriftwoodError?

    // MARK: - Private Properties

    private var searchTask: Task<Void, Never>?
    private let debounceInterval: TimeInterval = 0.3 // 300ms

    // MARK: - Initialization

    init(radarrService: any RadarrServiceProtocol) {
        self.radarrService = radarrService
    }

    // MARK: - Public Methods

    /// Perform search with the current query
    func search(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        error = nil
        defer { isSearching = false }

        do {
            searchResults = try await radarrService.searchMovies(query: query)
        } catch let error as ThriftwoodError {
            self.error = error
            searchResults = []
        } catch {
            self.error = .unknown(error)
            searchResults = []
        }
    }

    /// Clear search results and query
    func clearSearch() {
        searchQuery = ""
        searchResults = []
        error = nil
        searchTask?.cancel()
        searchTask = nil
    }

    // MARK: - Private Methods

    /// Schedule a debounced search
    private func scheduleSearch() {
        // Cancel any existing search task
        searchTask?.cancel()

        // If query is empty, clear results immediately
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        // Schedule new search after debounce interval
        searchTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(debounceInterval * 1_000_000_000))

            // Check if task was cancelled
            guard !Task.isCancelled else { return }

            // Perform search
            await search(query: searchQuery)
        }
    }
}
