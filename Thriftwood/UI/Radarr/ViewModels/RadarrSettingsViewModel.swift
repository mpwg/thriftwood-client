//
//  RadarrSettingsViewModel.swift
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

import Foundation
import Observation
import RadarrAPI

/// ViewModel for managing Radarr service configuration
@MainActor
@Observable
final class RadarrSettingsViewModel {
    // MARK: - Dependencies

    private let radarrService: any RadarrServiceProtocol
    private let dataService: any DataServiceProtocol

    // MARK: - Published Properties

    var serviceConfiguration: ServiceConfiguration?
    var host: String = ""
    var apiKey: String = ""
    var isEnabled: Bool = false
    var isLoading = false
    var error: ThriftwoodError?
    private var rawSystemStatus: SystemResource?
    var systemStatusDisplay: RadarrSystemStatusDisplayModel?
    var connectionTestResult: ConnectionTestResult?

    // MARK: - Initialization

    init(
        radarrService: any RadarrServiceProtocol,
        dataService: any DataServiceProtocol
    ) {
        self.radarrService = radarrService
        self.dataService = dataService
    }

    // MARK: - Public Methods

    /// Load the current Radarr configuration
    /// - Parameter profile: The profile to load configuration from
    func loadConfiguration(for profile: Profile) async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        // Find Radarr configuration for this profile
        serviceConfiguration = profile.serviceConfigurations.first {
            $0.serviceType == .radarr
        }

        if let config = serviceConfiguration {
            host = config.host
            isEnabled = config.isEnabled

            // Load API key from keychain
            if let storedApiKey = dataService.getAPIKey(for: config) {
                apiKey = storedApiKey
            }

            // If service is configured, try to load system status
            if config.isValid(), !apiKey.isEmpty {
                await loadSystemStatus()
            }
        }
    }

    /// Test the connection to Radarr
    /// - Returns: True if connection is successful
    func testConnection() async -> Bool {
        guard !host.isEmpty, !apiKey.isEmpty else {
            error = .validation(message: "Host and API key are required")
            connectionTestResult = .failure(message: "Host and API key are required")
            return false
        }

        guard let url = URL(string: host) else {
            error = .invalidURL
            connectionTestResult = .failure(message: "Invalid host URL")
            return false
        }

        isLoading = true
        error = nil
        connectionTestResult = nil
        defer { isLoading = false }

        do {
            // Configure service with test credentials
            try await radarrService.configure(baseURL: url, apiKey: apiKey)

            // Test connection
            let isConnected = try await radarrService.testConnection()

            if isConnected {
                connectionTestResult = .success
                // Load system status on successful connection
                await loadSystemStatus()
                return true
            } else {
                connectionTestResult = .failure(message: "Connection failed")
                return false
            }
        } catch let error as ThriftwoodError {
            self.error = error
            connectionTestResult = .failure(message: error.errorDescription ?? "Unknown error")
            return false
        } catch {
            let wrappedError = ThriftwoodError.unknown(error)
            self.error = wrappedError
            connectionTestResult = .failure(message: wrappedError.errorDescription ?? "Unknown error")
            return false
        }
    }

    /// Save the current settings
    /// - Parameter profile: The profile to save settings to
    func saveSettings(for profile: Profile) async {
        guard !host.isEmpty, !apiKey.isEmpty else {
            error = .validation(message: "Host and API key are required")
            return
        }

        guard let url = URL(string: host) else {
            error = .invalidURL
            return
        }

        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            // Create or update service configuration
            if serviceConfiguration == nil {
                serviceConfiguration = ServiceConfiguration(
                    serviceType: .radarr,
                    isEnabled: isEnabled,
                    host: host,
                    authenticationType: .apiKey
                )
                serviceConfiguration?.profile = profile
                profile.serviceConfigurations.append(serviceConfiguration!)
            } else {
                serviceConfiguration?.host = host
                serviceConfiguration?.isEnabled = isEnabled
            }

            guard let config = serviceConfiguration else {
                throw ThriftwoodError.invalidConfiguration("Failed to create service configuration")
            }

            // Save API key to keychain
            try dataService.saveAPIKey(apiKey, for: config)

            // Update configuration in storage
            try dataService.updateServiceConfiguration(config, for: profile)

            // Configure the service
            try await radarrService.configure(baseURL: url, apiKey: apiKey)

        } catch let error as ThriftwoodError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
    }

    /// Load Radarr system status
    func loadSystemStatus() async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            rawSystemStatus = try await radarrService.getSystemStatus()
            systemStatusDisplay = convertSystemStatusToDisplay(rawSystemStatus)
        } catch let error as ThriftwoodError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
    }

    /// Validate the current configuration
    /// - Returns: True if configuration is valid
    func validateConfiguration() -> Bool {
        guard !host.isEmpty else {
            error = .validation(message: "Host is required")
            return false
        }

        guard URL(string: host) != nil else {
            error = .invalidURL
            return false
        }

        guard !apiKey.isEmpty else {
            error = .validation(message: "API key is required")
            return false
        }

        error = nil
        return true
    }
    
    // MARK: - Private Methods
    
    /// Convert SystemResource to display model
    private func convertSystemStatusToDisplay(_ status: SystemResource?) -> RadarrSystemStatusDisplayModel? {
        guard let status = status else { return nil }
        
        return RadarrSystemStatusDisplayModel(
            version: status.version,
            osName: status.osName,
            osVersion: status.osVersion,
            runtimeName: status.runtimeName,
            runtimeVersion: status.runtimeVersion,
            startupPath: status.startupPath,
            appData: status.appData,
            branch: status.branch,
            databaseType: status.databaseType?.rawValue,
            authentication: status.authentication?.rawValue
        )
    }
}

// MARK: - Supporting Types

enum ConnectionTestResult {
    case success
    case failure(message: String)

    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
