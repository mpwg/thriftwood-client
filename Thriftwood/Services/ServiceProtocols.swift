//
//  ServiceProtocols.swift
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
//  ServiceProtocols.swift
//  Thriftwood
//
//  Base protocols for service implementations
//

import Foundation

// MARK: - Media Item Protocols

/// Base protocol for media items (movies, TV shows, music)
protocol MediaItem: Identifiable, Codable, Sendable {
    /// Unique identifier
    var id: String { get }
    
    /// Title of the media item
    var title: String { get }
    
    /// Overview/description
    var overview: String? { get }
    
    /// Release date
    var releaseDate: Date? { get }
    
    /// Poster image URL
    var posterURL: URL? { get }
}

/// Protocol for download queue items
protocol DownloadQueueItem: Identifiable, Codable {
    /// Unique identifier
    var id: String { get }
    
    /// Name of the download
    var name: String { get }
    
    /// Download status
    var status: DownloadStatus { get }
    
    /// Progress percentage (0-100)
    var progress: Double { get }
    
    /// Download size in bytes
    var size: Int64 { get }
    
    /// Remaining size in bytes
    var remaining: Int64 { get }
}

/// Download status enumeration
enum DownloadStatus: String, Codable {
    case downloading
    case paused
    case completed
    case failed
    case queued
}
