# Android CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the Android-specific code in this repository.

## Project Overview

This is the **Android** folder of Thriftwood, a Flutter-based self-hosted controller app for managing media server software (Radarr, Sonarr, Lidarr, NZBGet, SABnzbd, etc.). This folder contains the Android-specific build configuration and Fastlane automation.

## Development Commands

### Android Build Commands
Run these commands from the project root (`/Users/mat/code/thriftwood-client/`):

**Standard Builds:**
- **Build signed APK**: `npm run build:android` or `npm run build:android:apk`
- **Build signed AAB**: `npm run build:android:aab` (for Play Store)
- **Build both formats**: `npm run build:android:all`

**Signing and Deployment:**
- **Validate signing setup**: `npm run prepare:signing:android`
- **Deploy to Play Store**: `npm run deploy:android`
- **Update Fastlane dependencies**: `npm run fastlane:update:android`

### From Android Directory (`/Users/mat/code/thriftwood-client/android/`):
- **Fastlane lanes**:
  - `bundle exec fastlane setup_signing` - Validate keystore configuration
  - `bundle exec fastlane build_apk` - Build signed APK
  - `bundle exec fastlane build_aab` - Build signed App Bundle
  - `bundle exec fastlane build_all` - Build both APK and AAB
  - `bundle exec fastlane deploy_playstore --aab=../output/thriftwood-android.aab` - Deploy to Play Store

### Initial Setup Commands:
```bash
# Install Ruby dependencies
bundle install

# Create keystore (one-time)
keytool -genkey -v -keystore ../key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias thriftwood

# Setup signing configuration
cp key.properties.sample key.properties
# Edit key.properties with your keystore details
```

## Signing Configuration

### Required Files:
1. **Keystore file**: `key.jks` (placed in project root)
2. **Properties file**: `android/key.properties` (created from `key.properties.sample`)

### key.properties Format:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password  
keyAlias=thriftwood
storeFile=../key.jks
```

## Build Configuration

### Gradle Configuration (`app/build.gradle`):
- **Namespace**: `app.thriftwood.thriftwood`
- **Compile SDK**: 35 (target SDK: 35)
- **Min SDK**: 24 (Android 7.0+)
- **Build Tools**: 36.0.0
- **Java/Kotlin**: JVM Target 17

### Signing Configuration:
- **Release builds**: Automatically signed using keystore specified in `key.properties`
- **Debug builds**: Uses debug keystore with `.debug` suffix
- **Build types**: Debug (with version suffix `-dev`) and Release

### Output Locations:
- **APK**: `build/app/outputs/flutter-apk/app-release.apk` → copied to `output/thriftwood-android.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab` → copied to `output/thriftwood-android.aab`

## Fastlane Integration

### Available Lanes:
1. **`setup_signing`**: Validates keystore and key.properties configuration
2. **`build_apk`**: Builds signed APK with validation and cleanup
3. **`build_aab`**: Builds signed App Bundle for Play Store distribution
4. **`build_all`**: Builds both APK and AAB formats
5. **`deploy_playstore`**: Uploads AAB to Google Play Store

### Fastlane Features:
- **Automatic validation**: Checks keystore and configuration before building
- **Error handling**: Clear error messages for missing files or configuration
- **Build cleanup**: Runs `flutter clean` before each build
- **Output management**: Copies built files to standardized output directory
- **Build numbering**: Supports custom build numbers via parameters or environment variables

### Example Usage:
```bash
# Build with custom build number
bundle exec fastlane build_apk build_number:42

# Deploy to specific Play Store track
bundle exec fastlane deploy_playstore aab:../output/thriftwood-android.aab track:internal

# Build with environment variable
BUILD_NUMBER=100 bundle exec fastlane build_all
```

## Dependencies

### Ruby Gems (managed via Bundler):
- **fastlane**: Build automation and deployment
- **Other gems**: Various supporting gems for Google Play Store integration

### Build Dependencies:
- **Flutter SDK**: >=3.0.0 <4.0.0
- **Android SDK**: API 24+ (Android 7.0+)
- **Java**: JDK 17+
- **Gradle**: Managed by Flutter

## Development Environment

- **Platform**: Android 7.0+ (API 24+)
- **Architecture**: ARM64, ARM32, x86_64
- **Permissions**: Network, wake lock, internet access
- **Build variants**: Debug (with `.debug` package suffix), Release
- **Code signing**: Requires Android keystore for release builds

## Build Process

The Android build process involves:
1. **Validation**: Fastlane validates keystore configuration
2. **Cleanup**: `flutter clean` removes previous build artifacts  
3. **Flutter build**: Compiles Dart code and generates native Android code
4. **Gradle build**: Compiles Android code and signs with keystore
5. **Output**: Copies signed APK/AAB to output directory

For Play Store distribution, use AAB format which supports dynamic delivery and smaller download sizes.