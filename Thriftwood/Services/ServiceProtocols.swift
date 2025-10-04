//
//  ServiceProtocols.swift
//  Thriftwood
//
//  Base protocols for service implementations
//

import Foundation



/// Base protocol for all media management services (Radarr, Sonarr, etc.)
protocol MediaService {
    // Note: Configuration type will be concrete service configuration model (e.g., RadarrConfiguration)
    // associatedtype Configuration
    associatedtype Item: MediaItem
    
    // /// Current service configuration
    // var configuration: Configuration? { get }
    
    // /// Configure the service with connection details
    // /// - Parameter config: Service configuration
    // /// - Throws: ThriftwoodError if configuration is invalid
    // func configure(_ config: Configuration) async throws
    
    /// Test the service connection
    /// - Returns: True if connection is successful
    /// - Throws: ThriftwoodError if connection fails
    func testConnection() async throws -> Bool
    
    /// Fetch all items from the service
    /// - Returns: Array of media items
    /// - Throws: ThriftwoodError if request fails
    func fetchItems() async throws -> [Item]
    
    /// Search for items
    /// - Parameter query: Search query
    /// - Returns: Array of matching items
    /// - Throws: ThriftwoodError if request fails
    func search(query: String) async throws -> [Item]
}

/// Base protocol for download client services (SABnzbd, NZBGet)
protocol DownloadService {
    // Note: Configuration type will be concrete service configuration model (e.g., SABnzbdConfiguration)
    // associatedtype Configuration
    associatedtype QueueItem: DownloadQueueItem
    
    // /// Current service configuration
    // var configuration: Configuration? { get }
    
    // /// Configure the service
    // /// - Parameter config: Service configuration
    // /// - Throws: ThriftwoodError if configuration is invalid
    // func configure(_ config: Configuration) async throws
    
    /// Test the service connection
    /// - Returns: True if connection is successful
    /// - Throws: ThriftwoodError if connection fails
    func testConnection() async throws -> Bool
    
    /// Fetch current download queue
    /// - Returns: Array of queue items
    /// - Throws: ThriftwoodError if request fails
    func fetchQueue() async throws -> [QueueItem]
    
    /// Pause a download
    /// - Parameter id: Download ID
    /// - Throws: ThriftwoodError if request fails
    func pause(id: String) async throws
    
    /// Resume a download
    /// - Parameter id: Download ID
    /// - Throws: ThriftwoodError if request fails
    func resume(id: String) async throws
    
    /// Delete a download
    /// - Parameters:
    ///   - id: Download ID
    ///   - removeData: Whether to remove downloaded data
    /// - Throws: ThriftwoodError if request fails
    func delete(id: String, removeData: Bool) async throws
}

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
