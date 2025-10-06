//
//  RadarrHomeView.swift
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

struct RadarrHomeView: View {
    let onNavigateToMovies: () -> Void
    let onNavigateToAddMovie: () -> Void
    let onNavigateToQueue: () -> Void
    let onNavigateToHistory: () -> Void
    let onNavigateToSystemStatus: () -> Void
    
    var body: some View {
        List {
            Section("Media Management") {
                NavigationButton(
                    title: "Movies",
                    subtitle: "Browse your movie library",
                    icon: "film",
                    action: onNavigateToMovies
                )
                
                NavigationButton(
                    title: "Add Movie",
                    subtitle: "Search and add new movies",
                    icon: "plus.circle",
                    action: onNavigateToAddMovie
                )
            }
            
            Section("Monitoring") {
                NavigationButton(
                    title: "Queue",
                    subtitle: "Active downloads",
                    icon: "arrow.down.circle",
                    action: onNavigateToQueue
                )
                
                NavigationButton(
                    title: "History",
                    subtitle: "Past activity",
                    icon: "clock",
                    action: onNavigateToHistory
                )
            }
            
            Section("System") {
                NavigationButton(
                    title: "System Status",
                    subtitle: "View system information",
                    icon: "info.circle",
                    action: onNavigateToSystemStatus
                )
            }
        }
        .navigationTitle("Radarr")
    }
}

#Preview {
    NavigationStack {
        RadarrHomeView(
            onNavigateToMovies: {},
            onNavigateToAddMovie: {},
            onNavigateToQueue: {},
            onNavigateToHistory: {},
            onNavigateToSystemStatus: {}
        )
    }
}
