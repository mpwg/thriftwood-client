//
//  MovieFilesView.swift
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
//  MovieFilesView.swift
//  PrototypeGUI
//

import SwiftUI

struct MovieFilesView: View {
    let movie: Movie
    // fallback sample files when movie has no files
    private var files: [MovieFile] {
        // try reading from movie.files if available; else use samples
        if let mfiles = movie.files, !mfiles.isEmpty {
            return mfiles
        }
        return [MovieFile.sample1, MovieFile.sample2, MovieFile.sample3]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: UIConstants.Spacing.large) {
                // Top block: show the main movie detail card for the primary file
                if let primary = files.first(where: { $0.video != nil }) ?? files.first {
                    MovieFileDetail(file: primary)
                }

                // Remaining files as compact rows
                ForEach(files.dropFirst(), id: \.self) { file in
                    MovieFileCompactRow(file: file)
                }
            }
            .padding(.vertical)
        }
    }
}

// If Movie.sample exists in the project, keep the original preview usage otherwise provide a basic preview
#Preview(traits: .sizeThatFitsLayout) {
    MovieFilesView(movie: Movie.sample[0])
        .padding()
}

struct MovieFilesView_Previews: PreviewProvider {
    static var previews: some View {
        let movieWithFiles = Movie(
            title: "Preview Movie",
            year: "2025",
            runtime: "1h 40m",
            studio: "Studio",
            details: "Details",
            size: "4.4 GB",
            poster: Image(systemName: "photo"),
            files: [MovieFile.sample1, MovieFile.sample2, MovieFile.sample3]
        )

        return MovieFilesView(movie: movieWithFiles)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
