//
//  PreviewRadarrService.swift
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
import RadarrAPI

/// Simple preview service for SwiftUI previews
///
/// This service provides minimal implementations for preview purposes only.
/// It should NOT be used in production code or tests - use MockRadarrService instead.
///
/// **Purpose**: Allows SwiftUI previews to compile without importing RadarrAPI in view files,
/// maintaining MVVM-C layer separation (Views should never import service/domain modules).
final class PreviewRadarrService: RadarrServiceProtocol, @unchecked Sendable {
    func configure(baseURL: URL, apiKey: String) async throws {}
    
    func getMovies() async throws -> [MovieResource] { [] }
    
    func getMovie(id: Int) async throws -> MovieResource { MovieResource() }
    
    func searchMovies(query: String) async throws -> [MovieResource] { [] }
    
    func addMovie(_ movie: MovieResource) async throws -> MovieResource { MovieResource() }
    
    func updateMovie(_ movie: MovieResource) async throws -> MovieResource { MovieResource() }
    
    func deleteMovie(id: Int, deleteFiles: Bool) async throws {}
    
    func getQualityProfiles() async throws -> [QualityProfileResource] { [] }
    
    func getRootFolders() async throws -> [RootFolderResource] { [] }
    
    func getSystemStatus() async throws -> SystemResource { SystemResource() }
    
    func testConnection() async throws -> Bool { false }
}
