//
//  ErrorView.swift
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

import SwiftUI

/// A reusable error display component with retry capability
///
/// Displays an error icon, title, message, and optional retry button.
/// Uses theme colors and follows design system patterns.
///
/// Usage:
/// ```swift
/// ErrorView(
///     error: error,
///     onRetry: { viewModel.reload() }
/// )
/// ```
struct ErrorView: View {
    /// The error to display
    let error: any Error
    
    /// Optional custom title (defaults to "Error")
    let title: String?
    
    /// Optional retry action
    let onRetry: (() -> Void)?
    
    /// Creates an error view
    /// - Parameters:
    ///   - error: The error to display
    ///   - title: Optional custom title
    ///   - onRetry: Optional retry action closure
    init(
        error: any Error,
        title: String? = nil,
        onRetry: (() -> Void)? = nil
    ) {
        self.error = error
        self.title = title
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Error icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.error)
                .padding(.bottom, Spacing.sm)
            
            // Error title
            Text(title ?? "Error")
                .font(.title2.bold())
                .foregroundStyle(Color.themePrimaryText)
            
            // Error message
            Text(errorMessage)
                .font(.body)
                .foregroundStyle(Color.themeSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            
            // Retry button
            if let onRetry = onRetry {
                Button(action: onRetry) {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "arrow.clockwise")
                        Text("Retry")
                    }
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)
                    .background(Color.themeAccent)
                    .cornerRadius(CornerRadius.medium)
                }
                .padding(.top, Spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.themePrimaryBackground)
    }
    
    /// Extracts user-friendly error message
    private var errorMessage: String {
        if let thriftwoodError = error as? ThriftwoodError {
            return thriftwoodError.localizedDescription
        }
        return error.localizedDescription
    }
}

// MARK: - Previews

#Preview("Error - With Retry") {
    ErrorView(
        error: ThriftwoodError.networkError(URLError(.notConnectedToInternet)),
        onRetry: { print("Retry tapped") }
    )
}

#Preview("Error - Without Retry") {
    ErrorView(
        error: ThriftwoodError.authenticationRequired
    )
}

#Preview("Error - Custom Title") {
    ErrorView(
        error: ThriftwoodError.data(message: "Invalid data format"),
        title: "Failed to Load Data",
        onRetry: { print("Retry") }
    )
}

#Preview("Error - Generic Error") {
    struct CustomError: LocalizedError {
        var errorDescription: String? {
            "Something went wrong. Please try again later."
        }
    }
    
    return ErrorView(
        error: CustomError(),
        onRetry: { print("Retry") }
    )
}

#Preview("Error - Dark Theme") {
    ErrorView(
        error: ThriftwoodError.networkError(URLError(.timedOut)),
        onRetry: { print("Retry") }
    )
    .preferredColorScheme(.dark)
}
