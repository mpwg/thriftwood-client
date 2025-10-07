//
//  ServicesCoordinatorView.swift
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
//  ⚠️ OBSOLETE: This file is deprecated as part of ADR-0012 refactoring
//  AppCoordinator now handles all navigation with single NavigationStack.
//

#if false
import SwiftUI

/// Services coordinator view
struct ServicesCoordinatorView: View {
    @Bindable var coordinator: ServicesCoordinator
    @State private var showingRadarr = false
    @State private var showingSonarr = false
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            servicesListView()
                .navigationTitle("Services")
                .navigationDestination(for: ServicesRoute.self) { route in
                    destination(for: route)
                }
                .fullScreenCover(isPresented: $showingRadarr) {
                    let radarrCoordinator = coordinator.getRadarrCoordinator()
                    RadarrCoordinatorView(coordinator: radarrCoordinator)
                }
                .fullScreenCover(isPresented: $showingSonarr) {
                    // TODO [Milestone 3]: Implement Sonarr
                    Text("Sonarr Coming Soon")
                }
                .logViewLifecycle(
                    view: "ServicesCoordinatorView",
                    metadata: [
                        "coordinator_type": "ServicesCoordinator",
                        "navigation_depth": "\(coordinator.navigationPath.count)",
                        "child_coordinators": "\(coordinator.childCoordinators.count)"
                    ]
                )
        }
    }
    
    // MARK: - Services List
    
    @ViewBuilder
    private func servicesListView() -> some View {
        List {
            Section("Media Management") {
                Button(action: {
                    showingRadarr = true
                }) {
                    Label("Radarr", systemImage: "film")
                }
                
                Button(action: {
                    showingSonarr = true
                }) {
                    Label("Sonarr", systemImage: "tv")
                }
            }
            
            Section {
                Button(action: {
                    coordinator.showAddService()
                }) {
                    Label("Add Service", systemImage: "plus.circle")
                }
            }
        }
    }
    
    // MARK: - Destination Views
    
    @ViewBuilder
    private func destination(for route: ServicesRoute) -> some View {
        switch route {
        case .list:
            // .list should not be pushed - it's the root servicesListView
            // This case exists only for enum completeness
            EmptyView()
            
        case .radarr:
            // Radarr is shown via fullScreenCover, not push navigation
            // This case exists only for enum completeness
            EmptyView()
            
        case .sonarr:
            // Sonarr is shown via fullScreenCover, not push navigation
            // This case exists only for enum completeness
            EmptyView()
            
        case .addService:
            placeholderView(title: "Add Service", icon: "plus.circle")
            
        case .serviceConfiguration(let serviceId):
            placeholderView(title: "Configure \(serviceId)", icon: "gearshape")
            
        case .testConnection(let serviceId):
            placeholderView(title: "Test Connection \(serviceId)", icon: "network")
        }
    }
    
    // MARK: - Placeholder
    
    private func placeholderView(title: String, icon: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text(title)
                .font(.title)
            Text("Coming soon...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .navigationTitle(title)
    }
}
#endif  // Obsolete: ADR-0012
