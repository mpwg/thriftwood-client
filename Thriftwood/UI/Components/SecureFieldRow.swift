//
//  SecureFieldRow.swift
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

/// Form row with secure password input field.
/// Uses native SwiftUI SecureField for password protection.
@MainActor
struct SecureFieldRow: View {
    let title: String
    let placeholder: String
    let subtitle: String?
    let icon: String?
    let textContentType: UITextContentType?
    @Binding var text: String
    @State private var isRevealed = false
    
    init(
        title: String,
        placeholder: String = "",
        subtitle: String? = nil,
        icon: String? = nil,
        text: Binding<String>,
        textContentType: UITextContentType? = .password
    ) {
        self.title = title
        self.placeholder = placeholder
        self.subtitle = subtitle
        self.icon = icon
        self._text = text
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
            
            // Secure field or text field (if revealed)
            Group {
                if isRevealed {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled(true)
                        .textContentType(textContentType)
                } else {
                    SecureField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.plain)
                        .textContentType(textContentType)
                }
            }
            .foregroundStyle(Color.themePrimaryText)
            .frame(maxWidth: 150)
            
            // Reveal/hide button
            Button {
                isRevealed.toggle()
            } label: {
                Image(systemName: isRevealed ? "eye.slash.fill" : "eye.fill")
                    .foregroundStyle(Color.themeSecondaryText)
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, Spacing.sm)
    }
}

// MARK: - Previews

#Preview("SecureFieldRow - Empty") {
    @Previewable @State var apiKey = ""
    
    return Form {
        Section("Authentication") {
            SecureFieldRow(
                title: "API Key",
                placeholder: "Enter API key",
                subtitle: "From service settings",
                icon: "key.fill",
                text: $apiKey
            )
        }
    }
}

#Preview("SecureFieldRow - With Value") {
    @Previewable @State var apiKey = "a1b2c3d4e5f6g7h8i9j0"
    
    return Form {
        Section("Authentication") {
            SecureFieldRow(
                title: "API Key",
                placeholder: "Enter API key",
                icon: "key.fill",
                text: $apiKey
            )
        }
    }
}

#Preview("SecureFieldRow - Password") {
    @Previewable @State var password = "SuperSecretPassword123"
    
    return Form {
        Section("Credentials") {
            SecureFieldRow(
                title: "Password",
                placeholder: "Enter password",
                subtitle: "NZBGet password",
                icon: "lock.fill",
                text: $password,
                textContentType: .password
            )
        }
    }
}

#Preview("Multiple SecureFieldRows") {
    @Previewable @State var username = "admin"
    @Previewable @State var password = "password123"
    @Previewable @State var apiKey = "a1b2c3d4e5f6"
    
    return Form {
        Section("Credentials") {
            TextFieldRow(
                title: "Username",
                placeholder: "Enter username",
                icon: "person.fill",
                text: $username,
                autocorrection: false,
                textContentType: .username
            )
            
            SecureFieldRow(
                title: "Password",
                placeholder: "Enter password",
                icon: "lock.fill",
                text: $password,
                textContentType: .password
            )
            
            SecureFieldRow(
                title: "API Key",
                placeholder: "Enter API key",
                icon: "key.fill",
                text: $apiKey,
                textContentType: nil
            )
        }
    }
}
