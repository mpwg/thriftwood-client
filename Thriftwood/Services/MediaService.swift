//
//  MediaService.swift
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
