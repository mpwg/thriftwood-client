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
