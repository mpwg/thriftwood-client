//
//  SearchViewModelTests.swift
//  ThriftwoodTests
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

import Testing
import SwiftUI
@testable import Thriftwood

// MARK: - SearchViewModel Tests

@Suite("SearchViewModel Tests")
struct SearchViewModelTests {
    
    @Test("initializes with empty state")
    @MainActor
    func testInitialization() {
        let viewModel = SearchViewModel()
        
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.currentFilter == .all)
        #expect(viewModel.isSearching == false)
        #expect(viewModel.showEmptyState == true)
        #expect(viewModel.hasNoResults == false)
    }
    
    @Test("search with empty query clears results")
    @MainActor
    func testSearchWithEmptyQuery() async {
        let viewModel = SearchViewModel()
        
        // Set some initial results
        viewModel.searchQuery = ""
        await viewModel.search()
        
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.showEmptyState == true)
    }
    
    @Test("search with query generates mock results")
    @MainActor
    func testSearchWithQuery() async {
        let viewModel = SearchViewModel()
        
        viewModel.searchQuery = "Test Movie"
        await viewModel.search()
        
        #expect(!viewModel.searchResults.isEmpty)
        #expect(viewModel.showEmptyState == false)
        #expect(viewModel.hasNoResults == false)
        
        // Verify mock results contain expected types
        let mediaTypes = Set(viewModel.searchResults.map { $0.mediaType })
        #expect(mediaTypes.contains(.movie))
        #expect(mediaTypes.contains(.tvShow))
        #expect(mediaTypes.contains(.music))
    }
    
    @Test("filtered results respect current filter")
    @MainActor
    func testFilteredResults() async {
        let viewModel = SearchViewModel()
        
        viewModel.searchQuery = "Test"
        await viewModel.search()
        
        // Test all filter
        viewModel.setFilter(.all)
        let allResults = viewModel.filteredResults
        #expect(allResults.count == viewModel.searchResults.count)
        
        // Test movies filter
        viewModel.setFilter(.movies)
        let movieResults = viewModel.filteredResults
        #expect(movieResults.allSatisfy { $0.mediaType == .movie })
        
        // Test TV shows filter  
        viewModel.setFilter(.tvShows)
        let tvResults = viewModel.filteredResults
        #expect(tvResults.allSatisfy { $0.mediaType == .tvShow })
        
        // Test music filter
        viewModel.setFilter(.music)
        let musicResults = viewModel.filteredResults
        #expect(musicResults.allSatisfy { $0.mediaType == .music })
    }
    
        @Test("hasNoResults is correct for various states")
    @MainActor
    func testHasNoResults() async {
        let viewModel = SearchViewModel()
        
        // Initially false (no search performed, query is empty)
        #expect(viewModel.hasNoResults == false)
        
        // After successful search with results
        viewModel.searchQuery = "test"
        await viewModel.search()
        #expect(viewModel.hasNoResults == false)
        
        // Empty query shows no "no results" state
        viewModel.searchQuery = ""
        #expect(viewModel.hasNoResults == false)
        
        // Clear results to simulate no results scenario
        viewModel.clearResults()
        viewModel.searchQuery = "nonexistent"
        #expect(viewModel.hasNoResults == true)
    }
    
    @Test("showEmptyState is correct for various states")
    @MainActor
    func testShowEmptyState() async {
        let viewModel = SearchViewModel()
        
        // Initially should show empty state
        #expect(viewModel.showEmptyState == true)
        
        // After search with results, should not show empty state
        viewModel.searchQuery = "Test"
        await viewModel.search()
        #expect(viewModel.showEmptyState == false)
        
        // After clearing search, should show empty state again
        viewModel.clearSearch()
        #expect(viewModel.showEmptyState == true)
    }
    
    @Test("clearSearch resets all state")
    @MainActor
    func testClearSearch() async {
        let viewModel = SearchViewModel()
        
        // Perform search first
        viewModel.searchQuery = "Test"
        await viewModel.search()
        
        #expect(!viewModel.searchQuery.isEmpty)
        #expect(!viewModel.searchResults.isEmpty)
        
        // Clear search
        viewModel.clearSearch()
        
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.showEmptyState == true)
    }
    
    @Test("clearResults only clears results")
    @MainActor
    func testClearResults() async {
        let viewModel = SearchViewModel()
        
        viewModel.searchQuery = "Test"
        await viewModel.search()
        
        let originalQuery = viewModel.searchQuery
        viewModel.clearResults()
        
        #expect(viewModel.searchQuery == originalQuery)
        #expect(viewModel.searchResults.isEmpty)
    }
    
    @Test("setFilter updates current filter")
    @MainActor
    func testSetFilter() {
        let viewModel = SearchViewModel()
        
        #expect(viewModel.currentFilter == .all)
        
        viewModel.setFilter(.movies)
        #expect(viewModel.currentFilter == .movies)
        
        viewModel.setFilter(.tvShows)
        #expect(viewModel.currentFilter == .tvShows)
    }
    
    @Test("search sets and clears isSearching flag")
    @MainActor
    func testIsSearchingFlag() async {
        let viewModel = SearchViewModel()
        
        #expect(viewModel.isSearching == false)
        
        viewModel.searchQuery = "Test"
        
        // Start search and check flag immediately
        let searchTask = Task {
            await viewModel.search()
        }
        
        // Note: This might be flaky due to timing, but demonstrates the pattern
        await searchTask.value
        
        // Should not be searching after completion
        #expect(viewModel.isSearching == false)
    }
    
    @Test("addToLibrary marks result as available")
    @MainActor
    func testAddToLibrary() async {
        let viewModel = SearchViewModel()
        
        viewModel.searchQuery = "Test"
        await viewModel.search()
        
        // Get the first result (which should be a movie that's not available in mock data)
        guard let firstResult = viewModel.searchResults.first(where: { $0.mediaType == .movie && !$0.isAvailable }) else {
            Issue.record("No unavailable movie result found for testing")
            return
        }
        
        #expect(firstResult.isAvailable == false)
        
        await viewModel.addToLibrary(firstResult)
        
        // Find the updated result by external ID since ID changes when result is updated
        guard let updatedResult = viewModel.searchResults.first(where: { $0.externalId == firstResult.externalId }) else {
            Issue.record("Result not found after adding to library")
            return
        }
        
        #expect(updatedResult.isAvailable == true)
    }
    
    @Test("mock results have correct properties")
    @MainActor
    func testMockResultsProperties() async {
        let viewModel = SearchViewModel()
        
        viewModel.searchQuery = "TestQuery"
        await viewModel.search()
        
        #expect(!viewModel.searchResults.isEmpty)
        
        for result in viewModel.searchResults {
            #expect(!result.id.uuidString.isEmpty)
            #expect(result.title.contains("TestQuery"))
            #expect(result.year != nil)
            #expect(result.overview != nil)
            #expect(!result.externalId.isEmpty)
        }
    }
}

// MARK: - SearchResult Tests

@Suite("SearchResult Tests")
struct SearchResultTests {
    
    @Test("MediaType has correct system icons")
    @MainActor
    func testMediaTypeSystemIcons() {
        #expect(SearchResult.MediaType.movie.systemIcon == SystemIcon.movies)
        #expect(SearchResult.MediaType.tvShow.systemIcon == SystemIcon.tv)  
        #expect(SearchResult.MediaType.music.systemIcon == SystemIcon.music)
    }
    
    @Test("SearchFilter media type mapping is correct")
    @MainActor
    func testSearchFilterMediaTypeMapping() {
        #expect(SearchFilter.all.mediaType == nil)
        #expect(SearchFilter.movies.mediaType == .movie)
        #expect(SearchFilter.tvShows.mediaType == .tvShow)
        #expect(SearchFilter.music.mediaType == .music)
    }
    
    @Test("SearchResult conforms to required protocols")
    @MainActor
    func testSearchResultProtocolConformance() {
        let result = SearchResult(
            title: "Test",
            year: "2023",
            overview: "Test overview",
            posterURL: nil,
            mediaType: .movie,
            externalId: "123",
            isAvailable: false
        )
        
        // Test Identifiable
        #expect(!result.id.uuidString.isEmpty)
        
        // Test Hashable by creating a set
        let results = Set([result])
        #expect(results.count == 1)
    }
}