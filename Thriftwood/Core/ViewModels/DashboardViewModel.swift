//
//  DashboardViewModel.swift
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
import SwiftUI

// MARK: - Module Model

/// Represents a service module in the dashboard
struct Module: Identifiable, Hashable, Comparable {
    let id: String
    let title: String
    let subtitle: String
    let systemIcon: String
    let tint: Color
    let isEnabled: Bool
    
    init(id: String, title: String, subtitle: String, systemIcon: String, tint: Color, isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.systemIcon = systemIcon
        self.tint = tint
        self.isEnabled = isEnabled
    }
    
    static func < (lhs: Module, rhs: Module) -> Bool {
        lhs.title < rhs.title
    }
}

// MARK: - DashboardViewModel

@MainActor
@Observable
final class DashboardViewModel: BaseViewModelImpl {
    
    // MARK: - Published Properties
    
    /// Available service modules
    private(set) var modules: [Module] = []
    
    /// Filtered modules based on search and enabled state
    var availableModules: [Module] {
        modules.filter { $0.isEnabled }
    }
    
    // MARK: - Dependencies
    
    // TODO: Add UserPreferencesService for module configuration
    // private let userPreferencesService: any UserPreferencesServiceProtocol
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        loadModules()
    }
    
    // MARK: - BaseViewModel Implementation
    
    override func load() async {
        await safeAsyncVoid {
            // TODO: Load module configuration from UserPreferencesService
            // For now, use hardcoded modules
            self.loadModules()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadModules() {
        modules = [
            Module(
                id: "lidarr", 
                title: "Lidarr", 
                subtitle: "Manage Music", 
                systemIcon: SystemIcon.music, 
                tint: .green
            ),
            Module(
                id: "radarr", 
                title: "Radarr", 
                subtitle: "Manage Movies", 
                systemIcon: SystemIcon.movies, 
                tint: .yellow
            ),
            Module(
                id: "sabnzbd", 
                title: "SABnzbd", 
                subtitle: "Manage Usenet Downloads", 
                systemIcon: SystemIcon.downloadsFilled, 
                tint: .yellow
            ),
            Module(
                id: "search", 
                title: "Search", 
                subtitle: "Search Newznab Indexers", 
                systemIcon: SystemIcon.searchCircle, 
                tint: .mint
            ),
            Module(
                id: "sonarr", 
                title: "Sonarr", 
                subtitle: "Manage Television Series", 
                systemIcon: SystemIcon.tv, 
                tint: .blue
            ),
            Module(
                id: "tautulli", 
                title: "Tautulli", 
                subtitle: "View Plex Activity", 
                systemIcon: SystemIcon.monitoring, 
                tint: .orange
            ),
            Module(
                id: "settings", 
                title: "Settings", 
                subtitle: "Configure LunaSea", 
                systemIcon: SystemIcon.settingsFilled, 
                tint: .teal
            )
        ]
    }
    
    // MARK: - Public Methods
    
    /// Toggle module enabled state
    func toggleModule(_ moduleId: String) {
        // TODO: Persist to UserPreferencesService
        guard let index = modules.firstIndex(where: { $0.id == moduleId }) else { return }
        modules[index] = Module(
            id: modules[index].id,
            title: modules[index].title,
            subtitle: modules[index].subtitle,
            systemIcon: modules[index].systemIcon,
            tint: modules[index].tint,
            isEnabled: !modules[index].isEnabled
        )
    }
    
    /// Get module by ID
    func module(withId id: String) -> Module? {
        modules.first { $0.id == id }
    }
}