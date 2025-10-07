//
//  HomeView.swift
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

/// Home screen with navigation buttons to all main sections
struct HomeView: View {
    let onNavigateToDashboard: () -> Void
    let onNavigateToServices: () -> Void
    let onNavigateToSettings: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "film.stack")
                        .font(.system(size: 60))
                        .foregroundStyle(.tint)
                    
                    Text("Thriftwood")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Media Management")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                // Main Navigation
                VStack(spacing: 16) {
                    NavigationCard(
                        title: "Dashboard",
                        description: "Overview of your media",
                        icon: "square.grid.2x2",
                        color: .blue
                    ) {
                        onNavigateToDashboard()
                    }
                    
                    NavigationCard(
                        title: "Services",
                        description: "Radarr, Sonarr, and more",
                        icon: "server.rack",
                        color: .purple
                    ) {
                        onNavigateToServices()
                    }
                    
                    NavigationCard(
                        title: "Settings",
                        description: "Profiles and preferences",
                        icon: "gearshape",
                        color: .gray
                    ) {
                        onNavigateToSettings()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Navigation card component for home screen
private struct NavigationCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(color)
                    .frame(width: 60, height: 60)
                    .background(color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Home View") {
    NavigationStack {
        HomeView(
            onNavigateToDashboard: { print("Navigate to Dashboard") },
            onNavigateToServices: { print("Navigate to Services") },
            onNavigateToSettings: { print("Navigate to Settings") }
        )
    }
}
