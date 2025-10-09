//
//  MovieOverviewView.swift
//  PrototypeGUI
//

import SwiftUI

struct MovieOverviewView: View {
    let movie: Movie
    
    var body: some View {
        
        ScrollView{
            HStack(alignment: .top, spacing: 12) {
                (movie.poster ?? Image(systemName: "photo"))
                    .resizable()
                    .frame(width: 72, height: 108)
                    .cornerRadius(8)

//                VStack(alignment: .leading, spacing: 8) {
//                    Text(movie.title)
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.primary)

                    if let overview = movie.overview {
                        Text(overview)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
//                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
            VStack(spacing: 18) {
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
        HStack(spacing: 18) {
            Button(action: {}) { Label("Automatic", systemImage: "magnifyingglass") }

            Spacer()

            Button(action: {}) { Label("Interactive", systemImage: "person.fill") }
        }
        
        
        
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MovieOverviewView(movie: Movie.sample[0])
        .padding()
}
