# RadarrService OpenAPI Integration - Next Steps

## What's Been Completed ✅

### 1. Code Refactoring

- ✅ Removed all AsyncHTTPClient code (~300 lines of manual HTTP implementation)
- ✅ Replaced with OpenAPI-generated client calls (single-line API calls)
- ✅ Created Configuration actor wrapping RadarrAPIAPIConfiguration
- ✅ Implemented all 10 protocol methods using generated clients
- ✅ Created model mapping extensions (6 extensions)
- ✅ Fixed error handling signatures (`any Error`, proper `decodingError()` calls)
- ✅ Fixed `mapError()` function (URLError wrapping, proper error cases)

### 2. Domain Models Updated

- ✅ Added `Movie.path` property for file system path
- ✅ Added `AddMovieRequest.tags` property for tag IDs
- ✅ All domain models now match mapping extension expectations

### 3. Package Relocation

- ✅ **Moved RadarrAPI package to project root** (from `Thriftwood/Services/Radarr/Generated/` to `/RadarrAPI/`)
- ✅ Added `import RadarrAPI` statement to RadarrService.swift
- ✅ Package now follows proper Swift Package Manager structure

## What Needs to Be Done in Xcode 🎯

### Step 1: Add RadarrAPI Local Package

You need to manually add the local Swift Package to your Xcode project:

1. **Open Project**

   ```bash
   open Thriftwood.xcodeproj
   ```

2. **Add Local Package**

   - In Xcode menu: **File > Add Package Dependencies...**
   - Click the **"Add Local..."** button (bottom left)
   - Navigate to and select the `RadarrAPI` folder in your project root
   - Click **"Add Package"**

3. **Select Package Products**

   - In the dialog that appears, ensure **RadarrAPI** library is checked
   - Make sure the **Thriftwood** target is selected
   - Click **"Add Package"**

4. **Verify Integration**
   - In Project Navigator, you should now see **RadarrAPI** under "Package Dependencies"
   - In Target Settings > General > Frameworks, Libraries, and Embedded Content, **RadarrAPI** should be listed
   - Alternatively check Build Phases > Link Binary With Libraries

### Step 2: Build and Test

Once the package is added:

```bash
# Clean build folder
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood clean

# Build project
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood -destination 'platform=macOS' build

# Run tests
xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood -destination 'platform=macOS'
```

## Expected Outcome

After adding the package in Xcode, all compilation errors should be resolved:

- ✅ `RadarrAPIAPIConfiguration` will be in scope
- ✅ `RadarrMovieAPI`, `RadarrQualityProfileAPI`, etc. will be available
- ✅ `ErrorResponse` type will be recognized
- ✅ `MovieResource`, `QualityProfileResource`, etc. will be accessible
- ✅ `AddMovieOptions` will be found
- ✅ All model mapping extensions will compile

## File Changes Summary

### Modified Files

1. **`Thriftwood/Services/Radarr/RadarrService.swift`**

   - Removed AsyncHTTPClient implementation (~300 lines)
   - Added `import RadarrAPI`
   - Rewrote all methods to use generated client
   - Fixed error handling
   - Added model mapping extensions (6 extensions)
   - **Result**: 581 lines → ~424 lines (27% reduction)

2. **`Thriftwood/Services/Radarr/Models/RadarrModels.swift`**
   - Added `Movie.path` property
   - Added `AddMovieRequest.tags` property
   - Updated initializers

### Relocated

3. **`RadarrAPI/` (formerly `Thriftwood/Services/Radarr/Generated/`)**
   - Moved to project root for proper SPM structure
   - Contains 221 generated Swift files
   - 76+ API classes, 145+ model types

### Created Documentation

4. **`docs/implementation-summaries/radarr-openapi-adaptation.md`**

   - Comprehensive implementation summary
   - Before/after comparison
   - Architecture benefits
   - Future enhancements

5. **`docs/implementation-summaries/radarr-openapi-package-relocation.md`**
   - Package relocation rationale
   - Step-by-step guide
   - Best practices

## Why This Structure?

### Local Package at Root Level

```
thriftwood-client/
├── Thriftwood/              # App source
├── ThriftwoodTests/         # Tests
├── RadarrAPI/               # ✅ Local Swift Package (proper location)
│   ├── Package.swift
│   └── RadarrAPI/
│       └── Classes/
│           └── OpenAPIs/
│               ├── APIs/    # Generated API classes
│               └── Models/  # Generated model types
└── Thriftwood.xcodeproj/
```

**Benefits:**

- Standard Swift Package Manager layout
- Xcode recognizes it as a local package
- Clean separation of generated vs. app code
- Reusable across multiple targets
- Can be easily regenerated without affecting app code

## Testing After Integration

Once package is added, verify these key features work:

```swift
// 1. Configuration
let service = RadarrService()
try await service.configure(baseURL: "https://radarr.example.com", apiKey: "xxx")

// 2. Fetch movies
let movies = try await service.getMovies()
print("Found \(movies.count) movies")

// 3. Search
let results = try await service.searchMovies(query: "Inception")
print("Found \(results.count) search results")

// 4. System status
let status = try await service.getSystemStatus()
print("Radarr version: \(status.version)")
```

## Troubleshooting

### If Package Doesn't Appear in Add Package Dialog

The package might not be recognized. Verify:

```bash
# Check Package.swift exists and is valid
cd RadarrAPI
swift package describe
```

### If Build Fails After Adding Package

1. Clean build folder: **Product > Clean Build Folder** (⇧⌘K)
2. Reset package cache: **File > Packages > Reset Package Caches**
3. Rebuild: **Product > Build** (⌘B)

### If Types Still Not Found

1. Check import statement: `import RadarrAPI` at top of RadarrService.swift
2. Verify package product: Target > General > Frameworks, Libraries, and Embedded Content
3. Check module map: RadarrAPI should appear in build logs

## Next Steps After Build Succeeds

1. **Update DIContainer** - Remove `httpClient` parameter from `RadarrService()` initialization
2. **Run Tests** - Verify all existing tests still pass
3. **Add Integration Tests** - Test with real Radarr instance
4. **Implement Additional Methods** - Add methods from legacy analysis (see future enhancements)
5. **Update Documentation** - Mark M2-T4.1 task as complete

## References

- **ADR-0006**: OpenAPI Specification Usage Decision Record
- **Milestone 2**: Services Integration (Radarr & Sonarr)
- **Legacy Implementation**: `/legacy/lib/api/radarr/`
- **Generated Client Docs**: `/RadarrAPI/docs/`

---

**Status**: 🟡 Code ready, awaiting Xcode package integration

**Next Action**: Add RadarrAPI local package in Xcode (see Step 1 above)
