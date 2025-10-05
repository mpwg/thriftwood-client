//
//  ToggleRow.swift
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

/// Form row with toggle switch.
/// Uses native SwiftUI Toggle for maximum compatibility.
@MainActor
struct ToggleRow: View {
    let title: String
    let subtitle: String?
    let icon: String?
    @Binding var isOn: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
    }
    
    var body: some View {
        Toggle(isOn: $isOn) {
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
            }
        }
        .tint(Color.themeAccent)
        .padding(.vertical, Spacing.sm)
    }
}

// MARK: - Previews

#Preview("ToggleRow - On") {
    @Previewable @State var isEnabled = true
    
    return Form {
        Section("Features") {
            ToggleRow(
                title: "AMOLED Theme",
                subtitle: "Pure black background",
                icon: "moon.fill",
                isOn: $isEnabled
            )
        }
    }
}

#Preview("ToggleRow - Off") {
    @Previewable @State var isEnabled = false
    
    return Form {
        Section("Features") {
            ToggleRow(
                title: "AMOLED Theme",
                subtitle: "Pure black background",
                icon: "moon.fill",
                isOn: $isEnabled
            )
        }
    }
}

#Preview("ToggleRow - No Icon") {
    @Previewable @State var isEnabled = true
    
    return Form {
        Section("Settings") {
            ToggleRow(
                title: "Enable Notifications",
                subtitle: "Show in-app notifications",
                isOn: $isEnabled
            )
        }
    }
}

#Preview("Multiple ToggleRows") {
    @Previewable @State var amoled = true
    @Previewable @State var borders = false
    @Previewable @State var notifications = true
    @Previewable @State var time24h = false
    
    return Form {
        Section("Appearance") {
            ToggleRow(
                title: "AMOLED Theme",
                subtitle: "Pure black background",
                icon: "moon.fill",
                isOn: $amoled
            )
            
            ToggleRow(
                title: "Draw Borders",
                subtitle: "Show card borders",
                icon: "rectangle.on.rectangle",
                isOn: $borders
            )
        }
        
        Section("General") {
            ToggleRow(
                title: "Notifications",
                subtitle: "Show in-app notifications",
                icon: "bell.fill",
                isOn: $notifications
            )
            
            ToggleRow(
                title: "24-Hour Time",
                subtitle: "Use 24-hour format",
                icon: "clock.fill",
                isOn: $time24h
            )
        }
    }
}
