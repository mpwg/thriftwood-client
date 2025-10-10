//
//  RadarrSettingsView.swift
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

struct RadarrSettingsView: View {
    @State private var enabled: Bool = true
    @State private var discoverSuggestions: Bool = true
    @State private var queueSize: Int = 50

    var body: some View {
        List {
            // Header card with description and buttons
            Section {
                VStack(alignment: .leading, spacing: UIConstants.Spacing.medium) {
                    HStack(alignment: .top) {
                        Image(systemName: SystemIcon.movies)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("Radarr")
                                .font(.headline)
                            Text("Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {}, label: {
                            Image(systemName: SystemIcon.closeCircle)
                        })
                    }

                    HStack(spacing: UIConstants.Spacing.medium) {
                        Button(action: {}, label: {
                            Label("GitHub", systemImage: SystemIcon.github)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.borderedProminent)

                        Button(action: {}, label: {
                            Label("Website", systemImage: SystemIcon.web)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical, UIConstants.Spacing.tiny)
            }

            Section {
                Toggle("Enable Radarr", isOn: $enabled)
            }

            Section {
                NavigationLink(destination: RadarrConnectionView()) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Connection Details")
                            Text("Connection Details for Radarr")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }

                NavigationLink(destination: Text("Default Options")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Default Options")
                            Text("Set Sorting, Filtering, and View Options")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }

                NavigationLink(destination: Text("Default Pages")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Default Pages")
                            Text("Set Default Landing Pages")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }

                Toggle("Discover Suggestions", isOn: $discoverSuggestions)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Queue Size")
                        Text("\(queueSize) Items")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "rectangle.stack.badge.plus")
                }
            }
        }
        .navigationTitle("Radarr")
        .listStyle(.insetGrouped)
    }
}

#Preview {
    RadarrSettingsView()
}
