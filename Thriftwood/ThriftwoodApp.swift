//
//  ThriftwoodApp.swift
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
//
//  ThriftwoodApp.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 03.10.25.
//

import SwiftUI
import SwiftData

@main
struct ThriftwoodApp: App {
    /// Shared DI container
    private let container = DIContainer.shared
    
    /// Shared model container for the app (resolved from DI)
    var sharedModelContainer: ModelContainer {
        container.resolve(ModelContainer.self)
    }
    
    /// Data service for persistence operations (resolved from DI)
    @State private var dataService: (any DataServiceProtocol)?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Initialize data service and bootstrap database
                    if dataService == nil {
                        let service = container.resolve((any DataServiceProtocol).self)
                        dataService = service
                        do {
                            try service.bootstrap()
                        } catch {
                            print("Failed to bootstrap database: \(error)")
                        }
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
