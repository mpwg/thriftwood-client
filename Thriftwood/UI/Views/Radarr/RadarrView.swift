//
//  RadarrView.swift
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

// Platform-aware semantic colors to keep the view compilable on macOS and iOS

struct RadarrView: View {
    @State private var viewModel = RadarrViewModel()

    var body: some View {
        ZStack {
            Color.platformGroupedBackground
                .ignoresSafeArea()

            if viewModel.isLoading && viewModel.movies.isEmpty {
                LoadingView(message: "Loading movies...")
            } else if let error = viewModel.error {
                ErrorView(
                    error: error,
                    onRetry: {
                        Task {
                            await viewModel.reload()
                        }
                    }
                )
            } else if viewModel.movies.isEmpty {
                EmptyStateView(
                    title: "No Movies Found",
                    message: "Add movies to your Radarr library to see them here.",
                    systemIcon: SystemIcon.movies
                )
            } else {
                ScrollView {
                    VStack(spacing: UIConstants.Spacing.medium) {
                        ForEach(viewModel.movies) { movie in
                            NavigationLink {
                                MovieDetailView(movie: movie)
                            } label: {
                                MovieRow(movie: movie)
                                    .padding(.horizontal, UIConstants.Padding.screen)
                            }
                        }
                    }
                    .padding(.top, UIConstants.Spacing.small)
                    .padding(.bottom, UIConstants.Padding.bottomToolbarSpacer)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
        .navigationTitle("Radarr")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .searchable(text: $viewModel.searchText, prompt: "Search movies...")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Menu {
                    Picker("Filter", selection: $viewModel.filterOption) {
                        ForEach(MovieFilterOption.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Divider()
                    
                    Picker("Sort", selection: $viewModel.sortOption) {
                        ForEach(MovieSortOption.allCases) { sort in
                            Text(sort.rawValue).tag(sort)
                        }
                    }
                    .pickerStyle(.menu)
                } label: {
                    Label("Filter & Sort", systemImage: SystemIcon.filterCircle)
                }
            }

            ToolbarItem(placement: .automatic) {
                Button(action: {
                    Task {
                        await viewModel.refresh()
                    }
                }, label: {
                    if viewModel.isRefreshing {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Label("Refresh", systemImage: SystemIcon.refresh)
                    }
                })
                .disabled(viewModel.isRefreshing)
            }

            ToolbarItemGroup(placement: .automatic) {
                Menu(content: {
                    Button(action: { /* filter by */ }, label: {
                        Label("Filter By", systemImage: SystemIcon.filter)
                    })
                    Button(action: { /* sort by */ }, label: {
                        Label("Sort By", systemImage: SystemIcon.sort)
                    })
                }, label: {
                    Label("Filter", systemImage: SystemIcon.filter)
                })

                Button(action: { /* toggle grid */ }, label: {
                    Label("Grid", systemImage: SystemIcon.grid)
                })

                NavigationLink(destination: AddMovieView(), label: {
                    Label("Add", systemImage: SystemIcon.add)
                })

                Menu(content: {
                    Button(action: { /* action 1 */ }, label: {
                        Label("Refresh", systemImage: SystemIcon.refresh)
                    })
                    Button(action: { /* action 2 */ }, label: {
                        Label("Settings", systemImage: SystemIcon.settings)
                    })
                }, label: {
                    Label("More", systemImage: SystemIcon.more)
                })
            }

            ToolbarItemGroup(placement: .platformBottom) {
                Button(action: {}, label: {
                    Label("Movies", systemImage: SystemIcon.moviesFilled)
                })
                .pillStyle(prominent: true)

                Spacer()

                HStack(spacing: UIConstants.Spacing.large) {
                    Button(action: {}, label: {
                        Label("Calendar", systemImage: SystemIcon.calendar)
                    })
                    .cardStyle()

                    Button(action: {}, label: {
                        Label("Grid", systemImage: SystemIcon.grid3x2)
                    })
                    .cardStyle()
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    Group {
        RadarrView()
    }
}
