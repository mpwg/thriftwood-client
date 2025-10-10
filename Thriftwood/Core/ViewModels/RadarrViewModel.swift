//
//  RadarrViewModel.swift
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

// MARK: - Movie Filter Options

enum MovieFilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case monitored = "Monitored"
    case unmonitored = "Unmonitored"
    case available = "Available"
    case missing = "Missing"
    
    var id: String { rawValue }
}

// MARK: - Movie Sort Options

enum MovieSortOption: String, CaseIterable, Identifiable {
    case title = "Title"
    case year = "Year"
    case dateAdded = "Date Added"
    case runtime = "Runtime"
    case size = "File Size"
    
    var id: String { rawValue }
}

// MARK: - RadarrViewModel

@MainActor
@Observable
final class RadarrViewModel: BaseViewModelImpl {
    
    // MARK: - Published Properties
    
    /// All movies from Radarr
    private(set) var allMovies: [Movie] = []
    
    /// Filtered and sorted movies for display
    var movies: [Movie] {
        var filtered = allMovies
        
        // Apply filter
        switch filterOption {
        case .all:
            break
        case .monitored:
            filtered = filtered.filter { $0.monitoring == true }
        case .unmonitored:
            filtered = filtered.filter { $0.monitoring == false }
        case .available:
            filtered = filtered.filter { $0.status == "Available" }
        case .missing:
            filtered = filtered.filter { $0.status == "Missing" }
        }
        
        // Apply search
        if !searchText.isEmpty {
            filtered = filtered.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText) ||
                movie.year.localizedCaseInsensitiveContains(searchText) ||
                movie.studio.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sort
        switch sortOption {
        case .title:
            filtered.sort { $0.title < $1.title }
        case .year:
            filtered.sort { $0.year > $1.year }
        case .dateAdded:
            filtered.sort { $0.addedOn ?? "" > $1.addedOn ?? "" }
        case .runtime:
            filtered.sort { $0.runtime < $1.runtime }
        case .size:
            filtered.sort { $0.size < $1.size }
        }
        
        return filtered
    }
    
    /// Current filter option
    var filterOption: MovieFilterOption = .all
    
    /// Current sort option
    var sortOption: MovieSortOption = .title
    
    /// Search text
    var searchText: String = ""
    
    /// Loading state for refresh
    var isRefreshing: Bool = false
    
    // MARK: - Dependencies
    
    // TODO: Add RadarrService when implemented
    // private let radarrService: any RadarrServiceProtocol
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        Task {
            await load()
        }
    }
    
    // MARK: - BaseViewModel Implementation
    
    override func load() async {
        await safeAsyncVoid {
            // TODO: Replace with actual Radarr API call
            // allMovies = try await radarrService.fetchMovies()
            
            // For now, use sample data
            self.loadSampleMovies()
        }
    }
    
    // MARK: - Public Methods
    
    /// Refresh movies from Radarr
    func refresh() async {
        isRefreshing = true
        await load()
        isRefreshing = false
    }
    
    /// Update filter option and refresh display
    func setFilter(_ filter: MovieFilterOption) {
        filterOption = filter
    }
    
    /// Update sort option and refresh display
    func setSort(_ sort: MovieSortOption) {
        sortOption = sort
    }
    
    /// Update search text
    func updateSearchText(_ text: String) {
        searchText = text
    }
    
    /// Get movie by ID
    func movie(withId id: UUID) -> Movie? {
        allMovies.first { $0.id == id }
    }
    
    /// Toggle movie monitoring status
    func toggleMonitoring(for movieId: UUID) async {
        guard let index = self.allMovies.firstIndex(where: { $0.id == movieId }) else { return }
        
        await safeAsyncVoid {
            // TODO: Call Radarr API to toggle monitoring
            // try await radarrService.setMonitoring(movieId: movieId, monitored: !self.allMovies[index].monitoring)
            
            // For now, just update local state
            _ = self.allMovies[index]
            // Note: Movie struct might need to be made mutable or use a different approach
            // This is a placeholder showing the intended behavior
        }
    }
    
    // MARK: - Private Methods
    
    private func loadSampleMovies() {
        // Load sample data (this will be replaced with actual API calls)
        allMovies = Movie.sample
    }
}