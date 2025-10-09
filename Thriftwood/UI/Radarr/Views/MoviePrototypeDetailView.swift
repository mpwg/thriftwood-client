//
//  MoviePrototypeDetailView.swift
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

struct MoviePrototypeDetailView: View {
    let movie: Movie

    private enum Tab: String {
        case overview
        case files
        case history
        case people
    }

    @State private var selectedTab: Tab = .overview

    var body: some View {
        VStack {
            // Content area changes with selected tab
            Group {
                switch selectedTab {
                case .overview:
                    MovieOverviewView(movie: movie)

                case .files:
                    Text("Files - Coming soon")
                        .foregroundColor(.secondary)

                case .history:
                    Text("History - Coming soon")
                        .foregroundColor(.secondary)

                case .people:
                    Text("Cast & Crew - Coming soon")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.platformSecondaryGroupedBackground)
        }
        .toolbar {
            ToolbarItemGroup(placement: .platformBottom) {
                Button(action: { selectedTab = .overview }, label: {
                    Label("Overview", systemImage: "list.bullet")
                })

                Spacer()

                Button(action: { selectedTab = .files }, label: {
                    Label("Files", systemImage: "doc.on.doc")
                })

                Button(action: { selectedTab = .history }, label: {
                    Label("History", systemImage: "clock.arrow.circlepath")
                })

                Button(action: { selectedTab = .people }, label: {
                    Label("People", systemImage: "person.crop.circle")
                })
            }
        }
        .navigationTitle(movie.title)
    }
}

#Preview {
    NavigationStack {
        MoviePrototypeDetailView(movie: Movie.sample[0])
    }
}
