//
//  EmptyStateView.swift
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

/// A reusable empty state component with customizable message and action
///
/// Displays an icon, title, subtitle, and optional action button.
/// Uses theme colors and follows design system patterns.
///
/// Usage:
/// ```swift
/// EmptyStateView(
///     icon: "film",
///     title: "No Movies",
///     subtitle: "Add movies to see them here",
///     actionTitle: "Add Movie",
///     action: { viewModel.addMovie() }
/// )
/// ```
struct EmptyStateView: View {
    /// SF Symbol name for the icon
    let icon: String
    
    /// Main title text
    let title: String
    
    /// Optional subtitle/description text
    let subtitle: String?
    
    /// Optional action button title
    let actionTitle: String?
    
    /// Optional action closure
    let action: (() -> Void)?
    
    /// Creates an empty state view
    /// - Parameters:
    ///   - icon: SF Symbol name for the icon
    ///   - title: Main title text
    ///   - subtitle: Optional subtitle/description
    ///   - actionTitle: Optional action button title
    ///   - action: Optional action closure
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(Color.themeSecondaryText.opacity(0.5))
                .padding(.bottom, Spacing.sm)
            
            // Title
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(Color.themePrimaryText)
                .multilineTextAlignment(.center)
            
            // Subtitle
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(Color.themeSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            // Action button
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
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
}

// MARK: - Previews

#Preview("Empty State - With Action") {
    EmptyStateView(
        icon: "film",
        title: "No Movies",
        subtitle: "Add movies to see them here",
        actionTitle: "Add Movie",
        action: { print("Add movie tapped") }
    )
}

#Preview("Empty State - Without Action") {
    EmptyStateView(
        icon: "tray",
        title: "No Items",
        subtitle: "There are no items to display"
    )
}

#Preview("Empty State - Title Only") {
    EmptyStateView(
        icon: "magnifyingglass",
        title: "No Results Found"
    )
}

#Preview("Empty State - Search") {
    EmptyStateView(
        icon: "magnifyingglass",
        title: "No Search Results",
        subtitle: "Try adjusting your search terms",
        actionTitle: "Clear Filters",
        action: { print("Clear filters") }
    )
}

#Preview("Empty State - Dark Theme") {
    EmptyStateView(
        icon: "person.fill",
        title: "No Users",
        subtitle: "Start by adding your first user",
        actionTitle: "Add User",
        action: { print("Add user") }
    )
    .preferredColorScheme(.dark)
}
