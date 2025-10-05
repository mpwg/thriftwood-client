//
//  OnboardingViewModel.swift
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

/// ViewModel for managing onboarding flow business logic
@MainActor
@Observable
final class OnboardingViewModel {
    // MARK: - Properties
    
    private let profileService: any ProfileServiceProtocol
    private let preferencesService: any UserPreferencesServiceProtocol
    
    var isLoading = false
    var error: (any Error)?
    
    /// Whether at least one profile exists
    var hasProfiles: Bool {
        do {
            let profiles = try profileService.fetchProfiles()
            return !profiles.isEmpty
        } catch {
            AppLogger.ui.error("Failed to check profiles: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Initialization
    
    init(
        profileService: any ProfileServiceProtocol,
        preferencesService: any UserPreferencesServiceProtocol
    ) {
        self.profileService = profileService
        self.preferencesService = preferencesService
    }
    
    // MARK: - Business Logic
    
    /// Check if user has completed profile creation step
    /// Returns true if at least one profile exists
    func checkProfileCreated() async -> Bool {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        do {
            let profiles = try profileService.fetchProfiles()
            let hasProfile = !profiles.isEmpty
            
            if hasProfile {
                AppLogger.ui.info("Profile creation verified: \(profiles.count) profile(s) exist")
            } else {
                AppLogger.ui.info("No profiles found after profile creation")
            }
            
            return hasProfile
        } catch {
            self.error = error
            AppLogger.ui.error("Failed to check profile creation: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Prepare for profile creation
    /// This can be extended in the future to pre-populate data or set up defaults
    func prepareForProfileCreation() {
        AppLogger.ui.info("Preparing for profile creation")
        clearError()
    }
    
    /// Handle completion of onboarding
    /// This can be extended to perform cleanup or analytics
    func handleOnboardingComplete() {
        AppLogger.ui.info("Onboarding completed")
        clearError()
    }
    
    /// Handle skipping onboarding
    /// This can be extended to track analytics or set preferences
    func handleOnboardingSkipped() {
        AppLogger.ui.info("Onboarding skipped by user")
        clearError()
    }
    
    // MARK: - Helper Methods
    
    /// Clear current error state
    func clearError() {
        self.error = nil
    }
}
