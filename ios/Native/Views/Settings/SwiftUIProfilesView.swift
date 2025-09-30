//
//  SwiftUIProfilesView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIProfilesView: View {
    let viewModel: ProfilesViewModel
    @State private var showingCreateProfile = false
    @State private var showingRenameProfile = false
    @State private var showingDeleteConfirmation = false
    @State private var newProfileName = ""
    @State private var selectedProfileToRename: ThriftwoodProfile?
    @State private var selectedProfileToDelete: ThriftwoodProfile?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Current Profile") {
                    ForEach(viewModel.profiles) { profile in
                        ProfileRow(
                            profile: profile,
                            isSelected: profile.name == viewModel.currentProfile,
                            onSelect: {
                                Task {
                                    await viewModel.selectProfile(profile.name)
                                }
                            },
                            onRename: {
                                selectedProfileToRename = profile
                                newProfileName = profile.name
                                showingRenameProfile = true
                            },
                            onDelete: profile.name != "default" ? {
                                selectedProfileToDelete = profile
                                showingDeleteConfirmation = true
                            } : nil
                        )
                    }
                }
            }
            .navigationTitle("Profiles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Profile") {
                        showingCreateProfile = true
                    }
                }
            }
            .alert("Create Profile", isPresented: $showingCreateProfile) {
                TextField("Profile Name", text: $newProfileName)
                Button("Create") {
                    Task {
                        await viewModel.createProfile(newProfileName)
                        newProfileName = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    newProfileName = ""
                }
            }
            .alert("Rename Profile", isPresented: $showingRenameProfile) {
                TextField("New Name", text: $newProfileName)
                Button("Rename") {
                    if let profile = selectedProfileToRename {
                        Task {
                            await viewModel.renameProfile(from: profile.name, to: newProfileName)
                            selectedProfileToRename = nil
                            newProfileName = ""
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    selectedProfileToRename = nil
                    newProfileName = ""
                }
            }
            .alert("Delete Profile", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let profile = selectedProfileToDelete {
                        Task {
                            await viewModel.deleteProfile(profile.name)
                            selectedProfileToDelete = nil
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    selectedProfileToDelete = nil
                }
            } message: {
                if let profile = selectedProfileToDelete {
                    Text("Are you sure you want to delete the profile '\(profile.name)'? This action cannot be undone.")
                }
            }
        }
        .task {
            await viewModel.loadProfiles()
        }
    }
}