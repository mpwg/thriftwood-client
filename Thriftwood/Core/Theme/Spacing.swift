//
//  Spacing.swift
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

import Foundation
import CoreGraphics

// MARK: - Spacing System

/// Consistent spacing scale for padding, margins, and gaps
enum Spacing {
    /// Extra extra small spacing (2pt)
    static let xxs: CGFloat = 2
    
    /// Extra small spacing (4pt)
    static let xs: CGFloat = 4
    
    /// Small spacing (8pt)
    static let sm: CGFloat = 8
    
    /// Medium spacing (12pt) - default for most UI elements
    static let md: CGFloat = 12
    
    /// Large spacing (16pt)
    static let lg: CGFloat = 16
    
    /// Extra large spacing (24pt)
    static let xl: CGFloat = 24
    
    /// Extra extra large spacing (32pt)
    static let xxl: CGFloat = 32
    
    /// Huge spacing (48pt)
    static let huge: CGFloat = 48
    
    // MARK: - Semantic Spacing
    
    /// Standard padding for view edges
    static let viewPadding: CGFloat = lg // 16pt
    
    /// Standard padding for cards and containers
    static let cardPadding: CGFloat = md // 12pt
    
    /// Standard spacing between sections
    static let sectionSpacing: CGFloat = xl // 24pt
    
    /// Standard spacing between list items
    static let listItemSpacing: CGFloat = sm // 8pt
    
    /// Standard spacing for inline elements
    static let inlineSpacing: CGFloat = xs // 4pt
}

// MARK: - Sizing Constants

/// Standard sizes for UI elements
enum Sizing {
    
    // MARK: - Icon Sizes
    
    /// Small icon (16x16)
    static let iconSmall: CGFloat = 16
    
    /// Medium icon (24x24) - default
    static let iconMedium: CGFloat = 24
    
    /// Large icon (32x32)
    static let iconLarge: CGFloat = 32
    
    /// Extra large icon (48x48)
    static let iconExtraLarge: CGFloat = 48
    
    // MARK: - Button Sizes
    
    /// Small button height (32pt)
    static let buttonSmall: CGFloat = 32
    
    /// Medium button height (44pt) - default touch target
    static let buttonMedium: CGFloat = 44
    
    /// Large button height (56pt)
    static let buttonLarge: CGFloat = 56
    
    /// Minimum touch target size (44x44) for accessibility
    static let minTouchTarget: CGFloat = 44
    
    // MARK: - Input Field Sizes
    
    /// Standard text field height
    static let textFieldHeight: CGFloat = 44
    
    /// Large text field height (for search bars, etc.)
    static let textFieldLargeHeight: CGFloat = 56
    
    /// Text area minimum height
    static let textAreaMinHeight: CGFloat = 100
    
    // MARK: - Card Sizes
    
    /// Card corner radius
    static let cardCornerRadius: CGFloat = 12
    
    /// Small card corner radius
    static let cardCornerRadiusSmall: CGFloat = 8
    
    /// Large card corner radius
    static let cardCornerRadiusLarge: CGFloat = 16
    
    // MARK: - Navigation/Tab Bar
    
    /// Tab bar height
    static let tabBarHeight: CGFloat = 49
    
    /// Navigation bar height (standard)
    static let navigationBarHeight: CGFloat = 44
    
    /// Navigation bar height (large title)
    static let navigationBarLargeTitleHeight: CGFloat = 96
    
    // MARK: - Borders
    
    /// Thin border width
    static let borderThin: CGFloat = 0.5
    
    /// Standard border width
    static let borderStandard: CGFloat = 1.0
    
    /// Thick border width
    static let borderThick: CGFloat = 2.0
    
    // MARK: - Thumbnails/Images
    
    /// Small thumbnail (64x64)
    static let thumbnailSmall: CGFloat = 64
    
    /// Medium thumbnail (120x120)
    static let thumbnailMedium: CGFloat = 120
    
    /// Large thumbnail (200x200)
    static let thumbnailLarge: CGFloat = 200
    
    /// Poster width (standard aspect ratio 2:3)
    static let posterWidth: CGFloat = 150
    
    /// Poster height (standard aspect ratio 2:3)
    static let posterHeight: CGFloat = 225
    
    // MARK: - List/Grid
    
    /// Minimum list row height
    static let listRowMinHeight: CGFloat = 44
    
    /// Standard list row height
    static let listRowHeight: CGFloat = 60
    
    /// Large list row height (with subtitle)
    static let listRowLargeHeight: CGFloat = 80
    
    /// Grid item spacing
    static let gridItemSpacing: CGFloat = Spacing.md
}

// MARK: - Corner Radius

/// Standard corner radius values
enum CornerRadius {
    /// No rounding
    static let none: CGFloat = 0
    
    /// Small corner radius (4pt)
    static let small: CGFloat = 4
    
    /// Medium corner radius (8pt) - default
    static let medium: CGFloat = 8
    
    /// Large corner radius (12pt)
    static let large: CGFloat = 12
    
    /// Extra large corner radius (16pt)
    static let extraLarge: CGFloat = 16
    
    /// Pill/capsule shape (very large radius)
    static let pill: CGFloat = 9999
}

// MARK: - Shadow

/// Standard shadow configurations
enum Shadow {
    /// Small shadow (subtle elevation)
    static let small = ShadowStyle(radius: 2, x: 0, y: 1, opacity: 0.1)
    
    /// Medium shadow (card elevation)
    static let medium = ShadowStyle(radius: 4, x: 0, y: 2, opacity: 0.15)
    
    /// Large shadow (modal/dialog elevation)
    static let large = ShadowStyle(radius: 8, x: 0, y: 4, opacity: 0.2)
    
    /// Extra large shadow (floating elements)
    static let extraLarge = ShadowStyle(radius: 16, x: 0, y: 8, opacity: 0.25)
}

/// Shadow style definition
struct ShadowStyle {
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    let opacity: Double
}

// MARK: - Opacity

/// Standard opacity values
enum Opacity {
    /// Invisible
    static let invisible: Double = 0.0
    
    /// Very subtle (10%)
    static let subtle: Double = 0.1
    
    /// Disabled state (40%)
    static let disabled: Double = 0.4
    
    /// Semi-transparent (60%)
    static let semi: Double = 0.6
    
    /// Mostly opaque (80%)
    static let mostlyOpaque: Double = 0.8
    
    /// Fully opaque
    static let opaque: Double = 1.0
}
