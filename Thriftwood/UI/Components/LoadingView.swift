//
//  LoadingView.swift
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

/// A reusable loading view component with theme-aware styling
///
/// Displays a progress indicator with optional message text.
/// Uses theme colors and follows design system spacing.
///
/// Usage:
/// ```swift
/// LoadingView()
/// LoadingView(message: "Loading movies...")
/// ```
struct LoadingView: View {
    /// Optional message to display below the spinner
    let message: String?
    
    /// Progress indicator size
    let size: LoadingSize
    
    /// Creates a loading view with optional message
    /// - Parameters:
    ///   - message: Optional text to display below the spinner
    ///   - size: Size of the progress indicator (default: .medium)
    init(message: String? = nil, size: LoadingSize = .medium) {
        self.message = message
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .themeAccent))
                .controlSize(size.controlSize)
            
            if let message = message {
                Text(message)
                    .font(.body)
                    .foregroundStyle(Color.themeSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.themePrimaryBackground)
    }
}

// MARK: - Loading Size

/// Size options for loading indicator
enum LoadingSize {
    case small
    case medium
    case large
    
    var controlSize: ControlSize {
        switch self {
        case .small: return .small
        case .medium: return .regular
        case .large: return .large
        }
    }
}

// MARK: - Previews

#Preview("Loading - No Message") {
    LoadingView()
}

#Preview("Loading - With Message") {
    LoadingView(message: "Loading movies...")
}

#Preview("Loading - Small") {
    LoadingView(message: "Please wait", size: .small)
}

#Preview("Loading - Large") {
    LoadingView(message: "Loading content...", size: .large)
}

#Preview("Loading - Dark Theme") {
    LoadingView(message: "Loading...")
        .preferredColorScheme(.dark)
}
