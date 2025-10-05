//
//  ProfileListView.swift
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
import SwiftData

/// View displaying list of profiles with management capabilities
@MainActor
struct ProfileListView: View {
    @State private var coordinator: SettingsCoordinator
    @State private var viewModel: ProfileListViewModel
    @State private var showingAddProfile = false
    @State private var showingDeleteConfirmation = false
    @State private var profileToDelete: Profile?
    
    init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
        // Initialize ViewModel from DI container
        let profileService = DIContainer.shared.resolve((any ProfileServiceProtocol).self)
        let preferences = DIContainer.shared.resolve((any UserPreferencesServiceProtocol).self)
        self.viewModel = ProfileListViewModel(
            profileService: profileService,
            preferencesService: preferences
        )
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Loading profiles...")
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    Task {
                        await viewModel.loadProfiles()
                    }
                }
            } else if viewModel.profiles.isEmpty {
                EmptyStateView(
                    icon: "person.2.slash",
                    title: "No Profiles",
                    subtitle: "Create your first profile to get started",
                    actionTitle: "Add Profile",
                    action: {
                        showingAddProfile = true
                    }
                )
            } else {
                profileList
            }
        }
        .navigationTitle("Profiles")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddProfile = true
                } label: {
                    Label("Add Profile", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddProfile) {
            AddProfileView(coordinator: coordinator)
        }
        .alert("Delete Profile", isPresented: $showingDeleteConfirmation, presenting: profileToDelete) { profile in
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteProfile(profile)
                }
            }
        } message: { profile in
            Text("Are you sure you want to delete '\(profile.name)'? This action cannot be undone.")
        }
        .task {
            await viewModel.loadProfiles()
        }
    }
    
    @ViewBuilder
    private var profileList: some View {
        List {
            ForEach(viewModel.profiles) { profile in
                ProfileRow(
                    profile: profile,
                    isActive: profile.name == viewModel.currentProfileName,
                    onSwitch: {
                        Task {
                            await viewModel.switchProfile(to: profile)
                        }
                    },
                    onDelete: {
                        if viewModel.canDeleteProfile(profile) {
                            profileToDelete = profile
                            showingDeleteConfirmation = true
                        }
                    }
                )
            }
        }
        .refreshable {
            await viewModel.loadProfiles()
        }
    }
}

// MARK: - Profile Row

private struct ProfileRow: View {
    let profile: Profile
    let isActive: Bool
    let onSwitch: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack {
                    Text(profile.name)
                        .font(.headline)
                    
                    if isActive {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.caption)
                    }
                }
                
                // Service configuration comes in Milestone 2
                Text("Services not yet configured")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if !isActive {
                Button {
                    onSwitch()
                } label: {
                    Text("Switch")
                        .font(.caption)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xxs)
                }
                .buttonStyle(.bordered)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .contextMenu {
            if !isActive {
                Button {
                    onSwitch()
                } label: {
                    Label("Switch to Profile", systemImage: "arrow.right.circle")
                }
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete Profile", systemImage: "trash")
            }
        }
    }
}

// MARK: - Preview

#Preview("Profile List - With Profiles") {
    let coordinator = SettingsCoordinator()
    coordinator.start()
    
    return NavigationStack {
        ProfileListView(coordinator: coordinator)
    }
}

#Preview("Profile List - Empty") {
    let coordinator = SettingsCoordinator()
    coordinator.start()
    
    return NavigationStack {
        ProfileListView(coordinator: coordinator)
    }
}
