//
//  Extensions.swift
//  Thriftwood
//
//  Core utility extensions for Thriftwood
//

import Foundation
import SwiftUI

// MARK: - String Extensions

extension String {
    /// Validate if string is a valid URL
    var isValidURL: Bool {
        URL(string: self) != nil
    }
    
    /// Capitalize first letter
    var capitalizedFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    /// Remove whitespace and newlines
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - URL Extensions

extension URL {
    /// Safely append path component
    func safeAppendingPathComponent(_ pathComponent: String) -> URL {
        let cleanPath = pathComponent.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return appendingPathComponent(cleanPath)
    }
}

// MARK: - Date Extensions

extension Date {
    /// Format date for API requests
    var apiDateString: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    /// Human readable relative date
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    /// Format for calendar display
    var calendarDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - Color Extensions

extension Color {
    /// Create color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Convert to hex string
    var hexString: String {
        guard let components = cgColor?.components, components.count >= 3 else {
            return "#000000"
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}

// MARK: - View Extensions

extension View {
    /// Apply corner radius with specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    /// Conditional view modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply Thriftwood card styling
    func thriftwoodCard(backgroundColor: Color = Color(.secondarySystemBackground)) -> some View {
        self
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    /// Loading state overlay
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                }
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Custom Shapes

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - UserDefaults Extensions

extension UserDefaults {
    /// Type-safe UserDefaults access for Thriftwood settings
    enum ThriftwoodKeys: String {
        case selectedProfile = "thriftwood_selected_profile"
        case enabledServices = "thriftwood_enabled_services"
        case lastSyncDate = "thriftwood_last_sync"
        case cacheSize = "thriftwood_cache_size"
    }
    
    func set<T>(_ value: T, for key: ThriftwoodKeys) {
        set(value, forKey: key.rawValue)
    }
    
    func value<T>(for key: ThriftwoodKeys, defaultValue: T) -> T {
        return object(forKey: key.rawValue) as? T ?? defaultValue
    }
}

// MARK: - Bundle Extensions

extension Bundle {
    /// App version string
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    /// Build number string
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    /// Full version string with build
    var fullVersion: String {
        return "\(appVersion) (\(buildNumber))"
    }
}

// MARK: - Array Extensions

extension Array {
    /// Safe array access
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Identifiable {
    /// Update element by ID
    mutating func updateElement(withId id: Element.ID, using update: (inout Element) -> Void) {
        if let index = firstIndex(where: { $0.id == id }) {
            update(&self[index])
        }
    }
    
    /// Remove element by ID
    mutating func removeElement(withId id: Element.ID) {
        removeAll { $0.id == id }
    }
}

// MARK: - Error Extensions

extension Error {
    /// User-friendly error message
    var friendlyMessage: String {
        if let apiError = self as? APIError {
            return apiError.localizedDescription
        }
        return localizedDescription
    }
}