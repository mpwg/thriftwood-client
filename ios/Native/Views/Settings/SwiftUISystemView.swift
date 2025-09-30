//
//  SwiftUISystemView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 17.01.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//

// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/modules/settings/routes/system/route.dart
// Validation date: 2025-01-17
// Validated against: Flutter SystemRoute exact structure

import SwiftUI

struct SwiftUISystemView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingLogs = false
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Exact Flutter Structure Match
                // Flutter: SettingsSystemBackupRestoreBackupTile()
                backupTile
                
                // Flutter: SettingsSystemBackupRestoreRestoreTile()
                restoreTile
                
                // Flutter: LunaDivider()
                Divider()
                
                // Flutter: _logs()
                logsTile
                
                // Flutter: _clearImageCache()
                clearImageCacheTile
                
                // Flutter: _clearConfiguration()
                clearConfigurationTile
            }
            .navigationTitle("System")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .alert("Clear Image Cache", isPresented: $viewModel.showingClearCacheConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    Task {
                        await viewModel.clearImageCache()
                    }
                }
            } message: {
                Text("Are you sure you want to clear the image cache?")
            }
            .alert("Clear Configuration", isPresented: $viewModel.showingClearConfigConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All Data", role: .destructive) {
                    Task {
                        await viewModel.clearConfiguration()
                    }
                }
            } message: {
                Text("This will reset all settings to default and cannot be undone. Are you sure?")
            }
            .alert("Error", isPresented: $viewModel.isShowingError) {
                Button("OK") {
                    viewModel.isShowingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .fullScreenCover(isPresented: $showingLogs) {
                FlutterSwiftUIBridge.shared.createSwiftUIView(for: "settings_system_logs", data: [:])
            }
        }
    }
    
    // MARK: - System Tiles (exact Flutter functionality)
    
    private var backupTile: some View {
        Button(action: {
            Task {
                await viewModel.performBackup()
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Backup Configuration")
                        .foregroundColor(.primary)
                    Text("Backup configuration to your device")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if viewModel.isBackingUp {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
        }
        .disabled(viewModel.isBackingUp)
    }
    
    private var restoreTile: some View {
        Button(action: {
            Task {
                await viewModel.performRestore()
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Restore Configuration")
                        .foregroundColor(.primary)
                    Text("Restore configuration from a backup file")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if viewModel.isRestoring {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.blue)
                }
            }
        }
        .disabled(viewModel.isRestoring)
    }
    
    private var logsTile: some View {
        Button(action: {
            showingLogs = true
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Logs")
                        .foregroundColor(.primary)
                    Text("View LunaSea logs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "doc.text")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var clearImageCacheTile: some View {
        Button(action: {
            viewModel.showingClearCacheConfirmation = true
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Clear Image Cache")
                        .foregroundColor(.primary)
                    Text("Remove cached images to free up storage")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if viewModel.isClearingCache {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .disabled(viewModel.isClearingCache)
    }
    
    private var clearConfigurationTile: some View {
        Button(action: {
            viewModel.showingClearConfigConfirmation = true
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Clear Configuration")
                        .foregroundColor(.primary)
                    Text("Clean slate!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SwiftUISystemView(viewModel: SettingsViewModel())
}