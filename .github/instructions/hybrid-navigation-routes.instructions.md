# Hybrid Navigation Architecture: Route Naming Convention

## **CRITICAL RULE: Unified Route Format**

**ALL navigation routes MUST use the Flutter format: `/path/subpath`**

This is a **MANDATORY** architectural constraint that prevents navigation system failures.

## The Problem This Solves

The hybrid Flutter-SwiftUI architecture requires seamless navigation between both systems. Route naming inconsistencies break this fundamental requirement:

❌ **WRONG** - Different formats between systems:

- Flutter: `/settings/general`
- SwiftUI: `settings_general`
- Result: Navigation fails, user clicks do nothing

✅ **CORRECT** - Unified format across systems:

- Flutter: `/settings/general`
- SwiftUI: `/settings/general`
- Result: Navigation works seamlessly

## Mandatory Format Rules

### 1. Route Structure

```
Format: /module/submodule/action
Examples:
- /settings
- /settings/general
- /settings/system/logs
- /dashboard
- /radarr/movies
- /sonarr/series
```

### 2. Character Rules

- **MUST** start with forward slash `/`
- **MUST** use forward slashes `/` as separators (NOT underscores `_`)
- **MUST** use lowercase letters
- **MUST** use underscores `_` only within words (`wake_on_lan`)
- **NO** spaces, special characters, or mixed case

### 3. Consistency Requirements

- **Every route registered in Flutter MUST have identical format in SwiftUI**
- **Every SwiftUI view case MUST match Flutter route exactly**
- **NO dual format support** (no "fallback" underscore variants)

## Implementation Enforcement

### FlutterSwiftUIBridge.swift

```swift
func createSwiftUIView(for route: String, data: [String: Any]) -> AnyView {
    // STANDARD RULE: All routes MUST use Flutter format: "/path/subpath"
    // NO underscore variants allowed (settings_general -> /settings/general)

    switch route {
    case "/settings":           // ✅ CORRECT
        return AnyView(SwiftUISettingsView())
    case "/settings/general":   // ✅ CORRECT
        return AnyView(SwiftUIGeneralSettingsView())
    // case "settings_general": // ❌ FORBIDDEN - Causes navigation failures
    }
}
```

### Flutter Route Registration

```dart
// router/router.dart
GoRoute(
  path: '/settings',        // ✅ MUST match SwiftUI exactly
  builder: (context, state) => SettingsView(),
),
GoRoute(
  path: '/settings/general', // ✅ MUST match SwiftUI exactly
  builder: (context, state) => GeneralSettingsView(),
),
```

### Native View Registration

```swift
// Bridge initialization MUST use identical routes
registerNativeView("/settings")        // ✅ Matches Flutter
registerNativeView("/settings/general") // ✅ Matches Flutter
```

## Validation Checklist

Before adding any new routes, verify:

- [ ] Route starts with `/`
- [ ] Route uses `/` separators (not `_` except within words)
- [ ] Route is lowercase
- [ ] Flutter router defines exact same path
- [ ] SwiftUI bridge handles exact same case
- [ ] Native view registration uses exact same string
- [ ] No "fallback" underscore variants exist

## Migration Guide

When updating existing routes:

1. **Identify inconsistencies** - Find underscore variants
2. **Update SwiftUI first** - Change switch cases to slash format
3. **Update Flutter** - Ensure router matches exactly
4. **Remove fallbacks** - Delete underscore case variants
5. **Test navigation** - Verify clicks work in both directions

## Architecture Benefits

This unified approach ensures:

- **Predictable Navigation** - Users can navigate reliably between systems
- **Maintainable Code** - Single source of truth for route definitions
- **Future-Proof** - New routes automatically work in hybrid system
- **Debug-Friendly** - Route mismatches are immediately obvious
- **Migration-Safe** - Gradual Flutter→SwiftUI migration without breaks

## Enforcement Tools

### Build-Time Checks

```swift
#if DEBUG
// Add build-time validation that all registered routes use correct format
static func validateRouteFormat(_ route: String) {
    assert(route.hasPrefix("/"), "Route must start with /: \(route)")
    assert(!route.contains("_") || route.range(of: "_", options: .backwards)?.lowerBound != route.startIndex,
           "Route must not use _ as path separator: \(route)")
}
#endif
```

### Code Review Requirements

- **Every PR** adding routes must include both Flutter and SwiftUI changes
- **Every route change** must be validated against this documentation
- **No exceptions** - architectural consistency over convenience

---

## Quick Reference

| Component           | Format          | Example                                   |
| ------------------- | --------------- | ----------------------------------------- |
| Flutter Router      | `/path/subpath` | `/settings/general`                       |
| SwiftUI Bridge      | `/path/subpath` | `case "/settings/general":`               |
| Native Registration | `/path/subpath` | `registerNativeView("/settings/general")` |
| Navigation Calls    | `/path/subpath` | `navigateTo("/settings/general")`         |

**Remember: One format, everywhere. No exceptions.**
