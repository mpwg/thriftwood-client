//
//  MainTabView.swift
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

/// Main tab view that displays enabled tabs based on user configuration.
/// Tabs are customizable - users can enable/disable and reorder them.

/// Main tab view with customizable tabs
/// Reads configuration from TabCoordinator which uses UserPreferencesService
struct MainTabView: View {
    /// Tab coordinator that manages navigation and configuration
    @Bindable var coordinator: TabCoordinator
    
    var body: some View {
        TabView(selection: Binding(
            get: { coordinator.selectedTab },
            set: { newTab in
                // If tapping the same tab, pop to root
                if coordinator.selectedTab == newTab {
                    coordinator.popToRoot(for: newTab)
                } else {
                    coordinator.selectedTab = newTab
                }
            }
        )) {
            ForEach(coordinator.enabledTabs, id: \.self) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.iconName)
                    }
                    .tag(tab)
            }
        }
    }
    
    /// Returns the appropriate view for each tab
    /// - Parameter tab: The tab route
    /// - Returns: View for the tab
    @ViewBuilder
    private func tabContent(for tab: TabRoute) -> some View {
        switch tab {
        case .dashboard:
            if let coordinator = coordinator.coordinator(for: .dashboard) as? DashboardCoordinator {
                DashboardCoordinatorView(coordinator: coordinator)
            } else {
                placeholderView(for: tab)
            }
            
        case .calendar:
            // TODO [Milestone 5]: Implement CalendarCoordinatorView when CalendarCoordinator is created
            placeholderView(for: tab)
            
        case .services:
            if let coordinator = coordinator.coordinator(for: .services) as? ServicesCoordinator {
                ServicesCoordinatorView(coordinator: coordinator)
            } else {
                placeholderView(for: tab)
            }
            
        case .search:
            // TODO [Milestone 4]: Implement SearchCoordinatorView when SearchCoordinator is created
            placeholderView(for: tab)
            
        case .settings:
            if let coordinator = coordinator.coordinator(for: .settings) as? SettingsCoordinator {
                SettingsCoordinatorView(coordinator: coordinator)
            } else {
                placeholderView(for: tab)
            }
        }
    }
    
    /// Placeholder view for tabs that are not yet implemented
    /// - Parameter tab: The tab route
    /// - Returns: Placeholder view
    private func placeholderView(for tab: TabRoute) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(tab.title)
                .font(.title)
            Text("Coming soon...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
