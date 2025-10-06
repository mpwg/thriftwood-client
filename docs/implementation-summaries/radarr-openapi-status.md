# RadarrService Integration - Status & Next Steps

## Current Status: ⚠️ BUILD FAILING

The RadarrAPI package has been successfully added to Xcode, but there are **type mismatches** between our domain models and the generated OpenAPI types.

## Root Cause

The model mapping extensions were written **before** examining the actual generated types. The generated `MovieResource` has different types and property names than we assumed:

### Type Mismatches

| Our Assumption             | Actual Generated Type                   |
| -------------------------- | --------------------------------------- |
| `id: String`               | `id: Int`                               |
| `MovieStatus` enum         | `MovieStatusType` enum (from generator) |
| `tags: [Int]?`             | `tags: Set<Int>?`                       |
| `SystemStatusResource`     | Actually called `SystemResource`        |
| `qualityProfileId: String` | `qualityProfileId: Int`                 |

## Errors (17 total)

1. ID type mismatches (Movie, QualityProfile, RootFolder use String, generated uses Int)
2. Enum type mismatches (MovieStatus vs MovieStatusType)
3. Collection type mismatches (Array vs Set for tags)
4. Missing/wrong type names (SystemStatusResource vs SystemResource)
5. RadarrAPIAPIConfiguration property access errors
6. Method signature mismatches

## Recommended Solutions

### Option 1: Use Generated Types Directly (RECOMMENDED)

**Simplest approach** - Don't create domain models, use the generated types:

```swift
// Change protocol to use generated types
protocol RadarrServiceProtocol {
    func configure(baseURL: String, apiKey: String) async throws
    func getMovies() async throws -> [MovieResource]  // Use generated type
    func getMovie(id: Int) async throws -> MovieResource
    func searchMovies(query: String) async throws -> [MovieResource]
    //... etc
}
```

**Benefits:**

- No mapping code needed
- No type mismatches
- Less code to maintain
- Generated types are already Codable

**Trade-offs:**

- UI layer uses API types directly (tighter coupling)
- If we switch APIs later, more refactoring needed

### Option 2: Fix Domain Model IDs to Use Int

Change all domain model IDs from `String` to `Int` to match generated types:

```swift
struct Movie: Identifiable {
    let id: Int  // Changed from String
    // ... rest
}
```

Then fix all the mapping code to handle type conversions properly.

### Option 3: Create Proper Type Adapters

Write comprehensive conversion between `MovieStatusType` ↔ `MovieStatus`, `Int` ↔ `String` IDs, etc. This is the most work but provides the cleanest separation.

## My Recommendation

**Go with Option 1** (use generated types directly) for now because:

1. **Fastest path to working code** - No mapping needed
2. **Type-safe** - Compiler enforces correctness
3. **Well-documented** - Generated types have full API documentation
4. **Can refactor later** - Can add domain models later if needed

Then, if you want clean separation later, gradually introduce domain models with proper adapters.

## What Needs to Be Done

### If Choosing Option 1 (Recommended):

1. **Delete the mapping extensions** from RadarrService.swift (lines 300-424)
2. **Update RadarrServiceProtocol** to use generated types:

   ```swift
   import RadarrAPI

   protocol RadarrServiceProtocol: Actor, Sendable {
       func getMovies() async throws -> [MovieResource]
       func getMovie(id: Int) async throws -> MovieResource
       // ... etc
   }
   ```

3. **Update RadarrService implementation** - Remove `.toDomainModel()` calls
4. **Update domain models file** - Either delete or keep for future use
5. **Update any UI code** that expects domain models

### If Choosing Option 2 or 3:

This will take significantly more time to:

- Update all domain model ID types
- Write proper type converters
- Handle all enum conversions
- Test thoroughly

Probably 2-3 hours of work vs. 30 minutes for Option 1.

## Files That Need Changes (Option 1)

1. `Thriftwood/Services/Radarr/RadarrServiceProtocol.swift` - Update return types
2. `Thriftwood/Services/Radarr/RadarrService.swift` - Remove mapping extensions, simplify methods
3. Any ViewModels using RadarrService - Update to use `MovieResource` instead of `Movie`
4. Any Views displaying movie data - Update property names

## Quick Fix to Make It Build (Temporary)

If you want to just make it compile to save progress:

```bash
# Comment out the mapping extensions temporarily
# Lines 300-424 in RadarrService.swift

# Or delete the models file temporarily
mv Thriftwood/Services/Radarr/Models/RadarrModels.swift Thriftwood/Services/Radarr/Models/RadarrModels.swift.bak
```

Then update the protocol to return the actual types being used.

## Summary

✅ **What works:**

- RadarrAPI package properly integrated
- Generated client available and importable
- Configuration actor pattern working
- DI Container updated

❌ **What's broken:**

- Type mismatches between domain models and generated types
- 17 compilation errors in mapping code

**Time to fix:**

- Option 1 (use generated types): ~30 minutes
- Option 2/3 (fix mappings): ~2-3 hours

**My strong recommendation**: Go with Option 1 for now. You can always add a domain layer later when you have working code and better understand the actual API shapes.

## Want Me to Implement Option 1?

I can quickly:

1. Remove the mapping extensions
2. Update the protocol to use generated types
3. Simplify the service implementation
4. Get it building in ~10 minutes

Just say the word!
