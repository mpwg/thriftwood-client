//
//  MovieHistoryView.swift
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
//  MovieHistoryView.swift
//  PrototypeGUI
//

import SwiftUI

struct MovieHistoryView: View {
    let movie: Movie

    // Local history model for UI rendering
    // Entries are provided by sampledata to keep real code free of sample data
    private let entries: [HistoryEntry]

    @State private var expandedIDs: Set<UUID>

    init(movie: Movie) {
        self.movie = movie
        // Bind entries from external sample store; default to empty if not provided
        if let sample = (movieFilesSampleHistory[movie.title] ?? sampleHistoryEntries) as [HistoryEntry]? {
            self.entries = sample
        } else {
            self.entries = []
        }

        // default: expand the first entry when available
        if let first = entries.first {
            _expandedIDs = State(initialValue: [first.id])
        } else {
            _expandedIDs = State(initialValue: [])
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: UIConstants.Spacing.large) {
                ForEach(Array(entries.enumerated()), id: \.1.id) { index, entry in
                    MovieHistoryRow(entry: entry, initiallyExpanded: index == 0)
                        .padding(.horizontal, UIConstants.Padding.screen)
                }
            }
            .padding(.vertical)
        }
        // onAppear no longer needed because initial state is set in init
    }

    // MARK: - Subviews to simplify type-checking

}
#Preview(traits: .sizeThatFitsLayout) {
    MovieHistoryView(movie: Movie.sample[0])
        .padding()
}
