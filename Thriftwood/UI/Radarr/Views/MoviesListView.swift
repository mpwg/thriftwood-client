//
//  MoviesListView.swift
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

import SwiftUI

/// Main view for displaying the movies list with filtering, sorting, and layout options
///
/// Based on legacy Flutter RadarrCataloguePage with modernized SwiftUI patterns.
/// Follows MVVM-C architecture -ViewModel handles business logic.
///
/// Features:
/// - Grid/List layout toggle
/// - Pull-to-refresh
/// - Search functionality
/// - Filter options (all, monitored, missing, etc.)
/// - Sort options (title, date added, rating, etc.)
/// - Empty/Loading/Error states
///
/// Usage:
/// ```swift
/// MoviesListView(
///     onMovieSelected: { movieId in
///         coordinator.showMovieDetail(movieId)
///     },
///     onAddMovie: {
///         coordinator.showAddMovie()
///     }
/// )
/// .environment(viewModel)
/// ```
struct MoviesListView: View {
    // MARK: - Properties
    
    @Environment(MoviesListViewModel.self) private var viewModel
    @State private var layout: MovieCardLayout = .grid
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var showSortSheet = false
    
    let onMovieSelected: (Int) -> Void
    let onAddMovie: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    loadingView
                } else if let error = viewModel.error {
                    errorView(error)
                } else if filteredMovies.isEmpty {
                    emptyStateView
                } else {
                    moviesList
                }
            }
            .navigationTitle("Movies")
            .searchable(text: $searchText, prompt: "Search movies")
            .toolbar {
                toolbarContent
            }
            .refreshable {
                await viewModel.refreshMovies()
            }
            .task {
                if viewModel.movies.isEmpty {
                    await viewModel.loadMovies()
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                filterSheet
            }
            .sheet(isPresented: $showSortSheet) {
                sortSheet
            }
        }
        .logViewLifecycle(view: "MoviesListView", metadata: ["coordinator": "RadarrCoordinator"])
    }
    
    // MARK: - Movies List
    
    @ViewBuilder
    private var moviesList: some View {
        switch layout {
        case .grid:
            moviesGrid
        case .list:
            moviesListLayout
        }
    }
    
    private var moviesGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 140, maximum: 200), spacing: Spacing.md)
                ],
                spacing: Spacing.md
            ) {
                ForEach(filteredMovies) { movie in
                    MovieCardView(movie: movie, layout: .grid) {
                        onMovieSelected(movie.id)
                    }
                }
            }
            .padding(Spacing.md)
        }
    }
    
    private var moviesListLayout: some View {
        List {
            ForEach(filteredMovies) { movie in
                MovieCardView(movie: movie, layout: .list) {
                    onMovieSelected(movie.id)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(
                    top: Spacing.xs,
                    leading: Spacing.md,
                    bottom: Spacing.xs,
                    trailing: Spacing.md
                ))
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: - Loading State
    
    private var loadingView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 140, maximum: 200), spacing: Spacing.md)
                ],
                spacing: Spacing.md
            ) {
                ForEach(0..<12, id: \.self) { _ in
                    MovieCardSkeleton(layout: layout)
                }
            }
            .padding(Spacing.md)
        }
    }
    
    // MARK: - Error State
    
    private func errorView(_ error: ThriftwoodError) -> some View {
        ErrorView(
            error: error,
            title: "Failed to Load Movies",
            onRetry: {
                Task {
                    await viewModel.loadMovies()
                }
            }
        )
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        EmptyStateView(
            icon: "film",
            title: searchText.isEmpty ? "No Movies" : "No Results",
            subtitle: searchText.isEmpty 
                ? "Add movies to your library to see them here"
                : "No movies match '\(searchText)'",
            actionTitle: searchText.isEmpty ? "Add Movie" : nil,
            action: searchText.isEmpty ? onAddMovie : nil
        )
    }
    
    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        // Add Movie button
        ToolbarItem(placement: .primaryAction) {
            Button(action: onAddMovie) {
                Label("Add Movie", systemImage: "plus")
            }
            .accessibilityLabel("Add new movie")
        }
        
        // Layout toggle
        ToolbarItem(placement: .secondaryAction) {
            Button(action: toggleLayout) {
                Label(
                    layout == .grid ? "List View" : "Grid View",
                    systemImage: layout == .grid ? "list.bullet" : "square.grid.2x2"
                )
            }
            .accessibilityLabel(layout == .grid ? "Switch to list view" : "Switch to grid view")
        }
        
        // Filter button
        ToolbarItem(placement: .secondaryAction) {
            Button(action: { showFilterSheet = true }) {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
            .accessibilityLabel("Filter movies")
        }
        
        // Sort button
        ToolbarItem(placement: .secondaryAction) {
            Button(action: { showSortSheet = true }) {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
            .accessibilityLabel("Sort movies")
        }
    }
    
    // MARK: - Filter Sheet
    
    private var filterSheet: some View {
        NavigationStack {
            List {
                Section("Show Movies") {
                    ForEach([MovieFilter.all, .monitored, .unmonitored, .missing, .downloaded], id: \.self) { filter in
                        Button(action: {
                            viewModel.filterOption = filter
                            viewModel.applyFilterAndSort()
                            showFilterSheet = false
                        }) {
                            HStack {
                                Text(filter.displayName)
                                    .foregroundStyle(Color.themePrimaryText)
                                Spacer()
                                if viewModel.filterOption == filter {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.themeAccent)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Movies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showFilterSheet = false
                    }
                }
            }
        }
    }
    
    // MARK: - Sort Sheet
    
    private var sortSheet: some View {
        NavigationStack {
            List {
                Section("Sort By") {
                    ForEach([MovieSort.title, .dateAdded, .releaseDate, .rating], id: \.self) { sort in
                        Button(action: {
                            viewModel.sortOption = sort
                            viewModel.applyFilterAndSort()
                            showSortSheet = false
                        }) {
                            HStack {
                                Text(sort.displayName)
                                    .foregroundStyle(Color.themePrimaryText)
                                Spacer()
                                if viewModel.sortOption == sort {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.themeAccent)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sort Movies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showSortSheet = false
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var filteredMovies: [MovieDisplayModel] {
        if searchText.isEmpty {
            return viewModel.movies
        }
        
        return viewModel.movies.filter { movie in
            movie.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Actions
    
    private func toggleLayout() {
        withAnimation(.easeInOut(duration: 0.2)) {
            layout = layout == .grid ? .list : .grid
        }
    }
}

// MARK: - Filter/Sort Display Names

extension MovieFilter {
    var displayName: String {
        switch self {
        case .all: return "All Movies"
        case .monitored: return "Monitored"
        case .unmonitored: return "Unmonitored"
        case .missing: return "Missing Files"
        case .downloaded: return "Downloaded"
        }
    }
}

extension MovieSort {
    var displayName: String {
        switch self {
        case .title: return "Title"
        case .dateAdded: return "Date Added"
        case .releaseDate: return "Release Date"
        case .rating: return "Rating"
        }
    }
}

// MARK: - Previews

#Preview("Movies List - Grid") {
    @Previewable @State var viewModel = {
        let vm = MoviesListViewModel(
            radarrService: PreviewRadarrService()
        )
        vm.movies = [
            .preview,
            .previewMissing,
            .previewUnmonitored
        ]
        return vm
    }()
    
    MoviesListView(
        onMovieSelected: { _ in },
        onAddMovie: { }
    )
    .environment(viewModel)
}

#Preview("Movies List - Loading") {
    @Previewable @State var viewModel = {
        let vm = MoviesListViewModel(
            radarrService: PreviewRadarrService()
        )
        vm.isLoading = true
        return vm
    }()
    
    MoviesListView(
        onMovieSelected: { _ in },
        onAddMovie: { }
    )
    .environment(viewModel)
}

#Preview("Movies List - Empty") {
    @Previewable @State var viewModel = MoviesListViewModel(
        radarrService: PreviewRadarrService()
    )
    
    MoviesListView(
        onMovieSelected: { _ in },
        onAddMovie: { }
    )
    .environment(viewModel)
}

#Preview("Movies List - Error") {
    @Previewable @State var viewModel = {
        let vm = MoviesListViewModel(
            radarrService: PreviewRadarrService()
        )
        vm.error = .networkError(URLError(.notConnectedToInternet))
        return vm
    }()
    
    MoviesListView(
        onMovieSelected: { _ in },
        onAddMovie: { }
    )
    .environment(viewModel)
}
