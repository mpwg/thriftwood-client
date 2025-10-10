//
//  ButtonStyles.swift
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

/// Standard button style for toolbar buttons.
/// Provides subtle visual feedback on press without overriding system styling.
struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .secondary : .primary)
            .opacity(configuration.isPressed ? UIConstants.Opacity.pressed : 1.0)
    }
}

/// Pill-shaped button style for prominent action buttons.
/// Commonly used in floating toolbars and call-to-action buttons.
struct PillButtonStyle: ButtonStyle {
    var isProminent: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, UIConstants.Padding.screen)
            .padding(.vertical, UIConstants.Padding.compact)
            .background(
                isProminent
                    ? AnyShapeStyle(.tint)
                    : AnyShapeStyle(.regularMaterial)
            )
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? UIConstants.Opacity.pressed : 1.0)
    }
}

/// Rounded rectangle button style for cards and container actions.
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(UIConstants.Padding.compact)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium, style: .continuous))
            .opacity(configuration.isPressed ? UIConstants.Opacity.pressed : 1.0)
    }
}

/// Extension to easily apply button styles
extension Button {
    /// Apply toolbar button style
    func toolbarStyle() -> some View {
        self.buttonStyle(ToolbarButtonStyle())
    }
    
    /// Apply pill button style
    func pillStyle(prominent: Bool = false) -> some View {
        self.buttonStyle(PillButtonStyle(isProminent: prominent))
    }
    
    /// Apply card button style
    func cardStyle() -> some View {
        self.buttonStyle(CardButtonStyle())
    }
}
