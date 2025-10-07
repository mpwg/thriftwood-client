//
//  SettingsLogicCoordinator.swift
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
import OSLog

/// Logic coordinator for Settings feature (ADR-0012: Simple MVVM)
///
/// **Role**: Business logic and service coordination for Settings
/// **Navigation**: Handled by AppCoordinator (single NavigationStack pattern)
///
/// This coordinator manages:
/// - Settings-related business logic
/// - Profile management coordination
/// - Preferences handling
///
/// **It does NOT manage navigation** - that's handled by AppCoordinator with unified AppRoute enum.
@MainActor
@Observable
final class SettingsLogicCoordinator {
    // MARK: - Initialization
    
    init() {
        AppLogger.navigation.logCoordinator(
            event: "created",
            coordinator: "SettingsLogicCoordinator",
            details: "Settings logic coordinator initialized (no navigation path)"
        )
    }
    
    // MARK: - Business Logic Methods
    
    // Settings-specific business logic methods can be added here as needed
    // For now, this coordinator is primarily a dependency holder for Settings views
}
