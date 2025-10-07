//
//  SettingsCoordinatorView.swift
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

/// Settings coordinator view
struct SettingsCoordinatorView: View {
    @Bindable var coordinator: SettingsCoordinator
    
    var body: some View {
        SettingsView(coordinator: coordinator)
            .navigationDestination(for: SettingsRoute.self) { route in
                destinationView(for: route)
            }
            .logViewLifecycle(
                view: "SettingsCoordinatorView",
                metadata: [
                    "coordinator_type": "SettingsCoordinator",
                    "navigation_depth": "\(coordinator.navigationPath.count)"
                ]
            )
    }
    
    @ViewBuilder
    private func destinationView(for route: SettingsRoute) -> some View {
        switch route {
        case .main:
            // .main should not be pushed - it's the root SettingsView
            // This case exists only for enum completeness
            EmptyView()
            
        case .profiles:
            ProfileListView(coordinator: coordinator)
            
        case .addProfile:
            AddProfileView(coordinator: coordinator)
            
        case .editProfile(let profileId):
            Text("Edit Profile: \(profileId)")
                .navigationTitle("Edit Profile")
            
        case .appearance:
            Text("Appearance Settings")
                .navigationTitle("Appearance")
            
        case .notifications:
            Text("Networking Settings")
                .navigationTitle("Networking")
            
        case .about:
            Text("About Thriftwood")
                .navigationTitle("About")
            
        case .logs:
            AcknowledgementsView()
        }
    }
}
