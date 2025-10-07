//
//  AddMovieView.swift
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

/// View for searching and adding new movies to Radarr
///
/// Based on legacy Flutter AddMovieRoute with modernized SwiftUI patterns.
/// Follows pure MVVM architecture - ViewModel handles business logic, navigation via callbacks.
///
/// Features:
/// - Movie search with debouncing
/// - Search results display using MovieCardView
/// - Selection sheet with quality profile and root folder pickers
/// - Monitored toggle
/// - Loading/Error states
///
/// Usage:
/// ```swift
/// AddMovieView(
///     viewModel: viewModel,
///     onMovieAdded: { movieId in
///         // Navigate to movie detail via AppCoordinator
///     }
/// )
/// ```
struct AddMovieView: View {
    // MARK: - Constants
    
    private static let searchDebounceDelay: Duration = .milliseconds(500)
    
    // MARK: - Properties
    
    @Bindable var viewModel: AddMovieViewModel
    @State private var selectedMovie: MovieDisplayModel?
    @State private var showConfigurationSheet = false
    @State private var searchTask: Task<Void, Never>?
    
    let onMovieAdded: (Int) -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            
            if viewModel.isSearching {
                loadingView
            } else if let error = viewModel.error {
                errorView(error)
            } else if viewModel.displayResults.isEmpty && !viewModel.searchQuery.isEmpty {
                emptyStateView
            } else if !viewModel.displayResults.isEmpty {
                resultsView
            } else {
                instructionsView
            }
        }
        .navigationTitle("Add Movie")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadConfiguration()
        }
        .sheet(isPresented: $showConfigurationSheet) {
            if let movie = selectedMovie {
                configurationSheet(movie)
            }
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.themeSecondaryText)
            
            TextField(
                String(localized: "search.movies.placeholder",
                      defaultValue: "Search for movies...",
                      comment: "Placeholder text for movie search field"),
                text: Binding(
                    get: { viewModel.searchQuery },
                    set: { newValue in
                        viewModel.searchQuery = newValue
                        performSearch()
                    }
                )
            )
            .textFieldStyle(.plain)
            .submitLabel(.search)
            .onSubmit {
                performSearch(immediate: true)
            }
            
            if !viewModel.searchQuery.isEmpty {
                Button(action: {
                    viewModel.clearSearch()
                    searchTask?.cancel()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.themeSecondaryText)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
                .accessibilityHint("Clears the search field and results")
            }
        }
        .padding(Spacing.md)
        .background(Color.themeSecondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
        .padding(Spacing.md)
        .accessibilityElement(children: .contain)
    }
    
    // MARK: - Results View
    
    private var resultsView: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.md) {
                ForEach(viewModel.displayResults) { movie in
                    MovieCardView(movie: movie, layout: .list) {
                        selectedMovie = movie
                        showConfigurationSheet = true
                    }
                }
            }
            .padding(Spacing.md)
        }
    }
    
    // MARK: - Configuration Sheet
    
    private func configurationSheet(_ movie: MovieDisplayModel) -> some View {
        NavigationStack {
            Form {
                Section {
                    // Movie info preview
                    HStack(spacing: Spacing.md) {
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .empty, .failure:
                                    posterPlaceholder
                                @unknown default:
                                    posterPlaceholder
                                }
                            }
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                            .accessibilityLabel("Movie poster for \(movie.title)")
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text(movie.title)
                                .font(.headline)
                                .foregroundStyle(Color.themePrimaryText)
                            
                            if let year = movie.yearText {
                                Text(year)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.themeSecondaryText)
                            }
                        }
                    }
                }
                
                Section("Configuration") {
                    // Quality Profile Picker
                    Picker("Quality Profile", selection: $viewModel.selectedQualityProfile) {
                        ForEach(viewModel.qualityProfileNames, id: \.id) { profile in
                            Text(profile.name)
                                .tag(profile.id as Int?)
                        }
                    }
                    
                    // Root Folder Picker  
                    Picker("Root Folder", selection: $viewModel.selectedRootFolder) {
                        ForEach(viewModel.rootFolderPaths, id: \.id) { folder in
                            Text(folder.path)
                                .tag(folder.id as Int?)
                        }
                    }
                    
                    // Monitored Toggle
                    Toggle("Monitor Movie", isOn: $viewModel.monitored)
                }
                
                Section {
                    Text("Radarr will search for and download this movie according to your settings.")
                        .font(.caption)
                        .foregroundStyle(Color.themeSecondaryText)
                }
            }
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showConfigurationSheet = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addMovie(movie)
                    }
                    .disabled(!canAddMovie)
                    .accessibilityHint(canAddMovie ? "Adds the movie to your collection" : "Select quality profile and root folder to enable")
                }
            }
        }
    }
    
    private var posterPlaceholder: some View {
        Rectangle()
            .fill(Color.themeSecondaryBackground)
            .frame(width: 60, height: 90)
            .overlay {
                Image(systemName: "film")
                    .font(.title3)
                    .foregroundStyle(Color.themeSecondaryText)
            }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Searching movies...")
                .font(.body)
                .foregroundStyle(Color.themeSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    
    private func errorView(_ error: ThriftwoodError) -> some View {
        ErrorView(
            error: error,
            title: "Search Failed",
            onRetry: {
                performSearch(immediate: true)
            }
        )
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results",
            subtitle: "No movies found for '\(viewModel.searchQuery)'"
        )
    }
    
    // MARK: - Instructions View
    
    private var instructionsView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(Color.themeSecondaryText)
            
            VStack(spacing: Spacing.sm) {
                Text("Search for Movies")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.themePrimaryText)
                
                Text("Enter a movie title to search")
                    .font(.body)
                    .foregroundStyle(Color.themeSecondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xl)
    }
    
    // MARK: - Computed Properties
    
    private var canAddMovie: Bool {
        viewModel.selectedQualityProfile != nil && viewModel.selectedRootFolder != nil
    }
    
    // MARK: - Actions
    
    private func performSearch(immediate: Bool = false) {
        searchTask?.cancel()
        
        if immediate {
            searchTask = Task {
                await viewModel.searchMovies()
            }
        } else {
            // Debounce search to avoid excessive API calls
            searchTask = Task {
                try? await Task.sleep(for: Self.searchDebounceDelay)
                guard !Task.isCancelled else { return }
                await viewModel.searchMovies()
            }
        }
    }
    
    private func addMovie(_ movie: MovieDisplayModel) {
        Task {
            do {
                try await viewModel.addMovieById(movie.id)
                showConfigurationSheet = false
                onMovieAdded(movie.id)
            } catch {
                // Error is already set in ViewModel
            }
        }
    }
}

// MARK: - Previews

#Preview("Add Movie - Empty") {
    @Previewable @State var viewModel = AddMovieViewModel(
        radarrService: PreviewRadarrService()
    )
    
    NavigationStack {
        AddMovieView(viewModel: viewModel, onMovieAdded: { _ in })
    }
}

#Preview("Add Movie - Searching") {
    @Previewable @State var viewModel = {
        let vm = AddMovieViewModel(radarrService: PreviewRadarrService())
        vm.searchQuery = "Matrix"
        vm.isSearching = true
        return vm
    }()
    
    NavigationStack {
        AddMovieView(viewModel: viewModel, onMovieAdded: { _ in })
    }
}

#Preview("Add Movie - Error") {
    @Previewable @State var viewModel = {
        let vm = AddMovieViewModel(radarrService: PreviewRadarrService())
        vm.searchQuery = "Matrix"
        vm.error = .networkError(URLError(.notConnectedToInternet))
        return vm
    }()
    
    NavigationStack {
        AddMovieView(viewModel: viewModel, onMovieAdded: { _ in })
    }
}
