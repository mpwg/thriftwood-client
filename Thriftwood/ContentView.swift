//
//  ContentView.swift
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
import SwiftData

enum SidebarItem: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case lidarr = "Lidarr"
    case radarr = "Radarr"
    case sabnzbd = "SABnzbd"
    case search = "Search"
    case sonarr = "Sonarr"
    case tautulli = "Tautulli"
    case settings = "Settings"

    var id: String { rawValue }
    
    var systemImage: String {
        switch self {
        case .dashboard: return "house"
        case .lidarr: return "bolt.circle"
        case .radarr: return "play.circle"
        case .sabnzbd: return "tray.and.arrow.down"
        case .search: return "magnifyingglass"
        case .sonarr: return "sparkles"
        case .tautulli: return "network"
        case .settings: return "gearshape"
        }
    }
}

struct ContentView: View {
    @State private var selection: SidebarItem? = .dashboard

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(SidebarItem.allCases) { item in
                    NavigationLink(value: item) {
                        Label(item.rawValue, systemImage: item.systemImage)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Thriftwood")
        } detail: {
            Group {
                switch selection {
                case .dashboard: DashboardView()
                case .lidarr: LidarrView()
                case .radarr: RadarrView()
                case .sabnzbd: SABnzbdView()
                case .search: SearchView()
                case .sonarr: SonarrView()
                case .tautulli: TautulliView()
                case .settings: SettingsView()
                case .none: PlaceholderEmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Placeholder View

private struct PlaceholderView: View {
    let title: String
    let icon: String
    var subtitle: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.title)
                .foregroundStyle(.primary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            Text("View not yet implemented")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .navigationTitle(title)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
