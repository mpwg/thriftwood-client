//
//  Color+Theme.swift
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

// MARK: - Theme-based Color Extensions

extension Color {
    
    // MARK: - Dynamic Colors (from active theme)
    
    /// Theme color accessors
    ///
    /// **Usage Pattern**:
    /// For dynamic theme colors, access the theme via environment:
    /// ```swift
    /// @Environment(\.mpwgTheme) private var theme
    /// var body: some View {
    ///     Text("Hello")
    ///         .foregroundStyle(theme.accentColor.color)
    /// }
    /// ```
    ///
    /// The static properties below provide fallback colors when theme is not available
    /// (e.g., in previews or during initialization).
    
    /// Accent color from active theme (fallback: orange)
    static var themeAccent: Color {
        .orange
    }
    
    /// Primary background from active theme
    static var themePrimaryBackground: Color {
        #if os(macOS)
        Color(nsColor: .controlBackgroundColor)
        #else
        Color(uiColor: .systemBackground)
        #endif
    }
    
    /// Secondary background from active theme
    static var themeSecondaryBackground: Color {
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color(uiColor: .secondarySystemBackground)
        #endif
    }
    
    /// Tertiary background from active theme
    static var themeTertiaryBackground: Color {
        #if os(macOS)
        Color(nsColor: .textBackgroundColor)
        #else
        Color(uiColor: .tertiarySystemBackground)
        #endif
    }
    
    /// Card background from active theme
    static var themeCardBackground: Color {
        #if os(macOS)
        Color(nsColor: .controlBackgroundColor)
        #else
        Color(uiColor: .secondarySystemBackground)
        #endif
    }
    
    /// Primary text from active theme
    static var themePrimaryText: Color {
        #if os(macOS)
        Color(nsColor: .labelColor)
        #else
        Color(uiColor: .label)
        #endif
    }
    
    /// Secondary text from active theme
    static var themeSecondaryText: Color {
        #if os(macOS)
        Color(nsColor: .secondaryLabelColor)
        #else
        Color(uiColor: .secondaryLabel)
        #endif
    }
    
    /// Tertiary text from active theme
    static var themeTertiaryText: Color {
        #if os(macOS)
        Color(nsColor: .tertiaryLabelColor)
        #else
        Color(uiColor: .tertiaryLabel)
        #endif
    }
    
    /// Placeholder text from active theme
    static var themePlaceholderText: Color {
        #if os(macOS)
        Color(nsColor: .placeholderTextColor)
        #else
        Color(uiColor: .placeholderText)
        #endif
    }
    
    /// Separator from active theme
    static var themeSeparator: Color {
        #if os(macOS)
        Color(nsColor: .separatorColor)
        #else
        Color(uiColor: .separator)
        #endif
    }
    
    /// Opaque separator from active theme
    static var themeOpaqueSeparator: Color {
        #if os(macOS)
        Color(nsColor: .separatorColor)
        #else
        Color(uiColor: .opaqueSeparator)
        #endif
    }
    
    // MARK: - Semantic Colors (consistent across themes)
    
    /// Success/positive state color
    static let success = Color.green
    
    /// Warning state color
    static let warning = Color.yellow
    
    /// Error/destructive state color
    static let error = Color.red
    
    /// Info state color
    static let info = Color.blue
    
    // MARK: - Service Colors (with theme overrides)
    
    /// Radarr service color
    static var radarr: Color {
        .yellow
    }
    
    /// Sonarr service color
    static var sonarr: Color {
        .blue
    }
    
    /// Lidarr service color
    static var lidarr: Color {
        .green
    }
    
    /// SABnzbd service color
    static var sabnzbd: Color {
        .orange
    }
    
    /// NZBGet service color
    static var nzbget: Color {
        .purple
    }
    
    /// Tautulli service color
    static var tautulli: Color {
        .orange
    }
    
    /// Overseerr service color
    static var overseerr: Color {
        .blue
    }
    
    /// Search/indexer color
    static var search: Color {
        .cyan
    }
}

// MARK: - Theme Application

extension Color {
    /// Apply a theme's colors to the color scheme
    ///
    /// **Recommended Pattern**:
    /// Access theme colors dynamically via environment:
    /// ```swift
    /// @Environment(\.mpwgTheme) private var theme
    /// theme.accentColor.color  // Dynamic accent color
    /// ```
    ///
    /// Static accessors like `Color.themeAccent` provide fallbacks but don't update
    /// when the theme changes. Use `@Environment(\.mpwgTheme)` for dynamic theming.
    static func applyTheme(_ theme: MPWGTheme) {
        // Theme colors are applied through SwiftUI environment
        // Access via: @Environment(\.mpwgTheme) private var theme
    }
    
    /// Initialize color from hexadecimal value
    ///
    /// Usage:
    /// ```swift
    /// let radarrColor = Color(hex: 0xFEC333)
    /// ```
    ///
    /// - Parameter hex: Hexadecimal color value (0xRRGGBB)
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

// MARK: - MPWGTheme Convenience Extensions

extension MPWGTheme {
    /// Convenience accessors for SwiftUI Colors from theme
    ///
    /// Usage in views:
    /// ```swift
    /// @Environment(\.mpwgTheme) private var theme
    ///
    /// var body: some View {
    ///     Text("Hello")
    ///         .foregroundStyle(theme.accent)      // Shorter syntax
    ///         .background(theme.primaryBg)
    /// }
    /// ```
    
    /// Accent color (shorter accessor)
    var accent: Color { accentColor.color }
    
    /// Primary background (shorter accessor)
    var primaryBg: Color { primaryBackground.color }
    
    /// Secondary background (shorter accessor)
    var secondaryBg: Color { secondaryBackground.color }
    
    /// Tertiary background (shorter accessor)
    var tertiaryBg: Color { tertiaryBackground.color }
    
    /// Card background (shorter accessor)
    var cardBg: Color { cardBackground.color }
    
    /// Primary text (shorter accessor)
    var primaryTxt: Color { primaryText.color }
    
    /// Secondary text (shorter accessor)
    var secondaryTxt: Color { secondaryText.color }
    
    /// Tertiary text (shorter accessor)
    var tertiaryTxt: Color { tertiaryText.color }
    
    /// Placeholder text (shorter accessor)
    var placeholderTxt: Color { placeholderText.color }
    
    /// Separator (shorter accessor)
    var separatorColor: Color { separator.color }
    
    /// Opaque separator (shorter accessor)
    var opaqueSeparatorColor: Color { opaqueSeparator.color }
    
    /// Success color (shorter accessor)
    var successColor: Color { success.color }
    
    /// Warning color (shorter accessor)
    var warningColor: Color { warning.color }
    
    /// Error color (shorter accessor)
    var errorColor: Color { error.color }
    
    /// Info color (shorter accessor)
    var infoColor: Color { info.color }
}
