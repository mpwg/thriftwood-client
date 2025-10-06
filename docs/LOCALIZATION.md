# Localization Guide for Thriftwood

This guide explains how to properly implement localization in Thriftwood using the String Catalog (`.xcstrings`) format introduced in Xcode 15+.

## Overview

Thriftwood uses **String Catalog** (`Localizable.xcstrings`) for all user-facing strings. This is Apple's modern localization system that provides:

- Automatic string extraction during build
- Type-safe string keys
- Support for pluralization and string variables
- Visual editor in Xcode
- Better compiler integration

## File Location

- **String Catalog**: `/Thriftwood/Localizable.xcstrings`
- **Supported Languages**: English (source), German (de), and others can be added

## Basic Usage

### Simple Strings (No Variables)

For static strings without variables, use `String(localized:)` with a **key-based approach**:

```swift
// ✅ CORRECT - Key-based localization
let title = String(localized: "movie.status.downloaded",
                   defaultValue: "Downloaded",
                   comment: "Movie status: file has been downloaded")

// ❌ WRONG - Direct string without key
let title = String(localized: "Downloaded", 
                   comment: "Movie status")
```

**Why?** Using a key (e.g., `movie.status.downloaded`) allows you to:

- Change the English text without breaking translations
- Organize strings hierarchically
- Avoid conflicts between identical strings in different contexts

### Strings with Variables

For strings containing variables, you **must** provide a `defaultValue` with interpolation:

```swift
// ✅ CORRECT - Variables with defaultValue
let hours = 2
let minutes = 16
let runtime = String(localized: "runtime.hours_minutes",
                    defaultValue: "\(hours)h \(minutes)m",
                    comment: "Runtime format with hours and minutes (e.g., '2h 16m')")

// ❌ WRONG - Interpolation directly in localized key
let runtime = String(localized: "\(hours)h \(minutes)m",
                    comment: "Runtime format")
```

**Why?** String Catalog requires a static key for string extraction. The `defaultValue` parameter allows you to provide the interpolated fallback.

## Naming Conventions

Use **hierarchical keys** with dot notation to organize strings:

```text
feature.component.purpose.variant
```

### Examples

```swift
// Movie-related strings
"movie.status.downloaded"        // Movie download status
"movie.status.missing"           // Movie missing status
"movie.monitoring.monitored"     // Monitoring enabled
"movie.monitoring.unmonitored"   // Monitoring disabled

// Runtime formatting
"runtime.hours_minutes"          // "2h 16m"
"runtime.hours_only"             // "2h"
"runtime.minutes_only"           // "45m"
"runtime.short_format"           // "136min"

// UI elements
"button.add_movie"               // Add movie button
"button.refresh"                 // Refresh button
"toolbar.filter"                 // Filter toolbar item
```

### Hierarchy Guidelines

1. **Feature**: Top-level feature (e.g., `movie`, `show`, `settings`)
2. **Component**: UI component or data type (e.g., `status`, `button`, `toolbar`)
3. **Purpose**: What the string represents (e.g., `downloaded`, `missing`, `title`)
4. **Variant** (optional): Specific variant (e.g., `hours_minutes`, `short_format`)

## Advanced Patterns

### Pluralization

For strings that need plural forms, use `String(localized:count:)`:

```swift
let count = 5
let text = String(localized: "movie.count",
                 defaultValue: "\(count) movies",
                 comment: "Number of movies")
```

In the String Catalog, Xcode will automatically generate plural forms:

```json
"movie.count" : {
  "localizations" : {
    "en" : {
      "variations" : {
        "plural" : {
          "one" : { "stringUnit" : { "value" : "%lld movie" } },
          "other" : { "stringUnit" : { "value" : "%lld movies" } }
        }
      }
    }
  }
}
```

### String Formatting with Multiple Variables

For complex formatting, use `String(localized:defaultValue:)` with multiple variables:

```swift
let title = "The Matrix"
let year = 1999
let text = String(localized: "movie.title_with_year",
                 defaultValue: "\(title) (\(year))",
                 comment: "Movie title with release year (e.g., 'The Matrix (1999)')")
```

### Using LocalizedStringKey in SwiftUI

For SwiftUI views, you can use `LocalizedStringKey` directly:

```swift
// ✅ In SwiftUI Text views
Text("movie.status.downloaded")  // Automatic localization

// ✅ With interpolation (SwiftUI handles it)
Text("Welcome, \(userName)")
```

**Note**: SwiftUI's `Text` automatically treats string literals as `LocalizedStringKey`, but this only works for **compile-time constants**. For runtime strings or computed properties, use `String(localized:)`.

## Comments Best Practices

Always provide **descriptive comments** explaining:

1. **Context**: Where the string appears in the UI
2. **Variables**: What each variable represents
3. **Example**: A concrete example of the formatted output

```swift
// ✅ GOOD - Clear context and example
String(localized: "runtime.hours_minutes",
      defaultValue: "\(hours)h \(minutes)m",
      comment: "Runtime format with hours and minutes (e.g., '2h 16m')")

// ❌ BAD - No context or example
String(localized: "runtime.hours_minutes",
      defaultValue: "\(hours)h \(minutes)m",
      comment: "Runtime")
```

## Extracting Strings for Translation

### Automatic Extraction

Xcode automatically extracts strings from:

- `String(localized:)` calls
- SwiftUI `Text` with string literals
- `LocalizedStringKey` usage

### Manual Export/Import

To export for translation:

1. **Xcode 15+**:
   - Select project → Editor → Export for Localization
   - Generates `.xcloc` bundles for translators

2. **Import translations**:
   - Editor → Import Localizations
   - Select `.xcloc` file from translator

## Testing Localization

### In Xcode

1. **Scheme Editor**: Edit Scheme → Run → App Language → Select language
2. **SwiftUI Previews**: Use `.environment(\.locale, Locale(identifier: "de"))`

```swift
#Preview("German") {
    MovieCardView(movie: .preview, layout: .grid)
        .environment(\.locale, Locale(identifier: "de"))
}
```

### Pseudolocalization

Enable in Xcode scheme to test for:

- Hard-coded strings (appear in English)
- Layout issues with longer text
- Encoding issues

**Scheme Editor** → Options → App Language → "Double-Length Pseudolanguage"

## Common Patterns in Thriftwood

### Display Model Computed Properties

```swift
struct MovieDisplayModel {
    var statusText: String {
        if hasFile {
            return String(localized: "movie.status.downloaded",
                         defaultValue: "Downloaded",
                         comment: "Movie status: file has been downloaded")
        } else {
            return String(localized: "movie.status.missing",
                         defaultValue: "Missing",
                         comment: "Movie status: file is missing")
        }
    }
}
```

### SwiftUI Views

```swift
struct MovieCardView: View {
    var body: some View {
        Text("movie.status.downloaded")  // Automatic localization
            .accessibilityLabel(movie.statusText)  // Use computed property
    }
}
```

### Buttons and Labels

```swift
Button(action: addMovie) {
    Label("button.add_movie", systemImage: "plus")
}
.accessibilityLabel(String(localized: "accessibility.add_movie",
                           defaultValue: "Add new movie",
                           comment: "Accessibility label for add movie button"))
```

## Migration Checklist

When adding new user-facing strings:

- [ ] Use key-based localization (e.g., `movie.status.downloaded`)
- [ ] Provide `defaultValue` for strings with variables
- [ ] Add descriptive `comment` with context and example
- [ ] Follow hierarchical naming convention
- [ ] Test with at least one non-English language
- [ ] Verify accessibility labels are localized
- [ ] Check that Xcode extracts the string (build the project)

## Troubleshooting

### String Not Appearing in String Catalog

**Cause**: Xcode hasn't extracted the string yet.

**Solution**:

1. Build the project (⌘B)
2. Check that you're using `String(localized:)` correctly
3. Verify the string isn't dynamic (must be compile-time evaluable)

### Variables Not Working in Localization

**Cause**: Using interpolation directly in the `localized` parameter.

**Solution**: Move interpolation to `defaultValue`:

```swift
// ❌ WRONG
String(localized: "\(hours)h", comment: "Hours")

// ✅ CORRECT
String(localized: "runtime.hours_only",
      defaultValue: "\(hours)h",
      comment: "Runtime format: hours only (e.g., '2h')")
```

### Translations Not Showing in App

**Cause**: Language not added to Localizable.xcstrings.

**Solution**:

1. Open Localizable.xcstrings in Xcode
2. Click + button to add language
3. Build and run with new language

## Resources

- [Apple Human Interface Guidelines - Localization](https://developer.apple.com/design/human-interface-guidelines/localization)
- [String Catalog Documentation](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)
- [WWDC23 - Discover String Catalogs](https://developer.apple.com/videos/play/wwdc2023/10155/)

## Legacy Flutter Reference

The legacy Flutter app used JSON-based localization files in `/legacy/localization/` and `/legacy/assets/localization/`. These can be used as reference for string keys and translations, but the format is different:

**Flutter** (JSON):

```json
{
  "sonarr.AddSeries": "Add Series",
  "radarr.AddMovie": "Add Movie"
}
```

**Swift** (String Catalog):

```swift
String(localized: "button.add_series",
      defaultValue: "Add Series",
      comment: "Button to add new series")
```

---

**Last Updated**: October 6, 2025  
**Version**: 1.0  
**Author**: Thriftwood Development Team
