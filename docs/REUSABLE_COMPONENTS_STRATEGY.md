# Reusable Components Strategy

**Date**: 2025-10-05
**Status**: Planning Phase
**Decision**: Prefix all custom theme types with "MPWG" to avoid naming conflicts

## Naming Convention Change

### Problem

SwiftUI defines a `Theme` protocol, causing ambiguity with our custom `Theme` struct. This creates compilation issues and developer confusion.

### Solution

Prefix all theme-related types with "MPWG" (project prefix):

| Old Name               | New Name                   | Purpose                       |
| ---------------------- | -------------------------- | ----------------------------- |
| `Theme`                | `MPWGTheme`                | Theme definition struct       |
| `ThemeMode`            | `MPWGThemeMode`            | Theme selection enum          |
| `ThemeManager`         | `MPWGThemeManager`         | Theme management service      |
| `ThemeManagerProtocol` | `MPWGThemeManagerProtocol` | Protocol for theme management |

### Environment Keys

- `\.theme` → `\.mpwgTheme`
- `\.themeManager` → `\.mpwgThemeManager`

## Package Extraction Candidates

### Phase 1: MPWGTheme Package (Future)

**Purpose**: Reusable theme system for SwiftUI apps

**Components**:

- `MPWGTheme` struct (color definitions)
- `MPWGThemeMode` enum (system/custom modes)
- `MPWGThemeManager` service (theme state management)
- `Color` extensions (theme-aware colors, not service-specific)
- `Font` extensions (typography scales)
- `Spacing`, `Sizing`, `CornerRadius`, `Shadow`, `Opacity` constants
- `Animation` constants and extensions

**Benefits**:

- Use across multiple MPWG projects
- Semantic versioning for stable API
- Isolated testing
- Community sharing potential

**Exclusions** (Keep in Thriftwood):

- Service-specific colors (radarr, sonarr, etc.)
- App-specific theme configurations

### Phase 2: MPWGUIKit Package (Future)

**Purpose**: Reusable SwiftUI components

**Components**:

- `LoadingView` - generic loading indicator
- `ErrorView` - error display with retry
- `EmptyStateView` - empty state templates
- `CardView` - card wrapper and modifier
- `RefreshableModifier` - pull-to-refresh
- `MPWGButtonStyle` - button styles (primary, secondary, destructive, compact)
- Form components:
  - `TextFieldRow` - labeled text input
  - `SecureFieldRow` - password input
  - `ToggleRow` - labeled toggle
  - `PickerRow` - labeled picker
  - Form validation helpers

**Benefits**:

- Consistent UI across projects
- Reduced boilerplate
- Well-tested components
- Accessibility built-in

**Exclusions** (Keep in Thriftwood):

- Service-specific UI components
- Navigation coordinators
- App-specific views

### Phase 3: MPWGFoundation Package (Future)

**Purpose**: Core utilities and protocols

**Components**:

- `LoggerProtocol` and implementation
- Base error protocols (not service-specific errors)
- `BaseViewModel` and `BaseListViewModel`
- Dependency injection patterns
- Common extensions (String, Date, etc.)

**Benefits**:

- Shared foundation across projects
- Consistent patterns
- Battle-tested utilities

**Exclusions** (Keep in Thriftwood):

- Service-specific logic
- Data models
- API clients

## Migration Timeline

### Immediate (Task 3.3 - October 2025)

1. ✅ Rename all theme types with MPWG prefix
2. ✅ Update DI container registrations
3. ⏳ Update all references in existing code
4. ⏳ Implement form components with reusability in mind
5. ⏳ Complete Task 3.3 implementation

### Phase 1 (Milestone 2 - November 2025)

- Continue development in main app
- Document extraction criteria for each component
- Mark components with `// MARK: - Extraction Candidate` comments

### Phase 2 (Post-MVP - Q1 2026)

- Extract MPWGTheme package
- Extract MPWGUIKit package
- Extract MPWGFoundation package
- Update Thriftwood to use packages

### Phase 3 (Post-Launch - Q2 2026)

- Open-source packages (if suitable)
- Create documentation sites
- Publish to Swift Package Index

## Design Principles

### For Reusable Components

1. **Generic First**: Avoid app-specific assumptions
2. **Configurable**: Accept parameters for customization
3. **Accessible**: Follow WCAG guidelines
4. **Documented**: Comprehensive DocC documentation
5. **Tested**: >90% test coverage
6. **Previewed**: Rich SwiftUI previews

### For App-Specific Code

1. **Separation**: Clear boundaries from reusable code
2. **Composition**: Build on reusable components
3. **Documentation**: Explain app-specific decisions

## File Organization

### Current (In-App)

```
Thriftwood/
  Core/
    Theme/
      MPWGTheme.swift           # Extraction candidate
      MPWGThemeMode.swift       # Extraction candidate
      MPWGThemeManager.swift    # Extraction candidate
      Color+Theme.swift         # Extraction candidate (partial)
      Font+Theme.swift          # Extraction candidate
      Spacing.swift             # Extraction candidate
      Animation+Theme.swift     # Extraction candidate
  UI/
    Components/
      LoadingView.swift         # Extraction candidate
      ErrorView.swift           # Extraction candidate
      EmptyStateView.swift      # Extraction candidate
      CardView.swift            # Extraction candidate
      ThriftwoodButtonStyle.swift # → MPWGButtonStyle
      RefreshableModifier.swift # Extraction candidate
      [Form components]         # Extraction candidates
```

### Future (Packages)

```
MPWGTheme/
  Sources/MPWGTheme/
    MPWGTheme.swift
    MPWGThemeManager.swift
    Extensions/
      Color+Theme.swift
      Font+Theme.swift
    Constants/
      Spacing.swift
      Animation.swift

MPWGUIKit/
  Sources/MPWGUIKit/
    Components/
      LoadingView.swift
      ErrorView.swift
      EmptyStateView.swift
      CardView.swift
    Buttons/
      MPWGButtonStyle.swift
    Forms/
      TextFieldRow.swift
      SecureFieldRow.swift
      ToggleRow.swift
      PickerRow.swift
      ValidationHelpers.swift
    Modifiers/
      RefreshableModifier.swift
```

## Decision Rationale

### Why MPWG Prefix?

1. **Avoid Conflicts**: Prevent naming collisions with system frameworks
2. **Clarity**: Immediately identify custom types
3. **Professionalism**: Industry standard for framework/package authoring
4. **Branding**: Consistent branding across projects

### Why Delay Extraction?

1. **MVP Focus**: Prioritize shipping Thriftwood v1
2. **API Stability**: Let APIs mature through real usage
3. **Refactoring Risk**: Avoid premature abstraction
4. **Learning**: Understand full requirements first

### Why Plan Now?

1. **Naming**: Get naming right from the start
2. **Architecture**: Design for extraction later
3. **Documentation**: Track extraction candidates
4. **Quality**: Build with reusability mindset

## References

- [Swift Package Index](https://swiftpackageindex.com/)
- [Apple's Swift Package Manager Guide](https://developer.apple.com/documentation/packagedescription)
- [DocC Documentation](https://www.swift.org/documentation/docc/)
- [Semantic Versioning](https://semver.org/)
