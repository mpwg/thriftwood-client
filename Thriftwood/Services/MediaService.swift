//
//  MediaService.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
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
