//
//  ServicesHomeView.swift
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

struct ServicesHomeView: View {
    let onNavigateToRadarr: () -> Void
    // Future: let onNavigateToSonarr: () -> Void
    
    var body: some View {
        List {
            Section("Media Management") {
                NavigationButton(
                    title: "Radarr",
                    subtitle: "Movie management",
                    icon: "film",
                    action: onNavigateToRadarr
                )
                
                // Future services
                // NavigationButton(
                //     title: "Sonarr",
                //     subtitle: "TV show management",
                //     icon: "tv",
                //     action: onNavigateToSonarr
                // )
            }
        }
        .navigationTitle("Services")
    }
}

/// Helper component for consistent button styling in hierarchical navigation
struct NavigationButton: View {
    let title: String
    var subtitle: String?
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.tint)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ServicesHomeView(
            onNavigateToRadarr: {}
        )
    }
}
