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
        .init(id: "lidarr", title: "Lidarr", subtitle: "Manage Music", systemIcon: SystemIcon.music, tint: .green),
        .init(id: "radarr", title: "Radarr", subtitle: "Manage Movies", systemIcon: SystemIcon.movies, tint: .yellow),
        .init(id: "sabnzbd", title: "SABnzbd", subtitle: "Manage Usenet Downloads", systemIcon: SystemIcon.downloadsFilled, tint: .yellow),
        .init(id: "search", title: "Search", subtitle: "Search Newznab Indexers", systemIcon: SystemIcon.searchCircle, tint: .mint),
        .init(id: "sonarr", title: "Sonarr", subtitle: "Manage Television Series", systemIcon: SystemIcon.tv, tint: .blue),
        .init(id: "tautulli", title: "Tautulli", subtitle: "View Plex Activity", systemIcon: SystemIcon.monitoring, tint: .orange),
        .init(id: "settings", title: "Settings", subtitle: "Configure LunaSea", systemIcon: SystemIcon.settingsFilled, tint: .teal)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Background (uses system semantic color so previews follow light/dark)
                Color.platformGroupedBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: UIConstants.Spacing.medium) {
                        ForEach(modules) { module in
                            NavigationLink {
                                destinationView(for: module)
                            } label: {
                                ModuleCard(module: module)
                                    .padding(.horizontal, UIConstants.Padding.screen)
                            }
                        }
                    }
                    .padding(.top, UIConstants.Spacing.extraLarge)
                    .padding(.bottom, UIConstants.Padding.bottomToolbarSpacer)
                }
            }
            .navigationTitle("LunaSea")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {}, label: {
                        Label("Menu", systemImage: SystemIcon.menu)
                    })
                }

                ToolbarItemGroup(placement: .platformBottom) {
                    Button(action: {}, label: {
                        Label("Modules", systemImage: SystemIcon.grid3x3)
                    })
                    .pillStyle(prominent: true)

                    Spacer()

                    Button(action: {}, label: {
                        Label("Calendar", systemImage: SystemIcon.calendar)
                    })
                    .cardStyle()
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
            VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
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
                .padding(.leading, UIConstants.Spacing.small)
        }
        .padding(UIConstants.Padding.card)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card, style: .continuous)
                .fill(Color.platformSecondaryGroupedBackground)
        )
        .shadow(
            color: UIConstants.Shadow.cardColor,
            radius: UIConstants.Shadow.cardRadius,
            x: UIConstants.Shadow.cardX,
            y: UIConstants.Shadow.cardY
        )
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
    Group {
        DashboardView()
    }
}
