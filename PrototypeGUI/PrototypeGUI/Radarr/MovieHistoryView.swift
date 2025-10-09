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
            VStack(spacing: 16) {
                ForEach(Array(entries.enumerated()), id: \ .1.id) { index, entry in
                    MovieHistoryRow(entry: entry, initiallyExpanded: index == 0)
                        .padding(.horizontal)
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

