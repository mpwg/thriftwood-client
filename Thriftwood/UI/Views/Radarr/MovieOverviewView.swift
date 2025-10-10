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
//
//  MovieOverviewView.swift
//  PrototypeGUI
//

import SwiftUI

struct MovieOverviewView: View {
    let movie: Movie
    
    var body: some View {
        
        ScrollView {
            HStack(alignment: .top, spacing: UIConstants.Spacing.medium) {
                (movie.poster ?? Image(systemName: "photo"))
                    .resizable()
                    .frame(
                        width: UIConstants.ImageSize.posterSmall.width,
                        height: UIConstants.ImageSize.posterSmall.height
                    )
                    .cornerRadius(UIConstants.CornerRadius.small)

                if let overview = movie.overview {
                    Text(overview)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
            .padding(UIConstants.Padding.card)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .fill(Color.platformSecondaryGroupedBackground)
            )
            VStack(spacing: UIConstants.Spacing.extraLarge) {
                if let monitoring = movie.monitoring {
                    HStack {
                        Text("MONITORING")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(monitoring ? "Yes" : "No")
                    }
                }
                
                if let path = movie.path {
                    HStack(alignment: .top) {
                        Text("PATH")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(path)
                            .multilineTextAlignment(.trailing)
                            .font(.subheadline)
                    }
                }
                
                if let quality = movie.quality {
                    HStack {
                        Text("QUALITY")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(quality)
                    }
                }
                
                if let availability = movie.availability {
                    HStack {
                        Text("AVAILABILITY")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(availability)
                    }
                }
                
                if let status = movie.status {
                    HStack {
                        Text("STATUS")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(status)
                    }
                }
                
                if let inCinemas = movie.inCinemas {
                    HStack {
                        Text("IN CINEMAS")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(inCinemas)
                    }
                }
                
                if let digital = movie.digital {
                    HStack {
                        Text("DIGITAL")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(digital)
                    }
                }
                
                if let physical = movie.physical {
                    HStack {
                        Text("PHYSICAL")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(physical)
                    }
                }
                
                if let addedOn = movie.addedOn {
                    HStack {
                        Text("ADDED ON")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(addedOn)
                    }
                }
            }
            // Secondary block: year / studio / runtime / rating
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("YEAR").foregroundColor(.secondary)
                    Text("STUDIO").foregroundColor(.secondary)
                    Text("RUNTIME").foregroundColor(.secondary)
                    Text("RATING").foregroundColor(.secondary)
                    Text("GENRES").foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text(movie.year)
                    Text(movie.studio)
                    Text(movie.runtime)
                    Text(movie.rating ?? "—")
                    if let genres = movie.genres {
                        VStack(alignment: .trailing, spacing: 2) {
                            ForEach(genres, id: \.self) { g in
                                Text(g)
                            }
                        }
                    } else {
                        Text("—")
                    }
                }
            }
            
            // Alternate titles
            if let alt = movie.alternateTitles {
                HStack(alignment: .top) {
                    Text("ALTERNATE\\nTITLES")
                        .foregroundColor(.secondary)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        ForEach(alt, id: \.self) { a in
                            Text(a)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
        }
        // Bottom toolbar mimicking screenshot
        HStack(spacing: UIConstants.Spacing.extraLarge) {
            Button(action: {}, label: {
                Label("Automatic", systemImage: SystemIcon.search)
            })

            Spacer()

            Button(action: {}, label: {
                Label("Interactive", systemImage: SystemIcon.person)
            })
        }
        .padding(UIConstants.Padding.card)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                .fill(Color.platformSecondaryGroupedBackground)
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MovieOverviewView(movie: Movie.sample[0])
        .padding()
}
