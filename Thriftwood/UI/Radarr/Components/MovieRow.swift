//
//  MovieRow.swift
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

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            (movie.poster ?? Image(systemName: "photo"))
                .resizable()
                .frame(width: 64, height: 96)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text("\(movie.year) · \(movie.runtime) · \(movie.studio)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(movie.details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Image(systemName: "video.fill")
                        .foregroundColor(.orange)
                    Image(systemName: "record.circle")
                        .foregroundColor(.blue)
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.gray)
                    Text(movie.size)
                        .foregroundColor(.mint)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }

            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 12) {
        MovieRow(movie: Movie.sample[0])
        MovieRow(movie: Movie.sample[1])
    }
    .padding()
}
