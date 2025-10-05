//
//  ThemeManager.swift
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

import SwiftUI
import Combine
import OSLog

/// Protocol for theme management
/// Prefixed with MPWG to avoid naming conflicts
protocol MPWGThemeManagerProtocol {
    /// Current active theme
    var currentTheme: MPWGTheme { get }
    
    /// Current theme mode (system or custom)
    var themeMode: MPWGThemeMode { get set }
    
    /// ID of selected custom theme (when themeMode is .custom)
    var selectedThemeID: String? { get set }
    
    /// All available themes (built-in + custom)
    var availableThemes: [MPWGTheme] { get }
    
    /// Custom themes created by user
    var customThemes: [MPWGTheme] { get set }
    
    /// Detect if system is in dark mode
    var isSystemDarkMode: Bool { get }
    
    /// Set a specific theme
    func setTheme(_ theme: MPWGTheme)
    
    /// Add a custom theme
    func addCustomTheme(_ theme: MPWGTheme)
    
    /// Remove a custom theme
    func removeCustomTheme(id: String)
    
    /// Update an existing custom theme
    func updateCustomTheme(_ theme: MPWGTheme)
    
    /// Reset to default theme
    func resetToDefault()
}

/// Theme manager for handling app-wide theme state
/// Prefixed with MPWG to avoid naming conflicts
@MainActor
final class MPWGThemeManager: MPWGThemeManagerProtocol, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var currentTheme: MPWGTheme
    @Published var themeMode: MPWGThemeMode {
        didSet {
            updateCurrentTheme()
            savePreferences()
        }
    }
    
    @Published var selectedThemeID: String? {
        didSet {
            updateCurrentTheme()
            savePreferences()
        }
    }
    
    @Published var customThemes: [MPWGTheme] {
        didSet {
            saveCustomThemes()
        }
    }
    
    @Published private(set) var isSystemDarkMode: Bool = false
    
    // MARK: - Dependencies
    
    private let userPreferences: any UserPreferencesServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constants
    
    private let customThemesKey = "thriftwood.customThemes"
    private let selectedThemeIDKey = "thriftwood.selectedThemeID"
    private let themeModeKey = "thriftwood.themeMode"
    
    // MARK: - Computed Properties
    
    var availableThemes: [MPWGTheme] {
        MPWGTheme.builtInThemes + customThemes
    }
    
    // MARK: - Initialization
    
    init(userPreferences: any UserPreferencesServiceProtocol) {
        self.userPreferences = userPreferences
        
        // Load saved preferences
        let loadedThemeMode = Self.loadThemeMode()
        let loadedSelectedThemeID = Self.loadSelectedThemeID()
        let loadedCustomThemes = Self.loadCustomThemes()
        let detectedSystemDarkMode = Self.detectSystemDarkMode()
        
        // Initialize published properties
        self.themeMode = loadedThemeMode
        self.selectedThemeID = loadedSelectedThemeID
        self.customThemes = loadedCustomThemes
        self.isSystemDarkMode = detectedSystemDarkMode
        
        // Set initial theme
        self.currentTheme = Self.resolveTheme(
            mode: loadedThemeMode,
            selectedID: loadedSelectedThemeID,
            customThemes: loadedCustomThemes,
            isSystemDark: detectedSystemDarkMode
        )
        
        // Observe system appearance changes
        observeSystemAppearance()
    }
    
    // MARK: - Public Methods
    
    func setTheme(_ theme: MPWGTheme) {
        themeMode = .custom
        selectedThemeID = theme.id
        currentTheme = theme
    }
    
    func addCustomTheme(_ theme: MPWGTheme) {
        guard !availableThemes.contains(where: { $0.id == theme.id }) else {
            unsafe os_log(.info, "Theme with ID %{public}@ already exists", theme.id)
            return
        }
        customThemes.append(theme)
    }
    
    func removeCustomTheme(id: String) {
        customThemes.removeAll { $0.id == id }
        
        // If removed theme was selected, switch to default
        if selectedThemeID == id {
            resetToDefault()
        }
    }
    
    func updateCustomTheme(_ theme: MPWGTheme) {
        if let index = customThemes.firstIndex(where: { $0.id == theme.id }) {
            customThemes[index] = theme
            
            // Update current theme if this was the active one
            if selectedThemeID == theme.id {
                currentTheme = theme
            }
        }
    }
    
    func resetToDefault() {
        themeMode = .system
        selectedThemeID = nil
        updateCurrentTheme()
    }
    
    // MARK: - Private Methods
    
    private func updateCurrentTheme() {
        currentTheme = Self.resolveTheme(
            mode: themeMode,
            selectedID: selectedThemeID,
            customThemes: customThemes,
            isSystemDark: isSystemDarkMode
        )
    }
    
    private static func resolveTheme(
        mode: MPWGThemeMode,
        selectedID: String?,
        customThemes: [MPWGTheme],
        isSystemDark: Bool
    ) -> MPWGTheme {
        switch mode {
        case .system:
            // Follow system appearance
            return isSystemDark ? MPWGTheme.dark : MPWGTheme.light
            
        case .custom:
            // Use selected theme or fall back to system
            guard let id = selectedID else {
                return isSystemDark ? MPWGTheme.dark : MPWGTheme.light
            }
            
            // Look in built-in themes first
            if let theme = MPWGTheme.builtInThemes.first(where: { $0.id == id }) {
                return theme
            }
            
            // Then look in custom themes
            if let theme = customThemes.first(where: { $0.id == id }) {
                return theme
            }
            
            // Fall back to system
            return isSystemDark ? MPWGTheme.dark : MPWGTheme.light
        }
    }
    
    private func observeSystemAppearance() {
        #if os(macOS)
        // Observe system appearance changes on macOS
        NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    self?.updateSystemAppearance()
                }
            }
            .store(in: &cancellables)
        #endif
        
        // Periodic check (as backup)
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateSystemAppearance()
            }
            .store(in: &cancellables)
    }
    
    private func updateSystemAppearance() {
        let newValue = Self.detectSystemDarkMode()
        if newValue != isSystemDarkMode {
            isSystemDarkMode = newValue
            
            // Update theme if following system
            if themeMode == .system {
                updateCurrentTheme()
            }
        }
    }
    
    private static func detectSystemDarkMode() -> Bool {
        #if os(macOS)
        let appearance = NSApp.effectiveAppearance
        let aquaAppearance = NSAppearance(named: .aqua)
        let darkAquaAppearance = NSAppearance(named: .darkAqua)
        
        if appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua {
            return true
        }
        return false
        #else
        // Use UITraitCollection from first available window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.traitCollection.userInterfaceStyle == .dark
        }
        // Fallback to light mode if no window scene available
        return false
        #endif
    }
    
    // MARK: - Persistence
    
    private func savePreferences() {
        UserDefaults.standard.set(themeMode.rawValue, forKey: themeModeKey)
        if let id = selectedThemeID {
            UserDefaults.standard.set(id, forKey: selectedThemeIDKey)
        } else {
            UserDefaults.standard.removeObject(forKey: selectedThemeIDKey)
        }
    }
    
    private func saveCustomThemes() {
        if let data = try? JSONEncoder().encode(customThemes) {
            UserDefaults.standard.set(data, forKey: customThemesKey)
        }
    }
    
    private static func loadThemeMode() -> MPWGThemeMode {
        guard let rawValue = UserDefaults.standard.string(forKey: "thriftwood.themeMode"),
              let mode = MPWGThemeMode(rawValue: rawValue) else {
            return .system
        }
        return mode
    }
    
    private static func loadSelectedThemeID() -> String? {
        UserDefaults.standard.string(forKey: "thriftwood.selectedThemeID")
    }
    
    private static func loadCustomThemes() -> [MPWGTheme] {
        guard let data = UserDefaults.standard.data(forKey: "thriftwood.customThemes"),
              let themes = try? JSONDecoder().decode([MPWGTheme].self, from: data) else {
            return []
        }
        return themes
    }
}

// MARK: - Environment Key

private struct MPWGThemeKey: EnvironmentKey {
    static let defaultValue: MPWGTheme = MPWGTheme.light
}

private struct MPWGThemeManagerKey: EnvironmentKey {
    static let defaultValue: MPWGThemeManager? = nil
}

extension EnvironmentValues {
    var mpwgTheme: MPWGTheme {
        get { self[MPWGThemeKey.self] }
        set { self[MPWGThemeKey.self] = newValue }
    }
    
    var mpwgThemeManager: MPWGThemeManager? {
        get { self[MPWGThemeManagerKey.self] }
        set { self[MPWGThemeManagerKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// Apply the theme to this view and its children
    func themed(_ theme: MPWGTheme) -> some View {
        self.environment(\.mpwgTheme, theme)
            .preferredColorScheme(theme.isDark ? .dark : .light)
    }
    
    /// Apply the theme manager to this view and its children
    func themedWithManager(_ manager: MPWGThemeManager) -> some View {
        self.environment(\.mpwgTheme, manager.currentTheme)
            .environment(\.mpwgThemeManager, manager)
            .preferredColorScheme(manager.currentTheme.isDark ? .dark : .light)
    }
}
