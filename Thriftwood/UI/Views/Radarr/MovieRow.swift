//
//  MovieRow.swift
//  PrototypeGUI
//
//  Created by Matthias Wallner-Géhri on 07.10.25.
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