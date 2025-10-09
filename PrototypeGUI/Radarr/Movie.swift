//
//  Movie.swift
//  PrototypeGUI
//
//  Created by Matthias Wallner-Géhri on 07.10.25.
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
    // Cast & crew for the movie (used in previews and detail views)
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
        alternateTitles: [String]? = nil
        ,
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

    // Lightweight Person model for cast/crew
    struct Person: Identifiable {
        let id = UUID()
        let name: String
        let role: String
        let isCast: Bool
    }
}
