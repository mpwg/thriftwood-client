//
//  MovieDetailView.swift
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

/// Detailed view for a single movie with full metadata, images, and actions
///
/// Based on legacy Flutter RadarrMovieDetailsRoute with modernized SwiftUI patterns.
/// Follows MVVM-C architecture - ViewModel handles business logic, Coordinator handles navigation.
///
/// Features:
/// - Large poster/backdrop display
/// - Full metadata (title, year, runtime, rating, genres, studio)
/// - Overview/synopsis
/// - Monitored toggle
/// - File information (if downloaded)
/// - Action buttons (refresh, delete, edit)
/// - Pull-to-refresh
/// - Loading/Error states
///
/// Usage:
/// ```swift
/// MovieDetailView(
///     movieId: 123,
///     onEdit: { movieId in
///         coordinator.showMovieEdit(movieId)
///     },
///     onDeleted: {
///         coordinator.popToRoot()
///     }
/// )
/// .environment(viewModel)
/// ```
struct MovieDetailView: View {
    // MARK: - Properties
    
    @Environment(MovieDetailViewModel.self) private var viewModel
    @State private var showDeleteConfirmation = false
    @State private var deleteFiles = false
    
    let onEdit: (Int) -> Void
    let onDeleted: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        contentBody
            .navigationTitle(viewModel.displayMovie?.title ?? "Movie Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
            .refreshable {
                await viewModel.refreshMovie()
            }
            .task {
                if viewModel.displayMovie == nil {
                    await viewModel.loadMovie()
                }
            }
            .confirmationDialog(
                "Delete Movie",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                deleteConfirmationDialog
            } message: {
                Text("This action cannot be undone")
            }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if viewModel.isLoading && viewModel.displayMovie == nil {
            loadingView
        } else if let error = viewModel.error, viewModel.displayMovie == nil {
            errorView(error)
        } else if let movie = viewModel.displayMovie {
            ScrollView {
                VStack(spacing: 0) {
                    headerImage(movie)
                    contentView(movie)
                }
            }
        }
    }
    
    // MARK: - Header Image
    
    @ViewBuilder
    private func headerImage(_ movie: MovieDisplayModel) -> some View {
        if let posterURL = movie.posterURL {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    posterPlaceholder
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    posterPlaceholder
                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(height: 400)
            .frame(maxWidth: .infinity)
            .clipped()
            .accessibilityLabel("Poster for \(movie.title)")
        } else {
            posterPlaceholder
                .accessibilityHidden(true)
        }
    }
    
    private var posterPlaceholder: some View {
        Rectangle()
            .fill(Color.themeSecondaryBackground)
            .frame(height: 400)
            .overlay {
                Image(systemName: "film")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.themeSecondaryText)
            }
    }
    
    // MARK: - Content View
    
    private func contentView(_ movie: MovieDisplayModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Title section
            titleSection(movie)
            
            // Metadata section
            metadataSection(movie)
            
            // Overview section
            if let overview = movie.overview, !overview.isEmpty {
                overviewSection(overview)
            }
            
            // File information section
            if movie.hasFile {
                fileSection(movie)
            }
            
            // Status section
            statusSection(movie)
        }
        .padding(Spacing.lg)
    }
    
    // MARK: - Title Section
    
    private func titleSection(_ movie: MovieDisplayModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.themePrimaryText)
                    
                    if let year = movie.yearText {
                        Text(year)
                            .font(.title3)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
                
                Spacer()
                
                // Status badge
                statusBadge(movie)
            }
            
            // Genres and certification
            HStack(spacing: Spacing.sm) {
                if let certification = movie.certification, !certification.isEmpty {
                    certificationBadge(certification)
                }
                
                if let genresText = movie.genresText {
                    Text(genresText)
                        .font(.subheadline)
                        .foregroundStyle(Color.themeSecondaryText)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
    
    private func statusBadge(_ movie: MovieDisplayModel) -> some View {
        HStack(spacing: Spacing.xs) {
            Circle()
                .fill(movie.hasFile ? Color.green : Color.orange)
                .frame(width: 12, height: 12)
            
            Text(movie.statusText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.themeSecondaryText)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(Color.themeSecondaryBackground)
        .clipShape(Capsule())
    }
    
    private func certificationBadge(_ certification: String) -> some View {
        Text(certification)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(Color.themePrimaryText)
            .padding(.horizontal, Spacing.xs)
            .padding(.vertical, 2)
            .background(Color.themeSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    // MARK: - Metadata Section
    
    private func metadataSection(_ movie: MovieDisplayModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Runtime and Rating
            HStack(spacing: Spacing.xl) {
                if let runtime = movie.runtimeText {
                    metadataItem(icon: "clock", text: runtime, label: "Runtime")
                }
                
                if let rating = movie.ratingText {
                    metadataItem(icon: "star.fill", text: rating, label: "Rating")
                }
            }
            
            // Studio
            if let studio = movie.studio, !studio.isEmpty {
                metadataItem(icon: "building.2", text: studio, label: "Studio")
            }
            
            // Quality Profile
            if let qualityProfile = movie.qualityProfileName {
                metadataItem(icon: "gauge.with.dots.needle.50percent", text: qualityProfile, label: "Quality Profile")
            }
        }
    }
    
    private func metadataItem(icon: String, text: String, label: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.callout)
                .foregroundStyle(Color.themeAccent)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundStyle(Color.themePrimaryText)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(text)")
    }
    
    // MARK: - Overview Section
    
    private func overviewSection(_ overview: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Overview")
                .font(.headline)
                .foregroundStyle(Color.themePrimaryText)
            
            Text(overview)
                .font(.body)
                .foregroundStyle(Color.themeSecondaryText)
                .lineSpacing(4)
        }
    }
    
    // MARK: - File Section
    
    private func fileSection(_ movie: MovieDisplayModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("File Information")
                .font(.headline)
                .foregroundStyle(Color.themePrimaryText)
            
            CardView {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.green)
                        Text("Movie file downloaded")
                            .font(.body)
                            .foregroundStyle(Color.themePrimaryText)
                    }
                    
                    if let qualityProfile = movie.qualityProfileName {
                        HStack {
                            Image(systemName: "gauge.with.dots.needle.50percent")
                                .foregroundStyle(Color.themeAccent)
                            Text(qualityProfile)
                                .font(.body)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                    }
                }
                .padding(Spacing.md)
            }
        }
    }
    
    // MARK: - Status Section
    
    private func statusSection(_ movie: MovieDisplayModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Monitoring")
                .font(.headline)
                .foregroundStyle(Color.themePrimaryText)
            
            CardView {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(movie.monitored ? "Monitored" : "Unmonitored")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.themePrimaryText)
                        
                        Text(movie.monitored
                            ? "Radarr will monitor for new releases"
                            : "Radarr will not monitor this movie")
                            .font(.caption)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: monitoredBinding)
                        .labelsHidden()
                        .accessibilityLabel(movie.monitored ? "Monitored, toggle to stop monitoring" : "Not monitored, toggle to start monitoring")
                }
                .padding(Spacing.md)
                .accessibilityElement(children: .contain)
            }
        }
    }
    
    private var monitoredBinding: Binding<Bool> {
        Binding(
            get: { viewModel.displayMovie?.monitored ?? false },
            set: { _ in
                Task {
                    await viewModel.toggleMonitored()
                }
            }
        )
    }
    
    // MARK: - Loading State
    
    private var loadingView: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading movie details...")
                .font(.body)
                .foregroundStyle(Color.themeSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error State
    
    private func errorView(_ error: ThriftwoodError) -> some View {
        ErrorView(
            error: error,
            title: "Failed to Load Movie",
            onRetry: {
                Task {
                    await viewModel.loadMovie()
                }
            }
        )
    }
    
    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button(action: { onEdit(viewModel.movieId) }) {
                    Label("Edit Movie", systemImage: "pencil")
                }
                
                Button(action: refreshMovie) {
                    Label("Refresh Metadata", systemImage: "arrow.clockwise")
                }
                
                Divider()
                
                Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                    Label("Delete Movie", systemImage: "trash")
                }
            } label: {
                Label("Actions", systemImage: "ellipsis.circle")
            }
            .accessibilityLabel("Movie actions")
        }
    }
    
    // MARK: - Delete Confirmation Dialog
    
    @ViewBuilder
    private var deleteConfirmationDialog: some View {
        Button("Delete Movie Only", role: .destructive) {
            deleteMovie(deleteFiles: false)
        }
        
        Button("Delete Movie and Files", role: .destructive) {
            deleteMovie(deleteFiles: true)
        }
        
        Button("Cancel", role: .cancel) { }
    }
    
    // MARK: - Actions
    
    private func refreshMovie() {
        Task {
            await viewModel.refreshMovie()
        }
    }
    
    private func deleteMovie(deleteFiles: Bool) {
        Task {
            let success = await viewModel.deleteMovie(deleteFiles: deleteFiles)
            if success {
                onDeleted()
            }
        }
    }
}

// MARK: - Previews

#Preview("Movie Detail - Loaded") {
    @Previewable @State var viewModel = MovieDetailViewModel(
        movieId: 1,
        radarrService: PreviewRadarrService()
    )
    
    NavigationStack {
        MovieDetailView(
            onEdit: { _ in },
            onDeleted: { }
        )
        .environment(viewModel)
    }
}

#Preview("Movie Detail - Loading") {
    @Previewable @State var viewModel = {
        let vm = MovieDetailViewModel(
            movieId: 1,
            radarrService: PreviewRadarrService()
        )
        vm.isLoading = true
        return vm
    }()
    
    NavigationStack {
        MovieDetailView(
            onEdit: { _ in },
            onDeleted: { }
        )
        .environment(viewModel)
    }
}

#Preview("Movie Detail - Error") {
    @Previewable @State var viewModel = {
        let vm = MovieDetailViewModel(
            movieId: 1,
            radarrService: PreviewRadarrService()
        )
        vm.error = .networkError(URLError(.notConnectedToInternet))
        return vm
    }()
    
    NavigationStack {
        MovieDetailView(
            onEdit: { _ in },
            onDeleted: { }
        )
        .environment(viewModel)
    }
}
