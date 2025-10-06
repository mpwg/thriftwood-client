# RadarrAPI Package Relocation Plan

## Issue

The OpenAPI-generated `RadarrAPI` package is currently located at:

```
Thriftwood/Services/Radarr/Generated/
```

This is **incorrect** for a local Swift Package. It should be at the project root level for proper integration with Xcode.

## Correct Structure

Local Swift Packages should be at the root level of the repository:

```
thriftwood-client/
├── Thriftwood/              # Main app target (source files)
├── ThriftwoodTests/         # Test target
├── RadarrAPI/               # ✅ Local Swift Package (SHOULD BE HERE)
│   ├── Package.swift
│   ├── README.md
│   └── Sources/
│       └── RadarrAPI/
│           └── [generated files]
├── Thriftwood.xcodeproj/
└── openapi/
    └── radarr-v3.yaml       # Source OpenAPI spec
```

## Steps to Relocate

### 1. Move the Package

```bash
# Move the generated package to root
mv Thriftwood/Services/Radarr/Generated RadarrAPI

# Clean up any build artifacts
rm -rf RadarrAPI/.build
rm -rf RadarrAPI/.swiftpm
```

### 2. Update Generator Output Location

The package was generated with `openapi-generator-cli` (v7.16.0) using the `swift5` generator.

**Option A: Regenerate in correct location**

```bash
# Install openapi-generator-cli if not installed
brew install openapi-generator

# Generate in correct location
openapi-generator generate \
  -i openapi/radarr-v3.yaml \
  -g swift5 \
  -o RadarrAPI \
  --additional-properties=projectName=RadarrAPI,swiftPackageManager=true
```

**Option B: Update generation script**

Create `scripts/generate-radarr-api.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SPEC="$REPO_ROOT/openapi/radarr-v3.yaml"
OUTPUT="$REPO_ROOT/RadarrAPI"

echo "🔧 Generating RadarrAPI Swift Package..."

openapi-generator generate \
  -i "$SPEC" \
  -g swift5 \
  -o "$OUTPUT" \
  --additional-properties=projectName=RadarrAPI,swiftPackageManager=true \
  --git-repo-id=thriftwood-client \
  --git-user-id=mpwg

echo "✅ Generation complete: $OUTPUT"
```

### 3. Add Package to Xcode Project

**In Xcode:**

1. Open `Thriftwood.xcodeproj`
2. Go to **File > Add Package Dependencies...**
3. Click **"Add Local..."** button
4. Navigate to and select the `RadarrAPI` folder
5. Click **"Add Package"**
6. In the package product selection, check **RadarrAPI** library
7. Select the **Thriftwood** target
8. Click **"Add Package"**

**Verify:**

- In Project Navigator, you should see `RadarrAPI` listed under "Package Dependencies"
- In Build Phases > Link Binary With Libraries, `RadarrAPI` should be listed

### 4. Add Import Statement

Update `RadarrService.swift`:

```swift
import Foundation
import RadarrAPI  // ✅ Import the generated package

/// Implementation of Radarr service using OpenAPI-generated client
actor RadarrService: RadarrServiceProtocol {
    // ... rest of implementation
}
```

### 5. Update .gitignore

Add to root `.gitignore`:

```gitignore
# OpenAPI Generated Code (regenerate as needed)
/RadarrAPI/.build/
/RadarrAPI/.swiftpm/
/RadarrAPI/Package.resolved
```

**Optionally** (if generated code should be gitignored):

```gitignore
# Regenerate from openapi/radarr-v3.yaml as needed
/RadarrAPI/
```

Then add generation to CI/CD or as a build phase.

## Why This Structure?

### ✅ Benefits of Root-Level Package

1. **Standard Swift Package Layout**: Follows Swift Package Manager conventions
2. **Xcode Integration**: Easier to add as local package dependency
3. **Clean Separation**: Generated code is separate from app source
4. **Build Isolation**: Package builds independently with its own targets
5. **Reusability**: Can be used by multiple targets (app, tests, extensions)

### ❌ Problems with Current Location

1. **Not Discoverable**: Xcode doesn't recognize it as a package
2. **Import Issues**: Can't use `import RadarrAPI` statement
3. **Nested Structure**: Violates Swift Package conventions
4. **Build Issues**: Xcode doesn't compile nested packages automatically

## Current Status

- ✅ Domain models updated with missing properties (`Movie.path`, `AddMovieRequest.tags`)
- ✅ Error handling signatures fixed (`any Error`, `decodingError()` calls)
- ✅ All mapper extensions implemented
- ❌ **Package not in correct location** (blocks compilation)
- ❌ **Package not added to Xcode project** (blocks compilation)

## Next Steps

1. **Move package to root**: `mv Thriftwood/Services/Radarr/Generated RadarrAPI`
2. **Add to Xcode**: File > Add Package Dependencies > Add Local > RadarrAPI
3. **Add import**: Add `import RadarrAPI` to `RadarrService.swift`
4. **Test build**: `xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood build`
5. **Commit changes**: Update git with new package location

## References

- OpenAPI Generator: https://github.com/OpenAPITools/openapi-generator
- Swift Package Manager: https://www.swift.org/documentation/package-manager/
- Xcode Local Packages: https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages
- ADR-0006: OpenAPI Specification Usage Decision Record

---

**Note**: After relocation, the package will be properly integrated and all generated types (RadarrMovieAPI, ErrorResponse, MovieResource, etc.) will be visible to the compiler.
