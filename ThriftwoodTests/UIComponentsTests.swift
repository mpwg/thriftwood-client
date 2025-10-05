//
//  UIComponentsTests.swift
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

/// Tests for common UI components
@Suite("UI Components Tests")
@MainActor
struct UIComponentsTests {
    
    @Test("LoadingView initializes successfully")
    func loadingViewCreation() {
        _ = LoadingView()
        _ = LoadingView(message: "Loading...")
        _ = LoadingView(size: .large)
        // Views create successfully
    }
    
    @Test("ErrorView initializes successfully")
    func errorViewCreation() {
        let error = ThriftwoodError.networkError(URLError(.notConnectedToInternet))
        _ = ErrorView(error: error)
        _ = ErrorView(error: error, title: "Custom Title")
        // Views create successfully
    }
    
    @Test("EmptyStateView initializes successfully")
    func emptyStateViewCreation() {
        _ = EmptyStateView(icon: "magnifyingglass", title: "No Results")
        _ = EmptyStateView(icon: "film", title: "No Movies", subtitle: "Add some movies")
        // Views create successfully
    }
    
    @Test("CardView initializes successfully")
    func cardViewCreation() {
        _ = CardView { Text("Content") }
        _ = CardView(showBorder: true) { Text("Content") }
        // Views create successfully
    }
    
    @Test("Button styles can be instantiated")
    func buttonStylesInstantiation() {
        _ = PrimaryButtonStyle()
        _ = SecondaryButtonStyle()
        _ = DestructiveButtonStyle()
        _ = CompactButtonStyle()
        // Styles instantiate successfully
    }
}
