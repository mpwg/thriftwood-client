# Fastlane Configuration for Thriftwood Native

This directory contains the Fastlane configuration for automating iOS app builds, code signing, and distribution.

## 🚀 Available Lanes

### Development & Testing
- **`fastlane build`** - Build app for CI validation (no signing required)
- **`fastlane dev`** - Build development version with development certificates
- **`fastlane beta`** - Build and upload to TestFlight (auto-increments build number)

### Production
- **`fastlane release`** - Build and upload to App Store (auto-increments version & build, creates git tag)

### Code Signing
- **`fastlane certificates`** - Sync development and App Store certificates/profiles
- **`fastlane update_certificates`** - Update certificates and push to Match repository

### Utilities
- **`fastlane version`** - Show current app version and build number
- **`fastlane lanes`** - Show available lanes with descriptions

## 🔧 Setup

### Prerequisites
1. **Ruby & Bundler**: Install Ruby (3.3+) and Bundler
2. **Xcode**: Latest stable version (15.0+)
3. **Apple Developer Account**: Valid paid developer account
4. **Git Repository**: For Match certificate storage

### Installation
```bash
# Install Ruby dependencies
bundle install

# Verify Fastlane installation
bundle exec fastlane version
```

### Match (Code Signing) Setup
Fastlane uses Match for automatic certificate and provisioning profile management.

#### Initial Match Setup (One Time)
```bash
# Initialize Match repository (creates certificates repo)
bundle exec fastlane match init

# Create development certificates
bundle exec fastlane match development

# Create App Store certificates  
bundle exec fastlane match appstore
```

## 🔐 Required Environment Variables

Set these in your CI/CD system or local `.env` file:

### Apple Developer
- `APPLE_ID` - Your Apple Developer account email
- `DEVELOPMENT_TEAM` - Apple Developer Team ID (10 character string)
- `APPSTORE_TEAM_ID` - App Store Connect Team ID
- `ITUNES_TEAM_ID` - iTunes Connect Team ID (usually same as APPSTORE_TEAM_ID)

### App Store Connect API
- `APP_STORE_CONNECT_API_KEY_KEY_ID` - API Key ID from App Store Connect
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID` - Issuer ID from App Store Connect
- `APP_STORE_CONNECT_API_KEY_CONTENT` - Base64 encoded .p8 key content

### Match (Code Signing)
- `MATCH_PASSWORD` - Passphrase for encrypting certificates
- `MATCH_GIT_URL` - Git repository URL for storing certificates
- `MATCH_GIT_BASIC_AUTHORIZATION` - Base64 encoded git credentials (user:token)

### CI/CD (GitHub Actions)
- `KEYCHAIN_PASSWORD` - Password for temporary keychain (CI only)

## 🏗️ GitHub Actions Integration

The workflow supports multiple deployment scenarios following a structured Git flow.

### Branch Strategy
- **`main`**: Production-ready code → TestFlight deployment
- **`develop`**: Development code → Development builds with artifacts  
- **`feature/*`**: Feature branches → Build validation only (via PRs)

### Tag Strategy
- **`v*`**: Version tags (e.g., `v1.0.0`, `v1.2.3`) → App Store deployment
- Follow semantic versioning: `major.minor.patch`
- Support pre-release tags: `v2.0.0-beta.1`

### Automatic Deployments
1. **PR to develop/main**: Build validation only (`fastlane build`)
2. **Push to develop**: Development build (`fastlane dev`) with artifacts
3. **Push to main**: TestFlight deployment (`fastlane beta`)
4. **Create version tag**: App Store deployment (`fastlane release`) + GitHub release

### Manual Deployments
Use GitHub's "Run workflow" button from any branch:
- Choose **beta** for TestFlight deployment
- Choose **production** for App Store deployment

### Workflow Structure
```yaml
Jobs:
├── build-and-test      # Always runs - validates build
├── deploy-dev          # develop branch only
├── deploy-beta         # main branch or manual
└── deploy-production   # version tags or manual
```

### Creating Version Tags
```bash
# Create and push a version tag for App Store release
git tag v1.2.3
git push origin v1.2.3

# Or create annotated tag with release notes
git tag -a v1.2.3 -m "Release version 1.2.3 - Bug fixes and improvements"
git push origin v1.2.3
```

## 📱 Local Development

### Building Locally
```bash
# Development build
bundle exec fastlane dev

# TestFlight build (requires valid certificates)
bundle exec fastlane beta

# App Store build (requires main branch)
bundle exec fastlane release
```

### Version Management
```bash
# Check current version
bundle exec fastlane version

# Versions are auto-incremented by lanes:
# - beta: increments build number
# - release: increments patch version + build number
```

## 🔧 Configuration Details

### App Configuration
- **Bundle ID**: `app.thriftwood.native`
- **Scheme**: `ThriftwoodNative`
- **Project**: `ThriftwoodNative.xcodeproj`

### Build Settings
- **Development**: Debug configuration, development export method
- **TestFlight/App Store**: Release configuration, app-store export method
- **Bitcode**: Disabled (not required for iOS 14+)
- **Profile Detection**: Skipped (uses Match profiles)

### Keychain Management (CI)
- Creates temporary keychain `CI` with provided password
- Automatically cleans up keychain after builds
- Handles errors gracefully with cleanup

## 🚨 Troubleshooting

### Common Issues

#### Missing Certificates
```bash
# Re-sync certificates
bundle exec fastlane certificates

# Force update if needed
bundle exec fastlane update_certificates
```

#### Build Number Conflicts
```bash
# Check current TestFlight build number
# Fastlane auto-increments based on latest TestFlight build
bundle exec fastlane beta --verbose
```

#### Match Repository Issues
```bash
# Check Match status
bundle exec fastlane match development --readonly

# Regenerate certificates if corrupted
bundle exec fastlane match nuke development
bundle exec fastlane match nuke distribution
bundle exec fastlane update_certificates
```

### Debug Mode
Add `--verbose` to any lane for detailed output:
```bash
bundle exec fastlane build --verbose
```

## 📚 Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Match Code Signing](https://docs.fastlane.tools/actions/match/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [GitHub Actions for iOS](https://docs.github.com/en/actions/guides/building-and-testing-swift)