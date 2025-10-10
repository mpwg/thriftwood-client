//
//  SearchView.swift
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

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.platformGroupedBackground
                    .ignoresSafeArea()

                if viewModel.showEmptyState {
                    EmptyStateView(
                        title: "Search Media",
                        message: "Search for movies, TV shows, and music to add to your library.",
                        systemIcon: SystemIcon.searchCircle
                    )
                } else if viewModel.isSearching {
                    LoadingView(message: "Searching...")
                } else if let error = viewModel.error {
                    ErrorView(
                        error: error,
                        onRetry: {
                            Task {
                                await viewModel.search()
                            }
                        }
                    )
                } else if viewModel.hasNoResults {
                    EmptyStateView(
                        title: "No Results Found",
                        message: "Try adjusting your search terms or filters.",
                        systemIcon: SystemIcon.magnifyingGlass
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: UIConstants.Spacing.medium) {
                            ForEach(viewModel.filteredResults) { result in
                                SearchResultRow(
                                    result: result,
                                    onAdd: { result in
                                        Task {
                                            await viewModel.addToLibrary(result)
                                        }
                                    }
                                )
                                .padding(.horizontal, UIConstants.Padding.screen)
                            }
                        }
                        .padding(.top, UIConstants.Spacing.small)
                        .padding(.bottom, UIConstants.Padding.bottomToolbarSpacer)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(
                text: $viewModel.searchQuery,
                prompt: "Search movies, TV shows, music..."
            )
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search()
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Picker("Filter", selection: $viewModel.currentFilter) {
                            ForEach(SearchFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        .pickerStyle(.menu)
                    } label: {
                        Label("Filter", systemImage: SystemIcon.filterCircle)
                    }
                }
            }
        }
    }
}

// MARK: - Search Result Row

struct SearchResultRow: View {
    let result: SearchResult
    let onAdd: (SearchResult) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
                HStack {
                    Text(result.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let year = result.year {
                        Text("(\(year))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: result.mediaType.systemIcon)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let overview = result.overview {
                    Text(overview)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            if result.isAvailable {
                Label("In Library", systemImage: SystemIcon.checkmarkCircleFill)
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Button(action: {
                    onAdd(result)
                }) {
                    Label("Add", systemImage: SystemIcon.plus)
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(UIConstants.Padding.card)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card, style: .continuous)
                .fill(Color.platformSecondaryGroupedBackground)
        )
        .shadow(
            color: UIConstants.Shadow.cardColor,
            radius: UIConstants.Shadow.cardRadius,
            x: UIConstants.Shadow.cardX,
            y: UIConstants.Shadow.cardY
        )
    }
}

#Preview {
    SearchView()
}
