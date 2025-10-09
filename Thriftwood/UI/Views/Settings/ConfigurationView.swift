//
//  ConfigurationView.swift
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

struct ConfigurationView: View {
    var body: some View {
        List {
            Section {
                NavigationLink(destination: Text("General settings")) {
                    HStack {
                        Text("General")
                        Spacer()
                        Image(systemName: SystemIcon.paintbrush)
                    }
                }

                NavigationLink(destination: Text("Drawer settings")) {
                    HStack {
                        Text("Drawer")
                        Spacer()
                        Image(systemName: SystemIcon.menu)
                    }
                }

                NavigationLink(destination: Text("Quick Actions settings")) {
                    HStack {
                        Text("Quick Actions")
                        Spacer()
                        Image(systemName: SystemIcon.quickActions)
                    }
                }
            }

            Section {
                NavigationLink(destination: Text("Dashboard settings")) {
                    HStack {
                        Text("Dashboard")
                        Spacer()
                        Image(systemName: SystemIcon.dashboard)
                    }
                }

                NavigationLink(destination: Text("External Modules settings")) {
                    HStack {
                        Text("External Modules")
                        Spacer()
                        Image(systemName: SystemIcon.externalModules)
                    }
                }

                NavigationLink(destination: Text("Lidarr settings")) {
                    HStack {
                        Text("Lidarr")
                        Spacer()
                        Image(systemName: SystemIcon.music)
                    }
                }

                NavigationLink(destination: Text("NZBGet settings")) {
                    HStack {
                        Text("NZBGet")
                        Spacer()
                        Image(systemName: SystemIcon.downloads)
                    }
                }

                NavigationLink(destination: RadarrSettingsView()) {
                    HStack {
                        Text("Radarr")
                        Spacer()
                        Image(systemName: SystemIcon.movies)
                    }
                }

                NavigationLink(destination: Text("SABnzbd settings")) {
                    HStack {
                        Text("SABnzbd")
                        Spacer()
                        Image(systemName: SystemIcon.printer)
                    }
                }

                NavigationLink(destination: Text("Search settings")) {
                    HStack {
                        Text("Search")
                        Spacer()
                        Image(systemName: SystemIcon.search)
                    }
                }

                NavigationLink(destination: Text("Sonarr settings")) {
                    HStack {
                        Text("Sonarr")
                        Spacer()
                        Image(systemName: SystemIcon.tv)
                    }
                }
            }
        }
        .navigationTitle("Configuration")
        .listStyle(.insetGrouped)
    }
}

#Preview {
    ConfigurationView()
}
