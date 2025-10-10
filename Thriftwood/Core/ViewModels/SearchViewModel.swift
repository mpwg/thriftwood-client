//
//  SearchViewModel.swift
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

// MARK: - Search Result Model

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let year: String?
    let overview: String?
    let posterURL: String?
    let mediaType: MediaType
    let externalId: String // TMDB ID, TVDB ID, etc.
    let isAvailable: Bool // Already in library
    
    enum MediaType: String, CaseIterable, Identifiable {
        case movie = "Movie"
        case tvShow = "TV Show"
        case music = "Music"
        
        var id: String { rawValue }
        
        var systemIcon: String {
            switch self {
            case .movie: return SystemIcon.movies
            case .tvShow: return SystemIcon.tv
            case .music: return SystemIcon.music
            }
        }
    }
}

// MARK: - Search Filter Options

enum SearchFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case movies = "Movies"
    case tvShows = "TV Shows"
    case music = "Music"
    
    var id: String { rawValue }
    
    var mediaType: SearchResult.MediaType? {
        switch self {
        case .all: return nil
        case .movies: return .movie
        case .tvShows: return .tvShow
        case .music: return .music
        }
    }
}

// MARK: - SearchViewModel

@MainActor
@Observable
final class SearchViewModel: BaseViewModelImpl {
    
    // MARK: - Published Properties
    
    /// Current search query
    var searchQuery: String = ""
    
    /// Search results
    private(set) var searchResults: [SearchResult] = []
    
    /// Filtered search results based on current filter
    var filteredResults: [SearchResult] {
        guard let mediaType = currentFilter.mediaType else {
            return searchResults
        }
        return searchResults.filter { $0.mediaType == mediaType }
    }
    
    /// Current search filter
    var currentFilter: SearchFilter = .all
    
    /// Whether a search is currently in progress
    var isSearching: Bool = false
    
    /// Whether there are no results for the current search
    var hasNoResults: Bool {
        !searchQuery.isEmpty && !isSearching && filteredResults.isEmpty
    }
    
    /// Whether to show the empty state (no search performed yet)
    var showEmptyState: Bool {
        searchQuery.isEmpty && searchResults.isEmpty
    }
    
    // MARK: - Dependencies
    
    // TODO: Add SearchService when implemented
    // private let searchService: any SearchServiceProtocol
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
    
    // MARK: - BaseViewModel Implementation
    
    override func load() async {
        // No initial loading needed for search
    }
    
    // MARK: - Public Methods
    
    /// Perform search with current query
    func search() async {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            clearResults()
            return
        }
        
        isSearching = true
        
        await safeAsyncVoid {
            // TODO: Replace with actual search service call
            // self.searchResults = try await searchService.search(query: query)
            
            // For now, use mock data
            self.searchResults = self.generateMockResults(for: query)
            
            // Simulate network delay
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        }
        
        isSearching = false
    }
    
    /// Clear search results and query
    func clearSearch() {
        searchQuery = ""
        clearResults()
    }
    
    /// Clear search results only
    func clearResults() {
        searchResults = []
    }
    
    /// Update search filter
    func setFilter(_ filter: SearchFilter) {
        currentFilter = filter
    }
    
    /// Add item to appropriate service (Radarr, Sonarr, etc.)
    func addToLibrary(_ result: SearchResult) async {
        await safeAsyncVoid {
            switch result.mediaType {
            case .movie:
                // TODO: Add to Radarr
                // try await radarrService.addMovie(tmdbId: result.externalId)
                break
            case .tvShow:
                // TODO: Add to Sonarr
                // try await sonarrService.addSeries(tvdbId: result.externalId)
                break
            case .music:
                // TODO: Add to Lidarr
                // try await lidarrService.addArtist(musicBrainzId: result.externalId)
                break
            }
            
            // Update result to mark as available
            if let index = self.searchResults.firstIndex(where: { $0.id == result.id }) {
                let updatedResult = SearchResult(
                    title: result.title,
                    year: result.year,
                    overview: result.overview,
                    posterURL: result.posterURL,
                    mediaType: result.mediaType,
                    externalId: result.externalId,
                    isAvailable: true
                )
                self.searchResults[index] = updatedResult
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func generateMockResults(for query: String) -> [SearchResult] {
        // Generate mock search results for demonstration
        return [
            SearchResult(
                title: "\(query) Movie Result",
                year: "2023",
                overview: "A mock movie result for demonstration purposes.",
                posterURL: nil,
                mediaType: .movie,
                externalId: "12345",
                isAvailable: false
            ),
            SearchResult(
                title: "\(query) TV Show Result",
                year: "2022",
                overview: "A mock TV show result for demonstration purposes.",
                posterURL: nil,
                mediaType: .tvShow,
                externalId: "67890",
                isAvailable: true
            ),
            SearchResult(
                title: "\(query) Music Result",
                year: "2021",
                overview: "A mock music result for demonstration purposes.",
                posterURL: nil,
                mediaType: .music,
                externalId: "abcde",
                isAvailable: false
            )
        ].filter { !$0.title.isEmpty }
    }
}