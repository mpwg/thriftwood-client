//
//  NavigationRow.swift
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

/// Form row with navigation arrow for drill-down navigation.
/// Can display a value or use as a plain navigation button.
@MainActor
struct NavigationRow<Destination: View>: View {
    let title: String
    let subtitle: String?
    let value: String?
    let icon: String?
    let destination: () -> Destination
    
    init(
        title: String,
        subtitle: String? = nil,
        value: String? = nil,
        icon: String? = nil,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.icon = icon
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
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
                
                // Value (if provided)
                if let value = value {
                    Text(value)
                        .font(.callout)
                        .foregroundStyle(Color.themeSecondaryText)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, Spacing.sm)
        }
    }
}

// MARK: - Previews

#Preview("NavigationRow - Simple") {
    NavigationStack {
        Form {
            Section("Settings") {
                NavigationRow(
                    title: "Connection Details",
                    subtitle: "Host and API key",
                    icon: "network"
                ) {
                    Text("Connection Details Screen")
                }
            }
        }
        .navigationTitle("Radarr")
    }
}

#Preview("NavigationRow - With Value") {
    NavigationStack {
        Form {
            Section("Server") {
                NavigationRow(
                    title: "Host",
                    subtitle: "Server URL",
                    value: "radarr.example.com",
                    icon: "network"
                ) {
                    Text("Edit Host Screen")
                }
            }
        }
        .navigationTitle("Configuration")
    }
}

#Preview("NavigationRow - Not Set") {
    NavigationStack {
        Form {
            Section("Authentication") {
                NavigationRow(
                    title: "API Key",
                    subtitle: "Authentication token",
                    value: "Not Set",
                    icon: "key.fill"
                ) {
                    Text("Edit API Key Screen")
                }
            }
        }
        .navigationTitle("Configuration")
    }
}

#Preview("Multiple NavigationRows") {
    NavigationStack {
        Form {
            Section("Radarr Configuration") {
                NavigationRow(
                    title: "Connection Details",
                    subtitle: "Host and API key",
                    icon: "network"
                ) {
                    Text("Connection Details Screen")
                }
                
                NavigationRow(
                    title: "Custom Headers",
                    subtitle: "HTTP headers",
                    icon: "list.bullet"
                ) {
                    Text("Custom Headers Screen")
                }
                
                NavigationRow(
                    title: "Test Connection",
                    subtitle: "Verify connectivity",
                    icon: "wifi"
                ) {
                    Text("Test Connection Screen")
                }
            }
            
            Section("Quick Actions") {
                NavigationRow(
                    title: "Enable in Drawer",
                    subtitle: "Show in navigation",
                    value: "Enabled",
                    icon: "sidebar.left"
                ) {
                    Text("Quick Actions Screen")
                }
            }
        }
        .navigationTitle("Radarr")
    }
}

#Preview("NavigationRow - Realistic Settings") {
    NavigationStack {
        Form {
            Section("Server Details") {
                NavigationRow(
                    title: "Host",
                    value: "radarr.example.com",
                    icon: "network"
                ) {
                    Text("Edit Host")
                }
                
                NavigationRow(
                    title: "API Key",
                    value: "••••••••",
                    icon: "key.fill"
                ) {
                    Text("Edit API Key")
                }
            }
            
            Section("Advanced") {
                NavigationRow(
                    title: "Custom Headers",
                    subtitle: "Add custom HTTP headers",
                    icon: "list.bullet"
                ) {
                    Text("Custom Headers")
                }
                
                NavigationRow(
                    title: "TLS Validation",
                    subtitle: "Certificate verification",
                    value: "Enabled",
                    icon: "lock.shield"
                ) {
                    Text("TLS Settings")
                }
            }
        }
        .navigationTitle("Connection")
    }
}
