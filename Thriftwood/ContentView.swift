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
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 03.10.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationPath: [AppRoute] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            AppHomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .services:
            ServicesHomeView()
            
        case .radarrHome:
            RadarrHomeView()
            
        case .radarrMoviesList:
            PlaceholderView(title: "Movies List", icon: "film")
            
        case .radarrMovieDetail(let movieId):
            PlaceholderView(title: "Movie Detail", icon: "film", subtitle: "ID: \(movieId)")
            
        case .radarrAddMovie(let query):
            PlaceholderView(title: "Add Movie", icon: "plus.circle", subtitle: query.isEmpty ? nil : "Query: \(query)")
            
        case .radarrSettings:
            PlaceholderView(title: "Radarr Settings", icon: "gearshape")
            
        case .radarrSystemStatus:
            PlaceholderView(title: "System Status", icon: "info.circle")
            
        case .radarrQueue:
            PlaceholderView(title: "Queue", icon: "arrow.down.circle")
            
        case .radarrHistory:
            PlaceholderView(title: "History", icon: "clock")
            
        case .settingsMain:
            SettingsView()
            
        case .settingsProfiles:
            ProfileListView()
            
        case .settingsAddProfile:
            AddProfileView()
            
        case .settingsEditProfile(let profileId):
            PlaceholderView(title: "Edit Profile", icon: "person.circle", subtitle: "ID: \(profileId)")
            
        case .settingsAppearance:
            PlaceholderView(title: "Appearance", icon: "paintbrush")
            
        case .settingsNotifications:
            PlaceholderView(title: "Notifications", icon: "bell")
            
        case .settingsAbout:
            PlaceholderView(title: "About", icon: "info.circle")
            
        case .settingsLogs:
            PlaceholderView(title: "Logs", icon: "doc.text")
            
        case .onboarding:
            // Onboarding removed for now
            PlaceholderView(title: "Onboarding", icon: "hand.wave", subtitle: "Coming soon")
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
