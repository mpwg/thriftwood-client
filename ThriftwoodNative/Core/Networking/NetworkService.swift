import Combine
import Foundation

/// Network service implementation using modern Swift concurrency
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
