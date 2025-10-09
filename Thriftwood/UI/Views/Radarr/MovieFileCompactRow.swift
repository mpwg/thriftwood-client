//
//  MovieFileCompactRow.swift
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

struct MovieFileCompactRow: View {
    let file: MovieFile

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.primary.opacity(0.06))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "doc"))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("RELATIVE PATH")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(file.relativePath)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("TYPE")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(file.type)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }

                HStack {
                    Text("EXTENSION")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(file.extension)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }

        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.platformSecondaryGroupedBackground))
        .padding(.horizontal)
    }
}

struct MovieFileCompactRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            MovieFileCompactRow(file: .sample2)
            MovieFileCompactRow(file: .sample3)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
