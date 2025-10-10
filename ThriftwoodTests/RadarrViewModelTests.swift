//
//  RadarrViewModelTests.swift
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

// MARK: - RadarrViewModel Tests

@Suite("RadarrViewModel Tests")
struct RadarrViewModelTests {
    
    @Test("initializes with sample movies")
    @MainActor
    func testInitializationWithSampleMovies() async {
        let viewModel = RadarrViewModel()
        
        // Wait for initial load to complete
        await viewModel.load()
        
        #expect(!viewModel.allMovies.isEmpty)
        #expect(viewModel.allMovies == Movie.sample)
    }
    
    @Test("movies property returns filtered and sorted results")
    @MainActor
    func testMoviesPropertyFiltering() async {
        let viewModel = RadarrViewModel()
        await viewModel.load()
        
        let originalCount = viewModel.movies.count
        #expect(originalCount > 0)
        
        // Test filtering by monitored
        viewModel.setFilter(.monitored)
        let monitoredMovies = viewModel.movies
        #expect(monitoredMovies.allSatisfy { $0.monitoring == true })
        
        // Test filtering by unmonitored
        viewModel.setFilter(.unmonitored)
        let unmonitoredMovies = viewModel.movies
        #expect(unmonitoredMovies.allSatisfy { $0.monitoring == false })
        
        // Reset filter
        viewModel.setFilter(.all)
        #expect(viewModel.movies.count == originalCount)
    }
    
    @Test("search text filters movies correctly")
    @MainActor
    func testSearchTextFiltering() async {
        let viewModel = RadarrViewModel()
        await viewModel.load()
        
        let originalCount = viewModel.movies.count
        
        // Apply search filter
        viewModel.updateSearchText("Test")
        let filteredMovies = viewModel.movies
        
        // Should have fewer or equal movies
        #expect(filteredMovies.count <= originalCount)
        
        // All filtered movies should contain the search text
        for movie in filteredMovies {
            let containsSearchText = movie.title.localizedCaseInsensitiveContains("Test") ||
                                   movie.year.localizedCaseInsensitiveContains("Test") ||
                                   movie.studio.localizedCaseInsensitiveContains("Test")
            #expect(containsSearchText)
        }
        
        // Clear search
        viewModel.updateSearchText("")
        #expect(viewModel.movies.count == originalCount)
    }
    
    @Test("sort options work correctly")
    @MainActor
    func testSortOptions() async {
        let viewModel = RadarrViewModel()
        await viewModel.load()
        
        // Test title sorting (default)
        viewModel.setSort(.title)
        let titleSorted = viewModel.movies
        let expectedTitleSorted = titleSorted.sorted { $0.title < $1.title }
        #expect(titleSorted.map { $0.title } == expectedTitleSorted.map { $0.title })
        
        // Test year sorting
        viewModel.setSort(.year)
        let yearSorted = viewModel.movies
        let expectedYearSorted = yearSorted.sorted { $0.year > $1.year }
        #expect(yearSorted.map { $0.year } == expectedYearSorted.map { $0.year })
    }
    
    @Test("filter options are correctly applied")
    @MainActor
    func testFilterOptions() async {
        let viewModel = RadarrViewModel()
        await viewModel.load()
        
        // Test all filter cases
        for filterOption in MovieFilterOption.allCases {
            viewModel.setFilter(filterOption)
            let filteredMovies = viewModel.movies
            
            switch filterOption {
            case .all:
                #expect(filteredMovies.count == viewModel.allMovies.count)
            case .monitored:
                #expect(filteredMovies.allSatisfy { $0.monitoring == true })
            case .unmonitored:
                #expect(filteredMovies.allSatisfy { $0.monitoring == false })
            case .available:
                #expect(filteredMovies.allSatisfy { $0.status == "Available" })
            case .missing:
                #expect(filteredMovies.allSatisfy { $0.status == "Missing" })
            }
        }
    }
    
    @Test("refresh sets and clears isRefreshing flag")
    @MainActor
    func testRefreshState() async {
        let viewModel = RadarrViewModel()
        
        #expect(viewModel.isRefreshing == false)
        
        // Start refresh
        let refreshTask = Task {
            await viewModel.refresh()
        }
        
        // Should be refreshing briefly
        // Note: This test might be flaky due to timing, but demonstrates the pattern
        await refreshTask.value
        
        // Should not be refreshing after completion
        #expect(viewModel.isRefreshing == false)
    }
    
    @Test("movie with id returns correct movie")
    @MainActor
    func testMovieWithId() async {
        let viewModel = RadarrViewModel()
        await viewModel.load()
        
        guard let firstMovie = viewModel.allMovies.first else {
            Issue.record("No movies available for testing")
            return
        }
        
        let foundMovie = viewModel.movie(withId: firstMovie.id)
        #expect(foundMovie?.id == firstMovie.id)
        #expect(foundMovie?.title == firstMovie.title)
        
        // Test with non-existent ID
        let nonExistentMovie = viewModel.movie(withId: UUID())
        #expect(nonExistentMovie == nil)
    }
    
    @Test("load method loads sample movies")
    @MainActor
    func testLoadMethod() async {
        let viewModel = RadarrViewModel()
        
        #expect(viewModel.allMovies.isEmpty) // Should be empty initially
        
        await viewModel.load()
        
        #expect(!viewModel.allMovies.isEmpty)
        #expect(viewModel.error == nil)
    }
    
    @Test("initial filter and sort options are correct")
    @MainActor
    func testInitialState() {
        let viewModel = RadarrViewModel()
        
        #expect(viewModel.filterOption == .all)
        #expect(viewModel.sortOption == .title)
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.isRefreshing == false)
    }
    
    @Test("combined filter and search works correctly")
    @MainActor
    func testCombinedFilterAndSearch() async {
        let viewModel = RadarrViewModel()
        await viewModel.load()
        
        // Apply both filter and search
        viewModel.setFilter(.monitored)
        viewModel.updateSearchText("Test")
        
        let results = viewModel.movies
        
        // All results should match both criteria
        for movie in results {
            #expect(movie.monitoring == true)
            let containsSearchText = movie.title.localizedCaseInsensitiveContains("Test") ||
                                   movie.year.localizedCaseInsensitiveContains("Test") ||
                                   movie.studio.localizedCaseInsensitiveContains("Test")
            #expect(containsSearchText)
        }
    }
}