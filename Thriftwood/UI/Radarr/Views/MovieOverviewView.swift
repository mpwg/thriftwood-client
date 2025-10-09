//
//  MovieOverviewView.swift
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

struct MovieOverviewView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header with poster and overview
                HStack(alignment: .top, spacing: 12) {
                    (movie.poster ?? Image(systemName: "photo"))
                        .resizable()
                        .frame(width: 72, height: 108)
                        .cornerRadius(8)

                    if let overview = movie.overview {
                        Text(overview)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
                
                // Movie details
                VStack(spacing: 16) {
                    DetailRow(label: "YEAR", value: movie.year)
                    DetailRow(label: "STUDIO", value: movie.studio)
                    DetailRow(label: "RUNTIME", value: movie.runtime)
                    if let rating = movie.rating {
                        DetailRow(label: "RATING", value: rating)
                    }
                    if let genres = movie.genres {
                        HStack(alignment: .top) {
                            Text("GENRES")
                                .foregroundColor(.secondary)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                ForEach(genres, id: \.self) { genre in
                                    Text(genre)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MovieOverviewView(movie: Movie.sample[0])
        .padding()
}
