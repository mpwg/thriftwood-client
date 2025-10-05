//
//  CardView.swift
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

/// A reusable card container view with theme-aware styling
///
/// Provides consistent card styling with proper spacing, shadows, and theme support.
/// Matches the legacy LunaCard pattern from Flutter implementation.
///
/// Usage:
/// ```swift
/// CardView {
///     Text("Card Content")
/// }
/// ```
struct CardView<Content: View>: View {
    /// Card content
    let content: Content
    
    /// Optional custom padding
    let padding: EdgeInsets
    
    /// Whether to show border (useful for AMOLED themes)
    let showBorder: Bool
    
    /// Creates a card view
    /// - Parameters:
    ///   - padding: Custom padding (default: medium on all sides)
    ///   - showBorder: Whether to show border (default: false)
    ///   - content: Card content builder
    init(
        padding: EdgeInsets = EdgeInsets(
            top: Spacing.md,
            leading: Spacing.md,
            bottom: Spacing.md,
            trailing: Spacing.md
        ),
        showBorder: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.showBorder = showBorder
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(Color.themeCardBackground)
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        showBorder ? Color.themeSeparator : Color.clear,
                        lineWidth: 1
                    )
            )
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 4,
                x: 0,
                y: 2
            )
    }
}

// MARK: - Card Modifiers

extension View {
    /// Wraps the view in a CardView
    /// - Parameters:
    ///   - padding: Custom padding (default: medium on all sides)
    ///   - showBorder: Whether to show border (default: false)
    /// - Returns: View wrapped in CardView
    func card(
        padding: EdgeInsets = EdgeInsets(
            top: Spacing.md,
            leading: Spacing.md,
            bottom: Spacing.md,
            trailing: Spacing.md
        ),
        showBorder: Bool = false
    ) -> some View {
        CardView(padding: padding, showBorder: showBorder) {
            self
        }
    }
}

// MARK: - Previews

#Preview("Card - Basic") {
    CardView {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Card Title")
                .font(.headline)
            Text("Card content goes here")
                .font(.body)
        }
    }
    .padding()
}

#Preview("Card - With Border") {
    CardView(showBorder: true) {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Card Title")
                .font(.headline)
            Text("Card with border enabled")
                .font(.body)
        }
    }
    .padding()
}

#Preview("Card - Custom Padding") {
    CardView(
        padding: EdgeInsets(
            top: Spacing.lg,
            leading: Spacing.lg,
            bottom: Spacing.lg,
            trailing: Spacing.lg
        )
    ) {
        Text("Card with large padding")
    }
    .padding()
}

#Preview("Card - List of Cards") {
    ScrollView {
        VStack(spacing: Spacing.md) {
            ForEach(0..<5) { index in
                CardView {
                    HStack {
                        Image(systemName: "film")
                            .font(.title)
                            .foregroundStyle(Color.themeAccent)
                        
                        VStack(alignment: .leading) {
                            Text("Movie \(index + 1)")
                                .font(.headline)
                            Text("2024 • Action")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview("Card - Using Modifier") {
    VStack(alignment: .leading, spacing: Spacing.sm) {
        Text("Modified Card")
            .font(.headline)
        Text("Using the .card() modifier")
            .font(.body)
    }
    .card()
    .padding()
}

#Preview("Card - Dark Theme") {
    VStack(spacing: Spacing.md) {
        CardView {
            Text("Dark theme card")
        }
        
        CardView(showBorder: true) {
            Text("Dark theme with border")
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Card - Complex Content") {
    CardView {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.themeAccent)
                
                VStack(alignment: .leading) {
                    Text("Profile Name")
                        .font(.headline)
                    Text("Default Profile")
                        .font(.caption)
                        .foregroundStyle(Color.themeSecondaryText)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.themeAccent)
                }
            }
            
            Divider()
            
            // Content
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("Radarr:")
                        .foregroundStyle(Color.themeSecondaryText)
                    Spacer()
                    Text("Enabled")
                        .foregroundStyle(Color.success)
                }
                
                HStack {
                    Text("Sonarr:")
                        .foregroundStyle(Color.themeSecondaryText)
                    Spacer()
                    Text("Enabled")
                        .foregroundStyle(Color.success)
                }
                
                HStack {
                    Text("Tautulli:")
                        .foregroundStyle(Color.themeSecondaryText)
                    Spacer()
                    Text("Disabled")
                        .foregroundStyle(Color.error)
                }
            }
            .font(.footnote)
        }
    }
    .padding()
}
