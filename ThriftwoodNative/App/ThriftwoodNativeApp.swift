import SwiftUI

@main
struct ThriftwoodNativeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
            .windowResizability(.contentSize)


    }
}

#if DEBUG
    #Preview {
        ContentView()
    }
#endif
