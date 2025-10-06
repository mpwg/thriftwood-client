# Add RadarrAPI Local Package to Xcode - Quick Guide

## Why You Need to Do This

The OpenAPI-generated `RadarrAPI` Swift Package has been moved to the correct location at the project root, but Xcode projects don't automatically recognize local packages. You must manually add it through Xcode's UI.

## Step-by-Step Instructions

### 1. Open Your Project

```bash
cd /Users/mat/code/thriftwood-client
open Thriftwood.xcodeproj
```

### 2. Navigate to Package Dependencies Menu

In Xcode menu bar:

- Click **File**
- Hover over **Add Package Dependencies...** (or **Add Packages...** in newer Xcode)
- Click it

### 3. Add Local Package

In the dialog that opens:

1. **Look for "Add Local..." button**

   - It's typically in the bottom-left corner of the dialog
   - Or there might be a dropdown menu at the top-right with "Add Local Package"

2. **Navigate to RadarrAPI folder**

   - A file picker will open
   - Navigate to your project root
   - Select the `RadarrAPI` folder (the entire folder, not files inside it)

3. **Click "Add Package" or "Choose"**

### 4. Configure Package Products

After selecting the folder, you'll see a product selection dialog:

1. **Check the RadarrAPI library**

   - There should be a checkbox next to "RadarrAPI" product
   - Make sure it's checked ✅

2. **Select Target**

   - In the "Add to Target" dropdown, select **Thriftwood**
   - This tells Xcode which target should link against the package

3. **Click "Add Package"**

### 5. Verify Integration

After adding:

1. **In Project Navigator (left sidebar)**

   - Look for a "Package Dependencies" section (usually below your project files)
   - You should see **RadarrAPI** listed there with a package icon 📦

2. **In Target Settings**

   - Select the **Thriftwood** target in Project Navigator
   - Go to **General** tab
   - Scroll to **Frameworks, Libraries, and Embedded Content**
   - You should see **RadarrAPI** listed there

3. **Alternative Check - Build Phases**
   - Select the **Thriftwood** target
   - Go to **Build Phases** tab
   - Expand **Link Binary With Libraries**
   - **RadarrAPI** should be listed

### 6. Test the Build

```bash
# Clean build folder first
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood clean

# Build
xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood -destination 'platform=macOS' build
```

**Expected result**: Build should succeed with no errors! 🎉

All the generated types should now be visible:

- `RadarrAPIAPIConfiguration`
- `RadarrMovieAPI`, `RadarrQualityProfileAPI`, `RadarrSystemAPI`, etc.
- `ErrorResponse`
- `MovieResource`, `QualityProfileResource`, etc.
- `AddMovieOptions`

## Troubleshooting

### "No packages found" or RadarrAPI folder isn't recognized

**Check Package.swift exists:**

```bash
ls -la RadarrAPI/Package.swift
```

If it doesn't exist, the generator didn't create a proper package. Try:

```bash
cd RadarrAPI
swift package describe
```

### Build still fails after adding package

1. **Clean build folder**: Product → Clean Build Folder (⇧⌘K)
2. **Reset package cache**: File → Packages → Reset Package Caches
3. **Quit and restart Xcode**
4. **Try building again**

### Package appears but types still not found

Make sure the import statement is at the top of RadarrService.swift:

```swift
import Foundation
import RadarrAPI  // ← This line must be present
```

### Xcode can't find the package path

The package must be at the project root:

```bash
# Verify structure
ls -la /Users/mat/code/thriftwood-client/
# Should see:
# - Thriftwood/
# - RadarrAPI/          ← Package is here
# - Thriftwood.xcodeproj/
```

## Alternative: Using Xcode Project Navigator

If you prefer a different approach:

1. In **Project Navigator**, right-click on project root (blue icon at top)
2. Select **Add Files to "Thriftwood"...**
3. Navigate to and select `RadarrAPI` folder
4. **IMPORTANT**: In the dialog options:
   - **DO NOT** check "Copy items if needed"
   - **DO** select "Create folder references" (not "Create groups")
   - Under "Add to targets", check **Thriftwood**
5. Click **Add**

However, the **File → Add Package Dependencies** method is preferred as it properly recognizes it as a Swift Package.

## What Happens After Adding the Package?

1. **Xcode indexes the package** - This might take 10-30 seconds
2. **Code completion works** - You'll get autocomplete for generated types
3. **Build succeeds** - All 30+ compilation errors should disappear
4. **Tests can run** - You can now test the RadarrService integration

## Next Steps After Successful Build

See `docs/implementation-summaries/radarr-openapi-next-steps.md` for:

- Testing the integration
- Updating DIContainer
- Adding more API methods
- Integration tests with real Radarr instance

---

**Remember**: This is a ONE-TIME setup. Once added, Xcode will remember the package dependency and you won't need to add it again unless you create a new project or Workspace.
