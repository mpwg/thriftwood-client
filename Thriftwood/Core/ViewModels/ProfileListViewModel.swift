//
//  ProfileListViewModel.swift
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
import SwiftData

/// ViewModel for managing profile list
@MainActor
@Observable
final class ProfileListViewModel {
    // MARK: - Properties
    
    private let profileService: any ProfileServiceProtocol
    private let preferencesService: any UserPreferencesServiceProtocol
    
    var profiles: [Profile] = []
    var isLoading = false
    var error: (any Error)?
    
    var currentProfileName: String? {
        preferencesService.enabledProfileName
    }
    
    // MARK: - Initialization
    
    init(
        profileService: any ProfileServiceProtocol,
        preferencesService: any UserPreferencesServiceProtocol
    ) {
        self.profileService = profileService
        self.preferencesService = preferencesService
    }
    
    // MARK: - Actions
    
    func loadProfiles() async {
        isLoading = true
        error = nil
        
        do {
            profiles = try profileService.fetchProfiles()
            AppLogger.ui.info("Loaded \(self.profiles.count) profiles")
        } catch {
            self.error = error
            AppLogger.ui.error("Failed to load profiles: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func switchProfile(to profile: Profile) async {
        do {
            try profileService.switchToProfile(profile)
            AppLogger.ui.info("Switched to profile: \(profile.name)")
            
            // Reload to update UI
            await loadProfiles()
        } catch {
            self.error = error
            AppLogger.ui.error("Failed to switch profile: \(error.localizedDescription)")
        }
    }
    
    func deleteProfile(_ profile: Profile) async {
        do {
            try profileService.deleteProfile(profile)
            AppLogger.ui.info("Deleted profile: \(profile.name)")
            
            // Reload list
            await loadProfiles()
        } catch {
            self.error = error
            AppLogger.ui.error("Failed to delete profile: \(error.localizedDescription)")
        }
    }
    
    func canDeleteProfile(_ profile: Profile) -> Bool {
        // Can't delete if it's the only profile or if it's the current profile
        return profiles.count > 1 && profile.name != currentProfileName
    }
}
