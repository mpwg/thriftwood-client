//
//  ThemeTests.swift
//  ThriftwoodTests
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

import Testing
import SwiftUI
@testable import Thriftwood

// MARK: - Theme Tests

@Suite("Theme System Tests")
@MainActor
struct ThemeTests {
    
    // MARK: - Built-in Themes
    
    @Test("Built-in themes exist")
    func builtInThemesExist() {
        #expect(Theme.builtInThemes.count == 3)
        #expect(Theme.builtInThemes.contains(where: { $0.id == "light" }))
        #expect(Theme.builtInThemes.contains(where: { $0.id == "dark" }))
        #expect(Theme.builtInThemes.contains(where: { $0.id == "black" }))
    }
    
    @Test("Light theme properties")
    func lightThemeProperties() {
        let theme = Theme.light
        #expect(theme.id == "light")
        #expect(theme.name == "Light")
        #expect(theme.isDark == false)
        #expect(theme.showBorders == false)
        #expect(theme.imageBackgroundOpacity == 50)
    }
    
    @Test("Dark theme properties")
    func darkThemeProperties() {
        let theme = Theme.dark
        #expect(theme.id == "dark")
        #expect(theme.name == "Dark")
        #expect(theme.isDark == true)
        #expect(theme.showBorders == false)
    }
    
    @Test("Black theme properties")
    func blackThemeProperties() {
        let theme = Theme.black
        #expect(theme.id == "black")
        #expect(theme.name == "Black")
        #expect(theme.isDark == true)
        #expect(theme.showBorders == true)
        #expect(theme.imageBackgroundOpacity == 30)
    }
    
    // MARK: - CodableColor
    
    @Test("CodableColor initialization with values")
    func codableColorInitialization() {
        let color = CodableColor(red: 1.0, green: 0.5, blue: 0.0, opacity: 0.8)
        #expect(color.red == 1.0)
        #expect(color.green == 0.5)
        #expect(color.blue == 0.0)
        #expect(color.opacity == 0.8)
    }
    
    @Test("CodableColor color property exists")
    func codableColorToSwiftUIColor() {
        let codableColor = CodableColor(red: 1.0, green: 0.0, blue: 0.0)
        // Just verify the color property exists and can be accessed
        _ = codableColor.color
    }
    
    // MARK: - Theme Customization
    
    @Test("Theme customization")
    func themeCustomization() {
        let lightIsDark = Theme.light.isDark
        let customTheme = Theme.light.customized(
            id: "custom-light",
            name: "Custom Light",
            accentColor: .blue,
            showBorders: true,
            imageBackgroundOpacity: 75
        )
        
        #expect(customTheme.id == "custom-light")
        #expect(customTheme.name == "Custom Light")
        #expect(customTheme.showBorders == true)
        #expect(customTheme.imageBackgroundOpacity == 75)
        #expect(customTheme.isDark == lightIsDark)
    }
    
    // MARK: - Theme Codable
    
    @Test("Theme encoding and decoding")
    func themeEncodingDecoding() throws {
        let original = Theme.light
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Theme.self, from: data)
        
        #expect(decoded.id == original.id)
        #expect(decoded.name == original.name)
        #expect(decoded.isDark == original.isDark)
    }
}

// MARK: - Theme Manager Tests

@Suite("ThemeManager Tests")
@MainActor
struct ThemeManagerTests {
    
    // MARK: - Initialization
    
    @Test("ThemeManager initialization with defaults")
    func themeManagerInitialization() async throws {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "thriftwood.themeMode")
        UserDefaults.standard.removeObject(forKey: "thriftwood.selectedThemeID")
        UserDefaults.standard.removeObject(forKey: "thriftwood.customThemes")
        
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        #expect(manager.themeMode == .system)
        #expect(manager.selectedThemeID == nil)
        #expect(manager.customThemes.isEmpty)
        #expect(manager.availableThemes.count == 3) // 3 built-in themes
    }
    
    // MARK: - Theme Selection
    
    @Test("Set specific theme")
    func setSpecificTheme() async throws {
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        manager.setTheme(Theme.dark)
        
        #expect(manager.themeMode == .custom)
        #expect(manager.selectedThemeID == "dark")
        #expect(manager.currentTheme.id == "dark")
    }
    
    @Test("System theme mode")
    func systemThemeMode() async throws {
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        manager.themeMode = .system
        manager.selectedThemeID = nil
        
        #expect(manager.themeMode == .system)
        // Current theme should be light or dark based on system
        #expect(manager.currentTheme.id == "light" || manager.currentTheme.id == "dark")
    }
    
    // MARK: - Custom Themes
    
    @Test("Add custom theme")
    func addCustomTheme() async throws {
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        let customTheme = Theme.light.customized(
            id: "my-theme",
            name: "My Theme",
            accentColor: .purple
        )
        
        manager.addCustomTheme(customTheme)
        
        #expect(manager.customThemes.count == 1)
        #expect(manager.availableThemes.count == 4) // 3 built-in + 1 custom
        #expect(manager.availableThemes.contains(where: { $0.id == "my-theme" }))
    }
    
    @Test("Remove custom theme")
    func removeCustomTheme() async throws {
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        let customTheme = Theme.light.customized(
            id: "my-theme",
            name: "My Theme"
        )
        
        manager.addCustomTheme(customTheme)
        #expect(manager.customThemes.count == 1)
        
        manager.removeCustomTheme(id: "my-theme")
        #expect(manager.customThemes.isEmpty)
        #expect(manager.availableThemes.count == 3) // Back to 3 built-in
    }
    
    @Test("Update custom theme")
    func updateCustomTheme() async throws {
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        let originalTheme = Theme.light.customized(
            id: "my-theme",
            name: "My Theme",
            imageBackgroundOpacity: 50
        )
        
        manager.addCustomTheme(originalTheme)
        
        let updatedTheme = originalTheme.customized(
            id: "my-theme",
            name: "My Updated Theme",
            imageBackgroundOpacity: 75
        )
        
        manager.updateCustomTheme(updatedTheme)
        
        let found = manager.customThemes.first(where: { $0.id == "my-theme" })
        #expect(found?.name == "My Updated Theme")
        #expect(found?.imageBackgroundOpacity == 75)
    }
    
    // MARK: - Persistence
    
    @Test("Theme preferences persistence")
    func themePreferencesPersistence() async throws {
        // Clear existing
        UserDefaults.standard.removeObject(forKey: "thriftwood.themeMode")
        UserDefaults.standard.removeObject(forKey: "thriftwood.selectedThemeID")
        
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        manager.themeMode = .custom
        manager.selectedThemeID = "dark"
        
        // Verify persistence
        let savedMode = UserDefaults.standard.string(forKey: "thriftwood.themeMode")
        let savedID = UserDefaults.standard.string(forKey: "thriftwood.selectedThemeID")
        
        #expect(savedMode == "custom")
        #expect(savedID == "dark")
    }
    
    @Test("Reset to default")
    func resetToDefault() async throws {
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        manager.setTheme(Theme.black)
        #expect(manager.themeMode == .custom)
        
        manager.resetToDefault()
        
        #expect(manager.themeMode == .system)
        #expect(manager.selectedThemeID == nil)
    }
    
    // MARK: - Default Behavior
    
    @Test("Default theme mode is system")
    func defaultThemeModeIsSystem() async throws {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "thriftwood.themeMode")
        UserDefaults.standard.removeObject(forKey: "thriftwood.selectedThemeID")
        
        let mockPreferences = MockUserPreferencesService()
        let manager = ThemeManager(userPreferences: mockPreferences)
        
        #expect(manager.themeMode == .system)
        #expect(manager.selectedThemeID == nil)
    }
    
    @Test("System theme mode persists across instances")
    func systemThemeModePersists() async throws {
        // Clear and set system mode explicitly
        UserDefaults.standard.removeObject(forKey: "thriftwood.themeMode")
        UserDefaults.standard.removeObject(forKey: "thriftwood.selectedThemeID")
        
        let mockPreferences = MockUserPreferencesService()
        let manager1 = ThemeManager(userPreferences: mockPreferences)
        manager1.themeMode = .system
        
        // Create new instance
        let manager2 = ThemeManager(userPreferences: mockPreferences)
        #expect(manager2.themeMode == .system)
        #expect(manager2.selectedThemeID == nil)
    }
    
    @Test("Custom theme selection persists across instances")
    func customThemeSelectionPersists() async throws {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "thriftwood.themeMode")
        UserDefaults.standard.removeObject(forKey: "thriftwood.selectedThemeID")
        
        let mockPreferences = MockUserPreferencesService()
        let manager1 = ThemeManager(userPreferences: mockPreferences)
        manager1.setTheme(Theme.dark)
        
        // Create new instance - should load saved theme
        let manager2 = ThemeManager(userPreferences: mockPreferences)
        #expect(manager2.themeMode == .custom)
        #expect(manager2.selectedThemeID == "dark")
        #expect(manager2.currentTheme.id == "dark")
    }
}
