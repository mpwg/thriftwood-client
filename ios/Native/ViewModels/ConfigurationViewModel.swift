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
    
    @MainActor
    func testConnection(for service: ServiceConfiguration) async -> Bool {
        // Phase 2: Basic validation only - actual connection testing will be implemented in later phases
        isLoading = true
        
        // Simulate network delay for user feedback
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isLoading = false
        
        // Basic validation: ensure host and API key are provided
        return !service.host.isEmpty && !service.apiKey.isEmpty
    }
    
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