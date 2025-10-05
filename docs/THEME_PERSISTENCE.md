# Theme Persistence in Thriftwood

**Status**: ✅ Implemented and Tested  
**Default**: System theme (follows macOS appearance)

## Overview

ThemeManager automatically persists theme preferences across app launches using UserDefaults. Users can choose to follow the system appearance (default) or select a specific theme.

## Storage Keys

| Key                          | Value                       | Default  |
| ---------------------------- | --------------------------- | -------- |
| `thriftwood.themeMode`       | "system" or "custom"        | "system" |
| `thriftwood.selectedThemeID` | Theme ID (e.g., "dark")     | nil      |
| `thriftwood.customThemes`    | JSON array of custom themes | []       |

## Behavior

### Default (First Launch)

```swift
let manager = ThemeManager(userPreferences: userPrefs)
// themeMode = .system
// selectedThemeID = nil
// currentTheme = Theme.light or Theme.dark (based on macOS appearance)
```

### System Mode (Default)

When `themeMode = .system`:

- ✅ Automatically switches between light/dark based on macOS appearance
- ✅ Updates in real-time when user changes System Preferences
- ✅ No manual theme selection needed
- ✅ Persists across app launches

```swift
// User changes macOS to dark mode
// → ThemeManager automatically updates currentTheme to Theme.dark
```

### Custom Mode

When user selects a specific theme:

```swift
themeManager.setTheme(Theme.black)
// themeMode = .custom
// selectedThemeID = "black"
// currentTheme = Theme.black
// ✅ Saved to UserDefaults immediately
```

On next app launch:

```swift
let manager = ThemeManager(userPreferences: userPrefs)
// ✅ Loads themeMode = .custom from UserDefaults
// ✅ Loads selectedThemeID = "black" from UserDefaults
// ✅ Restores currentTheme = Theme.black
```

### Reset to Default

```swift
themeManager.resetToDefault()
// themeMode = .system
// selectedThemeID = nil
// currentTheme = Theme.light or Theme.dark (based on macOS appearance)
// ✅ Saved to UserDefaults immediately
```

## Custom Themes

Custom themes are also persisted:

```swift
let customTheme = Theme.light.customized(
    id: "my-theme",
    name: "My Theme",
    accentColor: .purple
)
themeManager.addCustomTheme(customTheme)
// ✅ Saved to UserDefaults immediately
```

On next app launch:

```swift
let manager = ThemeManager(userPreferences: userPrefs)
// ✅ Custom themes loaded from UserDefaults
// ✅ Available in availableThemes array
```

## Implementation Details

### Automatic Persistence

All theme changes are saved automatically via `didSet` property observers:

```swift
@Published var themeMode: ThemeMode {
    didSet {
        updateCurrentTheme()
        savePreferences()  // ← Automatic save
    }
}

@Published var selectedThemeID: String? {
    didSet {
        updateCurrentTheme()
        savePreferences()  // ← Automatic save
    }
}

@Published var customThemes: [Theme] {
    didSet {
        saveCustomThemes()  // ← Automatic save
    }
}
```

### Loading on Initialization

```swift
init(userPreferences: any UserPreferencesServiceProtocol) {
    // Load saved preferences
    let loadedThemeMode = Self.loadThemeMode()          // ← Loads from UserDefaults
    let loadedSelectedThemeID = Self.loadSelectedThemeID() // ← Loads from UserDefaults
    let loadedCustomThemes = Self.loadCustomThemes()    // ← Loads from UserDefaults

    // Initialize with loaded values
    self.themeMode = loadedThemeMode
    self.selectedThemeID = loadedSelectedThemeID
    self.customThemes = loadedCustomThemes
    // ...
}
```

## Testing

Theme persistence is verified with tests:

```swift
@Test("Default theme mode is system")
func defaultThemeModeIsSystem() async throws {
    let manager = ThemeManager(userPreferences: mockPrefs)
    #expect(manager.themeMode == .system)
    #expect(manager.selectedThemeID == nil)
}

@Test("Custom theme selection persists across instances")
func customThemeSelectionPersists() async throws {
    let manager1 = ThemeManager(userPreferences: mockPrefs)
    manager1.setTheme(Theme.dark)

    // Create new instance - should load saved theme
    let manager2 = ThemeManager(userPreferences: mockPrefs)
    #expect(manager2.themeMode == .custom)
    #expect(manager2.selectedThemeID == "dark")
}
```

## User Experience

### Scenario 1: First-Time User

1. User launches app for first time
2. App follows system appearance (light/dark)
3. User switches macOS to dark mode → app updates automatically
4. ✅ No manual configuration needed

### Scenario 2: Theme Preference

1. User opens Settings → Appearance
2. Selects "Black (AMOLED)" theme
3. Theme changes immediately
4. ✅ Preference saved automatically
5. User quits and relaunches app
6. ✅ Black theme restored automatically

### Scenario 3: Reset

1. User has custom theme selected
2. User taps "Reset to Default"
3. App returns to system appearance mode
4. ✅ Preference saved automatically

## Migration from Legacy

Legacy LunaSea stored theme preferences in Hive database:

```dart
// Flutter/Hive (legacy)
thriftwoodDatabase.put(
  'THEME_AMOLED',
  value['THEME_AMOLED'] ?? false,
);
```

Thriftwood uses UserDefaults:

```swift
// Swift/UserDefaults (Thriftwood)
UserDefaults.standard.set(themeMode.rawValue, forKey: "thriftwood.themeMode")
```

**Migration Path**: Import preferences from legacy backup → map to new keys.

## Best Practices

### DO

✅ Let ThemeManager handle persistence automatically  
✅ Use `.system` mode as default (better UX)  
✅ Call `setTheme()` to change theme (handles persistence)  
✅ Call `resetToDefault()` to clear preferences

### DON'T

❌ Manually write to UserDefaults for theme preferences  
❌ Bypass ThemeManager for theme changes  
❌ Assume theme state is in-memory only  
❌ Force a specific theme on first launch

## Debugging

### View Current Preferences

```swift
print("Theme Mode:", UserDefaults.standard.string(forKey: "thriftwood.themeMode") ?? "nil")
print("Selected Theme:", UserDefaults.standard.string(forKey: "thriftwood.selectedThemeID") ?? "nil")
```

### Clear Preferences (Testing)

```swift
UserDefaults.standard.removeObject(forKey: "thriftwood.themeMode")
UserDefaults.standard.removeObject(forKey: "thriftwood.selectedThemeID")
UserDefaults.standard.removeObject(forKey: "thriftwood.customThemes")
```

### Force System Mode

```swift
themeManager.themeMode = .system
// Persisted automatically
```

## Summary

- ✅ **Automatic**: All theme changes saved immediately to UserDefaults
- ✅ **Default**: `.system` mode follows macOS appearance
- ✅ **Persistent**: Preferences restored on every app launch
- ✅ **Simple**: No manual save/load calls needed
- ✅ **Tested**: 19 tests verify persistence behavior
