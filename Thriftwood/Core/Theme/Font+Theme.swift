//
//  Font+Theme.swift
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

// MARK: - Typography System

extension Font {
    
    // MARK: - Headings
    
    /// Large page title (34pt, bold)
    static var largeTitle: Font {
        .system(size: 34, weight: .bold)
    }
    
    /// Section title (28pt, bold)
    static var title1: Font {
        .system(size: 28, weight: .bold)
    }
    
    /// Subsection title (22pt, bold)
    static var title2: Font {
        .system(size: 22, weight: .bold)
    }
    
    /// Group title (20pt, semibold)
    static var title3: Font {
        .system(size: 20, weight: .semibold)
    }
    
    // MARK: - Body Text
    
    /// Primary body text (17pt, regular)
    static var body: Font {
        .system(size: 17, weight: .regular)
    }
    
    /// Emphasized body text (17pt, semibold)
    static var bodyEmphasized: Font {
        .system(size: 17, weight: .semibold)
    }
    
    /// Secondary body text (15pt, regular)
    static var callout: Font {
        .system(size: 15, weight: .regular)
    }
    
    // MARK: - Secondary Text
    
    /// Subheading text (15pt, regular)
    static var subheadline: Font {
        .system(size: 15, weight: .regular)
    }
    
    /// Small label text (13pt, regular)
    static var footnote: Font {
        .system(size: 13, weight: .regular)
    }
    
    /// Smallest text (11pt, regular)
    static var caption: Font {
        .system(size: 11, weight: .regular)
    }
    
    /// Smallest emphasized text (11pt, medium)
    static var caption2: Font {
        .system(size: 11, weight: .medium)
    }
    
    // MARK: - Monospace (for codes, logs, etc.)
    
    /// Monospace body text (17pt)
    static var bodyMonospaced: Font {
        .system(size: 17, weight: .regular, design: .monospaced)
    }
    
    /// Monospace footnote (13pt)
    static var footnoteMonospaced: Font {
        .system(size: 13, weight: .regular, design: .monospaced)
    }
    
    /// Monospace caption (11pt)
    static var captionMonospaced: Font {
        .system(size: 11, weight: .regular, design: .monospaced)
    }
}

// MARK: - Text Styles (for accessibility and dynamic type)

extension Font {
    /// Dynamic large title (responds to user text size settings)
    static var dynamicLargeTitle: Font {
        .largeTitle
    }
    
    /// Dynamic title
    static var dynamicTitle: Font {
        .title
    }
    
    /// Dynamic title 2
    static var dynamicTitle2: Font {
        .title2
    }
    
    /// Dynamic title 3
    static var dynamicTitle3: Font {
        .title3
    }
    
    /// Dynamic body
    static var dynamicBody: Font {
        .body
    }
    
    /// Dynamic callout
    static var dynamicCallout: Font {
        .callout
    }
    
    /// Dynamic subheadline
    static var dynamicSubheadline: Font {
        .subheadline
    }
    
    /// Dynamic footnote
    static var dynamicFootnote: Font {
        .footnote
    }
    
    /// Dynamic caption
    static var dynamicCaption: Font {
        .caption
    }
    
    /// Dynamic caption 2
    static var dynamicCaption2: Font {
        .caption2
    }
}

// MARK: - Custom Font Weights

extension Font.Weight {
    /// Ultra light weight (100)
    static let ultraLight = Font.Weight.ultraLight
    
    /// Thin weight (200)
    static let thin = Font.Weight.thin
    
    /// Light weight (300)
    static let light = Font.Weight.light
    
    /// Regular weight (400)
    static let regular = Font.Weight.regular
    
    /// Medium weight (500)
    static let medium = Font.Weight.medium
    
    /// Semibold weight (600)
    static let semibold = Font.Weight.semibold
    
    /// Bold weight (700)
    static let bold = Font.Weight.bold
    
    /// Heavy weight (800)
    static let heavy = Font.Weight.heavy
    
    /// Black weight (900)
    static let black = Font.Weight.black
}
