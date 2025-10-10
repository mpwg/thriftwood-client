//
//  BaseViewModel.swift
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

// MARK: - BaseViewModel Protocol

/// Base protocol for all ViewModels in the MVVM-C architecture
/// Provides common state management and lifecycle methods
@MainActor
protocol BaseViewModel: Observable {
    /// Loading state indicator
    var isLoading: Bool { get set }
    
    /// Current error state
    var error: (any Error)? { get set }
    
    /// Load initial data
    func load() async
    
    /// Reload data (refresh)
    func reload() async
    
    /// Cleanup resources when view disappears
    func cleanup()
}

// MARK: - Default Implementation

extension BaseViewModel {
    /// Default reload implementation calls load()
    func reload() async {
        await load()
    }
    
    /// Default cleanup implementation (override if needed)
    func cleanup() {
        // Override in concrete implementations if cleanup is needed
    }
}



// MARK: - Base Implementation Class

/// Concrete base class providing common ViewModel functionality
/// Inherit from this class for ViewModels that need default implementations
@MainActor
@Observable
class BaseViewModelImpl: BaseViewModel {
    var isLoading: Bool = false
    var error: (any Error)? = nil
    
    init() {}
    
    func load() async {
        // Override in subclasses
    }
    
    func reload() async {
        await load()
    }
    
    func cleanup() {
        // Override in subclasses if needed
    }
    
    // MARK: - Error Handling Helpers
    
    /// Helper to safely execute async operations with error handling
    func safeAsync<T>(_ operation: @escaping () async throws -> T) async -> T? {
        do {
            isLoading = true
            error = nil
            let result = try await operation()
            isLoading = false
            return result
        } catch {
            self.error = error
            isLoading = false
            return nil
        }
    }
    
    /// Helper to execute operations without return value
    func safeAsyncVoid(_ operation: @escaping () async throws -> Void) async {
        do {
            isLoading = true
            error = nil
            try await operation()
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}