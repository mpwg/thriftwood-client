//
//  ServiceIcon.swift
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

/// Service icon definitions and brand colors
///
/// Provides standardized icons and brand colors for all supported services.
/// Based on legacy LunaIcons and LunaModule color definitions.
///
/// Usage:
/// ```swift
/// Image(systemName: ServiceIcon.radarr.systemName)
///     .foregroundStyle(ServiceIcon.radarr.brandColor)
/// ```
enum ServiceIcon: String, CaseIterable, Identifiable {
    // Media Management Services
    case radarr
    case sonarr
    case lidarr
    
    // Download Clients
    case nzbget
    case sabnzbd
    
    // Media Servers & Monitoring
    case tautulli
    case overseerr
    case plex
    
    // Search & Indexers
    case search
    
    // External Links
    case imdb
    case themoviedatabase  // TMDB
    case thetvdb
    case tvmaze
    case trakt
    case letterboxd
    case musicbrainz
    case discogs
    case lastfm
    case bandsintown
    
    // Social & Community
    case github
    case discord
    case reddit
    case youtube
    
    var id: String { rawValue }
    
    /// SF Symbol name for the service icon
    ///
    /// Note: For services without official SF Symbols (Radarr, Sonarr, etc.),
    /// we use placeholder icons. Future implementation may include custom icon font
    /// similar to legacy LunaBrandIcons.ttf.
    var systemName: String {
        switch self {
        // Media Management - Using film/TV/music symbols as placeholders
        case .radarr:
            return "film"
        case .sonarr:
            return "tv"
        case .lidarr:
            return "music.note"
            
        // Download Clients - Using download arrow symbols
        case .nzbget:
            return "arrow.down.circle"
        case .sabnzbd:
            return "arrow.down.circle.fill"
            
        // Media Servers & Monitoring
        case .tautulli:
            return "chart.line.uptrend.xyaxis"
        case .overseerr:
            return "calendar.badge.clock"
        case .plex:
            return "play.rectangle.fill"
            
        // Search
        case .search:
            return "magnifyingglass"
            
        // External Links - Database/Info icons
        case .imdb:
            return "info.circle.fill"
        case .themoviedatabase:
            return "film.stack"
        case .thetvdb:
            return "tv.and.mediabox"
        case .tvmaze:
            return "tv.circle"
        case .trakt:
            return "chart.bar.fill"
        case .letterboxd:
            return "quote.bubble.fill"
        case .musicbrainz:
            return "music.note.list"
        case .discogs:
            return "opticaldisc"
        case .lastfm:
            return "waveform"
        case .bandsintown:
            return "ticket"
            
        // Social & Community
        case .github:
            return "chevron.left.forwardslash.chevron.right"
        case .discord:
            return "bubble.left.and.bubble.right.fill"
        case .reddit:
            return "person.3.fill"
        case .youtube:
            return "play.rectangle.fill"
        }
    }
    
    /// Brand color for the service (from legacy LunaModule colors)
    var brandColor: Color {
        switch self {
        // Media Management Services
        case .radarr:
            return Color(hex: 0xFEC333)  // Yellow/Gold
        case .sonarr:
            return Color(hex: 0x3FC6F4)  // Light Blue
        case .lidarr:
            return Color(hex: 0x159552)  // Green
            
        // Download Clients
        case .nzbget:
            return Color(hex: 0x42D535)  // Bright Green
        case .sabnzbd:
            return Color(hex: 0xFECC2B)  // Yellow
            
        // Media Servers & Monitoring
        case .tautulli:
            return Color(hex: 0xDBA23A)  // Orange/Gold
        case .overseerr:
            return Color(hex: 0x6366F1)  // Indigo/Purple
        case .plex:
            return Color(hex: 0xE5A00D)  // Orange (Plex brand color)
            
        // Search & External Links - Using neutral/accent colors
        case .search:
            return .themeAccent
        case .imdb:
            return Color(hex: 0xF5C518)  // IMDb Yellow
        case .themoviedatabase:
            return Color(hex: 0x01B4E4)  // TMDB Blue
        case .thetvdb:
            return Color(hex: 0x6CD491)  // TVDB Green
        case .tvmaze:
            return Color(hex: 0xFF0000)  // TVMaze Red
        case .trakt:
            return Color(hex: 0xED1C24)  // Trakt Red
        case .letterboxd:
            return Color(hex: 0x00D735)  // Letterboxd Green
        case .musicbrainz:
            return Color(hex: 0xBA478F)  // MusicBrainz Purple
        case .discogs:
            return Color(hex: 0x333333)  // Discogs Dark Gray
        case .lastfm:
            return Color(hex: 0xD51007)  // Last.fm Red
        case .bandsintown:
            return Color(hex: 0x00CEC8)  // Bandsintown Teal
            
        // Social & Community
        case .github:
            return Color(hex: 0x181717)  // GitHub Dark
        case .discord:
            return Color(hex: 0x5865F2)  // Discord Blurple
        case .reddit:
            return Color(hex: 0xFF4500)  // Reddit Orange
        case .youtube:
            return Color(hex: 0xFF0000)  // YouTube Red
        }
    }
    
    /// Display name for the service
    var displayName: String {
        switch self {
        case .radarr: return "Radarr"
        case .sonarr: return "Sonarr"
        case .lidarr: return "Lidarr"
        case .nzbget: return "NZBGet"
        case .sabnzbd: return "SABnzbd"
        case .tautulli: return "Tautulli"
        case .overseerr: return "Overseerr"
        case .plex: return "Plex"
        case .search: return "Search"
        case .imdb: return "IMDb"
        case .themoviedatabase: return "TMDB"
        case .thetvdb: return "TheTVDB"
        case .tvmaze: return "TVmaze"
        case .trakt: return "Trakt"
        case .letterboxd: return "Letterboxd"
        case .musicbrainz: return "MusicBrainz"
        case .discogs: return "Discogs"
        case .lastfm: return "Last.fm"
        case .bandsintown: return "Bandsintown"
        case .github: return "GitHub"
        case .discord: return "Discord"
        case .reddit: return "Reddit"
        case .youtube: return "YouTube"
        }
    }
    
    /// Website URL for the service
    var website: String? {
        switch self {
        case .radarr: return "https://radarr.video"
        case .sonarr: return "https://sonarr.tv"
        case .lidarr: return "https://lidarr.audio"
        case .nzbget: return "https://nzbget.net"
        case .sabnzbd: return "https://sabnzbd.org"
        case .tautulli: return "https://tautulli.com"
        case .overseerr: return "https://overseerr.dev"
        case .plex: return "https://plex.tv"
        case .search: return nil
        case .imdb: return "https://imdb.com"
        case .themoviedatabase: return "https://themoviedb.org"
        case .thetvdb: return "https://thetvdb.com"
        case .tvmaze: return "https://tvmaze.com"
        case .trakt: return "https://trakt.tv"
        case .letterboxd: return "https://letterboxd.com"
        case .musicbrainz: return "https://musicbrainz.org"
        case .discogs: return "https://discogs.com"
        case .lastfm: return "https://last.fm"
        case .bandsintown: return "https://bandsintown.com"
        case .github: return "https://github.com"
        case .discord: return "https://discord.com"
        case .reddit: return "https://reddit.com"
        case .youtube: return "https://youtube.com"
        }
    }
}

// MARK: - Common UI Icons

/// Common UI icons used throughout the app
///
/// Based on legacy LunaIcons built-in icons.
/// These use standard SF Symbols available on all Apple platforms.
enum ThriftwoodIcon {
    // Actions
    static let add = "plus"
    static let delete = "trash"
    static let edit = "pencil"
    static let rename = "textformat"
    static let refresh = "arrow.clockwise"
    static let save = "checkmark"
    static let cancel = "xmark"
    
    // Navigation
    static let arrowRight = "chevron.right"
    static let arrowDown = "chevron.down"
    static let arrowUp = "chevron.up"
    static let back = "chevron.left"
    static let home = "house"
    static let settings = "gearshape"
    
    // Media
    static let play = "play.fill"
    static let pause = "pause.fill"
    static let stop = "stop.fill"
    static let videoCam = "video"
    static let music = "music.note"
    static let film = "film"
    
    // Status & Feedback
    static let checkmark = "checkmark.circle"
    static let error = "exclamationmark.circle"
    static let warning = "exclamationmark.triangle"
    static let info = "info.circle"
    static let critical = "exclamationmark.octagon"
    
    // Content
    static let download = "arrow.down.circle"
    static let upload = "arrow.up.circle"
    static let cloud = "icloud"
    static let cloudDownload = "icloud.and.arrow.down"
    static let cloudUpload = "icloud.and.arrow.up"
    static let link = "link"
    
    // Organization
    static let filter = "line.3.horizontal.decrease"
    static let sort = "arrow.up.arrow.down"
    static let search = "magnifyingglass"
    static let view = "square.grid.2x2"
    static let shuffle = "shuffle"
    
    // User & Social
    static let user = "person"
    static let users = "person.3"
    static let profiles = "person.2"
    static let email = "envelope"
    
    // Monitoring & Status
    static let monitorOn = "eye"
    static let monitorOff = "eye.slash"
    static let watched = "eye.fill"
    static let history = "clock.arrow.circlepath"
    static let requests = "clock"
    
    // Development
    static let debug = "ant"
    static let connectionTest = "wifi"
    static let devices = "laptopcomputer.and.iphone"
    
    // Misc
    static let password = "key"
    static let translate = "globe"
    static let documentation = "book"
    static let feedback = "bubble.left.and.bubble.right"
    static let changelog = "doc.text"
}

// MARK: - Previews

#if DEBUG
#Preview("Service Icons") {
    ScrollView {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Media Management Services")
                .font(.headline)
            
            HStack(spacing: Spacing.lg) {
                ForEach([ServiceIcon.radarr, .sonarr, .lidarr]) { service in
                    VStack {
                        Image(systemName: service.systemName)
                            .font(.largeTitle)
                            .foregroundStyle(service.brandColor)
                        Text(service.displayName)
                            .font(.caption)
                    }
                }
            }
            
            Text("Download Clients")
                .font(.headline)
                .padding(.top, Spacing.md)
            
            HStack(spacing: Spacing.lg) {
                ForEach([ServiceIcon.nzbget, .sabnzbd]) { service in
                    VStack {
                        Image(systemName: service.systemName)
                            .font(.largeTitle)
                            .foregroundStyle(service.brandColor)
                        Text(service.displayName)
                            .font(.caption)
                    }
                }
            }
            
            Text("Media Servers")
                .font(.headline)
                .padding(.top, Spacing.md)
            
            HStack(spacing: Spacing.lg) {
                ForEach([ServiceIcon.tautulli, .overseerr, .plex]) { service in
                    VStack {
                        Image(systemName: service.systemName)
                            .font(.largeTitle)
                            .foregroundStyle(service.brandColor)
                        Text(service.displayName)
                            .font(.caption)
                    }
                }
            }
            
            Text("Common UI Icons")
                .font(.headline)
                .padding(.top, Spacing.lg)
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80))
            ], spacing: Spacing.md) {
                iconPreview(ThriftwoodIcon.add, "Add")
                iconPreview(ThriftwoodIcon.delete, "Delete")
                iconPreview(ThriftwoodIcon.edit, "Edit")
                iconPreview(ThriftwoodIcon.refresh, "Refresh")
                iconPreview(ThriftwoodIcon.search, "Search")
                iconPreview(ThriftwoodIcon.settings, "Settings")
                iconPreview(ThriftwoodIcon.error, "Error")
                iconPreview(ThriftwoodIcon.warning, "Warning")
            }
        }
        .padding()
    }
}

@MainActor
private func iconPreview(_ icon: String, _ label: String) -> some View {
    VStack {
        Image(systemName: icon)
            .font(.title2)
            .foregroundStyle(Color.themeAccent)
        Text(label)
            .font(.caption2)
    }
}
#endif
