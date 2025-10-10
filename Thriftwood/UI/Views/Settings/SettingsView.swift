//
//  SettingsView.swift
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

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: Text("Account")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Account")
                            }
                            Spacer()
                            Image(systemName: SystemIcon.person)
                        }
                    }

                    NavigationLink(destination: ConfigurationView()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Configuration")
                            }
                            Spacer()
                            Image(systemName: SystemIcon.network)
                        }
                    }

                    NavigationLink(destination: Text("Notifications")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Notifications")
                            }
                            Spacer()
                            Image(systemName: SystemIcon.notifications)
                        }
                    }

                    NavigationLink(destination: Text("Profiles")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Profiles")
                            }
                            Spacer()
                            Image(systemName: SystemIcon.profile)
                        }
                    }
                }

                Section {
                    NavigationLink(destination: Text("Donations")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Donations")
                            }
                            Spacer()
                            Image(systemName: SystemIcon.dollar)
                        }
                    }

                    NavigationLink(destination: Text("Resources")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Resources")
                            }
                            Spacer()
                            Image(systemName: SystemIcon.help)
                        }
                    }

                    NavigationLink(destination: Text("System")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("System")
                            }
                            Spacer()
                            Image(systemName: SystemIcon.settingsFilled)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(.insetGrouped)
        }
    }
}

#Preview {
    SettingsView()
}
