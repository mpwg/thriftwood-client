//
//  DashboardViewModelTests.swift
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
import SwiftUI
@testable import Thriftwood

// MARK: - DashboardViewModel Tests

@Suite("DashboardViewModel Tests")
struct DashboardViewModelTests {
    
    @Test("initializes with default modules")
    @MainActor
    func testInitializationWithDefaultModules() {
        let viewModel = DashboardViewModel()
        
        #expect(!viewModel.modules.isEmpty)
        #expect(viewModel.modules.count == 7)
        
        // Verify all expected modules are present
        let moduleIds = Set(viewModel.modules.map { $0.id })
        let expectedIds: Set<String> = ["lidarr", "radarr", "sabnzbd", "search", "sonarr", "tautulli", "settings"]
        #expect(moduleIds == expectedIds)
    }
    
    @Test("available modules filters enabled modules")
    @MainActor
    func testAvailableModulesFiltering() {
        let viewModel = DashboardViewModel()
        
        // Initially all modules should be enabled
        #expect(viewModel.availableModules.count == viewModel.modules.count)
        
        // Disable a module
        viewModel.toggleModule("radarr")
        
        // Available modules should be one less
        #expect(viewModel.availableModules.count == viewModel.modules.count - 1)
        #expect(!viewModel.availableModules.contains { $0.id == "radarr" })
    }
    
    @Test("toggle module changes enabled state")
    @MainActor  
    func testToggleModule() throws {
        let viewModel = DashboardViewModel()
        
        let radarrModule = viewModel.module(withId: "radarr")
        try #require(radarrModule != nil)
        #expect(radarrModule!.isEnabled == true)
        
        // Toggle module
        viewModel.toggleModule("radarr")
        
        let toggledModule = viewModel.module(withId: "radarr")
        try #require(toggledModule != nil)
        #expect(toggledModule!.isEnabled == false)
        
        // Toggle back
        viewModel.toggleModule("radarr")
        
        let retoggledModule = viewModel.module(withId: "radarr")
        try #require(retoggledModule != nil)
        #expect(retoggledModule!.isEnabled == true)
    }
    
    @Test("module with id returns correct module")
    @MainActor
    func testModuleWithId() throws {
        let viewModel = DashboardViewModel()
        
        let radarrModule = viewModel.module(withId: "radarr")
        try #require(radarrModule != nil)
        #expect(radarrModule!.title == "Radarr")
        #expect(radarrModule!.subtitle == "Manage Movies")
        
        let nonExistentModule = viewModel.module(withId: "nonexistent")
        #expect(nonExistentModule == nil)
    }
    
    @Test("load method completes without error")
    @MainActor
    func testLoad() async {
        let viewModel = DashboardViewModel()
        
        await viewModel.load()
        
        #expect(!viewModel.modules.isEmpty)
        #expect(viewModel.error == nil)
    }
    
    @Test("reload method works correctly")
    @MainActor
    func testReload() async {
        let viewModel = DashboardViewModel()
        
        await viewModel.reload()
        
        #expect(!viewModel.modules.isEmpty)
        #expect(viewModel.error == nil)
    }
    
    @Test("modules are sorted by title")
    @MainActor
    func testModulesSorting() {
        let viewModel = DashboardViewModel()
        
        let sortedTitles = viewModel.modules.map { $0.title }.sorted()
        _ = viewModel.modules.map { $0.title }
        
        // Note: Since Module conforms to Comparable, this tests the sorting behavior
        let sortedModules = viewModel.modules.sorted()
        let sortedModuleTitles = sortedModules.map { $0.title }
        
        #expect(sortedModuleTitles == sortedTitles)
    }
    
    @Test("module properties are correctly set")
    @MainActor
    func testModuleProperties() {
        let viewModel = DashboardViewModel()
        
        guard let radarrModule = viewModel.module(withId: "radarr") else {
            Issue.record("Radarr module not found")
            return
        }
        
        #expect(radarrModule.id == "radarr")
        #expect(radarrModule.title == "Radarr")
        #expect(radarrModule.subtitle == "Manage Movies")
        #expect(radarrModule.systemIcon == SystemIcon.movies)
        #expect(radarrModule.tint == .yellow)
        #expect(radarrModule.isEnabled == true)
    }
}