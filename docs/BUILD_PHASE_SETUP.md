# Build Phase Setup for Acknowledgements Generation

## Overview

This guide explains how to integrate the `generate-acknowledgements.sh` script into the Xcode build process so that it automatically runs before each build.

## Manual Setup (Recommended)

### Steps

1. **Open Xcode Project**

   - Open `Thriftwood.xcodeproj` in Xcode

2. **Navigate to Build Phases**

   - Select the **Thriftwood** project in the Project Navigator
   - Select the **Thriftwood** target (under TARGETS)
   - Click the **Build Phases** tab

3. **Add New Run Script Phase**

   - Click the **+** button at the top of the build phases list
   - Select **New Run Script Phase**

4. **Configure the Script Phase**
   - **Name**: Rename the phase to `Generate Acknowledgements`
   - **Shell**: Leave as `/bin/sh`
   - **Script**: Paste the following:

```bash
# Generate acknowledgements.json from SPM dependencies
if [ -f "${SRCROOT}/scripts/generate-acknowledgements.sh" ]; then
    echo "Generating acknowledgements from SPM dependencies..."
    "${SRCROOT}/scripts/generate-acknowledgements.sh"
else
    echo "Warning: generate-acknowledgements.sh not found at ${SRCROOT}/scripts/"
fi
```

5. **Configure Input Files** (Optional but Recommended)

   - Expand the **Input Files** section
   - Add the following input file to ensure the script only runs when dependencies change:
     - `$(SRCROOT)/Package.resolved`

6. **Configure Output Files** (Optional but Recommended)

   - Expand the **Output Files** section
   - Add the following output file:
     - `$(SRCROOT)/Thriftwood/Resources/acknowledgements.json`

7. **Move the Build Phase**

   - Drag the **Generate Acknowledgements** phase to run **before** the **Copy Bundle Resources** phase
   - This ensures the JSON is generated before being copied to the app bundle
   - Recommended order:
     1. Dependencies (automatic)
     2. **Generate Acknowledgements** ← Your new phase
     3. Sources
     4. Frameworks
     5. Resources

8. **Verify Setup**
   - Clean build folder: **Product → Clean Build Folder** (Cmd+Shift+K)
   - Build the project: **Product → Build** (Cmd+B)
   - Check the build log for: `✅ Generated acknowledgements.json with X dependencies`

## What This Does

### Automatic Generation

- **When**: Runs automatically before every build
- **What**: Parses `Package.resolved` and extracts LICENSE files from SPM checkouts
- **Output**: Creates/updates `Thriftwood/Resources/acknowledgements.json`
- **Optimization**: With Input/Output files configured, only runs when `Package.resolved` changes

### Benefits

1. **Always Current**: Acknowledgements stay in sync with actual dependencies
2. **No Manual Work**: Automatically updates when you add/remove packages
3. **CI/CD Ready**: Works in automated build environments
4. **Legal Compliance**: Ensures all licenses are tracked

## Troubleshooting

### Script Not Running

**Problem**: Build succeeds but no acknowledgements.json generated
**Solutions**:

- Check build log for script output
- Verify script exists at `scripts/generate-acknowledgements.sh`
- Ensure script is executable: `chmod +x scripts/generate-acknowledgements.sh`
- Check script path in build phase matches actual location

### Script Fails

**Problem**: Build fails with script error
**Solutions**:

- Run script manually to see full error: `./scripts/generate-acknowledgements.sh`
- Check that DerivedData exists (build once first)
- Verify `Package.resolved` exists
- Ensure SPM packages have been downloaded

### JSON Not in Bundle

**Problem**: App builds but can't load acknowledgements.json
**Solutions**:

- Verify `Generate Acknowledgements` runs **before** `Copy Bundle Resources`
- Check that `Thriftwood/Resources/` exists
- Ensure the Resources folder is added to the target
- Clean build folder and rebuild

### Input Files Not Working

**Problem**: Script runs every build despite unchanged dependencies
**Solutions**:

- Verify Input Files path is correct: `$(SRCROOT)/Package.resolved`
- Verify Output Files path is correct: `$(SRCROOT)/Thriftwood/Resources/acknowledgements.json`
- Clean build folder to reset dependency tracking
- Check that paths use `$(SRCROOT)` variable, not absolute paths

## Alternative: Command Line Setup

If you prefer to avoid Xcode UI, you can add the build phase via command line, but this is **not recommended** as it's fragile and can corrupt the project file.

### Manual project.pbxproj Editing (Advanced)

**⚠️ Warning**: Only attempt this if you're comfortable with Xcode project file format and have a backup.

The build phase needs to be added to the `buildPhases` array in the Thriftwood target. This requires:

1. Generating a unique UUID for the phase
2. Adding the phase definition to the appropriate section
3. Updating the target's buildPhases array
4. Ensuring proper syntax and references

**Recommended**: Use Xcode UI instead.

## Verification

After setup, verify the integration:

### 1. Clean Build

```bash
cd /Users/mat/code/thriftwood-client
xcodebuild clean -project Thriftwood.xcodeproj -scheme Thriftwood
```

### 2. Build and Check

```bash
xcodebuild build -project Thriftwood.xcodeproj -scheme Thriftwood 2>&1 | grep -A2 "Generate Acknowledgements"
```

Expected output:

```
PhaseScriptExecution Generate\ Acknowledgements
...
✅ Generated acknowledgements.json with X dependencies
```

### 3. Verify JSON Exists

```bash
ls -lh Thriftwood/Resources/acknowledgements.json
```

Expected: File exists and is ~50KB (contains full license texts)

### 4. Run App

- Build and run the app
- Navigate to **Settings → Acknowledgements**
- Verify all dependencies are listed
- Tap a dependency to view its license

## Maintenance

### When to Regenerate Manually

The build phase handles automatic generation, but you may want to regenerate manually:

```bash
./scripts/generate-acknowledgements.sh
```

Reasons to regenerate manually:

- After adding new SPM packages
- After updating package versions
- When troubleshooting build issues
- For development/testing

### Keeping Up-to-Date

The build phase ensures acknowledgements stay current:

- **Package.resolved** changes → Script runs → JSON regenerates
- **No changes** → Script skipped (with Input/Output files configured)
- **Clean build** → Script runs → JSON regenerates

## CI/CD Integration

If you use CI/CD (GitHub Actions, etc.), the build phase runs automatically:

### GitHub Actions Example

```yaml
- name: Build
  run: |
    xcodebuild build \
      -project Thriftwood.xcodeproj \
      -scheme Thriftwood \
      -destination 'platform=macOS,variant=Mac Catalyst'
```

The `Generate Acknowledgements` phase runs as part of the normal build process.

### Fastlane Integration

```ruby
build_app(
  scheme: "Thriftwood",
  # Build phase runs automatically
)
```

## References

- Script: `/scripts/generate-acknowledgements.sh`
- Model: `/Thriftwood/Core/Models/Dependency.swift`
- UI: `/Thriftwood/UI/Settings/AcknowledgementsView.swift`
- Implementation Docs: `/docs/implementation-summaries/dynamic-acknowledgements.md`
