//
//  TabRoute.swift
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
//  Created by Matthias Wallner-Géhri on 04.10.25.
//

import Foundation

/// Routes for the main tab navigation
/// Supports dynamic configuration via UserPreferencesService
enum TabRoute: String, Hashable, CaseIterable, Sendable {
    case dashboard
    case calendar
    case services
    case search
    case settings
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .calendar: return "Calendar"
        case .services: return "Services"
        case .search: return "Search"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .calendar: return "calendar"
        case .services: return "server.rack"
        case .search: return "magnifyingglass"
        case .settings: return "gearshape"
        }
    }
    
    /// Tabs that cannot be disabled
    static let requiredTabs: Set<TabRoute> = [.dashboard, .settings]
    
    /// Check if this tab can be disabled by the user
    var canBeDisabled: Bool {
        !Self.requiredTabs.contains(self)
    }
    
    /// Create TabRoute from string identifier
    /// - Parameter id: String identifier (rawValue)
    /// - Returns: TabRoute if valid, nil otherwise
    static func from(id: String) -> TabRoute? {
        return TabRoute(rawValue: id)
    }
    
    /// Get enabled tabs from array of tab IDs
    /// - Parameter tabIDs: Array of tab ID strings
    /// - Returns: Array of TabRoute enums
    static func from(ids tabIDs: [String]) -> [TabRoute] {
        return tabIDs.compactMap { TabRoute(rawValue: $0) }
    }
}
