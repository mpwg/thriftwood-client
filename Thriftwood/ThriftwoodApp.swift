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
    /// Shared model container for the app
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer.thriftwoodContainer()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    /// Data service for persistence operations
    @State private var dataService: DataService?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Initialize data service and bootstrap database
                    if dataService == nil {
                        let service = DataService(modelContainer: sharedModelContainer)
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
