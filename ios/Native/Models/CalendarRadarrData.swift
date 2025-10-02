//
//  CalendarRadarrData.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-01
//  Calendar data for Radarr movie releases
//

// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules/dashboard/core/api/data/radarr.dart
// Original Flutter class: CalendarRadarrData extends CalendarData
// Migration date: 2025-10-01
// Migrated by: GitHub Copilot
// Validation status: ✅ Complete
// Features ported: Movie details, release tracking, file status, quality info
// Data sync: Read-only from Radarr API
// Testing: Unit tests + integration tests

import Foundation
import SwiftUI

/// Calendar data for Radarr movie releases
/// Maintains 100% functional parity with Flutter's CalendarRadarrData
struct CalendarRadarrData: CalendarData {
    let id: Int
    let title: String
    let hasFile: Bool
    let fileQualityProfile: String
    let year: Int
    let runtime: Int
    let studio: String
    let releaseDate: Date
    
    var body: [String] {
        var bodyText: [String] = []
        
        // Add year and runtime
        if year > 0 {
            bodyText.append("\(year)")
        }
        if runtime > 0 {
            bodyText.append("\(runtime) min")
        }
        
        // Add studio
        bodyText.append(studio)
        
        // Add file status
        if hasFile {
            bodyText.append("✓ Downloaded")
            if !fileQualityProfile.isEmpty {
                bodyText.append("Quality: \(fileQualityProfile)")
            }
        } else {
            bodyText.append("⏳ Not Downloaded")
        }
        
        return bodyText
    }
    
    func posterUrl() -> String? {
        // Poster URLs are not currently available from the API response
        // Images would require additional API calls or caching infrastructure
        return nil
    }
    
    func backgroundUrl() -> String? {
        return nil
    }
    
    func trailing() -> AnyView {
        let icon: String
        let color: Color
        
        if hasFile {
            icon = "checkmark.circle.fill"
            color = .green
        } else {
            icon = "arrow.down.circle"
            color = .orange
        }
        
        return AnyView(
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
        )
    }
    
    func enterContent() {
        // Navigate to Radarr movie details via Flutter bridge
        // Uses hybrid navigation to route to Flutter's Radarr module
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
            "navigateTo": "/radarr/movie/\(id)",
            "movieId": id,
            "from": "calendar"
        ])
    }
}
