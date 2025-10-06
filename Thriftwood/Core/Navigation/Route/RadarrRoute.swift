//
//  RadarrRoute.swift
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

/// Routes within the Radarr feature
/// Based on legacy Flutter app structure: Catalogue, Upcoming, Missing, More
enum RadarrRoute: Hashable, Sendable {
    /// Main movies list (Catalogue in legacy)
    case moviesList
    
    /// Movie detail view
    case movieDetail(movieId: Int)
    
    /// Add movie search view
    case addMovie(query: String = "")
    
    /// Radarr settings/configuration
    case settings
    
    /// System status
    case systemStatus
    
    /// Queue view (downloads in progress)
    case queue
    
    /// History view (past activity)
    case history
}

extension RadarrRoute: DeepLinkable {
    static func parse(from url: URL) -> RadarrRoute? {
        // For URLs like "thriftwood://radarr/movie/123", the host is "radarr"
        guard url.host == "radarr" else { return nil }
        
        // Path components include the leading "/", so we filter it out
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        // If no path components, it's the movies list route
        guard !pathComponents.isEmpty else { return .moviesList }
        
        switch pathComponents[0] {
        case "movies":
            return .moviesList
        case "movie":
            guard pathComponents.count >= 2,
                  let movieId = Int(pathComponents[1]) else { return nil }
            return .movieDetail(movieId: movieId)
        case "add":
            let query = url.queryParameters?["query"] ?? ""
            return .addMovie(query: query)
        case "settings":
            return .settings
        case "status":
            return .systemStatus
        case "queue":
            return .queue
        case "history":
            return .history
        default:
            return nil
        }
    }
    
    func toURL() -> URL? {
        let base = "thriftwood://radarr"
        switch self {
        case .moviesList:
            return URL(string: "\(base)/movies")
        case .movieDetail(let movieId):
            return URL(string: "\(base)/movie/\(movieId)")
        case .addMovie(let query):
            if query.isEmpty {
                return URL(string: "\(base)/add")
            } else {
                var components = URLComponents(string: "\(base)/add")
                components?.queryItems = [URLQueryItem(name: "query", value: query)]
                return components?.url
            }
        case .settings:
            return URL(string: "\(base)/settings")
        case .systemStatus:
            return URL(string: "\(base)/status")
        case .queue:
            return URL(string: "\(base)/queue")
        case .history:
            return URL(string: "\(base)/history")
        }
    }
}

// MARK: - URL Helper
private extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}
