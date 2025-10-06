//
//  ViewLifecycleLogger.swift
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

/// ViewModifier that automatically logs view lifecycle events (appear/disappear)
/// with source tracking for navigation debugging
struct ViewLifecycleLogger: ViewModifier {
    let viewName: String
    let metadata: [String: String]
    let file: String
    let line: Int
    
    @State private var appearTime: Date?
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                appearTime = Date()
                AppLogger.navigation.logViewLifecycle(
                    event: "appear",
                    view: viewName,
                    coordinator: metadata["coordinator"]
                )
            }
            .onDisappear {
                let duration = appearTime.map { Date().timeIntervalSince($0) } ?? 0
                let durationString = unsafe String(format: "%.2f", duration)
                
                AppLogger.navigation.logViewLifecycle(
                    event: "disappear (\(durationString)s)",
                    view: viewName,
                    coordinator: metadata["coordinator"]
                )
            }
    }
}

// MARK: - View Extension

extension View {
    /// Adds automatic lifecycle logging to any SwiftUI view
    /// - Parameters:
    ///   - view: Name of the view (e.g., "MovieDetailView")
    ///   - metadata: Additional context to log
    ///   - file: Source file (auto-populated)
    ///   - line: Line number (auto-populated)
    /// - Returns: View with lifecycle logging attached
    ///
    /// # Example Usage:
    /// ```swift
    /// struct MovieDetailView: View {
    ///     var body: some View {
    ///         VStack {
    ///             // ... view content
    ///         }
    ///         .logViewLifecycle(
    ///             view: "MovieDetailView",
    ///             metadata: ["movie_id": movieId]
    ///         )
    ///     }
    /// }
    /// ```
    func logViewLifecycle(
        view viewName: String,
        metadata: [String: String] = [:],
        file: String = #fileID,
        line: Int = #line
    ) -> some View {
        self.modifier(ViewLifecycleLogger(
            viewName: viewName,
            metadata: metadata,
            file: file,
            line: line
        ))
    }
}
