//
//  MovieDisplayModel.swift
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

import Foundation

/// Display model for movie data in UI views
///
/// This model decouples the UI from the RadarrAPI domain models,
/// following MVVM-C architecture. The ViewModel is responsible for
/// converting `MovieResource` to `MovieDisplayModel`.
struct MovieDisplayModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let year: Int?
    let overview: String?
    let runtime: Int?
    let posterURL: URL?
    let backdropURL: URL?
    let monitored: Bool
    let hasFile: Bool
    let qualityProfileId: Int?
    let qualityProfileName: String?
    let rating: Double?
    let certification: String?
    let genres: [String]
    let studio: String?
    let dateAdded: Date?
    
    // MARK: - Initialization
    
    init(
        id: Int,
        title: String,
        year: Int? = nil,
        overview: String? = nil,
        runtime: Int? = nil,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        monitored: Bool = false,
        hasFile: Bool = false,
        qualityProfileId: Int? = nil,
        qualityProfileName: String? = nil,
        rating: Double? = nil,
        certification: String? = nil,
        genres: [String] = [],
        studio: String? = nil,
        dateAdded: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.overview = overview
        self.runtime = runtime
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.monitored = monitored
        self.hasFile = hasFile
        self.qualityProfileId = qualityProfileId
        self.qualityProfileName = qualityProfileName
        self.rating = rating
        self.certification = certification
        self.genres = genres
        self.studio = studio
        self.dateAdded = dateAdded
    }
    
    // MARK: - Computed Properties
    
    /// Formatted year string for display
    var yearText: String? {
        guard let year = year else { return nil }
        return String(year)
    }
    
    /// Formatted runtime string (e.g., "2h 16m")
    /// Uses localized time formatting for hours and minutes
    var runtimeText: String? {
        guard let runtime = runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        
        if hours > 0 && minutes > 0 {
            // Use String(localized:) with explicit format specifiers for String Catalog
            return String(localized: "runtime.hours_minutes", 
                         defaultValue: "\(hours)h \(minutes)m",
                         comment: "Runtime format with hours and minutes (e.g., '2h 16m')")
        } else if hours > 0 {
            return String(localized: "runtime.hours_only",
                         defaultValue: "\(hours)h",
                         comment: "Runtime format with hours only (e.g., '2h')")
        } else {
            return String(localized: "runtime.minutes_only",
                         defaultValue: "\(minutes)m",
                         comment: "Runtime format with minutes only (e.g., '45m')")
        }
    }
    
    /// Short runtime text for compact displays (e.g., "136min")
    /// Uses localized minute format
    var shortRuntimeText: String? {
        guard let runtime = runtime, runtime > 0 else { return nil }
        return String(localized: "runtime.short_format",
                     defaultValue: "\(runtime)min",
                     comment: "Short runtime format in minutes (e.g., '136min')")
    }
    
    /// Status text for accessibility
    /// Returns localized download status
    var statusText: String {
        if hasFile {
            return String(localized: "movie.status.downloaded", 
                         defaultValue: "Downloaded",
                         comment: "Movie status: file has been downloaded")
        } else {
            return String(localized: "movie.status.missing",
                         defaultValue: "Missing",
                         comment: "Movie status: file is missing")
        }
    }
    
    /// Monitoring status text
    /// Returns localized monitoring status
    var monitoringText: String {
        return monitored 
            ? String(localized: "movie.monitoring.monitored",
                    defaultValue: "Monitored",
                    comment: "Movie is being monitored for downloads")
            : String(localized: "movie.monitoring.unmonitored",
                    defaultValue: "Unmonitored",
                    comment: "Movie is not being monitored")
    }
    
    /// Formatted rating text (e.g., "8.7")
    /// Uses locale-appropriate number formatting
    var ratingText: String? {
        guard let rating = rating else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: rating))
    }
    
    /// Genres as comma-separated string
    /// Uses locale-appropriate list separator
    var genresText: String? {
        guard !genres.isEmpty else { return nil }
        let formatter = ListFormatter()
        formatter.locale = Locale.current
        return formatter.string(from: genres)
    }
}

// MARK: - Preview Helpers

extension MovieDisplayModel {
    /// Sample movie for previews
    static let preview = MovieDisplayModel(
        id: 1,
        title: "The Matrix",
        year: 1999,
        overview: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.",
        runtime: 136,
        posterURL: nil,
        backdropURL: nil,
        monitored: true,
        hasFile: true,
        qualityProfileId: 1,
        qualityProfileName: "HD-1080p",
        rating: 8.7,
        certification: "R",
        genres: ["Action", "Science Fiction"],
        studio: "Warner Bros."
    )
    
    /// Sample movie with missing file
    static let previewMissing = MovieDisplayModel(
        id: 2,
        title: "Inception",
        year: 2010,
        overview: "A thief who steals corporate secrets through the use of dream-sharing technology.",
        runtime: 148,
        posterURL: nil,
        backdropURL: nil,
        monitored: true,
        hasFile: false,
        qualityProfileId: 1,
        qualityProfileName: "HD-1080p",
        rating: 8.8,
        certification: "PG-13",
        genres: ["Action", "Science Fiction", "Thriller"],
        studio: "Warner Bros."
    )
    
    /// Sample unmonitored movie
    static let previewUnmonitored = MovieDisplayModel(
        id: 3,
        title: "The Dark Knight",
        year: 2008,
        overview: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham.",
        runtime: 152,
        posterURL: nil,
        backdropURL: nil,
        monitored: false,
        hasFile: true,
        qualityProfileId: 2,
        qualityProfileName: "4K",
        rating: 9.0,
        certification: "PG-13",
        genres: ["Action", "Crime", "Drama"],
        studio: "Warner Bros."
    )
}
