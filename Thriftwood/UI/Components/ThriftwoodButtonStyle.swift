//
//  ThriftwoodButtonStyle.swift
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

// MARK: - Primary Button Style

/// Primary button style with accent color background
///
/// Usage:
/// ```swift
/// Button("Save") { }
///     .buttonStyle(PrimaryButtonStyle())
/// ```
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(
                backgroundColor(for: configuration)
            )
            .cornerRadius(CornerRadius.medium)
            .opacity(isEnabled ? 1.0 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
        if configuration.isPressed {
            return Color.themeAccent.opacity(0.8)
        }
        return Color.themeAccent
    }
}

// MARK: - Secondary Button Style

/// Secondary button style with transparent background and border
///
/// Usage:
/// ```swift
/// Button("Cancel") { }
///     .buttonStyle(SecondaryButtonStyle())
/// ```
struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundStyle(Color.themeAccent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(
                backgroundColor(for: configuration)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.themeAccent, lineWidth: 2)
            )
            .cornerRadius(CornerRadius.medium)
            .opacity(isEnabled ? 1.0 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
        if configuration.isPressed {
            return Color.themeAccent.opacity(0.1)
        }
        return Color.clear
    }
}

// MARK: - Destructive Button Style

/// Destructive button style with error color (for delete actions)
///
/// Usage:
/// ```swift
/// Button("Delete") { }
///     .buttonStyle(DestructiveButtonStyle())
/// ```
struct DestructiveButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(
                backgroundColor(for: configuration)
            )
            .cornerRadius(CornerRadius.medium)
            .opacity(isEnabled ? 1.0 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
        if configuration.isPressed {
            return Color.error.opacity(0.8)
        }
        return Color.error
    }
}

// MARK: - Compact Button Style

/// Compact button style for smaller inline buttons
///
/// Usage:
/// ```swift
/// Button("Edit") { }
///     .buttonStyle(CompactButtonStyle())
/// ```
struct CompactButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.footnote.weight(.medium))
            .foregroundStyle(Color.white)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(
                backgroundColor(for: configuration)
            )
            .cornerRadius(CornerRadius.small)
            .opacity(isEnabled ? 1.0 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
        if configuration.isPressed {
            return Color.themeAccent.opacity(0.8)
        }
        return Color.themeAccent
    }
}

// MARK: - Button Style Extensions

extension ButtonStyle where Self == PrimaryButtonStyle {
    /// Primary button style
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    /// Secondary button style
    static var secondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}

extension ButtonStyle where Self == DestructiveButtonStyle {
    /// Destructive button style
    static var destructive: DestructiveButtonStyle { DestructiveButtonStyle() }
}

extension ButtonStyle where Self == CompactButtonStyle {
    /// Compact button style
    static var compact: CompactButtonStyle { CompactButtonStyle() }
}

// MARK: - Previews

#Preview("Primary Button") {
    VStack(spacing: Spacing.md) {
        Button("Save Changes") { }
            .buttonStyle(.primary)
        
        Button("Disabled") { }
            .buttonStyle(.primary)
            .disabled(true)
    }
    .padding()
}

#Preview("Secondary Button") {
    VStack(spacing: Spacing.md) {
        Button("Cancel") { }
            .buttonStyle(.secondary)
        
        Button("Disabled") { }
            .buttonStyle(.secondary)
            .disabled(true)
    }
    .padding()
}

#Preview("Destructive Button") {
    VStack(spacing: Spacing.md) {
        Button("Delete Profile") { }
            .buttonStyle(.destructive)
        
        Button("Disabled") { }
            .buttonStyle(.destructive)
            .disabled(true)
    }
    .padding()
}

#Preview("Compact Button") {
    VStack(spacing: Spacing.md) {
        Button("Edit") { }
            .buttonStyle(.compact)
        
        Button("Disabled") { }
            .buttonStyle(.compact)
            .disabled(true)
    }
    .padding()
}

#Preview("All Button Styles") {
    VStack(spacing: Spacing.lg) {
        Button("Primary Button") { }
            .buttonStyle(.primary)
        
        Button("Secondary Button") { }
            .buttonStyle(.secondary)
        
        Button("Destructive Button") { }
            .buttonStyle(.destructive)
        
        HStack {
            Button("Compact 1") { }
                .buttonStyle(.compact)
            Button("Compact 2") { }
                .buttonStyle(.compact)
        }
    }
    .padding()
}

#Preview("Dark Theme") {
    VStack(spacing: Spacing.lg) {
        Button("Primary") { }
            .buttonStyle(.primary)
        Button("Secondary") { }
            .buttonStyle(.secondary)
        Button("Destructive") { }
            .buttonStyle(.destructive)
    }
    .padding()
    .preferredColorScheme(.dark)
}
