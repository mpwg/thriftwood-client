//
//  PickerRow.swift
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

/// Form row with picker for selections.
/// Uses native SwiftUI Picker with menu style for inline selection.
@MainActor
struct PickerRow<SelectionValue: Hashable>: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let options: [PickerOption<SelectionValue>]
    @Binding var selection: SelectionValue
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        options: [PickerOption<SelectionValue>],
        selection: Binding<SelectionValue>
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.options = options
        self._selection = selection
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
            
            // Picker
            Picker("", selection: $selection) {
                ForEach(options, id: \.value) { option in
                    Text(option.label)
                        .tag(option.value)
                }
            }
            .pickerStyle(.menu)
            .tint(Color.themeAccent)
        }
        .padding(.vertical, Spacing.sm)
    }
}

/// Option for PickerRow.
struct PickerOption<Value: Hashable>: Identifiable {
    let id = UUID()
    let label: String
    let value: Value
    
    init(label: String, value: Value) {
        self.label = label
        self.value = value
    }
}

// MARK: - Previews

enum Quality: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case ultra = "Ultra"
}

enum Theme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    case black = "Black"
}

#Preview("PickerRow - Quality") {
    @Previewable @State var quality = Quality.high
    
    let options = Quality.allCases.map { PickerOption(label: $0.rawValue, value: $0) }
    
    return Form {
        Section("Video Settings") {
            PickerRow(
                title: "Quality",
                subtitle: "Streaming quality",
                icon: "video.fill",
                options: options,
                selection: $quality
            )
        }
    }
}

#Preview("PickerRow - Theme") {
    @Previewable @State var theme = Theme.dark
    
    let options = Theme.allCases.map { PickerOption(label: $0.rawValue, value: $0) }
    
    return Form {
        Section("Appearance") {
            PickerRow(
                title: "Theme",
                subtitle: "App appearance",
                icon: "paintbrush.fill",
                options: options,
                selection: $theme
            )
        }
    }
}

#Preview("PickerRow - Number Selection") {
    @Previewable @State var days = 7
    
    let options = [1, 7, 14, 30].map { PickerOption(label: "\($0) days", value: $0) }
    
    return Form {
        Section("Calendar") {
            PickerRow(
                title: "Past Days",
                subtitle: "Days to show in past",
                icon: "calendar",
                options: options,
                selection: $days
            )
        }
    }
}

#Preview("Multiple PickerRows") {
    @Previewable @State var quality = Quality.high
    @Previewable @State var theme = Theme.dark
    @Previewable @State var pastDays = 7
    @Previewable @State var futureDays = 14
    
    let qualityOptions = Quality.allCases.map { PickerOption(label: $0.rawValue, value: $0) }
    let themeOptions = Theme.allCases.map { PickerOption(label: $0.rawValue, value: $0) }
    let daysOptions = [1, 7, 14, 30].map { PickerOption(label: "\($0) days", value: $0) }
    
    return Form {
        Section("Appearance") {
            PickerRow(
                title: "Theme",
                icon: "paintbrush.fill",
                options: themeOptions,
                selection: $theme
            )
        }
        
        Section("Streaming") {
            PickerRow(
                title: "Quality",
                subtitle: "Default quality",
                icon: "video.fill",
                options: qualityOptions,
                selection: $quality
            )
        }
        
        Section("Calendar") {
            PickerRow(
                title: "Past Days",
                icon: "calendar",
                options: daysOptions,
                selection: $pastDays
            )
            
            PickerRow(
                title: "Future Days",
                icon: "calendar",
                options: daysOptions,
                selection: $futureDays
            )
        }
    }
}
