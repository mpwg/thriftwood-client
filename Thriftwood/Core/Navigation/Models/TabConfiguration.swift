//
//  TabConfiguration.swift
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
//  TabConfiguration.swift
//  Thriftwood
//
//  Model representing tab configuration for customizable tab bar
//

import Foundation

/// Represents a configurable tab in the application
/// Supports enabling/disabling tabs and custom ordering
struct TabConfiguration: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let iconName: String
    var isEnabled: Bool
    var sortOrder: Int
    
    init(id: String, title: String, iconName: String, isEnabled: Bool = true, sortOrder: Int = 0) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.isEnabled = isEnabled
        self.sortOrder = sortOrder
    }
}

// MARK: - Default Tab Configurations

extension TabConfiguration {
    /// All available tabs in the application
    static let allTabs: [TabConfiguration] = [
        .dashboard,
        .calendar,
        .services,
        .search,
        .settings
    ]
    
    /// Dashboard tab - always visible, cannot be disabled
    static let dashboard = TabConfiguration(
        id: "dashboard",
        title: "Dashboard",
        iconName: "square.grid.2x2",
        isEnabled: true,
        sortOrder: 0
    )
    
    /// Calendar tab - shows aggregated calendar across services
    static let calendar = TabConfiguration(
        id: "calendar",
        title: "Calendar",
        iconName: "calendar",
        isEnabled: true,
        sortOrder: 1
    )
    
    /// Services tab - shows all configured media services
    static let services = TabConfiguration(
        id: "services",
        title: "Services",
        iconName: "server.rack",
        isEnabled: true,
        sortOrder: 2
    )
    
    /// Search tab - unified search across indexers
    static let search = TabConfiguration(
        id: "search",
        title: "Search",
        iconName: "magnifyingglass",
        isEnabled: true,
        sortOrder: 3
    )
    
    /// Settings tab - always visible, cannot be disabled
    static let settings = TabConfiguration(
        id: "settings",
        title: "Settings",
        iconName: "gearshape",
        isEnabled: true,
        sortOrder: 4
    )
}

// MARK: - Tab Management

extension TabConfiguration {
    /// Tabs that cannot be disabled (dashboard and settings)
    static let requiredTabs: Set<String> = ["dashboard", "settings"]
    
    /// Check if this tab can be disabled
    var canBeDisabled: Bool {
        !Self.requiredTabs.contains(id)
    }
    
    /// Get default tab configurations (all enabled, default order)
    static func defaultConfigurations() -> [TabConfiguration] {
        return allTabs
    }
    
    /// Get tab configurations sorted by sortOrder
    static func sorted(_ tabs: [TabConfiguration]) -> [TabConfiguration] {
        return tabs.sorted { $0.sortOrder < $1.sortOrder }
    }
    
    /// Get tab configurations sorted alphabetically by title
    static func alphabetical(_ tabs: [TabConfiguration]) -> [TabConfiguration] {
        return tabs.sorted { $0.title < $1.title }
    }
    
    /// Filter to only enabled tabs
    static func enabledOnly(_ tabs: [TabConfiguration]) -> [TabConfiguration] {
        return tabs.filter { $0.isEnabled }
    }
}
