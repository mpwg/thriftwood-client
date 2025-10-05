//
//  Theme.swift
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

/// Complete theme definition with all colors and styles
/// Prefixed with MPWG to avoid naming conflicts with SwiftUI.Theme
struct MPWGTheme: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let isDark: Bool
    
    // MARK: - Colors
    
    var accentColor: CodableColor
    var primaryBackground: CodableColor
    var secondaryBackground: CodableColor
    var tertiaryBackground: CodableColor
    var cardBackground: CodableColor
    
    var primaryText: CodableColor
    var secondaryText: CodableColor
    var tertiaryText: CodableColor
    var placeholderText: CodableColor
    
    var separator: CodableColor
    var opaqueSeparator: CodableColor
    
    // MARK: - Semantic Colors
    
    var success: CodableColor
    var warning: CodableColor
    var error: CodableColor
    var info: CodableColor
    
    // MARK: - Service Colors (optional overrides)
    
    var radarr: CodableColor?
    var sonarr: CodableColor?
    var lidarr: CodableColor?
    var sabnzbd: CodableColor?
    var nzbget: CodableColor?
    var tautulli: CodableColor?
    var overseerr: CodableColor?
    var search: CodableColor?
    
    // MARK: - Theme-specific settings
    
    /// Whether to show borders (useful for black themes)
    var showBorders: Bool
    
    /// Image background opacity (0-100)
    var imageBackgroundOpacity: Int
    
    // MARK: - Predefined Themes
    
    /// Light theme (default)
    static let light = MPWGTheme(
        id: "light",
        name: "Light",
        isDark: false,
        accentColor: CodableColor(red: 1.0, green: 0.647, blue: 0.0), // Orange
        primaryBackground: CodableColor(red: 1.0, green: 1.0, blue: 1.0),
        secondaryBackground: CodableColor(red: 0.95, green: 0.95, blue: 0.97),
        tertiaryBackground: CodableColor(red: 1.0, green: 1.0, blue: 1.0),
        cardBackground: CodableColor(red: 1.0, green: 1.0, blue: 1.0),
        primaryText: CodableColor(red: 0.0, green: 0.0, blue: 0.0),
        secondaryText: CodableColor(red: 0.24, green: 0.24, blue: 0.26),
        tertiaryText: CodableColor(red: 0.24, green: 0.24, blue: 0.26, opacity: 0.6),
        placeholderText: CodableColor(red: 0.24, green: 0.24, blue: 0.26, opacity: 0.3),
        separator: CodableColor(red: 0.24, green: 0.24, blue: 0.26, opacity: 0.29),
        opaqueSeparator: CodableColor(red: 0.78, green: 0.78, blue: 0.78),
        success: CodableColor(red: 0.0, green: 1.0, blue: 0.0),
        warning: CodableColor(red: 1.0, green: 1.0, blue: 0.0),
        error: CodableColor(red: 1.0, green: 0.0, blue: 0.0),
        info: CodableColor(red: 0.0, green: 0.0, blue: 1.0),
        showBorders: false,
        imageBackgroundOpacity: 50
    )
    
    /// Dark theme
    static let dark = MPWGTheme(
        id: "dark",
        name: "Dark",
        isDark: true,
        accentColor: CodableColor(red: 1.0, green: 0.647, blue: 0.0), // Orange
        primaryBackground: CodableColor(red: 0.0, green: 0.0, blue: 0.0),
        secondaryBackground: CodableColor(red: 0.11, green: 0.11, blue: 0.12),
        tertiaryBackground: CodableColor(red: 0.17, green: 0.17, blue: 0.18),
        cardBackground: CodableColor(red: 0.11, green: 0.11, blue: 0.12),
        primaryText: CodableColor(red: 1.0, green: 1.0, blue: 1.0),
        secondaryText: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.6),
        tertiaryText: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.3),
        placeholderText: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.3),
        separator: CodableColor(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.15),
        opaqueSeparator: CodableColor(red: 0.22, green: 0.22, blue: 0.23),
        success: CodableColor(red: 0.0, green: 1.0, blue: 0.0),
        warning: CodableColor(red: 1.0, green: 1.0, blue: 0.0),
        error: CodableColor(red: 1.0, green: 0.0, blue: 0.0),
        info: CodableColor(red: 0.0, green: 0.0, blue: 1.0),
        showBorders: false,
        imageBackgroundOpacity: 50
    )
    
    /// Pure black theme (for OLED screens)
    static let black = MPWGTheme(
        id: "black",
        name: "Black",
        isDark: true,
        accentColor: CodableColor(red: 1.0, green: 0.647, blue: 0.0), // Orange
        primaryBackground: CodableColor(red: 0.0, green: 0.0, blue: 0.0),
        secondaryBackground: CodableColor(red: 0.0, green: 0.0, blue: 0.0),
        tertiaryBackground: CodableColor(red: 0.05, green: 0.05, blue: 0.05),
        cardBackground: CodableColor(red: 0.0, green: 0.0, blue: 0.0),
        primaryText: CodableColor(red: 1.0, green: 1.0, blue: 1.0),
        secondaryText: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.6),
        tertiaryText: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.3),
        placeholderText: CodableColor(red: 0.92, green: 0.92, blue: 0.96, opacity: 0.3),
        separator: CodableColor(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.15),
        opaqueSeparator: CodableColor(red: 0.15, green: 0.15, blue: 0.15),
        success: CodableColor(red: 0.0, green: 1.0, blue: 0.0),
        warning: CodableColor(red: 1.0, green: 1.0, blue: 0.0),
        error: CodableColor(red: 1.0, green: 0.0, blue: 0.0),
        info: CodableColor(red: 0.0, green: 0.0, blue: 1.0),
        showBorders: true, // Borders help distinguish elements on pure black
        imageBackgroundOpacity: 30 // Lower opacity for pure black backgrounds
    )
    
    /// All built-in themes
    static let builtInThemes: [MPWGTheme] = [.light, .dark, .black]
}

/// Codable wrapper for SwiftUI Color
struct CodableColor: Codable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double
    
    init(red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
    
    init(color: Color) {
        // Extract RGBA components from platform color
        #if os(macOS)
        let nsColor = NSColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
        #else
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        unsafe uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
        #endif
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Theme Extensions

extension MPWGTheme {
    /// Create a custom theme by modifying an existing theme
    func customized(
        id: String,
        name: String,
        accentColor: Color? = nil,
        showBorders: Bool? = nil,
        imageBackgroundOpacity: Int? = nil
    ) -> MPWGTheme {
        MPWGTheme(
            id: id,
            name: name,
            isDark: self.isDark,
            accentColor: accentColor.map { CodableColor(color: $0) } ?? self.accentColor,
            primaryBackground: self.primaryBackground,
            secondaryBackground: self.secondaryBackground,
            tertiaryBackground: self.tertiaryBackground,
            cardBackground: self.cardBackground,
            primaryText: self.primaryText,
            secondaryText: self.secondaryText,
            tertiaryText: self.tertiaryText,
            placeholderText: self.placeholderText,
            separator: self.separator,
            opaqueSeparator: self.opaqueSeparator,
            success: self.success,
            warning: self.warning,
            error: self.error,
            info: self.info,
            radarr: self.radarr,
            sonarr: self.sonarr,
            lidarr: self.lidarr,
            sabnzbd: self.sabnzbd,
            nzbget: self.nzbget,
            tautulli: self.tautulli,
            overseerr: self.overseerr,
            search: self.search,
            showBorders: showBorders ?? self.showBorders,
            imageBackgroundOpacity: imageBackgroundOpacity ?? self.imageBackgroundOpacity
        )
    }
}
