//
//  RadarrModels.swift
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
//  RadarrModels.swift
//  Thriftwood
//
//  Domain models for Radarr service
//

import Foundation

// MARK: - Movie Model

/// Represents a movie in Radarr
struct Movie: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let overview: String?
    let releaseDate: Date?
    let posterURL: URL?
    
    // Radarr-specific fields
    let year: Int?
    let tmdbId: Int?
    let imdbId: String?
    let hasFile: Bool
    let monitored: Bool
    let qualityProfileId: Int?
    let rootFolderPath: String?
    let sizeOnDisk: Int64
    let status: MovieStatus
    let genres: [String]
    let runtime: Int?
    let certification: String?
    
    init(
        id: String,
        title: String,
        overview: String? = nil,
        releaseDate: Date? = nil,
        posterURL: URL? = nil,
        year: Int? = nil,
        tmdbId: Int? = nil,
        imdbId: String? = nil,
        hasFile: Bool = false,
        monitored: Bool = true,
        qualityProfileId: Int? = nil,
        rootFolderPath: String? = nil,
        sizeOnDisk: Int64 = 0,
        status: MovieStatus = .announced,
        genres: [String] = [],
        runtime: Int? = nil,
        certification: String? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterURL = posterURL
        self.year = year
        self.tmdbId = tmdbId
        self.imdbId = imdbId
        self.hasFile = hasFile
        self.monitored = monitored
        self.qualityProfileId = qualityProfileId
        self.rootFolderPath = rootFolderPath
        self.sizeOnDisk = sizeOnDisk
        self.status = status
        self.genres = genres
        self.runtime = runtime
        self.certification = certification
    }
}

/// Movie availability status in Radarr
enum MovieStatus: String, Codable, Sendable {
    case tba
    case announced
    case inCinemas
    case released
    case deleted
}

// MARK: - Movie Search Result

/// Represents a movie search result from Radarr
struct MovieSearchResult: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let overview: String?
    let year: Int?
    let tmdbId: Int?
    let imdbId: String?
    let posterURL: URL?
    let isExisting: Bool
    
    init(
        id: String,
        title: String,
        overview: String? = nil,
        year: Int? = nil,
        tmdbId: Int? = nil,
        imdbId: String? = nil,
        posterURL: URL? = nil,
        isExisting: Bool = false
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.year = year
        self.tmdbId = tmdbId
        self.imdbId = imdbId
        self.posterURL = posterURL
        self.isExisting = isExisting
    }
}

// MARK: - Add Movie Request

/// Request model for adding a new movie to Radarr
struct AddMovieRequest: Sendable {
    let tmdbId: Int
    let title: String
    let year: Int?
    let qualityProfileId: Int
    let rootFolderPath: String
    let monitored: Bool
    let searchForMovie: Bool
    let minimumAvailability: MovieStatus
    
    init(
        tmdbId: Int,
        title: String,
        year: Int? = nil,
        qualityProfileId: Int,
        rootFolderPath: String,
        monitored: Bool = true,
        searchForMovie: Bool = true,
        minimumAvailability: MovieStatus = .announced
    ) {
        self.tmdbId = tmdbId
        self.title = title
        self.year = year
        self.qualityProfileId = qualityProfileId
        self.rootFolderPath = rootFolderPath
        self.monitored = monitored
        self.searchForMovie = searchForMovie
        self.minimumAvailability = minimumAvailability
    }
}

// MARK: - Quality Profile

/// Represents a quality profile in Radarr
struct QualityProfile: Identifiable, Codable, Sendable {
    let id: String
    let name: String
    let upgradeAllowed: Bool
    let cutoff: Int
    
    init(
        id: String,
        name: String,
        upgradeAllowed: Bool = true,
        cutoff: Int
    ) {
        self.id = id
        self.name = name
        self.upgradeAllowed = upgradeAllowed
        self.cutoff = cutoff
    }
}

// MARK: - Root Folder

/// Represents a root folder in Radarr
struct RootFolder: Identifiable, Codable, Sendable {
    let id: String
    let path: String
    let accessible: Bool
    let freeSpace: Int64
    let totalSpace: Int64
    
    init(
        id: String,
        path: String,
        accessible: Bool = true,
        freeSpace: Int64 = 0,
        totalSpace: Int64 = 0
    ) {
        self.id = id
        self.path = path
        self.accessible = accessible
        self.freeSpace = freeSpace
        self.totalSpace = totalSpace
    }
}

// MARK: - System Status

/// Represents Radarr system status
struct SystemStatus: Codable, Sendable {
    let version: String
    let buildTime: Date?
    let isDebug: Bool
    let isProduction: Bool
    let isAdmin: Bool
    let isUserInteractive: Bool
    let startupPath: String
    let appData: String
    let osName: String
    let osVersion: String
    let isMonoRuntime: Bool
    let isMono: Bool
    let isLinux: Bool
    let isOsx: Bool
    let isWindows: Bool
    let branch: String
    let authentication: String
    let sqliteVersion: String
    let urlBase: String?
    let runtimeVersion: String
    let runtimeName: String
    
    init(
        version: String,
        buildTime: Date? = nil,
        isDebug: Bool = false,
        isProduction: Bool = true,
        isAdmin: Bool = false,
        isUserInteractive: Bool = false,
        startupPath: String = "",
        appData: String = "",
        osName: String = "",
        osVersion: String = "",
        isMonoRuntime: Bool = false,
        isMono: Bool = false,
        isLinux: Bool = false,
        isOsx: Bool = false,
        isWindows: Bool = false,
        branch: String = "",
        authentication: String = "none",
        sqliteVersion: String = "",
        urlBase: String? = nil,
        runtimeVersion: String = "",
        runtimeName: String = ""
    ) {
        self.version = version
        self.buildTime = buildTime
        self.isDebug = isDebug
        self.isProduction = isProduction
        self.isAdmin = isAdmin
        self.isUserInteractive = isUserInteractive
        self.startupPath = startupPath
        self.appData = appData
        self.osName = osName
        self.osVersion = osVersion
        self.isMonoRuntime = isMonoRuntime
        self.isMono = isMono
        self.isLinux = isLinux
        self.isOsx = isOsx
        self.isWindows = isWindows
        self.branch = branch
        self.authentication = authentication
        self.sqliteVersion = sqliteVersion
        self.urlBase = urlBase
        self.runtimeVersion = runtimeVersion
        self.runtimeName = runtimeName
    }
}
