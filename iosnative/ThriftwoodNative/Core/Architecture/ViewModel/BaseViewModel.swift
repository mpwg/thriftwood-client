import Combine
import Foundation

/// Base protocol for all ViewModels in the app
@MainActor
protocol ViewModel: ObservableObject {
    /// Indicates if the ViewModel is currently loading data
    var isLoading: Bool { get }

    /// Current error state, if any
    var error: Error? { get }

    /// Called when the view appears
    func onViewAppear() async

    /// Called when the view disappears
    func onViewDisappear()
}

/// Base implementation of ViewModel with common functionality
@MainActor
class BaseViewModel: ViewModel, ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Subclasses can override for custom initialization
    }

    func onViewAppear() async {
        // Override in subclasses
    }

    func onViewDisappear() {
        // Override in subclasses
    }

    /// Helper method to handle async operations with loading state
    func withLoading<T>(_ operation: () async throws -> T) async throws -> T {
        isLoading = true
        error = nil

        defer {
            isLoading = false
        }

        do {
            let result = try await operation()
            return result
        } catch {
            self.error = error
            throw error
        }
    }

    /// Helper method to clear errors
    func clearError() {
        error = nil
    }
}
