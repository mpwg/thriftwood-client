//
//  AcknowledgementsView.swift
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

/// View displaying acknowledgements and credits
struct AcknowledgementsView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Thriftwood")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.themePrimaryText)
                    
                    Text("Thriftwood is inspired by and partly based on LunaSea, an open-source media management application.")
                        .font(.body)
                        .foregroundStyle(Color.themeSecondaryText)
                }
                .padding(.vertical, Spacing.sm)
            } header: {
                Text("About This App")
            }
            
            Section {
                AcknowledgementRow(
                    title: "LunaSea",
                    description: "Thriftwood is inspired by and partly based on LunaSea, a self-hosted media manager application. Special thanks to Jagandeep Brar and the LunaSea community for their excellent work.",
                    websiteURL: URL(string: "https://www.lunasea.app")!,
                    githubURL: URL(string: "https://github.com/jagandeepbrar/lunasea")!
                )
            } header: {
                Text("Inspiration & Credits")
            }
            
            Section {
                AcknowledgementRow(
                    title: "Swinject",
                    description: "Dependency injection framework for Swift",
                    githubURL: URL(string: "https://github.com/Swinject/Swinject")!
                )
                
                AcknowledgementRow(
                    title: "AsyncHTTPClient",
                    description: "HTTP client library built on SwiftNIO",
                    githubURL: URL(string: "https://github.com/swift-server/async-http-client")!
                )
                
                AcknowledgementRow(
                    title: "Valet",
                    description: "Secure keychain wrapper for credentials storage",
                    githubURL: URL(string: "https://github.com/square/Valet")!
                )
                
                AcknowledgementRow(
                    title: "Swift OpenAPI Generator",
                    description: "Type-safe API client generation from OpenAPI specs",
                    githubURL: URL(string: "https://github.com/apple/swift-openapi-generator")!
                )
            } header: {
                Text("Open Source Libraries")
            }
            
            Section {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Thriftwood is free and open-source software licensed under the GNU General Public License v3.0.")
                        .font(.footnote)
                        .foregroundStyle(Color.themeSecondaryText)
                    
                    Link("View License", destination: URL(string: "https://www.gnu.org/licenses/gpl-3.0.html")!)
                        .font(.footnote)
                        .foregroundStyle(Color.themeAccent)
                }
                .padding(.vertical, Spacing.sm)
            } header: {
                Text("License")
            }
        }
        .navigationTitle("Acknowledgements")
    }
}

// MARK: - Acknowledgement Row

private struct AcknowledgementRow: View {
    let title: String
    let description: String
    var websiteURL: URL?
    var githubURL: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.themePrimaryText)
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(Color.themeSecondaryText)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: Spacing.md) {
                if let websiteURL {
                    Link(destination: websiteURL) {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "globe")
                                .font(.caption)
                            Text("Website")
                                .font(.caption)
                        }
                        .foregroundStyle(Color.themeAccent)
                    }
                }
                
                if let githubURL {
                    Link(destination: githubURL) {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                .font(.caption)
                            Text("GitHub")
                                .font(.caption)
                        }
                        .foregroundStyle(Color.themeAccent)
                    }
                }
            }
            .padding(.top, Spacing.xxs)
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Preview

#Preview("Acknowledgements") {
    NavigationStack {
        AcknowledgementsView()
    }
}
