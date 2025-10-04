//
//  ServiceProtocols.swift
//  Thriftwood
//
//  Base protocols for service implementations
//

import Foundation







// MARK: - Media Item Protocols

/// Base protocol for media items (movies, TV shows, music)
protocol MediaItem: Identifiable, Codable {
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
