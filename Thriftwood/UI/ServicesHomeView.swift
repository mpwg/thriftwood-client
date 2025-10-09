//
//  ServicesHomeView.swift
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

struct ServicesHomeView: View {
    var body: some View {
        List {
            Section("Media Management") {
                NavigationLink(value: AppRoute.radarrHome) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Radarr")
                                .font(.body)
                            Text("Movie management")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "film")
                    }
                }
                
                // Future services
                // NavigationLink(value: AppRoute.sonarrHome) {
                //     Label {
                //         VStack(alignment: .leading, spacing: 2) {
                //             Text("Sonarr")
                //             Text("TV show management")
                //                 .font(.caption)
                //                 .foregroundStyle(.secondary)
                //         }
                //     } icon: {
                //         Image(systemName: "tv")
                //     }
                // }
            }
        }
        .navigationTitle("Services")
    }
}

#Preview {
    NavigationStack {
        ServicesHomeView()
    }
}
