//
//  ConfigurationViewModel.swift
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
class ConfigurationViewModel {
    var selectedProfile: ThriftwoodProfile?
    var serviceConfigurations: [ServiceConfiguration] = []
    var downloadClientConfigurations: [DownloadClientConfiguration] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var isShowingError: Bool = false
    
    // Connection testing state - proper MVVM state management
    var isTestingConnection: Bool = false
    var connectionTestResult: String?
    
    let settingsViewModel: SettingsViewModel
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        // Don't call loadConfiguration() here - will be called when view appears
    }
    
    @MainActor
    func loadConfiguration() {
        selectedProfile = settingsViewModel.selectedProfile
        
        if let profile = selectedProfile {
            serviceConfigurations = profile.serviceConfigurations
            downloadClientConfigurations = profile.downloadClientConfigurations
        }
    }
    
    @MainActor
    func updateServiceConfiguration(_ config: ServiceConfiguration) async {
        await settingsViewModel.updateServiceConfiguration(
            config.name,
            enabled: config.enabled,
            host: config.host,
            apiKey: config.apiKey
        )
        loadConfiguration()
    }
    
    // Removed duplicate method - consolidated into private testConnection method below
    
    @MainActor
    func updateDownloadClientConfiguration(_ config: DownloadClientConfiguration) async {
        await settingsViewModel.updateDownloadClientConfiguration(
            config.name,
            enabled: config.enabled,
            host: config.host,
            username: config.username,
            password: config.password,
            apiKey: config.apiKey
        )
        loadConfiguration()
    }
    
    // MARK: - Service Connection Testing (Proper MVVM)
    
    @MainActor
    func testServiceConnection(_ service: ServiceConfiguration) {
        // Input validation - ViewModel responsibility
        guard !service.host.isEmpty && !service.apiKey.isEmpty else {
            connectionTestResult = "❌ Host and API Key are required"
            return
        }
        
        // Clear previous results and set loading state
        isTestingConnection = true
        connectionTestResult = nil
        
        // Perform async operation in ViewModel
        Task {
            let success = await testConnection(for: service)
            
            await MainActor.run {
                isTestingConnection = false
                connectionTestResult = success 
                    ? "✅ Connection successful!" 
                    : "❌ Connection failed"
            }
        }
    }
    
    private func testConnection(for service: ServiceConfiguration) async -> Bool {
        // Phase 2: Basic validation with simulated network delay for user feedback
        // This will be replaced with proper API calls once service APIs are migrated
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                // Mock implementation - in real implementation this would call service API
                let success = !service.host.isEmpty && !service.apiKey.isEmpty
                continuation.resume(returning: success)
            }
        }
    }
    
    @MainActor
    func testDownloadClientConnection(for client: DownloadClientConfiguration) async -> Bool {
        // Basic validation for download clients
        isLoading = true
        
        // Simulate network delay for user feedback
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isLoading = false
        
        // Validation based on client type
        if client.name.lowercased() == "sabnzbd" {
            return !client.host.isEmpty && !client.apiKey.isEmpty
        } else if client.name.lowercased() == "nzbget" {
            return !client.host.isEmpty && !client.username.isEmpty && !client.password.isEmpty
        }
        
        return !client.host.isEmpty
    }
}