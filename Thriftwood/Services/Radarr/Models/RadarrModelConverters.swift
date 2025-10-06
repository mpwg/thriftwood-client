//
//  RadarrModelConverters.swift
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
//  RadarrModelConverters.swift
//  Thriftwood
//
//  Converters between OpenAPI-generated types and domain models
//

import Foundation
import RadarrAPI

// MARK: - MovieStatusType Conversion

extension MovieStatusType {
    /// Convert OpenAPI MovieStatusType to domain MovieStatus
    func toDomainStatus() -> MovieStatus {
        switch self {
        case .tba:
            return .tba
        case .announced:
            return .announced
        case .incinemas:
            return .inCinemas
        case .released:
            return .released
        case .deleted:
            return .deleted
        case .unknownDefaultOpenApi:
            return .announced  // Default fallback
        }
    }
}

extension MovieStatus {
    /// Convert domain MovieStatus to OpenAPI MovieStatusType
    func toAPIStatus() -> MovieStatusType {
        switch self {
        case .tba:
            return .tba
        case .announced:
            return .announced
        case .inCinemas:
            return .incinemas
        case .released:
            return .released
        case .deleted:
            return .deleted
        }
    }
}

// MARK: - MovieResource Conversion

extension MovieResource {
    /// Convert OpenAPI MovieResource to domain Movie
    func toDomainModel() -> Movie? {
        guard let id = self.id,
              let title = self.title else {
            return nil
        }
        
        return Movie(
            id: id,
            title: title,
            overview: self.overview,
            releaseDate: self.releaseDate,
            posterURL: self.remotePoster.flatMap { URL(string: $0) },
            year: self.year,
            tmdbId: self.tmdbId,
            imdbId: self.imdbId,
            hasFile: self.hasFile ?? false,
            monitored: self.monitored ?? false,
            qualityProfileId: self.qualityProfileId,
            path: self.path,
            rootFolderPath: self.rootFolderPath,
            sizeOnDisk: self.sizeOnDisk ?? 0,
            status: self.status?.toDomainStatus() ?? .announced,
            genres: self.genres ?? [],
            runtime: self.runtime,
            certification: self.certification
        )
    }
    
    /// Convert OpenAPI MovieResource to domain MovieSearchResult
    func toSearchResult() -> MovieSearchResult? {
        guard let id = self.id,
              let title = self.title else {
            return nil
        }
        
        return MovieSearchResult(
            id: id,
            title: title,
            overview: self.overview,
            year: self.year,
            tmdbId: self.tmdbId,
            imdbId: self.imdbId,
            posterURL: self.remotePoster.flatMap { URL(string: $0) },
            isExisting: self.hasFile ?? false
        )
    }
}

// MARK: - Movie to MovieResource Conversion

extension Movie {
    /// Convert domain Movie to OpenAPI MovieResource
    func toMovieResource() -> MovieResource {
        var resource = MovieResource()
        resource.id = self.id
        resource.title = self.title
        resource.year = self.year
        resource.overview = self.overview
        resource.monitored = self.monitored
        resource.hasFile = self.hasFile
        resource.path = self.path
        resource.qualityProfileId = self.qualityProfileId
        resource.sizeOnDisk = self.sizeOnDisk
        resource.status = self.status.toAPIStatus()
        resource.tmdbId = self.tmdbId
        resource.imdbId = self.imdbId
        resource.genres = self.genres
        resource.runtime = self.runtime
        resource.certification = self.certification
        resource.rootFolderPath = self.rootFolderPath
        return resource
    }
}

// MARK: - AddMovieRequest to MovieResource Conversion

extension AddMovieRequest {
    /// Convert domain AddMovieRequest to OpenAPI MovieResource
    func toMovieResource() -> MovieResource {
        var resource = MovieResource()
        resource.tmdbId = self.tmdbId
        resource.title = self.title
        resource.year = self.year
        resource.qualityProfileId = self.qualityProfileId
        resource.rootFolderPath = self.rootFolderPath
        resource.monitored = self.monitored
        resource.minimumAvailability = self.minimumAvailability.toAPIStatus()
        
        // Convert tags from [Int]? to Set<Int>?
        if let tags = self.tags {
            resource.tags = Set(tags)
        }
        
        // Add options for search
        var addOptions = AddMovieOptions()
        addOptions.searchForMovie = self.searchForMovie
        resource.addOptions = addOptions
        
        return resource
    }
}

// MARK: - QualityProfileResource Conversion

extension QualityProfileResource {
    /// Convert OpenAPI QualityProfileResource to domain QualityProfile
    func toDomainModel() -> QualityProfile? {
        guard let id = self.id,
              let name = self.name,
              let cutoff = self.cutoff else {
            return nil
        }
        
        return QualityProfile(
            id: id,
            name: name,
            upgradeAllowed: self.upgradeAllowed ?? false,
            cutoff: cutoff
        )
    }
}

// MARK: - RootFolderResource Conversion

extension RootFolderResource {
    /// Convert OpenAPI RootFolderResource to domain RootFolder
    func toDomainModel() -> RootFolder? {
        guard let id = self.id,
              let path = self.path else {
            return nil
        }
        
        return RootFolder(
            id: id,
            path: path,
            accessible: self.accessible ?? false,
            freeSpace: self.freeSpace ?? 0,
            totalSpace: 0  // Not provided by API, calculate if needed
        )
    }
}

// MARK: - SystemResource Conversion

extension SystemResource {
    /// Convert OpenAPI SystemResource to domain SystemStatus
    func toDomainModel() -> SystemStatus? {
        guard let version = self.version,
              let osName = self.osName,
              let osVersion = self.osVersion,
              let branch = self.branch,
              let runtimeVersion = self.runtimeVersion,
              let runtimeName = self.runtimeName,
              let startupPath = self.startupPath,
              let appData = self.appData else {
            return nil
        }
        
        // Convert enum types to strings
        let authString: String
        if let auth = self.authentication {
            authString = "\(auth)"  // Convert enum to string
        } else {
            authString = "none"
        }
        
        let sqliteVersionString = self.databaseVersion ?? "unknown"
        
        return SystemStatus(
            version: version,
            buildTime: self.buildTime,
            isDebug: self.isDebug ?? false,
            isProduction: self.isProduction ?? false,
            isAdmin: self.isAdmin ?? false,
            isUserInteractive: self.isUserInteractive ?? false,
            startupPath: startupPath,
            appData: appData,
            osName: osName,
            osVersion: osVersion,
            isMonoRuntime: false,  // Not in API v3
            isMono: false,  // Not in API v3
            isLinux: self.isLinux ?? false,
            isOsx: self.isOsx ?? false,
            isWindows: self.isWindows ?? false,
            branch: branch,
            authentication: authString,
            sqliteVersion: sqliteVersionString,
            urlBase: self.urlBase,
            runtimeVersion: runtimeVersion,
            runtimeName: runtimeName
        )
    }
}
