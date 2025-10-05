//
//  FormValidation.swift
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

import Foundation

/// Validation helpers for form inputs.
/// Provides common validation patterns for URLs, ports, API keys, etc.
enum FormValidation {
    
    // MARK: - URL Validation
    
    /// Validates that a string is a valid URL.
    static func isValidURL(_ string: String) -> Bool {
        guard !string.isEmpty else { return false }
        
        // Check if it's a valid URL
        guard let url = URL(string: string) else { return false }
        
        // Ensure it has a non-empty scheme and a non-nil host
        guard let scheme = url.scheme, !scheme.isEmpty else { return false }
        guard url.host != nil else { return false }
        
        return true
    }
    
    /// Validates that a URL uses HTTP or HTTPS scheme.
    static func isValidHTTPURL(_ string: String) -> Bool {
        guard isValidURL(string) else { return false }
        guard let url = URL(string: string) else { return false }
        
        return url.scheme == "http" || url.scheme == "https"
    }
    
    // MARK: - Port Validation
    
    /// Validates that a string is a valid port number (1-65535).
    static func isValidPort(_ string: String) -> Bool {
        guard let port = Int(string) else { return false }
        return port >= 1 && port <= 65535
    }
    
    // MARK: - API Key Validation
    
    /// Validates that an API key is not empty.
    static func isValidAPIKey(_ string: String) -> Bool {
        return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Validates that an API key meets minimum length requirement.
    static func isValidAPIKey(_ string: String, minLength: Int) -> Bool {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= minLength
    }
    
    // MARK: - MAC Address Validation
    
    /// Validates that a string is a valid MAC address.
    /// Supports formats: AA:BB:CC:DD:EE:FF or AA-BB-CC-DD-EE-FF
    static func isValidMACAddress(_ string: String) -> Bool {
        let pattern = "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(string.startIndex..., in: string)
        return regex?.firstMatch(in: string, range: range) != nil
    }
    
    // MARK: - Username Validation
    
    /// Validates that a username is not empty.
    static func isValidUsername(_ string: String) -> Bool {
        return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Password Validation
    
    /// Validates that a password meets minimum requirements.
    static func isValidPassword(_ string: String, minLength: Int = 1) -> Bool {
        return string.count >= minLength
    }
    
    // MARK: - Generic Validation
    
    /// Validates that a string is not empty after trimming whitespace.
    static func isNotEmpty(_ string: String) -> Bool {
        return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Validates that a string is within a length range.
    static func isWithinLength(_ string: String, min: Int, max: Int) -> Bool {
        let length = string.count
        return length >= min && length <= max
    }
}

// MARK: - String Extension

extension String {
    /// Returns true if the string is a valid URL.
    var isValidURL: Bool {
        FormValidation.isValidURL(self)
    }
    
    /// Returns true if the string is a valid HTTP/HTTPS URL.
    var isValidHTTPURL: Bool {
        FormValidation.isValidHTTPURL(self)
    }
    
    /// Returns true if the string is a valid port number.
    var isValidPort: Bool {
        FormValidation.isValidPort(self)
    }
    
    /// Returns true if the string is a valid API key (not empty).
    var isValidAPIKey: Bool {
        FormValidation.isValidAPIKey(self)
    }
    
    /// Returns true if the string is a valid MAC address.
    var isValidMACAddress: Bool {
        FormValidation.isValidMACAddress(self)
    }
    
    /// Returns true if the string is a valid username (not empty).
    var isValidUsername: Bool {
        FormValidation.isValidUsername(self)
    }
}
