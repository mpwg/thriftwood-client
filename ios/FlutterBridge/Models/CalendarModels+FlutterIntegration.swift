//
//  CalendarModels+FlutterIntegration.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-02.
//  MIGRATION TEMPORARY: Flutter integration for Calendar models
//  This file will be DELETED when migration to pure SwiftUI is complete
//

import Foundation

/// ⚠️ MIGRATION TEMPORARY: Flutter bridge integration for Calendar models
/// These extensions will be deleted when migration to pure SwiftUI is complete

extension CalendarRadarrData {
    /// Convert to dictionary for Flutter bridge communication
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "hasFile": hasFile,
            "fileQualityProfile": fileQualityProfile,
            "year": year,
            "runtime": runtime,
            "studio": studio,
            "releaseDate": ISO8601DateFormatter().string(from: releaseDate)
        ]
    }
    
    /// Navigate back to Flutter with calendar data
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func navigateBackToFlutterWithData() {
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
            "calendarData": self.toDictionary(),
            "serviceType": "radarr"
        ])
    }
}

extension CalendarSonarrData {
    /// Convert to dictionary for Flutter bridge communication
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "seriesID": seriesID,
            "title": title,
            "episodeTitle": episodeTitle,
            "seasonNumber": seasonNumber,
            "episodeNumber": episodeNumber,
            "airTime": airTime,
            "hasFile": hasFile,
            "fileQualityProfile": fileQualityProfile
        ]
    }
    
    /// Navigate back to Flutter with calendar data
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func navigateBackToFlutterWithData() {
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
            "calendarData": self.toDictionary(),
            "serviceType": "sonarr"
        ])
    }
    
    /// Navigate to Sonarr series details via Flutter bridge
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func enterContentViaFlutterBridge() {
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
            "navigateTo": "/sonarr/series/\(seriesID)",
            "seriesId": seriesID,
            "from": "calendar"
        ])
    }
}

extension CalendarLidarrData {
    /// Convert to dictionary for Flutter bridge communication
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "albumTitle": albumTitle,
            "artistId": artistId,
            "totalTrackCount": totalTrackCount,
            "hasAllFiles": hasAllFiles
        ]
    }
    
    /// Navigate back to Flutter with calendar data
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func navigateBackToFlutterWithData() {
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
            "calendarData": self.toDictionary(),
            "serviceType": "lidarr"
        ])
    }
    
    /// Navigate to Lidarr artist details via Flutter bridge
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    func enterContentViaFlutterBridge() {
        FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
            "navigateTo": "/lidarr/artist/\(artistId)",
            "artistId": artistId,
            "from": "calendar"
        ])
    }
}