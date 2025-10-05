//
//  TextFieldRow.swift
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

/// Form row with text input field.
/// Uses native SwiftUI TextField for maximum compatibility and features.
@MainActor
struct TextFieldRow: View {
    let title: String
    let placeholder: String
    let subtitle: String?
    let icon: String?
    let keyboardType: UIKeyboardType
    let autocorrection: Bool
    let textContentType: UITextContentType?
    @Binding var text: String
    
    init(
        title: String,
        placeholder: String = "",
        subtitle: String? = nil,
        icon: String? = nil,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        autocorrection: Bool = true,
        textContentType: UITextContentType? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self.subtitle = subtitle
        self.icon = icon
        self._text = text
        self.keyboardType = keyboardType
        self.autocorrection = autocorrection
        self.textContentType = textContentType
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
            
            // Text field
            TextField(placeholder, text: $text)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(.plain)
                .keyboardType(keyboardType)
                .autocorrectionDisabled(!autocorrection)
                .textContentType(textContentType)
                .foregroundStyle(Color.themePrimaryText)
                .frame(maxWidth: 200)
        }
        .padding(.vertical, Spacing.sm)
    }
}

// MARK: - Previews

#Preview("TextFieldRow - Empty") {
    @Previewable @State var host = ""
    
    return Form {
        Section("Server Details") {
            TextFieldRow(
                title: "Host",
                placeholder: "example.com",
                subtitle: "Server URL",
                icon: "network",
                text: $host,
                keyboardType: .URL,
                autocorrection: false,
                textContentType: .URL
            )
        }
    }
}

#Preview("TextFieldRow - With Value") {
    @Previewable @State var host = "radarr.example.com"
    
    return Form {
        Section("Server Details") {
            TextFieldRow(
                title: "Host",
                placeholder: "example.com",
                text: $host,
                keyboardType: .URL,
                autocorrection: false
            )
        }
    }
}

#Preview("TextFieldRow - Port Number") {
    @Previewable @State var port = "7878"
    
    return Form {
        Section("Server Details") {
            TextFieldRow(
                title: "Port",
                placeholder: "7878",
                subtitle: "Default: 7878",
                icon: "number",
                text: $port,
                keyboardType: .numberPad
            )
        }
    }
}

#Preview("Multiple TextFieldRows") {
    @Previewable @State var host = "radarr.example.com"
    @Previewable @State var port = "7878"
    @Previewable @State var path = "/api/v3"
    
    return Form {
        Section("Connection Details") {
            TextFieldRow(
                title: "Host",
                placeholder: "example.com",
                icon: "network",
                text: $host,
                keyboardType: .URL
            )
            
            TextFieldRow(
                title: "Port",
                placeholder: "7878",
                icon: "number",
                text: $port,
                keyboardType: .numberPad
            )
            
            TextFieldRow(
                title: "Base Path",
                placeholder: "/",
                icon: "arrow.turn.down.right",
                text: $path
            )
        }
    }
}
