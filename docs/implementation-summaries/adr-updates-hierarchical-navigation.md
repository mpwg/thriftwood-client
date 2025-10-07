# ADR Updates for Hierarchical Navigation Pattern

**Date**: 2025-10-06  
**Context**: Updated existing ADRs to reflect the acceptance of ADR-0011 (Hierarchical Navigation Pattern)

## Summary

With the acceptance of ADR-0011 (Hierarchical Navigation Pattern for Media Management), several existing ADRs needed updates to:

1. Reference the new navigation pattern
2. Ensure consistent cross-referencing
3. Update architectural diagrams to reflect hierarchical (not tab-based) navigation
4. Maintain consistent ADR numbering

## Changes Made

### 1. ADR README (docs/architecture/decisions/README.md)

**Updated**: Decision Log table

**Changes**:

- Added ADR-0007 (Milestone 4 Service Implementation Strategies)
- Added ADR-0010 (Coordinator Navigation Initialization Pattern)
- Added ADR-0011 (Hierarchical Navigation Pattern for Media Management)

**Current Decision Log**:

| ADR  | Title                                                | Status   | Date       |
| ---- | ---------------------------------------------------- | -------- | ---------- |
| 0001 | Single NavigationStack Per Coordinator               | accepted | 2025-10-05 |
| 0002 | Use SwiftData Over CoreData                          | accepted | 2025-10-04 |
| 0003 | Use Swinject for Dependency Injection                | accepted | 2025-10-04 |
| 0004 | Use AsyncHTTPClient Over Custom Networking           | accepted | 2025-10-04 |
| 0005 | Use MVVM-C Pattern                                   | accepted | 2025-10-03 |
| 0006 | Use Swift OpenAPI Generator for Service API Clients  | accepted | 2025-10-05 |
| 0007 | Milestone 4 Service Implementation Strategies        | accepted | 2025-10-06 |
| 0010 | Coordinator Navigation Initialization Pattern        | accepted | 2025-10-06 |
| 0011 | Hierarchical Navigation Pattern for Media Management | accepted | 2025-10-06 |

**Note**: ADR-0008 and ADR-0009 do not exist (gap in numbering).

---

### 2. ADR-0001 (Single NavigationStack Per Coordinator)

**File**: `docs/architecture/decisions/0001-single-navigationstack-per-coordinator.md`

**Changes**:

1. **Updated "Related Decisions" section**:

   - Added reference to ADR-0005 (MVVM-C Pattern)
   - Added reference to ADR-0010 (Coordinator Navigation Initialization)
   - Added reference to ADR-0011 (Hierarchical Navigation Pattern)
   - Removed placeholder reference to non-existent ADR-0002

2. **Updated "Navigation Hierarchy" diagram**:
   - Replaced `MainTabView` → `TabCoordinator` structure
   - Now shows `AppCoordinatorView` with hierarchical button-based navigation
   - Shows Services hierarchy: Services Home → Radarr/Sonarr → Details
   - Added note: "As of ADR-0011, the app uses hierarchical button-based navigation instead of tabs"

**Before** (Navigation Hierarchy):

```text
└─ MainTabView
   └─ TabCoordinator
      ├─ DashboardCoordinatorView
      ├─ ServicesCoordinatorView
      └─ SettingsCoordinatorView
```

**After** (Navigation Hierarchy):

```text
└─ AppCoordinatorView
   └─ NavigationStack
      ├─ App Home (buttons for Dashboard, Services, Settings)
      ├─ DashboardCoordinatorView
      ├─ ServicesCoordinatorView
      │  └─ Services Home → RadarrCoordinatorView → Radarr Home → Movies → Details
      └─ SettingsCoordinatorView
```

---

### 3. ADR-0005 (MVVM-C Pattern)

**File**: `docs/architecture/decisions/0005-use-mvvm-c-pattern.md`

**Changes**:

**Updated "Related Decisions" section**:

- Fixed ADR references to use proper links (not placeholder numbers)
- Added ADR-0010 (Coordinator Navigation Initialization)
- Added ADR-0011 (Hierarchical Navigation Pattern)

**Before**:

```markdown
## Related Decisions

- [0001: Single NavigationStack Per Coordinator](0001-single-navigationstack-per-coordinator.md)
- 0002: Use SwiftData Over CoreData
- 0003: Use Swinject for DI
```

**After**:

```markdown
## Related Decisions

- [ADR-0001: Single NavigationStack Per Coordinator](0001-single-navigationstack-per-coordinator.md)
- [ADR-0002: Use SwiftData Over CoreData](0002-use-swiftdata-over-coredata.md)
- [ADR-0003: Use Swinject for DI](0003-use-swinject-for-dependency-injection.md)
- [ADR-0010: Coordinator Navigation Initialization](0010-coordinator-navigation-initialization.md)
- [ADR-0011: Hierarchical Navigation Pattern](0011-hierarchical-navigation-pattern.md)
```

---

### 4. ADR-0010 (Coordinator Navigation Initialization)

**File**: `docs/architecture/decisions/0010-coordinator-navigation-initialization.md`

**Changes**:

**Updated "References" section**:

- Added cross-references to related ADRs
- Improved documentation structure

**Before**:

```markdown
## References

- Original Bug Report: Settings navigation requiring back button
- Related Files: ...
```

**After**:

```markdown
## References

- [ADR-0001: Single NavigationStack Per Coordinator](0001-single-navigationstack-per-coordinator.md)
- [ADR-0005: MVVM-C Pattern](0005-use-mvvm-c-pattern.md)
- [ADR-0011: Hierarchical Navigation Pattern](0011-hierarchical-navigation-pattern.md)
- Original Bug Report: Settings navigation requiring back button
- Related Files: ...
```

---

### 5. ADR-0011 (Hierarchical Navigation Pattern)

**File**: `docs/architecture/decisions/0011-hierarchical-navigation-pattern.md`

**Status**: Created and marked as **accepted** (not proposed)

**Format**: Updated to follow MADR 4.0.0 template with:

- YAML frontmatter with metadata
- Proper heading structure
- Consequences section with Positive/Negative/Neutral
- Confirmation section with validation criteria
- More Information section with implementation details

---

## ADR Cross-Reference Matrix

This shows which ADRs reference each other:

| ADR  | References ADRs              | Referenced By ADRs |
| ---- | ---------------------------- | ------------------ |
| 0001 | 0005, 0010, 0011             | 0005, 0010, 0011   |
| 0002 | -                            | 0005               |
| 0003 | -                            | 0005               |
| 0004 | -                            | 0007               |
| 0005 | 0001, 0002, 0003, 0010, 0011 | 0001, 0010, 0011   |
| 0006 | -                            | 0007               |
| 0007 | 0004, 0006                   | -                  |
| 0010 | 0001, 0005, 0011             | 0001, 0005, 0011   |
| 0011 | 0001, 0005, 0010             | 0001, 0005, 0010   |

---

## Navigation Architecture Evolution

### Before ADR-0011 (Tab-Based)

```text
ContentView
└─ MainTabView (TabView)
   ├─ Dashboard Tab
   ├─ Services Tab
   │  └─ fullScreenCover → Radarr
   │     └─ Internal TabView (4 tabs)
   └─ Settings Tab
```

**Issues**:

- Nested tabs (2 levels)
- Full screen covers hide context
- Doesn't scale for deep navigation
- Inconsistent with media management UX

### After ADR-0011 (Hierarchical Button-Based)

```text
ContentView
└─ AppCoordinator (NavigationStack)
   ├─ App Home (buttons)
   ├─ Dashboard (NavigationStack)
   ├─ Services Home (buttons)
   │  ├─ Radarr Home (buttons) → NavigationStack
   │  │  ├─ Movies List
   │  │  ├─ Upcoming
   │  │  ├─ Missing
   │  │  ├─ History
   │  │  └─ Queue
   │  └─ Sonarr Home (similar)
   └─ Settings (NavigationStack)
```

**Benefits**:

- Single navigation pattern (no tabs)
- Handles 5+ level navigation depth
- Clear hierarchy with back/home buttons
- Consistent with media management UX

---

## Files Modified

1. ✅ `docs/architecture/decisions/README.md` - Updated decision log
2. ✅ `docs/architecture/decisions/0001-single-navigationstack-per-coordinator.md` - Updated hierarchy diagram and references
3. ✅ `docs/architecture/decisions/0005-use-mvvm-c-pattern.md` - Updated related decisions with proper links
4. ✅ `docs/architecture/decisions/0010-coordinator-navigation-initialization.md` - Added cross-references
5. ✅ `docs/architecture/decisions/0011-hierarchical-navigation-pattern.md` - Created with MADR 4.0.0 format

## Files Created

1. ✅ `docs/architecture/decisions/0011-hierarchical-navigation-pattern.md` (805 lines)
2. ✅ `docs/implementation-summaries/adr-updates-hierarchical-navigation.md` (this file)

---

## Validation

### ADR Numbering Consistency ✅

- Sequential: 0001, 0002, 0003, 0004, 0005, 0006, 0007, [gap], 0010, 0011
- Gap explained: 0008 and 0009 were never created
- All ADRs properly linked in README.md

### Cross-Reference Consistency ✅

- All navigation-related ADRs reference each other
- All references use proper ADR-NNNN format with links
- No broken links or placeholder references

### MADR 4.0.0 Compliance ✅

- ADR-0011 follows MADR 4.0.0 template
- YAML frontmatter with status, date, decision-makers
- Proper section structure (Context, Decision Drivers, Options, Outcome, Consequences, Confirmation)
- No markdown linting errors

---

## Next Steps

1. ✅ ADRs updated and consistent
2. ⏳ Implement Phase 1 of ADR-0011 (remove tabs, add button navigation)
3. ⏳ Update architecture documentation (`docs/architecture/README.md`)
4. ⏳ Update navigation quick reference (`docs/architecture/NAVIGATION_QUICK_REFERENCE.md`)

---

## Related Documentation

- [ADR-0011 Full Document](../architecture/decisions/0011-hierarchical-navigation-pattern.md)
- [ADR README](../architecture/decisions/README.md)
- [Architecture Overview](../architecture/README.md)
- [Navigation Quick Reference](../architecture/NAVIGATION_QUICK_REFERENCE.md)
