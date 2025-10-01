//
//  SwiftUISystemLogsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUISystemLogsView: View {
    @Bindable var viewModel: SystemLogsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: SystemLogsViewModel = SystemLogsViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Log type filter
                Picker("Log Type", selection: $viewModel.selectedLogType) {
                    ForEach(LunaLogType.allCases, id: \.self) { type in
                        Text(type.title)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Logs list
                if viewModel.isLoading {
                    ProgressView("Loading logs...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredLogs.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        
                        Text("No Logs Found")
                            .font(.headline)
                        
                        Text("No logs match the selected filter")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.filteredLogs, id: \.id) { log in
                        LunaLogEntryRow(log: log)
                    }
                    .refreshable {
                        await viewModel.refreshLogs()
                    }
                }
            }
            .navigationTitle("System Logs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Refresh") {
                            Task {
                                await viewModel.refreshLogs()
                            }
                        }
                        
                        Button("Clear All") {
                            Task {
                                await viewModel.clearLogs()
                            }
                        }
                        
                        Button("Export Logs") {
                            Task {
                                if let url = await viewModel.exportLogs() {
                                    // Show share sheet for exported logs
                                    // This would typically use UIActivityViewController
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
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
            .task {
                await viewModel.loadLogs()
            }
        }
    }
}