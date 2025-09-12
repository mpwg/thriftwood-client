import Combine
import Foundation
import SwiftUI

// MARK: - Shared Data Models

struct DashboardData: Codable {
    let title: String
    let modules: [DashboardModule]
}

struct DashboardModule: Codable, Identifiable {
    let id: String
    let name: String
    let isEnabled: Bool
}

struct AppSettings: Codable {
    var theme: Theme
    var notifications: Bool
    var analyticsEnabled: Bool

    enum Theme: String, Codable, CaseIterable {
        case light = "light"
        case dark = "dark"
        case system = "system"

        var displayName: String {
            switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .system: return "System"
            }
        }
    }
}

// MARK: - Service Protocols

protocol NetworkService {
    func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T
}

protocol StorageService {
    func save<T: Codable>(_ object: T, forKey key: String) async throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T?
    func delete(forKey key: String) async throws
}

// MARK: - Repository Protocols

protocol DashboardRepository {
    func fetchDashboardData() async throws -> DashboardData
}

protocol SettingsRepository {
    func loadSettings() async throws -> AppSettings
    func saveSettings(_ settings: AppSettings) async throws
}

// MARK: - API Support

struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?

    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE, PATCH
    }
}

// MARK: - Error Types

enum NetworkError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case encodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response received from server"
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        }
    }
}

enum StorageError: LocalizedError {
    case encodingError(Error)
    case decodingError(Error)
    case notFound

    var errorDescription: String? {
        switch self {
        case .encodingError(let error):
            return "Failed to encode data: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .notFound:
            return "Data not found in storage"
        }
    }
}

enum ViewModelError: LocalizedError {
    case dataNotFound
    case networkUnavailable
    case unauthorized
    case generic(String)

    var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "The requested data could not be found."
        case .networkUnavailable:
            return "Network connection is unavailable."
        case .unauthorized:
            return "You are not authorized to access this resource."
        case .generic(let message):
            return message
        }
    }
}

// MARK: - Service Implementations

final class NetworkServiceImpl: NetworkService, @unchecked Sendable {
    private let session: URLSession
    private let baseURL: URL

    init(baseURL: String = "https://api.thriftwood.app", session: URLSession = .shared) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        self.baseURL = url
        self.session = session
    }

    func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        // Set headers
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("ThriftwoodNative/1.0", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

final class StorageServiceImpl: StorageService, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }

    func save<T: Codable>(_ object: T, forKey key: String) async throws {
        do {
            let data = try encoder.encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            throw StorageError.encodingError(error)
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw StorageError.decodingError(error)
        }
    }

    func delete(forKey key: String) async throws {
        userDefaults.removeObject(forKey: key)
    }
}

// MARK: - Repository Implementations

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
