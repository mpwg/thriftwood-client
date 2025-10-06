---
description: "Mandatory SwiftLint compliance for all Swift code"
applyTo: "**/*.swift"
---

# Mandatory SwiftLint Rule

## Overview

**All Swift code MUST pass SwiftLint checks with zero violations before being committed or merged.**

This is a non-negotiable requirement that ensures code quality, consistency, and maintainability across the Thriftwood codebase.

## The Rule

```bash
# This command MUST return 0 violations
swiftlint lint --strict

# Expected output:
# Done linting! Found 0 violations, 0 serious in X files.
```

## When to Check

SwiftLint must be checked and pass:

1. ✅ **Before every commit** - Run `swiftlint lint --strict`
2. ✅ **Before creating a Pull Request** - Verify compliance
3. ✅ **During CI/CD** - Automated checks in GitHub Actions
4. ✅ **After making any code changes** - Continuous validation

## How to Fix Violations

### Step 1: Run SwiftLint with Autocorrect

Many violations can be automatically fixed:

```bash
swiftlint --fix
```

This will automatically correct issues like:

- Trailing whitespace
- Redundant type annotations
- Boolean toggle patterns
- Unused optional bindings

### Step 2: Check Remaining Violations

```bash
swiftlint lint --strict
```

### Step 3: Fix Manual Violations

Common violations that require manual fixes:

#### 1. Multiple Closures with Trailing Closure

❌ **Incorrect:**

```swift
Button(action: {}) {
    Text("Click me")
}
```

✅ **Correct:**

```swift
Button(
    action: {},
    label: {
        Text("Click me")
    }
)
```

#### 2. Multiline Function Chains

❌ **Incorrect:**

```swift
container.register(Service.self) { _ in
    ServiceImpl()
}.inObjectScope(.container)
```

✅ **Correct:**

```swift
container.register(Service.self) { _ in
    ServiceImpl()
}
.inObjectScope(.container)
```

#### 3. Prefer For-Where

❌ **Incorrect:**

```swift
for item in items {
    if item.isValid {
        process(item)
    }
}
```

✅ **Correct:**

```swift
for item in items where item.isValid {
    process(item)
}
```

#### 4. Short Variable Names

❌ **Incorrect:**

```swift
for p in profiles {
    p.isEnabled = false
}
```

✅ **Correct:**

```swift
for profile in profiles {
    profile.isEnabled = false
}

// Exception: r, g, b, a are allowed for color components (configured in .swiftlint.yml)
```

#### 5. Unused Optional Binding

❌ **Incorrect:**

```swift
if let _ = optionalValue {
    // Do something
}
```

✅ **Correct:**

```swift
if optionalValue != nil {
    // Do something
}
```

#### 6. Non-optional String -> Data Conversion

❌ **Incorrect:**

```swift
let data = string.data(using: .utf8)!
```

✅ **Correct:**

```swift
let data = Data(string.utf8)
```

#### 7. Cyclomatic Complexity

If a function exceeds complexity limit (15):

❌ **Problem:**

```swift
func processRoute(route: Route) -> View {
    switch route {
        case .home: return HomeView()
        case .settings: return SettingsView()
        case .profile: return ProfileView()
        // ... 15 more cases
    }
}
```

✅ **Solutions:**

1. Break into smaller functions
2. Use lookup tables/dictionaries
3. Add `// swiftlint:disable:next cyclomatic_complexity` if legitimately necessary

## Configuration Highlights

### Pragmatic Rules (from `.swiftlint.yml`)

Our SwiftLint configuration balances quality with productivity:

- **Cyclomatic Complexity**: Warning at 15 (accommodates switch statements)
- **Type Body Length**: Warning at 300 lines (maintainable types)
- **Identifier Names**: Allows common abbreviations (r, g, b, a, i, j, k)
- **Force Unwrapping**: Warning only (test code needs this)
- **Print Statements**: Custom rule disabled (SwiftUI previews use print)

### Disabled Rules

Some rules are intentionally disabled:

- `todo` - TODOs allowed during development
- `line_length` - Modern displays handle longer lines
- `trailing_whitespace` - Auto-formatting handles this

### Opt-In Rules

We enable additional quality rules:

- `multiline_function_chains` - Better readability
- `unused_optional_binding` - Cleaner code
- `first_where` / `last_where` - Performance and clarity
- `empty_count` / `empty_string` - Idiomatic Swift

## CI/CD Integration

### GitHub Actions

SwiftLint is enforced in CI (`.github/workflows/ci.yml`):

```yaml
- name: Run SwiftLint
  run: swiftlint lint --strict
```

**CI will FAIL the build if SwiftLint violations exist.**

### Pre-commit Hook (Optional)

Add to `.git/hooks/pre-commit`:

```bash
#!/bin/sh
echo "Running SwiftLint..."
swiftlint lint --strict

if [ $? -ne 0 ]; then
    echo "❌ SwiftLint violations found. Please fix before committing."
    exit 1
fi

echo "✅ SwiftLint passed"
```

## Troubleshooting

### SwiftLint Not Installed

```bash
# Install via Homebrew
brew install swiftlint

# Verify installation
swiftlint version
```

### Configuration Warnings

If you see warnings like:

```
warning: Found a configuration for 'X' rule, but it is not enabled
```

This means the `.swiftlint.yml` file has configuration for a rule that's not in `opt_in_rules`. Update the configuration file.

### False Positives

If SwiftLint flags something incorrectly:

1. **First**: Verify it's actually a false positive (not a real issue)
2. **Then**: Add targeted suppression:

```swift
// swiftlint:disable:next rule_name
let problematicLine = "code"
```

3. **Document WHY** in a comment:

```swift
// SwiftLint disabled: Legacy API requires force unwrap
// swiftlint:disable:next force_unwrapping
let value = legacyAPI.getValue()!
```

## Quick Reference

### Common Commands

```bash
# Check all violations
swiftlint lint --strict

# Auto-fix what can be fixed
swiftlint --fix

# Lint specific file
swiftlint lint --path path/to/File.swift

# Show all enabled rules
swiftlint rules

# Generate HTML report
swiftlint lint --reporter html > swiftlint.html
```

### Exit Codes

- `0` - No violations ✅
- `1` - Configuration error ⚠️
- `2` - Violations found ❌

## Philosophy

SwiftLint is not about being pedantic—it's about:

1. **Consistency** - Code looks the same across the project
2. **Safety** - Catch common mistakes early
3. **Maintainability** - Easier to understand and modify
4. **Team Alignment** - Reduces bikeshedding in reviews

Our configuration is tuned for **solo indie development** while maintaining professional standards.

## References

- [SwiftLint GitHub](https://github.com/realm/SwiftLint)
- [SwiftLint Rules](https://realm.github.io/SwiftLint/rule-directory.html)
- Project Configuration: `.swiftlint.yml`
- CI Configuration: `.github/workflows/ci.yml`

---

**Remember**: Clean code is not just about passing a linter—it's about writing maintainable software. SwiftLint helps us get there systematically.
