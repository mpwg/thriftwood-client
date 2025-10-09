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
//
//  ContentView.swift
//  PrototypeGUI
//
//  Created by Matthias Wallner-Géhri on 07.10.25.
//

import SwiftUI

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
        case .dashboard: return SystemIcon.dashboard
        case .lidarr: return SystemIcon.music
        case .radarr: return SystemIcon.movies
        case .sabnzbd: return SystemIcon.downloads
        case .search: return SystemIcon.search
        case .sonarr: return SystemIcon.tv
        case .tautulli: return SystemIcon.monitoring
        case .settings: return SystemIcon.settings
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
            .navigationTitle("LunaSea")
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

#Preview {
    ContentView()
}
