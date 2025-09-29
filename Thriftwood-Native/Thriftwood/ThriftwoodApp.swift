//
//  ThriftwoodApp.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 29.09.25.
//

import SwiftUI
import SwiftData

@main
struct ThriftwoodApp: App {
    
    // MARK: - Theme Manager
    @State private var themeManager = ThemeManager()
    
    // MARK: - SwiftData Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ThriftwoodProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(themeManager)
                .thriftwoodTheme(themeManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
