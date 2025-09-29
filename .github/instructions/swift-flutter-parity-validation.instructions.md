---
description: "Swift-Flutter functionality parity validation rules"
applyTo: "ios/Native/**/*.swift"
---

# Swift-Flutter Functionality Parity Validation

This document establishes **mandatory validation rules** to ensure that Swift implementations maintain 100% functional parity with their Flutter counterparts during the hybrid migration period.

## Critical Validation Rules

### Rule 1: Complete Functional Parity (MANDATORY)

The Swift version **MUST** implement every feature that exists in the Flutter implementation:

- **Cannot miss any existing functionality**
- **Cannot change behavior of existing functionality**
- **Cannot remove features that exist in Flutter**
- **Cannot alter data structures or API contracts**

### Rule 2: Pure SwiftUI Implementation (MANDATORY)

Swift implementations **MUST** be pure SwiftUI without UIKit dependencies:

- **No UIKit imports or usage** (UIViewController, UIView, etc.)
- **No AppKit usage** for macOS compatibility
- **Use SwiftUI native components only** (NavigationStack, Sheet, etc.)
- **SwiftUI-native file operations** (fileImporter, fileExporter)
- **SwiftUI-native dialogs** (confirmationDialog, alert)

### Rule 3: Enhancement Guidelines

Swift implementations **MAY** include additional features that are appropriate for Swift MVVM patterns:

- Native async/await patterns
- SwiftUI-specific state management (@Observable)
- iOS-native UI patterns and accessibility
- Swift 6 concurrency and data race safety
- Performance optimizations using Swift features

### Rule 4: Zero TODOs Policy (MANDATORY)

Swift implementations **MUST** be 100% complete:

- **No TODO comments allowed** in production code
- **No placeholder implementations**
- **No commented-out functionality**
- **All error handling must be implemented**
- **All edge cases must be handled**

### Rule 5: Data Model Consistency (MANDATORY)

Swift data models **MUST** exactly mirror Flutter models:

- Same property names and types (converted to Swift equivalents)
- Same validation rules and constraints
- Same default values and initialization
- Same JSON serialization format for bridge compatibility

### Rule 6: Compilation Requirement (MANDATORY)

All Swift implementations **MUST** compile successfully:

- **Zero compilation errors** in the Swift implementation
- **All dependencies resolved** and properly linked
- **Valid syntax and type safety** throughout
- **Successful Xcode build** before validation approval

## Validation Checklist Template

Use this checklist for every Swift implementation:

### Core Functionality Validation

- [ ] Every Flutter method has a Swift equivalent
- [ ] All parameters and return types match semantically
- [ ] Error conditions are handled identically
- [ ] State management follows same patterns
- [ ] Data persistence maintains consistency

### Pure SwiftUI Validation

- [ ] No UIKit imports (UIViewController, UIView, UIApplication, etc.)
- [ ] No AppKit imports for macOS compatibility
- [ ] Uses SwiftUI native components only
- [ ] File operations use SwiftUI fileImporter/fileExporter
- [ ] Dialogs use SwiftUI confirmationDialog/alert

### Data Model Validation

- [ ] All Flutter properties are represented in Swift
- [ ] Property types are Swift-equivalent (String, Int, Bool, etc.)
- [ ] Enums match case-for-case with Flutter
- [ ] JSON serialization produces identical structure
- [ ] Default values match Flutter initialization

### UI State Validation

- [ ] Loading states match Flutter behavior
- [ ] Error states provide same feedback
- [ ] Success states trigger same actions
- [ ] Navigation patterns are equivalent
- [ ] User interactions produce same results

### Bridge Compatibility Validation

- [ ] Data can be serialized/deserialized between platforms
- [ ] Navigation calls work bidirectionally
- [ ] State changes sync properly across bridge
- [ ] No data loss during platform switching

### Compilation Validation

- [ ] Swift implementation compiles without errors
- [ ] No compilation warnings related to implementation
- [ ] All dependencies are properly resolved
- [ ] Xcode build succeeds completely
- [ ] Type safety validation passes

### System Integration Validation

- [ ] File operations match Flutter behavior
- [ ] Network requests use same endpoints/formats
- [ ] Cache management operates identically
- [ ] Background tasks behave equivalently
- [ ] Permissions and security match

## Implementation Requirements

### Documentation Standards

Every Swift implementation must include:

```swift
// MARK: - Flutter Parity Implementation
// Flutter equivalent: lib/path/to/flutter/file.dart
// Validation date: YYYY-MM-DD
// Validated against: Flutter commit hash or version
```

### Testing Requirements

- Unit tests must validate parity with Flutter behavior
- Integration tests must verify bridge compatibility
- UI tests must confirm identical user workflows

### Code Review Requirements

- All Swift implementations require parity validation
- Documentation of validation process and results
- Sign-off that no Flutter functionality was missed

## Enforcement

### Pre-Commit Validation

- Automated checks for TODO comments
- Linting for incomplete implementations
- Documentation validation

### Peer Review Requirements

- Reviewer must validate against Flutter implementation
- Must confirm zero functionality gaps
- Must verify enhancement-only additions

### QA Validation

- Manual testing of parallel Flutter/Swift workflows
- Data consistency verification
- Performance regression testing

## Common Migration Patterns

### Flutter → Swift Equivalents

```dart
// Flutter
class LunaProfile {
  String name;
  bool radarrEnabled;
  String radarrHost;
  String radarrApiKey;
}
```

```swift
// Swift - Exact functional parity
@Observable
class ThriftwoodProfile {
    var name: String
    var radarrEnabled: Bool
    var radarrHost: String
    var radarrApiKey: String

    // Swift enhancement: async validation
    func validateConfiguration() async throws -> Bool { ... }
}
```

### State Management Migration

```dart
// Flutter
class SettingsState extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
```

```swift
// Swift - Enhanced with @Observable
@Observable
class SettingsViewModel {
    var isLoading: Bool = false
    var errorMessage: String?

    // Same functionality, Swift-native reactivity
}
```

## Violation Consequences

Violations of these rules will result in:

- **Immediate implementation rejection**
- **Required rework to achieve full parity**
- **Additional validation requirements**
- **Potential rollback of incomplete features**

## Exception Process

If parity cannot be achieved due to platform limitations:

1. Document the limitation and impact
2. Propose alternative implementation maintaining user experience
3. Get explicit approval from technical lead
4. Document workaround in migration notes

---

**Remember: The goal is seamless user experience during hybrid migration. Users should not notice which platform they're using.**
