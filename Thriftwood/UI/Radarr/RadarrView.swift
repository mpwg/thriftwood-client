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

struct RadarrView: View {
    private let movies: [Movie] = Movie.sample

    var body: some View {
        NavigationStack {
            ZStack {
                Color.platformGroupedBackground
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(movies) { movie in
                                NavigationLink(destination: {
                                    MoviePrototypeDetailView(movie: movie)
                                }, label: {
                                    MovieRow(movie: movie)
                                        .padding(.horizontal)
                                })
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 120)
                    }
                    .navigationTitle("Radarr")
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.large)
                    #endif

                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Label("Search...", systemImage: "magnifyingglass")
                    }

                    ToolbarItemGroup(placement: .automatic) {
                        Button(action: {}, label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease")
                        })

                        Button(action: {}, label: {
                            Label("Grid", systemImage: "square.grid.2x2")
                        })

                        Button(action: {}, label: {
                            Label("Add", systemImage: "plus")
                        })
                    }
                }

                // Bottom pill toolbar
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {}, label: {
                            Label("Movies", systemImage: "film.fill")
                                .background(.regularMaterial)
                                .clipShape(.capsule)
                        })

                        Spacer()

                        HStack(spacing: 20) {
                            Button(action: {}, label: {
                                Label("Calendar", systemImage: "calendar")
                                    .background(.regularMaterial)
                                    .clipShape(.capsule)
                            })
                            Button(action: {}, label: {
                                Label("Grid", systemImage: "square.grid.3x2.fill")
                                    .background(.regularMaterial)
                                    .clipShape(.capsule)
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    RadarrView()
}
