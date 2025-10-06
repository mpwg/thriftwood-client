# Localization Patterns for Thriftwood

## Overview

This document establishes standardized patterns for localization throughout the Thriftwood codebase. All user-facing strings must be localized to support multiple languages.

## Core Principles

1. **All user-facing text must be localized** - No hardcoded English strings
2. **Use String Catalogs** - Xcode's `Localizable.xcstrings` for centralized management
3. **Provide context comments** - Every localized string must have a descriptive comment
4. **Use system formatters** - Leverage `NumberFormatter`, `DateFormatter`, `ListFormatter` for locale-aware formatting
5. **Test with pseudo-localization** - Verify layouts work with longer translations

## String Localization Patterns

### Basic Localization

Use `String(localized:comment:)` for all user-facing strings:

```swift
// ❌ INCORRECT - Hardcoded English
let title = "Movies"
let message = "Download complete"

// ✅ CORRECT - Localized with context
let title = String(localized: "Movies", comment: "Navigation title for movies list")
let message = String(localized: "Download complete", comment: "Success message when movie download finishes")
```

### String Interpolation

For strings with dynamic values, use string interpolation within localized strings:

```swift
// ❌ INCORRECT - Not localized
let message = "Found \(count) movies"

// ✅ CORRECT - Localized with interpolation
let message = String(localized: "Found \(count) movies", comment: "Search results count (e.g., 'Found 42 movies')")
```

### Pluralization

Use `String(localized:defaultValue:table:bundle:locale:comment:)` with plural rules:

```swift
// Define in Localizable.xcstrings with plural variations
let moviesCount = String(
    localized: "^[\(count) movie](inflect: true)",
    comment: "Number of movies with proper pluralization"
)
// Results in: "1 movie", "2 movies", "42 movies"
```

### Context-Specific Strings

Provide context to help translators understand usage:

```swift
// Generic button - could be confusing
String(localized: "Add", comment: "Button to add an item")

// Specific button - clear context
String(localized: "Add Movie", comment: "Button to add a new movie to the library")

// Status indicator - context matters
String(localized: "Downloaded", comment: "Movie status: file has been downloaded")
String(localized: "Downloaded", comment: "Statistics label: total downloaded count")
```

## Number Formatting

### Decimal Numbers

Use `NumberFormatter` for locale-appropriate decimal formatting:

```swift
// ❌ INCORRECT - Hardcoded decimal format
let ratingText = String(format: "%.1f", rating)  // Always uses "." as separator

// ✅ CORRECT - Locale-aware formatting
func formatRating(_ rating: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    formatter.locale = Locale.current
    return formatter.string(from: NSNumber(value: rating))
}
// Results in: "8.7" (en_US), "8,7" (de_DE), "8.7" (fr_FR)
```

### Integers

Use `NumberFormatter` for large numbers with grouping:

```swift
// ❌ INCORRECT - No thousand separators
let sizeText = "\(fileSize) bytes"

// ✅ CORRECT - Locale-aware grouping
func formatFileSize(_ bytes: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = true
    formatter.locale = Locale.current
    return formatter.string(from: NSNumber(value: bytes)) ?? "0"
}
// Results in: "1,234,567" (en_US), "1.234.567" (de_DE), "1 234 567" (fr_FR)
```

### Percentages

```swift
func formatPercentage(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1
    formatter.locale = Locale.current
    return formatter.string(from: NSNumber(value: value)) ?? "0%"
}
// Results in: "87.5%" (en_US), "87,5 %" (fr_FR)
```

## Date and Time Formatting

### Relative Dates

Use `RelativeDateTimeFormatter` for human-readable date differences:

```swift
// ❌ INCORRECT - Manual date calculation
let daysAgo = "\(days) days ago"

// ✅ CORRECT - Locale-aware relative formatting
func formatRelativeDate(_ date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    formatter.locale = Locale.current
    return formatter.localizedString(for: date, relativeTo: Date.now)
}
// Results in: "2 days ago" (en_US), "vor 2 Tagen" (de_DE), "il y a 2 jours" (fr_FR)
```

### Duration Formatting

Use `DateComponentsFormatter` for time durations:

```swift
// ❌ INCORRECT - Manual duration formatting
let runtime = "\(hours)h \(minutes)m"

// ✅ CORRECT - Locale-aware duration
func formatDuration(minutes: Int) -> String? {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.unitsStyle = .abbreviated
    formatter.zeroFormattingBehavior = .dropLeading
    formatter.locale = Locale.current
    return formatter.string(from: TimeInterval(minutes * 60))
}
// Results in: "2h 16m" (en_US), "2 Std. 16 Min." (de_DE), "2 h 16 min" (fr_FR)
```

### Absolute Dates

Use `Date.FormatStyle` (iOS 15+) for flexible date formatting:

```swift
// ❌ INCORRECT - Hardcoded date format
let dateString = "\(month)/\(day)/\(year)"

// ✅ CORRECT - Locale-aware date format
func formatReleaseDate(_ date: Date) -> String {
    return date.formatted(.dateTime.year().month().day())
}
// Results in: "Jan 15, 2025" (en_US), "15. Jan. 2025" (de_DE), "15 janv. 2025" (fr_FR)
```

## List Formatting

Use `ListFormatter` for locale-appropriate list separators:

```swift
// ❌ INCORRECT - Hardcoded comma separator
let genresText = genres.joined(separator: ", ")

// ✅ CORRECT - Locale-aware list formatting
func formatList(_ items: [String]) -> String? {
    guard !items.isEmpty else { return nil }
    let formatter = ListFormatter()
    formatter.locale = Locale.current
    return formatter.string(from: items)
}
// Results in: "Action, Drama, Thriller" (en_US)
//            "Action, Drama und Thriller" (de_DE)
//            "Action, Drame et Thriller" (fr_FR)
```

## File Size Formatting

Use `ByteCountFormatter` for human-readable file sizes:

```swift
// ❌ INCORRECT - Manual byte conversion
let sizeText = "\(bytes / 1024 / 1024) MB"

// ✅ CORRECT - Locale-aware byte formatting
func formatFileSize(_ bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useAll]
    formatter.countStyle = .file
    formatter.includesUnit = true
    return formatter.string(fromByteCount: bytes)
}
// Results in: "1.5 GB" (en_US), "1,5 GB" (de_DE), "1,5 Go" (fr_FR)
```

## Accessibility and Localization

Accessibility labels must also be localized:

```swift
// ❌ INCORRECT - Hardcoded accessibility label
Button("Add") { }
    .accessibilityLabel("Add movie button")

// ✅ CORRECT - Localized accessibility label
Button(String(localized: "Add", comment: "Button to add movie")) { }
    .accessibilityLabel(String(localized: "Add movie button", comment: "Accessibility label for add movie button"))
```

## SwiftUI-Specific Patterns

### Text Views

SwiftUI's `Text` automatically localizes `String(localized:)`:

```swift
// ✅ Automatically localized
Text(String(localized: "Movies", comment: "Navigation title"))

// ✅ Also works with LocalizedStringKey
Text("Movies")  // Only use if string is defined in Localizable.xcstrings
```

### Labels and Hints

```swift
TextField(
    String(localized: "Movie Title", comment: "Placeholder for movie title input"),
    text: $title
)
.accessibilityLabel(String(localized: "Movie title", comment: "Accessibility label for title field"))
.accessibilityHint(String(localized: "Enter the name of the movie", comment: "Accessibility hint for title field"))
```

## Testing Localization

### Preview Different Locales

```swift
#Preview("English") {
    MovieCardView(movie: .preview)
        .environment(\.locale, Locale(identifier: "en_US"))
}

#Preview("German") {
    MovieCardView(movie: .preview)
        .environment(\.locale, Locale(identifier: "de_DE"))
}

#Preview("French") {
    MovieCardView(movie: .preview)
        .environment(\.locale, Locale(identifier: "fr_FR"))
}
```

### Pseudo-Localization

Test with pseudo-locale to verify:
- Layout handles longer strings
- No truncation occurs
- UI adapts to text expansion

```swift
#Preview("Pseudo-Localization") {
    MovieCardView(movie: .preview)
        .environment(\.locale, Locale(identifier: "en-US-POSIX"))
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}
```

## String Catalog Management

### Adding New Strings

1. Use `String(localized:comment:)` in code
2. Build the project (Cmd+B)
3. Xcode automatically extracts strings to `Localizable.xcstrings`
4. Add translations in String Catalog editor

### String Keys

Use descriptive keys that convey meaning:

```swift
// ❌ INCORRECT - Generic keys
String(localized: "button_1", comment: "")
String(localized: "label_2", comment: "")

// ✅ CORRECT - Descriptive keys
String(localized: "Add Movie", comment: "Button to add a new movie to the library")
String(localized: "Downloaded", comment: "Movie status: file has been downloaded")
```

### Organizing Strings

Group related strings in the String Catalog:
- Use comments to provide context
- Create translation notes for ambiguous terms
- Mark strings that should never be translated (e.g., brand names)

## Migration from Legacy Flutter

When migrating from the Flutter codebase (`/legacy/localization/`):

1. **Locate original string**: Find in Flutter's JSON files (e.g., `en.json`)
2. **Extract key and value**: Note the key path (e.g., `radarr.AddMovie`)
3. **Add to Swift**: Use `String(localized:)` with descriptive comment
4. **Verify context**: Ensure translation makes sense in SwiftUI context

Example:

```json
// legacy/localization/radarr/en.json
{
  "radarr.AddMovie": "Add Movie"
}
```

Becomes:

```swift
// Swift
String(localized: "Add Movie", comment: "Button to add a new movie to Radarr library")
```

## Common Patterns Reference

### Display Models

All computed properties that return user-facing strings should use localization:

```swift
struct MovieDisplayModel {
    var statusText: String {
        hasFile 
            ? String(localized: "Downloaded", comment: "Movie status: file downloaded")
            : String(localized: "Missing", comment: "Movie status: file missing")
    }
    
    var ratingText: String? {
        guard let rating = rating else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: rating))
    }
    
    var genresText: String? {
        guard !genres.isEmpty else { return nil }
        let formatter = ListFormatter()
        return formatter.string(from: genres)
    }
}
```

### Error Messages

```swift
enum ThriftwoodError: LocalizedError {
    case networkError(message: String)
    case authenticationFailed
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return String(localized: "Network Error: \(message)", comment: "Network error with detailed message")
        case .authenticationFailed:
            return String(localized: "Authentication failed. Please check your API key.", comment: "Error message when API authentication fails")
        }
    }
}
```

### Empty States

```swift
EmptyStateView(
    icon: "film",
    title: String(localized: "No Movies", comment: "Empty state title when no movies in library"),
    subtitle: String(localized: "Add movies to your library to see them here", comment: "Empty state subtitle explaining how to add movies"),
    actionTitle: String(localized: "Add Movie", comment: "Button to add first movie")
)
```

## Resources

- [Apple's Localization Documentation](https://developer.apple.com/documentation/xcode/localization)
- [String Catalogs Guide](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)
- [Foundation Formatters](https://developer.apple.com/documentation/foundation/formatter)
- [SwiftUI Localization](https://developer.apple.com/documentation/swiftui/localization)

## Legacy Reference

The Flutter app's localization structure (`/legacy/localization/`) contains translations for:
- 20+ languages
- Service-specific strings (Radarr, Sonarr, etc.)
- Common UI elements

Use these as reference for:
- Translation accuracy
- Context understanding
- Feature parity verification
