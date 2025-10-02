//
//  CalendarData.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-01
//  Base protocol for calendar event data
//

// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules/dashboard/core/api/data/abstract.dart:1-21
// Original Flutter class: abstract class CalendarData
// Migration date: 2025-10-01
// Migrated by: GitHub Copilot
// Validation status: ✅ Complete
// Features ported: id, title, body, posterUrl, backgroundUrl, trailing, enterContent
// Data sync: Read-only from API responses
// Testing: Unit tests + integration tests

import Foundation
import SwiftUI

/// Base protocol for calendar event data
/// Maintains 100% functional parity with Flutter's CalendarData abstract class
///
/// **Flutter Method Mapping:**
/// - CalendarData.id -> id
/// - CalendarData.title -> title
/// - CalendarData.body -> body
/// - CalendarData.posterUrl() -> posterUrl
/// - CalendarData.backgroundUrl() -> backgroundUrl
/// - CalendarData.trailing() -> trailing
/// - CalendarData.enterContent() -> enterContent()
protocol CalendarData: Identifiable {
    var id: Int { get }
    var title: String { get }
    var body: [String] { get }
    
    func posterUrl() -> String?
    func backgroundUrl() -> String?
    func trailing() -> AnyView
    func enterContent()
}

/// Helper extensions for calendar data
extension CalendarData {
    /// Default implementation for background URL
    func backgroundUrl() -> String? {
        return nil
    }
    
    /// Default implementation for trailing view
    func trailing() -> AnyView {
        return AnyView(EmptyView())
    }
    
    /// Default implementation for enter content action
    func enterContent() {
        // Override in concrete implementations
    }
}
