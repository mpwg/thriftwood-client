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
//
//  BaseViewModel.swift
//  Thriftwood
//
//  Base protocol and implementation for ViewModels using Swift 6 @Observable
//

import Foundation
import SwiftUI

/// Protocol defining common ViewModel behavior

protocol BaseViewModel: AnyObject, Observable {
    /// Current loading state
    @MainActor var isLoading: Bool { get set }
    
    /// Current error state
    @MainActor var error: ThriftwoodError? { get set }
    
    /// Whether the view model has data loaded
    @MainActor var hasData: Bool { get }
    
    /// Load initial data
    @MainActor func load() async
    
    /// Reload data (refresh)
    @MainActor func reload() async
    
    /// Handle error with optional custom action
    /// - Parameters:
    ///   - error: The error to handle
    ///   - customMessage: Optional custom error message
    @MainActor func handleError(_ error: any Error, customMessage: String?)
}

/// Default implementations for BaseViewModel
extension BaseViewModel {
    /// Default error handling implementation
    /// - Parameters:
    ///   - error: The error to handle
    ///   - customMessage: Optional custom message to override default
    func handleError(_ error: any Error, customMessage: String? = nil) {
        let thriftwoodError = ThriftwoodError.from(error)
        self.error = thriftwoodError
        
        AppLogger.general.error(
            customMessage ?? "Error in \(String(describing: type(of: self)))",
            error: thriftwoodError
        )
    }
    
    /// Clear current error state
    func clearError() {
        self.error = nil
    }
    
    /// Execute an async task with loading state management
    /// - Parameter task: The async task to execute
    func withLoading(_ task: @escaping () async throws -> Void) async {
        isLoading = true
        clearError()
        
        do {
            try await task()
        } catch {
            handleError(error, customMessage: nil)
        }
        
        isLoading = false
    }
}
