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
//
//  MovieDetailView.swift
//  PrototypeGUI
//
//  Created by Matthias Wallner-Géhri on 07.10.25.
//

import SwiftUI

struct MovieDetailView: View {
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
                    MovieFilesView(movie: movie)

                case .history:
                    MovieHistoryView(movie: movie)

                case .people:
                    MovieCastCrewView(movie: movie)
                }
            }
            .padding()
            .background(Color.platformSecondaryGroupedBackground)

            // The toolbar was moved to the view's toolbar as a bottom bar
        }
        .toolbar {
            ToolbarItemGroup(placement: .platformBottom) {
                Button(action: { selectedTab = .overview }, label: {
                    Label("Overview", systemImage: SystemIcon.list)
                })

                Spacer()

                Button(action: { selectedTab = .files }, label: {
                    Label("Files", systemImage: SystemIcon.files)
                })

                Button(action: { selectedTab = .history }, label: {
                    Label("History", systemImage: SystemIcon.history)
                })

                Button(action: { selectedTab = .people }, label: {
                    Label("People", systemImage: SystemIcon.people)
                })
            }
        }
        .navigationTitle(movie.title)
    }
}

#Preview("Movie Detail") {
    NavigationStack {
        MovieDetailView(movie: Movie.sample[0])
    }
}
