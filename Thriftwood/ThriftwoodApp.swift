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
    @State private var dataService: DataService?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Initialize data service and bootstrap database
                    if dataService == nil {
                        let service = container.resolve(DataService.self)
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
