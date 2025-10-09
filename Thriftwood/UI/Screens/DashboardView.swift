//
//  DashboardView.swift
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

struct DashboardView: View {
    private let modules: [Module] = [
        .init(id: "lidarr", title: "Lidarr", subtitle: "Manage Music", systemIcon: "bolt.circle", tint: .green),
        .init(id: "radarr", title: "Radarr", subtitle: "Manage Movies", systemIcon: "popcorn.circle", tint: .yellow),
        .init(id: "sabnzbd", title: "SABnzbd", subtitle: "Manage Usenet Downloads", systemIcon: "tray.full", tint: .yellow),
        .init(id: "search", title: "Search", subtitle: "Search Newznab Indexers", systemIcon: "magnifyingglass.circle", tint: .mint),
        .init(id: "sonarr", title: "Sonarr", subtitle: "Manage Television Series", systemIcon: "sparkles", tint: .blue),
        .init(id: "tautulli", title: "Tautulli", subtitle: "View Plex Activity", systemIcon: "network", tint: .orange),
        .init(id: "settings", title: "Settings", subtitle: "Configure Thriftwood", systemIcon: "gearshape.fill", tint: .teal)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Background (uses system semantic color so previews follow light/dark)
                Color.platformGroupedBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top bar
                    HStack(spacing: 12) {
                        Button(action: {}, label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })

                        Text("Thriftwood")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 14)

                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(modules) { module in
                                NavigationLink(destination: {
                                    destinationView(for: module)
                                }, label: {
                                    ModuleCard(module: module)
                                        .padding(.horizontal)
                                })
                            }
                        }
                        .padding(.top, 18)
                        .padding(.bottom, 120) // leave space for toolbar
                    }
                }

                // Bottom pill toolbar
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {}, label: {
                            HStack(spacing: 10) {
                                Image(systemName: "circle.grid.3x3.fill")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                                Text("Modules")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color.platformSecondaryGroupedBackground.opacity(0.9))
                            .clipShape(Capsule())
                        })

                        Spacer()

                        Button(action: {}, label: {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color.platformSecondaryGroupedBackground.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        })
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - Module model and Card view

struct Module: Identifiable, Hashable, Comparable {
    var id: String
    var title: String
    var subtitle: String
    var systemIcon: String
    var tint: Color

    static func < (lhs: Module, rhs: Module) -> Bool {
        lhs.title < rhs.title
    }
}

struct ModuleCard: View {
    let module: Module

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(module.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(module.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: module.systemIcon)
                .font(.title2)
                .foregroundColor(module.tint)
                .padding(.leading, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.platformSecondaryGroupedBackground)
        )
        .shadow(color: Color.primary.opacity(0.02), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Previews

extension DashboardView {
    @ViewBuilder
    func destinationView(for module: Module) -> some View {
        switch module.id {
        case "lidarr": LidarrView().navigationTitle(module.title)
        case "radarr": RadarrView().navigationTitle(module.title)
        case "sabnzbd": SABnzbdView().navigationTitle(module.title)
        case "search": SearchView().navigationTitle(module.title)
        case "sonarr": SonarrView().navigationTitle(module.title)
        case "tautulli": TautulliView().navigationTitle(module.title)
        case "settings": SettingsView().navigationTitle(module.title)
        default: PlaceholderEmptyView().navigationTitle(module.title)
        }
    }
}

#Preview {
    DashboardView()
}
