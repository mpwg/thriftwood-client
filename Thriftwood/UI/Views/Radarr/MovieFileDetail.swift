//
//  MovieFileDetail.swift
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

struct MovieFileDetail: View {
    let file: MovieFile

    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            VStack(alignment: .center, spacing: UIConstants.Spacing.medium) {
                // center-aligned details like the screenshot
                VStack(alignment: .center, spacing: UIConstants.Spacing.small) {
                    HStack(alignment: .top) {
                        Text("RELATIVE PATH")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 96, alignment: .leading)

                        Text(file.relativePath)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }

                    if let video = file.video {
                        labeledRow(title: "VIDEO", value: video)
                    }
                    if let audio = file.audio {
                        labeledRow(title: "AUDIO", value: audio)
                    }
                    if let size = file.size {
                        labeledRow(title: "SIZE", value: size)
                    }
                    if let languages = file.languages {
                        labeledColumn(title: "LANGUAGES", values: languages)
                    }
                    if let quality = file.quality {
                        labeledRow(title: "QUALITY", value: quality)
                    }
                    if let formats = file.formats {
                        labeledColumn(title: "FORMATS", values: formats)
                    }
                    if let added = file.addedOn {
                        VStack(spacing: 2) {
                            Text("ADDED ON")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(added, style: .date)
                                .font(.subheadline)
                            Text(added, style: .time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                HStack(spacing: UIConstants.Spacing.medium) {
                    Button(action: {}, label: {
                        Label("Media Info", systemImage: SystemIcon.info)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)

                    Button(role: .destructive, action: {}, label: {
                        Label("Delete", systemImage: SystemIcon.delete)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.bordered)
                }
            }
            .padding(UIConstants.Padding.screen)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .fill(Color.platformSecondaryGroupedBackground)
            )
        }
        .padding(.horizontal, UIConstants.Padding.screen)
    }

    @ViewBuilder
    private func labeledRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 96, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
        }
    }

    @ViewBuilder
    private func labeledColumn(title: String, values: [String]) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 96, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                ForEach(values, id: \.self) { value in
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }

            Spacer()
        }
    }
}

struct MovieFileDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieFileDetail(file: .sample1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
