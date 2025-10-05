//
//  OnboardingViewModelTests.swift
//  ThriftwoodTests
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

import Testing
import Foundation
@testable import Thriftwood

/// Tests for OnboardingViewModel business logic
@Suite("OnboardingViewModel Tests")
@MainActor
struct OnboardingViewModelTests {
    
    // MARK: - Test Initialization
    
    @Test("ViewModel initializes with correct dependencies")
    func testInitialization() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
    }
    
    // MARK: - Test Profile Checking
    
    @Test("checkProfileCreated returns true when profiles exist")
    func testCheckProfileCreatedWithProfiles() async {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        // Setup: Add a profile
        let profile = Profile(name: "Test Profile")
        profileService.profiles = [profile]
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        let hasProfiles = await viewModel.checkProfileCreated()
        
        #expect(hasProfiles == true)
        #expect(viewModel.error == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("checkProfileCreated returns false when no profiles exist")
    func testCheckProfileCreatedWithoutProfiles() async {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        // Setup: No profiles
        profileService.profiles = []
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        let hasProfiles = await viewModel.checkProfileCreated()
        
        #expect(hasProfiles == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("checkProfileCreated handles errors gracefully")
    func testCheckProfileCreatedWithError() async {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        // Setup: Simulate error
        profileService.shouldThrowError = true
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        let hasProfiles = await viewModel.checkProfileCreated()
        
        #expect(hasProfiles == false)
        #expect(viewModel.error != nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("checkProfileCreated sets loading state correctly")
    func testCheckProfileCreatedLoadingState() async {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        // Start the check
        let checkTask = Task {
            await viewModel.checkProfileCreated()
        }
        
        // Give a tiny moment for loading to be set
        try? await Task.sleep(for: .milliseconds(10))
        
        _ = await checkTask.value
        
        // After completion, loading should be false
        #expect(viewModel.isLoading == false)
    }
    
    // MARK: - Test hasProfiles Property
    
    @Test("hasProfiles returns true when profiles exist")
    func testHasProfilesWithProfiles() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let profile = Profile(name: "Test Profile")
        profileService.profiles = [profile]
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        #expect(viewModel.hasProfiles == true)
    }
    
    @Test("hasProfiles returns false when no profiles exist")
    func testHasProfilesWithoutProfiles() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        profileService.profiles = []
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        #expect(viewModel.hasProfiles == false)
    }
    
    @Test("hasProfiles handles errors by returning false")
    func testHasProfilesWithError() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        profileService.shouldThrowError = true
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        #expect(viewModel.hasProfiles == false)
    }
    
    // MARK: - Test Lifecycle Methods
    
    @Test("prepareForProfileCreation clears errors")
    func testPrepareForProfileCreation() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        // Set an error
        viewModel.error = MockError.testError
        
        // Prepare for profile creation
        viewModel.prepareForProfileCreation()
        
        // Error should be cleared
        #expect(viewModel.error == nil)
    }
    
    @Test("handleOnboardingComplete clears errors")
    func testHandleOnboardingComplete() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        // Set an error
        viewModel.error = MockError.testError
        
        // Handle completion
        viewModel.handleOnboardingComplete()
        
        // Error should be cleared
        #expect(viewModel.error == nil)
    }
    
    @Test("handleOnboardingSkipped clears errors")
    func testHandleOnboardingSkipped() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        // Set an error
        viewModel.error = MockError.testError
        
        // Handle skip
        viewModel.handleOnboardingSkipped()
        
        // Error should be cleared
        #expect(viewModel.error == nil)
    }
    
    @Test("clearError removes error state")
    func testClearError() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        // Set an error
        viewModel.error = MockError.testError
        #expect(viewModel.error != nil)
        
        // Clear it
        viewModel.clearError()
        
        #expect(viewModel.error == nil)
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete onboarding flow with profile creation")
    func testCompleteOnboardingFlow() async {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        // 1. Start: No profiles
        #expect(viewModel.hasProfiles == false)
        
        // 2. Prepare for profile creation
        viewModel.prepareForProfileCreation()
        #expect(viewModel.error == nil)
        
        // 3. User creates a profile (simulated)
        let profile = Profile(name: "New Profile")
        profileService.profiles = [profile]
        
        // 4. Check profile was created
        let hasProfiles = await viewModel.checkProfileCreated()
        #expect(hasProfiles == true)
        #expect(viewModel.hasProfiles == true)
        
        // 5. Complete onboarding
        viewModel.handleOnboardingComplete()
        #expect(viewModel.error == nil)
    }
    
    @Test("Skip onboarding flow without profile creation")
    func testSkipOnboardingFlow() {
        let profileService = MockProfileService()
        let preferencesService = MockUserPreferencesService()
        
        let viewModel = OnboardingViewModel(
            profileService: profileService,
            preferencesService: preferencesService
        )
        
        // 1. Start: No profiles
        #expect(viewModel.hasProfiles == false)
        
        // 2. User skips onboarding
        viewModel.handleOnboardingSkipped()
        
        // 3. Verify state
        #expect(viewModel.error == nil)
        #expect(viewModel.hasProfiles == false)
    }
}

// MARK: - Test Helpers

private enum MockError: Error {
    case testError
}
