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
    
    /// Get color from the current theme
    /// These colors will be provided via ThemeManager environment
    
    /// Accent color from active theme
    static var themeAccent: Color {
        // Will be overridden by ThemeManager environment value
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
    /// This is used by ThemeManager to update colors when theme changes
    static func applyTheme(_ theme: Theme) {
        // Theme colors are applied through SwiftUI environment
        // Views access them via @Environment(\.theme) or Color.themeAccent
    }
}
