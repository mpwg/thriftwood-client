//
//  SystemLogsViewModel.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI
import Combine
import UniformTypeIdentifiers

@Observable
class SystemLogsViewModel {
    // MARK: - Published Properties
    var logs: [LunaLogEntry] = []
    var selectedLogType: LunaLogType = .all
    var isLoading: Bool = false
    var errorMessage: String?
    var isShowingError: Bool = false
    
    // MARK: - Computed Properties
    var filteredLogs: [LunaLogEntry] {
        if selectedLogType == .all {
            return logs.filter { $0.type.enabled }
        }
        return logs.filter { $0.type == selectedLogType }
    }
    
    // MARK: - Public Methods
    
    /// Load system logs from Flutter LunaBox.logs implementation
    @MainActor
    func loadLogs() async {
        isLoading = true
        
        do {
            // Flutter implementation: LunaBox.logs.data access
            let hiveManager = HiveDataManager.shared
            
            // Load logs from Hive like Flutter's LunaBox.logs.data
            logs = try await hiveManager.getLogs()
            
            // Sort by timestamp (newest first) like Flutter implementation
            logs.sort { $0.timestamp > $1.timestamp }
            
        } catch {
            showError("Failed to load logs: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// Clear all logs using Flutter LunaLogger().clear() implementation
    @MainActor
    func clearLogs() async {
        do {
            // Flutter implementation: LunaLogger().clear() -> LunaBox.logs.clear()
            let hiveManager = HiveDataManager.shared
            
            try await hiveManager.clearLogs()
            logs.removeAll()
            
        } catch {
            showError("Failed to clear logs: \(error.localizedDescription)")
        }
    }
    
    /// Refresh logs
    @MainActor
    func refreshLogs() async {
        await loadLogs()
    }
    
    /// Export logs using Flutter LunaLogger().export() implementation
    @MainActor
    func exportLogs() async -> URL? {
        guard !logs.isEmpty else { return nil }
        
        do {
            // Flutter implementation: LunaLogger().export() creates JSON with indentation
            let hiveManager = HiveDataManager.shared
            
            let jsonData = try await hiveManager.exportLogs()
            
            // Create logs.json file like Flutter
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let logFileURL = documentsPath.appendingPathComponent("logs.json")
            
            try jsonData.write(to: logFileURL)
            return logFileURL
            
        } catch {
            showError("Failed to export logs: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func showError(_ message: String) {
        errorMessage = message
        isShowingError = true
    }
}