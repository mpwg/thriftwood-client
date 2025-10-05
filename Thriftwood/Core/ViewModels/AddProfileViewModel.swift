//
//  AddProfileViewModel.swift
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

/// ViewModel for adding or editing profiles
@MainActor
@Observable
final class AddProfileViewModel {
    // MARK: - Properties
    
    private let profileService: any ProfileServiceProtocol
    private let existingProfile: Profile?
    
    var profileName: String = ""
    var switchAfterCreation: Bool = true
    var isSaving: Bool = false
    var error: (any Error)?
    
    var isEditing: Bool {
        existingProfile != nil
    }
    
    var validationError: String? {
        if profileName.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Profile name cannot be empty"
        }
        if profileName.count > 50 {
            return "Profile name is too long (maximum 50 characters)"
        }
        return nil
    }
    
    var isValid: Bool {
        validationError == nil
    }
    
    // MARK: - Initialization
    
    init(
        profileService: any ProfileServiceProtocol,
        existingProfile: Profile? = nil
    ) {
        self.profileService = profileService
        self.existingProfile = existingProfile
        
        if let existing = existingProfile {
            self.profileName = existing.name
            self.switchAfterCreation = false // Don't switch when editing
        }
    }
    
    // MARK: - Actions
    
    func saveProfile() async -> Bool {
        guard isValid else {
            return false
        }
        
        isSaving = true
        error = nil
        
        do {
            let trimmedName = profileName.trimmingCharacters(in: .whitespaces)
            
            if let existing = existingProfile {
                // Edit existing profile
                try profileService.renameProfile(existing, newName: trimmedName)
                AppLogger.ui.info("Renamed profile to: \(trimmedName)")
            } else {
                // Create new profile
                let newProfile = try profileService.createProfile(
                    name: trimmedName,
                    enableImmediately: switchAfterCreation
                )
                AppLogger.ui.info("Created new profile: \(trimmedName)")
                
                // Switch to it if requested (and not already enabled)
                if switchAfterCreation {
                    try profileService.switchToProfile(newProfile)
                    AppLogger.ui.info("Switched to new profile: \(trimmedName)")
                }
            }
            
            isSaving = false
            return true
        } catch {
            self.error = error
            AppLogger.ui.error("Failed to save profile: \(error.localizedDescription)")
            isSaving = false
            return false
        }
    }
}
