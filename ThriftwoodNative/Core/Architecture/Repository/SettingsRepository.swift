import Foundation

/// Settings repository implementation
final class SettingsRepositoryImpl: SettingsRepository {
    private let storageService: StorageService
    private static let settingsKey = "app_settings"

    init(storageService: StorageService) {
        self.storageService = storageService
    }

    func loadSettings() async throws -> AppSettings {
        if let settings = try await storageService.load(AppSettings.self, forKey: Self.settingsKey)
        {
            return settings
        } else {
            // Return default settings
            return AppSettings(
                theme: .system,
                notifications: true,
                analyticsEnabled: false
            )
        }
    }

    func saveSettings(_ settings: AppSettings) async throws {
        try await storageService.save(settings, forKey: Self.settingsKey)
    }
}
