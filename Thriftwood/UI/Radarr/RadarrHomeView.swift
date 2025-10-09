//
//  RadarrHomeView.swift
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

struct RadarrHomeView: View {
    var body: some View {
        List {
            Section("Media Management") {
                NavigationLink(value: AppRoute.radarrMoviesList) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Movies")
                            Text("Browse your movie library")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "film")
                    }
                }
                
                NavigationLink(value: AppRoute.radarrAddMovie()) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Add Movie")
                            Text("Search and add new movies")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            
            Section("Monitoring") {
                NavigationLink(value: AppRoute.radarrQueue) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Queue")
                            Text("Active downloads")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "arrow.down.circle")
                    }
                }
                
                NavigationLink(value: AppRoute.radarrHistory) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("History")
                            Text("Past activity")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
            }
            
            Section("System") {
                NavigationLink(value: AppRoute.radarrSystemStatus) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("System Status")
                            Text("View system information")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
        .navigationTitle("Radarr")
    }
}

#Preview {
    NavigationStack {
        RadarrHomeView()
    }
}
