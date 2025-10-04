//
//  DownloadService.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation

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
