//
//  FormRow.swift
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

/// Generic form row container matching LunaBlock pattern.
/// Provides consistent layout for settings and configuration screens.
@MainActor
struct FormRow<Content: View>: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let content: () -> Content
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.content = content
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            // Leading icon (optional)
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundStyle(Color.themeAccent)
                    .font(.body)
                    .frame(width: Sizing.iconMedium, height: Sizing.iconMedium)
            }
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(Color.themePrimaryText)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.themeSecondaryText)
                }
            }
            
            Spacer()
            
            // Trailing content (TextField, Toggle, etc.)
            content()
        }
        .padding(.vertical, Spacing.sm)
    }
}

// MARK: - Previews

#Preview("Basic FormRow") {
    Form {
        Section("Settings") {
            FormRow(title: "Host", subtitle: "Server URL") {
                Text("example.com")
                    .font(.callout)
                    .foregroundStyle(Color.themeSecondaryText)
            }
        }
    }
}

#Preview("FormRow with Icon") {
    Form {
        Section("Configuration") {
            FormRow(
                title: "API Key",
                subtitle: "Authentication token",
                icon: "key.fill"
            ) {
                Text("••••••••")
                    .font(.callout)
                    .foregroundStyle(Color.themeSecondaryText)
            }
        }
    }
}

#Preview("Multiple FormRows") {
    Form {
        Section("Server Details") {
            FormRow(title: "Host") {
                Text("radarr.example.com")
                    .font(.callout)
            }
            
            FormRow(title: "Port") {
                Text("7878")
                    .font(.callout)
            }
            
            FormRow(title: "SSL", icon: "lock.fill") {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.green)
            }
        }
    }
}
