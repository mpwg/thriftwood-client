//
//  Movie.swift
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

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let year: String
    let runtime: String
    let studio: String
    let details: String
    let size: String
    let poster: Image?
    let overview: String?
    let monitoring: Bool?
    let path: String?
    let quality: String?
    let availability: String?
    let status: String?
    let inCinemas: String?
    let digital: String?
    let physical: String?
    let addedOn: String?
    let tags: [String]?
    let rating: String?
    let genres: [String]?
    let alternateTitles: [String]?
    let files: [MovieFile]?
    let cast: [Person]?

    // Explicit initializer so sample data can pass a subset of fields by name
    init(
        title: String,
        year: String,
        runtime: String,
        studio: String,
        details: String,
        size: String,
        poster: Image? = nil,
        overview: String? = nil,
        monitoring: Bool? = nil,
        path: String? = nil,
        quality: String? = nil,
        availability: String? = nil,
        status: String? = nil,
        inCinemas: String? = nil,
        digital: String? = nil,
        physical: String? = nil,
        addedOn: String? = nil,
        tags: [String]? = nil,
        rating: String? = nil,
        genres: [String]? = nil,
        alternateTitles: [String]? = nil,
        files: [MovieFile]? = nil,
        cast: [Person]? = nil
    ) {
        self.title = title
        self.year = year
        self.runtime = runtime
        self.studio = studio
        self.details = details
        self.size = size
        self.poster = poster
        self.overview = overview
        self.monitoring = monitoring
        self.path = path
        self.quality = quality
        self.availability = availability
        self.status = status
        self.inCinemas = inCinemas
        self.digital = digital
        self.physical = physical
        self.addedOn = addedOn
        self.tags = tags
        self.rating = rating
        self.genres = genres
        self.alternateTitles = alternateTitles
        self.files = files
        self.cast = cast
    }

    /// Lightweight Person model for cast/crew
    struct Person: Identifiable {
        let id = UUID()
        let name: String
        let role: String
        let isCast: Bool
    }
}
