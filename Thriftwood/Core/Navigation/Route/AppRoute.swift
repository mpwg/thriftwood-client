//
//  AppRoute.swift
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

/// Unified route enum for the entire application (ADR-0012: Single NavigationStack)
///
/// With a single NavigationStack at the window level, all routes are managed centrally by AppCoordinator.
///
/// **Pure MVVM Architecture (ADR-0012):**
/// - AppCoordinator manages the single navigation path
/// - ViewModels handle business logic (created directly by views or AppCoordinator)
/// - Services provide data access (injected via DI)
/// - No logic coordinators needed - simplified from original MVVM-C approach
///
/// **Benefits**:
/// - ~70% less code compared to nested NavigationStack approach
/// - Centralized navigation makes deep linking simpler
/// - Easier to understand and maintain
/// - Better SwiftUI integration (single homogeneous path type)
enum AppRoute: Hashable, Sendable {
    // MARK: - App Level Routes
    
    /// Initial onboarding flow
    case onboarding
    
    /// Services home view (Radarr, Sonarr, Lidarr, etc.)
    case services
    
    // MARK: - Radarr Routes
    // Based on legacy Flutter app structure: Catalogue, Upcoming, Missing, More
    
    /// Radarr home view with button navigation
    case radarrHome
    
    /// Main movies list (Catalogue in legacy)
    case radarrMoviesList
    
    /// Movie detail view
    /// - Parameter movieId: Radarr movie ID
    case radarrMovieDetail(movieId: Int)
    
    /// Add movie search view
    /// - Parameter query: Optional search query to pre-populate
    case radarrAddMovie(query: String = "")
    
    /// Radarr settings/configuration
    case radarrSettings
    
    /// System status view
    case radarrSystemStatus
    
    /// Queue view (downloads in progress)
    case radarrQueue
    
    /// History view (past activity)
    case radarrHistory
    
    // MARK: - Settings Routes
    
    /// Settings main/home view
    case settingsMain
    
    /// Profiles management view
    case settingsProfiles
    
    /// Add new profile view
    case settingsAddProfile
    
    /// Edit existing profile view
    /// - Parameter profileId: UUID string of the profile to edit
    case settingsEditProfile(profileId: String)
    
    /// Appearance settings (theme, colors, etc.)
    case settingsAppearance
    
    /// Notifications settings
    case settingsNotifications
    
    /// About view (app info, version, licenses, etc.)
    case settingsAbout
    
    /// Logs viewer
    case settingsLogs
}

// MARK: - Deep Linking Support

extension AppRoute: DeepLinkable {
    /// Parse a deep link URL into an AppRoute
    ///
    /// **Supported URL Schemes**:
    /// - `thriftwood://onboarding`
    /// - `thriftwood://services`
    /// - `thriftwood://radarr/home`
    /// - `thriftwood://radarr/movies`
    /// - `thriftwood://radarr/movie/123`
    /// - `thriftwood://settings`
    /// - `thriftwood://settings/profiles`
    /// - `thriftwood://settings/profiles/add`
    /// - `thriftwood://settings/profiles/edit/uuid`
    ///
    /// - Parameter url: The deep link URL to parse
    /// - Returns: The corresponding AppRoute, or nil if URL is invalid
    static func parse(from url: URL) -> AppRoute? {
        guard url.scheme == "thriftwood" else { return nil }
        guard let host = url.host else { return nil }
        
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        switch host {
        case "onboarding":
            return .onboarding
            
        case "services":
            return .services
            
        case "radarr":
            if pathComponents.isEmpty {
                return .radarrHome
            }
            switch pathComponents[0] {
            case "home":
                return .radarrHome
            case "movies":
                return .radarrMoviesList
            case "movie":
                guard pathComponents.count >= 2,
                      let movieId = Int(pathComponents[1]) else { return nil }
                return .radarrMovieDetail(movieId: movieId)
            case "add":
                let query = url.query ?? ""
                return .radarrAddMovie(query: query)
            case "settings":
                return .radarrSettings
            case "status":
                return .radarrSystemStatus
            case "queue":
                return .radarrQueue
            case "history":
                return .radarrHistory
            default:
                return nil
            }
            
        case "settings":
            if pathComponents.isEmpty {
                return .settingsMain
            }
            switch pathComponents[0] {
            case "profiles":
                if pathComponents.count >= 2 {
                    switch pathComponents[1] {
                    case "add":
                        return .settingsAddProfile
                    case "edit":
                        guard pathComponents.count >= 3 else { return nil }
                        return .settingsEditProfile(profileId: pathComponents[2])
                    default:
                        return nil
                    }
                }
                return .settingsProfiles
            case "appearance":
                return .settingsAppearance
            case "notifications":
                return .settingsNotifications
            case "about":
                return .settingsAbout
            case "logs":
                return .settingsLogs
            default:
                return nil
            }
            
        default:
            return nil
        }
    }
    
    /// Convert this route to a deep link URL
    ///
    /// - Returns: The URL representing this route, or nil if conversion fails
    func toURL() -> URL? {
        let base = "thriftwood://"
        let urlString: String
        
        switch self {
        // App level
        case .onboarding:
            urlString = "\(base)onboarding"
        case .services:
            urlString = "\(base)services"
            
        // Radarr
        case .radarrHome:
            urlString = "\(base)radarr/home"
        case .radarrMoviesList:
            urlString = "\(base)radarr/movies"
        case .radarrMovieDetail(let movieId):
            urlString = "\(base)radarr/movie/\(movieId)"
        case .radarrAddMovie(let query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString = "\(base)radarr/add?\(encodedQuery)"
        case .radarrSettings:
            urlString = "\(base)radarr/settings"
        case .radarrSystemStatus:
            urlString = "\(base)radarr/status"
        case .radarrQueue:
            urlString = "\(base)radarr/queue"
        case .radarrHistory:
            urlString = "\(base)radarr/history"
            
        // Settings
        case .settingsMain:
            urlString = "\(base)settings"
        case .settingsProfiles:
            urlString = "\(base)settings/profiles"
        case .settingsAddProfile:
            urlString = "\(base)settings/profiles/add"
        case .settingsEditProfile(let profileId):
            urlString = "\(base)settings/profiles/edit/\(profileId)"
        case .settingsAppearance:
            urlString = "\(base)settings/appearance"
        case .settingsNotifications:
            urlString = "\(base)settings/notifications"
        case .settingsAbout:
            urlString = "\(base)settings/about"
        case .settingsLogs:
            urlString = "\(base)settings/logs"
        }
        
        return URL(string: urlString)
    }
}

