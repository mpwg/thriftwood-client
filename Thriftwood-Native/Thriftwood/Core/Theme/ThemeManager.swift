//
//  ThemeManager.swift
//  Thriftwood
//
//  Swift 6 Modern Theme Management System
//

import SwiftUI
import Foundation

/// Theme configuration following Thriftwood's design system
@Observable
@MainActor
final class ThemeManager: Sendable {
    
    // MARK: - Theme Types
    
    enum ThemeType: String, CaseIterable, Sendable {
        case system = "system"
        case light = "light"
        case dark = "dark"
        case amoledBlack = "amoled_black"
        
        var displayName: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            case .amoledBlack: return "AMOLED Black"
            }
        }
    }
    
    enum AccentColor: String, CaseIterable, Sendable {
        case blue = "blue"
        case orange = "orange"
        case red = "red"
        case green = "green"
        case purple = "purple"
        case pink = "pink"
        
        var color: Color {
            switch self {
            case .blue: return .blue
            case .orange: return .orange
            case .red: return .red
            case .green: return .green
            case .purple: return .purple
            case .pink: return .pink
            }
        }
    }
    
    // MARK: - Properties
    
    private(set) var currentTheme: ThemeType = .system
    private(set) var accentColor: AccentColor = .blue
    private(set) var colorScheme: ColorScheme? = nil
    
    // MARK: - Initialization
    
    init() {
        loadThemeSettings()
    }
    
    // MARK: - Theme Management
    
    func setTheme(_ theme: ThemeType) {
        currentTheme = theme
        updateColorScheme()
        saveThemeSettings()
    }
    
    func setAccentColor(_ accent: AccentColor) {
        accentColor = accent
        saveThemeSettings()
    }
    
    private func updateColorScheme() {
        switch currentTheme {
        case .system:
            colorScheme = nil
        case .light:
            colorScheme = .light
        case .dark, .amoledBlack:
            colorScheme = .dark
        }
    }
    
    // MARK: - Colors
    
    var backgroundColor: Color {
        switch currentTheme {
        case .amoledBlack:
            return .black
        case .dark:
            return Color(.systemBackground)
        case .light:
            return Color(.systemBackground)
        case .system:
            return Color(.systemBackground)
        }
    }
    
    var cardBackgroundColor: Color {
        switch currentTheme {
        case .amoledBlack:
            return Color(.systemGray6).opacity(0.1)
        default:
            return Color(.secondarySystemBackground)
        }
    }
    
    var primaryTextColor: Color {
        switch currentTheme {
        case .amoledBlack:
            return .white
        default:
            return Color(.label)
        }
    }
    
    var secondaryTextColor: Color {
        switch currentTheme {
        case .amoledBlack:
            return Color(.systemGray)
        default:
            return Color(.secondaryLabel)
        }
    }
    
    // MARK: - Persistence
    
    private func loadThemeSettings() {
        if let themeString = UserDefaults.standard.string(forKey: "thriftwood_theme"),
           let theme = ThemeType(rawValue: themeString) {
            currentTheme = theme
        }
        
        if let accentString = UserDefaults.standard.string(forKey: "thriftwood_accent"),
           let accent = AccentColor(rawValue: accentString) {
            accentColor = accent
        }
        
        updateColorScheme()
    }
    
    private func saveThemeSettings() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: "thriftwood_theme")
        UserDefaults.standard.set(accentColor.rawValue, forKey: "thriftwood_accent")
    }
}

// MARK: - Environment Integration

extension EnvironmentValues {
    @Entry var themeManager: ThemeManager = ThemeManager()
}

// MARK: - View Modifiers

extension View {
    func thriftwoodTheme(_ manager: ThemeManager) -> some View {
        self
            .preferredColorScheme(manager.colorScheme)
            .tint(manager.accentColor.color)
            .background(manager.backgroundColor)
    }
}