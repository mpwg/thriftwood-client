import Foundation

/// Dashboard repository implementation
final class DashboardRepositoryImpl: DashboardRepository {
    private let networkService: NetworkService
    private let storageService: StorageService

    init(networkService: NetworkService, storageService: StorageService) {
        self.networkService = networkService
        self.storageService = storageService
    }

    func fetchDashboardData() async throws -> DashboardData {
        // For now, return mock data. This would typically fetch from API
        return DashboardData(
            title: "Thriftwood Dashboard",
            modules: [
                DashboardModule(id: "sonarr", name: "Sonarr", isEnabled: true),
                DashboardModule(id: "radarr", name: "Radarr", isEnabled: true),
                DashboardModule(id: "lidarr", name: "Lidarr", isEnabled: false),
                DashboardModule(id: "overseerr", name: "Overseerr", isEnabled: true),
            ]
        )
    }
}
