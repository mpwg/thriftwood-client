//
//  ProfilesViewModel.swift
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
class ProfilesViewModel {
    var profiles: [ThriftwoodProfile] = []
    var currentProfile: String = "default"
    var isLoading: Bool = false
    var errorMessage: String?
    var isShowingError: Bool = false
    
    private let settingsViewModel: SettingsViewModel
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        // Don't call loadProfiles() here - will be called when view appears
    }
    
    @MainActor
    func loadProfiles() {
        profiles = Array(settingsViewModel.appSettings.profiles.values)
        currentProfile = settingsViewModel.appSettings.enabledProfile
    }
    
    @MainActor
    func selectProfile(_ profileName: String) async {
        await settingsViewModel.switchProfile(profileName)
        loadProfiles()
    }
    
    @MainActor
    func createProfile(_ name: String) async {
        await settingsViewModel.createProfile(name)
        loadProfiles()
    }
    
    @MainActor
    func deleteProfile(_ profileName: String) async {
        await settingsViewModel.deleteProfile(profileName)
        loadProfiles()
    }
    
    @MainActor
    func renameProfile(from oldName: String, to newName: String) async {
        await settingsViewModel.renameProfile(from: oldName, to: newName)
        loadProfiles()
    }
}