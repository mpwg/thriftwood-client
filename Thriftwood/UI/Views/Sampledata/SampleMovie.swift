//
//  SampleMovie.swift
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
import Foundation

// Anonymized sample movie entries used across previews
// Generates 50 plausible (non-real) movie entries programmatically.
extension Movie {
    // Pool of unique people (cast & crew). At least 30 unique names.
    static let samplePeople: [Movie.Person] = [
        Movie.Person(name: "Alex Carter", role: "Director", isCast: false),
        Movie.Person(name: "Rosa Delgado", role: "Producer", isCast: false),
        Movie.Person(name: "Min-ji Park", role: "Writer", isCast: false),
        Movie.Person(name: "Samir Khan", role: "Cinematographer", isCast: false),
        Movie.Person(name: "Hannah Li", role: "Editor", isCast: false),
        Movie.Person(name: "Jonas Meyer", role: "Composer", isCast: false),
        Movie.Person(name: "Priya Nair", role: "Costume Designer", isCast: false),
        Movie.Person(name: "Ethan Brooks", role: "Lead", isCast: true),
        Movie.Person(name: "Maya Rossi", role: "Lead", isCast: true),
        Movie.Person(name: "Luca Bianchi", role: "Supporting", isCast: true),
        Movie.Person(name: "Zoe Anders", role: "Supporting", isCast: true),
        Movie.Person(name: "Omar Aziz", role: "Supporting", isCast: true),
        Movie.Person(name: "Nora Svensson", role: "Supporting", isCast: true),
        Movie.Person(name: "Diego Silva", role: "Supporting", isCast: true),
        Movie.Person(name: "Ava Thompson", role: "Supporting", isCast: true),
        Movie.Person(name: "Kai Nakamura", role: "Stunt Coordinator", isCast: false),
        Movie.Person(name: "Lena Kowalski", role: "Makeup Artist", isCast: false),
        Movie.Person(name: "Tomás Herrera", role: "Visual Effects", isCast: false),
        Movie.Person(name: "Yara Haddad", role: "Casting", isCast: false),
        Movie.Person(name: "Noah Green", role: "Actor", isCast: true),
        Movie.Person(name: "Isabella Cruz", role: "Actor", isCast: true),
        Movie.Person(name: "Felix Laurent", role: "Actor", isCast: true),
        Movie.Person(name: "Sofia Petrov", role: "Actor", isCast: true),
        Movie.Person(name: "Michael O'Neal", role: "Actor", isCast: true),
        Movie.Person(name: "Chen Wei", role: "Sound Mixer", isCast: false),
        Movie.Person(name: "Greta Müller", role: "Art Director", isCast: false),
        Movie.Person(name: "Ravi Shah", role: "Gaffer", isCast: false),
        Movie.Person(name: "Amara Okonkwo", role: "Production Design", isCast: false),
        Movie.Person(name: "Liam Walsh", role: "Actor", isCast: true),
        Movie.Person(name: "Zara Patel", role: "Actor", isCast: true),
        Movie.Person(name: "Hiro Tanaka", role: "Second Unit Director", isCast: false),
        Movie.Person(name: "Emilia Novak", role: "Script Supervisor", isCast: false),
        Movie.Person(name: "Victor Lopez", role: "Composer", isCast: false),
        Movie.Person(name: "Sana Amini", role: "Producer", isCast: false),
        Movie.Person(name: "Pedro Alvarez", role: "Actor", isCast: true),
        Movie.Person(name: "Marta Silva", role: "Actor", isCast: true),
        Movie.Person(name: "Igor Ivanov", role: "Stunts", isCast: false),
        Movie.Person(name: "Ella Brooks", role: "Lead", isCast: true),
    ]

    static let sample: [Movie] = {
        var movies: [Movie] = []

        let titles: [String] = [
            "Aurora Ridge", "Midnight Harbor", "Silent Atlas", "Glass Orchard", "Paper Lanterns",
            "Echo Gardens", "Neon Prairie", "Crimson Alley", "The Last Sextant", "River & Stone",
            "Winter's Ledger", "Sunless City", "Wanderlight", "The Quiet Draft", "Omega Station",
            "Bronze Skies", "Palace of Threads", "Velvet Compass", "Coal & Sea", "Harbor of Ash",
            "Maple & Iron", "Northern Bloom", "The Lantern Boat", "Hidden Meridian", "October Harbor",
            "The Long Field", "Second Horizon", "Mercury Lane", "Moonflower", "The Archivist",
            "Paper Moons", "Trailing Smoke", "Glass Harbor", "Blue Orchard", "Falling Anchor",
            "Sable Crossing", "Cerulean Road", "Twilight Engine", "The Gentle Quarry", "Crane's Hollow",
            "Salt & Cypress", "Old Thread", "Marrow of Day", "Silent Cartographers", "Lonesome Atlas",
            "Peregrine Road", "The Small Beacon", "Cinder & Pine", "Verdant Hollow", "Echo of Glass"
        ]

        let studios = ["Northlight Studios", "Harbor Lane Pictures", "Aster Filmworks", "Granite Road Media", "Indigo Forge"]
        let genreSets: [[String]] = [
            ["Drama"], ["Drama","Romance"], ["Thriller","Mystery"], ["Science Fiction"], ["Adventure","Drama"],
            ["Documentary"], ["Family"], ["Fantasy"], ["Animation"], ["Crime","Thriller"]
        ]

        for (index, title) in titles.enumerated() {
            let year = String(1990 + (index % 36))
            let minutes = 80 + ((index * 13) % 61) // between 80 and 140
            let hours = minutes / 60
            let mins = minutes % 60
            let runtime = "\(hours)h \(mins)m"
            let studio = studios[index % studios.count]
            let details = "WEB-1080p · Released · Added sample"
            let size = "\(2 + (index % 6)).\((index * 7) % 10) GB"
            let poster = Image(systemName: "film")
            let overview = "\(title) is a character-driven story set against a shifting landscape. Inventive, intimate and visually rich."
            let monitoring = (index % 3 == 0) ? true : false
            let path = "/data/media/Films/\(title) (\(year))"
            let quality = (index % 4 == 0) ? "Remux" : "WEB-1080p"
            let availability = "Released"
            let status = "Released"
            let inCinemas = "June \((index % 28) + 1), \(year)"
            let digital = "September \((index % 28) + 1), \(year)"
            let physical = "December \((index % 28) + 1), \(year)"
            let addedOn = "Sample Added"
            let tags: [String]? = (index % 5 == 0) ? ["indie","festival"] : nil
            let rating = String(10 + (index % 80))
            let genres = genreSets[index % genreSets.count]
            let alternateTitles: [String]? = (index % 6 == 0) ? ["\(title): Director's Cut"] : nil

            // Create 5 files per movie
            var files: [MovieFile] = []
            for fileIndex in 1...5 {
                let rel = "\(title) (\(year)) [part\(fileIndex)].mkv"
                let fileSize = "\(1 + ((index + fileIndex) % 7)).\((index * fileIndex) % 10) GB"
                let mf = MovieFile(
                    relativePath: rel,
                    type: "Video",
                    extension: ".mkv",
                    size: fileSize,
                    video: (fileIndex % 2 == 0) ? "x265" : "x264",
                    audio: (fileIndex % 3 == 0) ? "Dolby Atmos" : "AAC • 5.1",
                    languages: ["English"],
                    quality: quality,
                    formats: ["1080p"],
                    addedOn: Date()
                )
                files.append(mf)
            }

            // Assign cast & crew: pick a small set from samplePeople
            var cast: [Movie.Person] = []
            let people = Movie.samplePeople
            let start = (index * 3) % people.count
            for j in 0..<6 {
                let p = people[(start + j) % people.count]
                // Create a specific role per movie for clarity
                let role: String
                if j == 0 { role = "Director" }
                else if j == 1 { role = "Producer" }
                else if j == 2 { role = "Writer" }
                else { role = "\(p.role)" }
                let person = Movie.Person(name: p.name, role: role, isCast: j >= 3)
                cast.append(person)
            }

            let movie = Movie(
                title: title,
                year: year,
                runtime: runtime,
                studio: studio,
                details: details,
                size: size,
                poster: poster,
                overview: overview,
                monitoring: monitoring,
                path: path,
                quality: quality,
                availability: availability,
                status: status,
                inCinemas: inCinemas,
                digital: digital,
                physical: physical,
                addedOn: addedOn,
                tags: tags,
                rating: rating,
                genres: genres,
                alternateTitles: alternateTitles,
                files: files,
                cast: cast
            )

            movies.append(movie)
        }

        return movies
    }()
}
