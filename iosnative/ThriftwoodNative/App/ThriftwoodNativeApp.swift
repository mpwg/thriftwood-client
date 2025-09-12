import SwiftUI

@main
struct ThriftwoodNativeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(ColorScheme.dark)
        }
        #if targetEnvironment(macCatalyst)
            .windowStyle(.automatic)
            .windowResizability(.contentSize)
            .windowToolbarStyle(.unified)
        #endif
    }
}

#if DEBUG
    #Preview {
        ContentView()
    }
#endif
