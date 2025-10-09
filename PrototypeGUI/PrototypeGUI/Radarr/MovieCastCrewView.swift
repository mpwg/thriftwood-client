//
//  MovieCastCrewView.swift
//  PrototypeGUI
//

import SwiftUI

struct MovieCastCrewView: View {
    let movie: Movie

    // Local lightweight model for preview/sample rows. The view reads cast from the
    // movie's `cast` property (Movie.Person) when available.
    private struct PersonRow: Identifiable {
        let id = UUID()
        let name: String
        let role: String
        let isCast: Bool
    }

    // Use the movie's cast where available, otherwise fall back to an empty list
    private var samplePeopleRows: [PersonRow] {
        guard let cast = movie.cast else { return [] }
        return cast.map { person in
            PersonRow(name: person.name, role: person.role, isCast: person.isCast)
        }
    }

    // Explicit initializer so the view can be constructed without exposing private nested types
    init(movie: Movie) {
        self.movie = movie
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14, pinnedViews: []) {
                ForEach(samplePeopleRows) { person in
                    HStack(spacing: 14) {
                        // Avatar box (matches screenshot's rounded square avatar)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primary.opacity(0.08))
                            .frame(width: 56, height: 56)
                            .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.accentColor)
                                    .font(.system(size: 20))
                            )

                        VStack(alignment: .leading, spacing: 6) {
                            Text(person.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(person.role)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            // Tag (Cast / Crew)
                            Text(person.isCast ? "Cast" : "Crew")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(person.isCast ? Color.green : Color.orange)
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.platformSecondaryGroupedBackground)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MovieCastCrewView(movie: Movie.sample[0])
        .padding()
}
