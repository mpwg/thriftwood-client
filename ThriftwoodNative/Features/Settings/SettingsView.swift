import Combine
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var container: DIContainer

    var body: some View {
        NavigationView {
            Form {
                appearanceSection
                notificationSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
        .task {
            await viewModel.loadSettings()
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
    }

    @ViewBuilder
    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $viewModel.settings.theme) {
                ForEach(AppSettings.Theme.allCases, id: \.self) { theme in
                    Text(theme.displayName)
                        .tag(theme)
                }
            }
            .onChange(of: viewModel.settings.theme) { _, _ in
                Task {
                    await viewModel.saveSettings()
                }
            }
        }
    }

    @ViewBuilder
    private var notificationSection: some View {
        Section("Notifications") {
            Toggle("Enable Notifications", isOn: $viewModel.settings.notifications)
                .onChange(of: viewModel.settings.notifications) { _, _ in
                    Task {
                        await viewModel.saveSettings()
                    }
                }
        }
    }

    @ViewBuilder
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }

            Toggle("Analytics", isOn: $viewModel.settings.analyticsEnabled)
                .onChange(of: viewModel.settings.analyticsEnabled) { _, _ in
                    Task {
                        await viewModel.saveSettings()
                    }
                }
        }
    }
}

@MainActor
final class SettingsViewModel: BaseViewModel {
    @Published var settings = AppSettings(
        theme: .system, notifications: true, analyticsEnabled: false)

    private var repository: SettingsRepository?

    override func onViewAppear() async {
        if repository == nil {
            repository = DIContainer.shared.resolve(SettingsRepository.self)
        }
        await loadSettings()
    }

    func loadSettings() async {
        guard let repository = repository else { return }

        do {
            let loadedSettings = try await withLoading {
                try await repository.loadSettings()
            }
            settings = loadedSettings
        } catch {
            print("Failed to load settings: \(error)")
        }
    }

    func saveSettings() async {
        guard let repository = repository else { return }

        do {
            try await repository.saveSettings(settings)
        } catch {
            self.error = error
            print("Failed to save settings: \(error)")
        }
    }
}

// MARK: - Extensions

extension AppSettings.Theme {
    var displayName: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .system:
            return "System"
        }
    }
}

#if DEBUG
    #Preview {
        SettingsView()
            .environmentObject(DIContainer.shared)
    }
#endif
