//
//  SwiftUIProfilesView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIProfilesView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Flutter Parity Implementation
                // Flutter equivalent: lib/modules/settings/routes/profiles/route.dart
                // Validation date: 2025-01-17
                // Exact match to Flutter's 4-button structure
                
                // Enabled Profile (matches _enabledProfile())
                enabledProfileRow
                
                // Add Profile (matches _addProfile())
                addProfileRow
                
                // Rename Profile (matches _renameProfile())
                renameProfileRow
                
                // Delete Profile (matches _deleteProfile())  
                deleteProfileRow
            }
            .navigationTitle("Profiles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.isShowingError) {
                Button("OK") {
                    viewModel.isShowingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
    
    // MARK: - Profile Management Rows (exact Flutter structure)
    
    private var enabledProfileRow: some View {
        Button(action: {
            Task {
                await viewModel.showEnabledProfileDialog()
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Enabled Profile")
                        .foregroundColor(.primary)
                    Text(viewModel.currentProfileName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "person")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var addProfileRow: some View {
        Button(action: {
            Task {
                await viewModel.showAddProfileDialog()
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Add Profile")
                        .foregroundColor(.primary)
                    Text("Add Profile Description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "plus")
                    .foregroundColor(.green)
            }
        }
    }
    
    private var renameProfileRow: some View {
        Button(action: {
            Task {
                await viewModel.showRenameProfileDialog()
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Rename Profile")
                        .foregroundColor(.primary)
                    Text("Rename Profile Description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "pencil")
                    .foregroundColor(.orange)
            }
        }
    }
    
    private var deleteProfileRow: some View {
        Button(action: {
            Task {
                await viewModel.showDeleteProfileDialog()
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Delete Profile")
                        .foregroundColor(.primary)
                    Text("Delete Profile Description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}