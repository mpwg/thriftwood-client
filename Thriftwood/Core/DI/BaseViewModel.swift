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

/// Base implementation of a ViewModel with common state management
@MainActor
@Observable
class DefaultViewModel: BaseViewModel {
    var isLoading: Bool = false
    var error: ThriftwoodError?
    
    var hasData: Bool {
        // Override in subclasses
        false
    }
    
    func load() async {
        // Override in subclasses
        AppLogger.general.warning("load() not implemented in \(String(describing: type(of: self)))")
    }
    
    func reload() async {
        await load()
    }
}
