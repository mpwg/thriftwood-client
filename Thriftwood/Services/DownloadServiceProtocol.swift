//
//  DownloadService.swift
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
//  DownloadService.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation

/// Base protocol for download client services (SABnzbd, NZBGet)
protocol DownloadServiceProtocol {
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
