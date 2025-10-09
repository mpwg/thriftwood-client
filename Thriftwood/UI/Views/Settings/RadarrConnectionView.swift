//
//  RadarrConnectionView.swift
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

struct RadarrConnectionView: View {
    @State private var host: String = "http://localhost"
    @State private var port: String = "7878"
    @State private var apiKey: String = ""
    @State private var useSSL: Bool = false
    @State private var testing: Bool = false
    @State private var lastTestResult: String?

    var body: some View {
        Form {
            Section(header: Text("Connection")) {
                TextField("Host", text: $host)
                    .textContentType(.URL)
                TextField("Port", text: $port)
                    .keyboardType(.numberPad)
                SecureField("API Key", text: $apiKey)
                Toggle("Use SSL", isOn: $useSSL)
            }

            Section {
                Button(action: testConnection) {
                    HStack {
                        Spacer()
                        if testing {
                            ProgressView()
                        } else {
                            Text("Test Connection")
                        }
                        Spacer()
                    }
                }
            }

            if let result = lastTestResult {
                Section(header: Text("Last Test")) {
                    Text(result)
                }
            }
        }
        .navigationTitle("Connection Details")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    // placeholder save action
                }
            }
        }
    }

    private func testConnection() {
        testing = true
        lastTestResult = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            testing = false
            // fake success
            lastTestResult = "Connection successful"
        }
    }
}

#Preview {
    NavigationStack {
        RadarrConnectionView()
    }
}
