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
    @State private var dependencies: [Dependency] = []
    @State private var isLoadingDependencies = true
    
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
                if isLoadingDependencies {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if dependencies.isEmpty {
                    Text("Unable to load dependencies")
                        .font(.caption)
                        .foregroundStyle(Color.themeSecondaryText)
                } else {
                    ForEach(dependencies) { dependency in
                        DependencyRow(dependency: dependency)
                    }
                }
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
        .task {
            await loadDependencies()
        }
    }
    
    private func loadDependencies() async {
        guard let url = Bundle.main.url(forResource: "acknowledgements", withExtension: "json") else {
            AppLogger.ui.error("acknowledgements.json not found in bundle")
            isLoadingDependencies = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let acknowledgements = try JSONDecoder().decode(AcknowledgementsData.self, from: data)
            dependencies = acknowledgements.dependencies.sorted { $0.name.lowercased() < $1.name.lowercased() }
            isLoadingDependencies = false
            AppLogger.ui.info("Loaded \(dependencies.count) dependencies")
        } catch {
            AppLogger.ui.error("Failed to load acknowledgements: \(error.localizedDescription)")
            isLoadingDependencies = false
        }
    }
}

// MARK: - Dependency Row

private struct DependencyRow: View {
    let dependency: Dependency
    @State private var showLicense = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(dependency.name)
                        .font(.headline)
                        .foregroundStyle(Color.themePrimaryText)
                    
                    Text("Version \(dependency.version) • \(dependency.licenseType)")
                        .font(.caption)
                        .foregroundStyle(Color.themeSecondaryText)
                }
                
                Spacer()
                
                if let url = dependency.repositoryURL {
                    Link(destination: url) {
                        Image(systemName: "link")
                            .font(.caption)
                            .foregroundStyle(Color.themeAccent)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Button {
                showLicense.toggle()
            } label: {
                HStack {
                    Text(showLicense ? "Hide License" : "Show License")
                        .font(.caption)
                    Image(systemName: showLicense ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                }
                .foregroundStyle(Color.themeAccent)
            }
            .buttonStyle(.plain)
            
            if showLicense {
                ScrollView {
                    Text(dependency.licenseText)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(Color.themeSecondaryText)
                        .textSelection(.enabled)
                }
                .frame(maxHeight: 300)
                .padding(Spacing.sm)
                .background(Color.themeSecondaryBackground.opacity(0.5))
                .cornerRadius(CornerRadius.medium)
            }
        }
        .padding(.vertical, Spacing.xs)
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
