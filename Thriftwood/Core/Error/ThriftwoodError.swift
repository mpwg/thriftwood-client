//
//  ThriftwoodError.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//
//  ThriftwoodError.swift
//  Thriftwood
//
//  Comprehensive error handling for the application
//

import Foundation

/// Primary error type for Thriftwood application
enum ThriftwoodError: LocalizedError {
    case networkError(URLError)
    case apiError(statusCode: Int, message: String)
    case decodingError(DecodingError)
    case authenticationRequired
    case serviceUnavailable
    case invalidURL
    case invalidResponse
    case invalidConfiguration(String)
    case storageError(any Error)
    case keychainError(OSStatus)
    case unknown(any Error)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let urlError):
            return "Network error: \(urlError.localizedDescription)"
        case .apiError(let statusCode, let message):
            return "API error (\(statusCode)): \(message)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .authenticationRequired:
            return "Authentication required. Please check your credentials."
        case .serviceUnavailable:
            return "Service temporarily unavailable. Please try again later."
        case .invalidURL:
            return "Invalid URL configuration."
        case .invalidResponse:
            return "Invalid response from server."
        case .invalidConfiguration(let details):
            return "Invalid configuration: \(details)"
        case .storageError(let error):
            return "Storage error: \(error.localizedDescription)"
        case .keychainError(let status):
            return "Keychain error: \(status)"
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Check your internet connection and try again."
        case .apiError(let statusCode, _) where statusCode >= 500:
            return "The service is experiencing issues. Please try again later."
        case .authenticationRequired:
            return "Please verify your API key and credentials in settings."
        case .serviceUnavailable:
            return "Wait a moment and try again."
        case .decodingError:
            return "This might be a temporary issue. Please try again."
        case .invalidConfiguration:
            return "Please check your service configuration in settings."
        case .storageError:
            return "Try restarting the app. If the issue persists, contact support."
        case .keychainError:
            return "Please re-enter your credentials in settings."
        default:
            return "Please try again or contact support if the issue persists."
        }
    }
    
    /// Whether this error should trigger automatic retry
    var isRetryable: Bool {
        switch self {
        case .networkError(let urlError):
            return urlError.code == .timedOut || urlError.code == .networkConnectionLost
        case .apiError(let statusCode, _):
            return statusCode >= 500 // Server errors are retryable
        case .serviceUnavailable:
            return true
        default:
            return false
        }
    }
}

/// Extension to convert generic errors to ThriftwoodError
extension ThriftwoodError {
    static func from(_ error: any Error) -> ThriftwoodError {
        if let thriftwoodError = error as? ThriftwoodError {
            return thriftwoodError
        }
        
        if let urlError = error as? URLError {
            return .networkError(urlError)
        }
        
        if let decodingError = error as? DecodingError {
            return .decodingError(decodingError)
        }
        
        return .unknown(error)
    }
}
