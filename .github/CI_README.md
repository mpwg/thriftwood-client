# GitHub Actions CI/CD Setup

## Overview

This project uses a simple, maintainable CI/CD pipeline designed for **indie development**. The focus is on easy maintenance and quick feedback.

**Build Target**: Mac Catalyst (iOS app running on macOS)

## Philosophy

**Main Goal: Easy Maintenance**

- ✅ Simple, single-pipeline workflow
- ✅ Fast feedback on every push
- ✅ Minimal configuration overhead
- ✅ Easy to understand and modify
- ✅ No complex matrix builds or multi-platform testing
- ✅ Focus on critical checks only: build, test, lint

## What Gets Checked

Every push to `main` or `rety` branches triggers:

1. **SwiftLint** - Code quality and style consistency
2. **GPL-3.0 License Headers** - Ensures all Swift files have required license headers
3. **Build** - Ensures the app compiles for Mac Catalyst
4. **Tests** - Runs all unit tests with Mac Catalyst
5. **Summary** - Generates a code quality report

## Workflow Details

- **File**: `.github/workflows/ci.yml`
- **Runs on**: macOS 26 (latest with Xcode 26.0)
- **Build Target**: Mac Catalyst (`platform=macOS,variant=Mac Catalyst`)
- **Duration**: ~5-10 minutes typical
- **Cancellation**: Automatically cancels previous runs on new push

## Features for Indie Development

### 1. Fast Feedback

- Caches build artifacts to speed up runs
- Skips CI on documentation-only changes
- Cancels outdated runs automatically

### 2. Easy Debugging

- Test results uploaded on failure
- Clear step names and logging
- Version information logged for troubleshooting

### 3. Low Maintenance

- Uses latest stable Xcode
- Minimal dependencies (just SwiftLint)
- No code signing required for CI builds

## Local Development

Run the same checks locally before pushing:

```bash
# Check license headers
./scripts/check-license-headers.sh --check

# Lint your code
swiftlint lint --strict

# Build (Mac Catalyst)
xcodebuild clean build \
  -project Thriftwood.xcodeproj \
  -scheme Thriftwood \
  -destination 'platform=macOS,variant=Mac Catalyst'

# Test (Mac Catalyst)
xcodebuild test \
  -project Thriftwood.xcodeproj \
  -scheme Thriftwood \
  -destination 'platform=macOS,variant=Mac Catalyst'
```

## Customization

### Skip CI for Documentation Changes

CI automatically skips on:

- Markdown files (`**.md`)
- Documentation folder (`docs/**`)
- Legacy code (`legacy/**`)

### Adjust Xcode Version

Edit `.github/workflows/ci.yml`:

```yaml
- name: Setup Xcode
  uses: maxim-lobanov/setup-xcode@v1
  with:
    xcode-version: "26.0" # Change this to your desired version
```

### Change Build Target

To build for native macOS instead of Mac Catalyst:

```yaml
-destination 'platform=macOS'  # Native macOS
# or
-destination 'platform=macOS,variant=Mac Catalyst'  # Mac Catalyst (current)
```

### Add More Checks

Simply add steps to the workflow file. Keep it simple!

## SwiftLint Configuration

See `.swiftlint.yml` for linting rules focused on maintainability:

- Enforces consistent code style
- Catches common errors
- Encourages clear documentation
- Prefers safe patterns over force unwrapping

## Troubleshooting

### Build Fails on CI but Works Locally

1. Check Xcode version match (CI uses Xcode 26.0)
2. Verify Mac Catalyst destination: `platform=macOS,variant=Mac Catalyst`
3. Clear derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
4. Check for scheme visibility (must be shared)

### Tests Fail on CI but Pass Locally

1. Check for environment-specific assumptions
2. Ensure test resources are in Git
3. Look for timing-sensitive tests
4. Verify Mac Catalyst test runner configuration

### License Header Check Fails

Run the script to add missing headers:

```bash
./scripts/check-license-headers.sh --add
```

### SwiftLint Errors

Run locally first: `swiftlint lint --strict`
Auto-fix many issues: `swiftlint --fix`

## Future Enhancements

When needed (not now):

- Release builds and notarization
- TestFlight deployment
- Code coverage reporting
- Performance testing

Keep it simple until you need more!
