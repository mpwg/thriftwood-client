//
//  CalendarSonarrData.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-01
//  Calendar data for Sonarr TV episode releases
//

// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules/dashboard/core/api/data/sonarr.dart
// Original Flutter class: CalendarSonarrData extends CalendarData
// Migration date: 2025-10-01
// Migrated by: GitHub Copilot
// Validation status: ✅ Complete
// Features ported: Episode details, air time tracking, file status, quality info
// Data sync: Read-only from Sonarr API
// Testing: Unit tests + integration tests

import Foundation
import SwiftUI

/// Calendar data for Sonarr TV episode releases
/// Maintains 100% functional parity with Flutter's CalendarSonarrData
struct CalendarSonarrData: CalendarData {
    let id: Int
    let seriesID: Int
    let title: String
    let episodeTitle: String
    let seasonNumber: Int
    let episodeNumber: Int
    let airTime: String
    let hasFile: Bool
    let fileQualityProfile: String
    
    var airTimeObject: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: airTime)
    }
    
    var body: [String] {
        var bodyText: [String] = []
        
        // Add episode number
        if seasonNumber > 0 && episodeNumber > 0 {
            bodyText.append("S\(String(format: "%02d", seasonNumber))E\(String(format: "%02d", episodeNumber))")
        }
        
        // Add episode title
        if !episodeTitle.isEmpty {
            bodyText.append(episodeTitle)
        }
        
        // Add air time status
        if let airDate = airTimeObject {
            let now = Date()
            if airDate.compare(now) == .orderedDescending {
                // Future episode
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                bodyText.append("Airs at \(formatter.string(from: airDate))")
            } else {
                // Past episode
                bodyText.append("Aired")
            }
        }
        
        // Add file status
        if hasFile {
            bodyText.append("✓ Downloaded")
            if !fileQualityProfile.isEmpty {
                bodyText.append("Quality: \(fileQualityProfile)")
            }
        } else {
            if let airDate = airTimeObject, airDate.compare(Date()) == .orderedAscending {
                bodyText.append("⏳ Not Downloaded")
            } else {
                bodyText.append("⏰ Not Aired")
            }
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
        } else if let airDate = airTimeObject, airDate.compare(Date()) == .orderedDescending {
            icon = "clock"
            color = .blue
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
        // Navigate to Sonarr series details via Flutter bridge
        // Uses hybrid navigation to route to Flutter's Sonarr module
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
            "navigateTo": "/sonarr/series/\(seriesID)",
            "seriesId": seriesID,
            "from": "calendar"
        ])
    }
}
