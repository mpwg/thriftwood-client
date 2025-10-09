//
//  UIConstants.swift
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

/// Standardized UI measurement constants for consistent spacing, sizing, and layout across the app.
/// Using these constants ensures visual consistency and makes global UI changes easier to manage.
enum UIConstants {
    
    // MARK: - Spacing
    enum Spacing {
        /// 4pt - Minimal spacing between tightly related elements
        static let tiny: CGFloat = 4
        
        /// 8pt - Small spacing between related elements
        static let small: CGFloat = 8
        
        /// 12pt - Standard spacing between elements
        static let medium: CGFloat = 12
        
        /// 16pt - Large spacing between sections or groups
        static let large: CGFloat = 16
        
        /// 18pt - Extra large spacing for major sections
        static let extraLarge: CGFloat = 18
        
        /// 24pt - Maximum spacing for distinct sections
        static let huge: CGFloat = 24
    }
    
    // MARK: - Padding
    enum Padding {
        /// 10pt - Compact padding for buttons and small controls
        static let compact: CGFloat = 10
        
        /// 12pt - Standard padding for cards and containers
        static let card: CGFloat = 12
        
        /// 14pt - Top padding for screens
        static let screenTop: CGFloat = 14
        
        /// 16pt - Standard horizontal screen padding
        static let screen: CGFloat = 16
        
        /// 20pt - Bottom padding for screens with toolbars
        static let screenBottom: CGFloat = 20
        
        /// 120pt - Bottom spacer to prevent content from being hidden by floating toolbars
        static let bottomToolbarSpacer: CGFloat = 120
        
        /// 80pt - Smaller bottom spacer for compact layouts
        static let bottomToolbarSpacerCompact: CGFloat = 80
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        /// 8pt - Small corner radius for compact elements
        static let small: CGFloat = 8
        
        /// 10pt - Medium corner radius for buttons
        static let medium: CGFloat = 10
        
        /// 12pt - Standard corner radius for cards
        static let card: CGFloat = 12
        
        /// 16pt - Large corner radius for prominent containers
        static let large: CGFloat = 16
    }
    
    // MARK: - Image Sizes
    enum ImageSize {
        /// Poster thumbnail dimensions (width × height)
        static let posterThumbnail = CGSize(width: 64, height: 96)
        
        /// Poster small dimensions
        static let posterSmall = CGSize(width: 72, height: 108)
        
        /// Poster medium dimensions
        static let posterMedium = CGSize(width: 100, height: 150)
        
        /// Icon size for small icons
        static let iconSmall: CGFloat = 20
        
        /// Icon size for medium icons
        static let iconMedium: CGFloat = 24
        
        /// Icon size for large icons
        static let iconLarge: CGFloat = 32
    }
    
    // MARK: - Font Sizes
    enum FontSize {
        static let caption: Font = .caption
        static let footnote: Font = .footnote
        static let subheadline: Font = .subheadline
        static let body: Font = .body
        static let headline: Font = .headline
        static let title3: Font = .title3
        static let title2: Font = .title2
        static let title: Font = .title
        static let largeTitle: Font = .largeTitle
    }
    
    // MARK: - Shadow
    enum Shadow {
        /// Subtle shadow for cards
        static let cardColor = Color.primary.opacity(0.02)
        static let cardRadius: CGFloat = 1
        static let cardX: CGFloat = 0
        static let cardY: CGFloat = 1
    }
    
    // MARK: - Opacity
    enum Opacity {
        /// Material opacity for floating elements
        static let material: Double = 0.9
        
        /// Pressed state opacity
        static let pressed: Double = 0.7
        
        /// Disabled state opacity
        static let disabled: Double = 0.5
    }
}
