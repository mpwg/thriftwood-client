import Combine
import SwiftUI

/// Navigation destinations for the app
enum NavigationDestination: Hashable {
    case dashboard
    case settings
    case moduleDetail(String)
    case profile

    var title: String {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .settings:
            return "Settings"
        case .moduleDetail(let moduleName):
            return moduleName
        case .profile:
            return "Profile"
        }
    }
}

/// Base coordinator protocol for navigation management
@MainActor
protocol Coordinator: ObservableObject {
    associatedtype View: SwiftUI.View

    func start()
    func view(for destination: NavigationDestination) -> View
}

/// Main app coordinator
@MainActor
final class AppCoordinator: Coordinator {
    @Published var navigationPath = NavigationPath()
    let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func start() {
        // Perform any initial setup or navigation
    }

    @ViewBuilder
    func view(for destination: NavigationDestination) -> some View {
        switch destination {
        case .dashboard:
            DashboardView()
        case .settings:
            SettingsView()
        case .moduleDetail(let moduleName):
            VStack {
                Text("Module Details: \(moduleName)")
                    .font(.title)
                    .padding()
            }
        case .profile:
            VStack {
                Text("User Profile")
                    .font(.title)
                    .padding()
            }
        }
    }

    func navigate(to destination: NavigationDestination) {
        navigationPath.append(destination)
    }

    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
}

/// Temporary placeholder views (these will be moved to their respective feature modules)
struct ModuleDetailView: View {
    let moduleName: String

    var body: some View {
        VStack {
            Text("Module: \(moduleName)")
                .font(.largeTitle)
            Text("Details coming soon...")
                .foregroundStyle(.secondary)
        }
        .navigationTitle(moduleName)
        #if !os(macOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
            Text("User profile coming soon...")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Profile")
        #if !os(macOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}
