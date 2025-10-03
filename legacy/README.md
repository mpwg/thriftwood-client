# <img width="40px" src="./assets/images/branding_logo.png" alt="Thriftwood"></img>&nbsp;&nbsp;Thriftwood

Thriftwood is a fully featured, open source self-hosted controller focused on giving you a seamless experience between all of your self-hosted media software remotely on your devices. Thriftwood currently supports:

- [Lidarr](https://github.com/lidarr/lidarr)
- [Radarr](https://github.com/radarr/radarr)
- [Sonarr](https://github.com/sonarr/sonarr)
- [NZBGet](https://github.com/nzbget/nzbget)
- [SABnzbd](https://github.com/sabnzbd/sabnzbd)
- [Newznab Indexer Searching](https://newznab.readthedocs.io/en/latest/misc/api/)
- [NZBHydra2](https://github.com/theotherp/nzbhydra2)
- [Tautulli](https://github.com/Tautulli/Tautulli)
- [Wake on LAN](https://en.wikipedia.org/wiki/Wake-on-LAN)

Thriftwood even comes with support for webhook-based push notifications, multiple instances of applications using profiles, backup and restore functionality for your configuration, an AMOLED black theme, and more!

> Please note that Thriftwood is purely a remote control application, it does not offer any functionality without software installed on a server/computer.

## Building Thriftwood

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.0.0 <4.0.0)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- Platform-specific requirements (see sections below)

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd thriftwood-client
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   npm install  # For build scripts
   ```

3. **Generate code files**
   ```bash
   npm run generate
   ```
   This runs:
   - Environment configuration generation
   - Asset generation
   - Build runner code generation
   - Localization generation

### Build Commands

#### Quick Build Commands (NPM Scripts)

```bash
# Android
npm run build:android

# iOS
npm run build:ios

# Linux
npm run build:linux

# macOS
npm run build:macos

# Windows
npm run build:windows

# Web
npm run build:web
```

#### Direct Flutter Commands

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires macOS and Xcode)
flutter build ios --release
flutter build ipa --release  # For distribution

# Desktop platforms
flutter build linux --release
flutter build macos --release
flutter build windows --release

# Web
flutter build web --release
```

### Platform-Specific Instructions

#### Android

**Prerequisites:**
- [Android Studio](https://developer.android.com/studio) or Android SDK
- Java Development Kit (JDK) 8 or higher

**Build:**
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

**Output Location:** `build/app/outputs/`

#### iOS

**Prerequisites:**
- macOS with Xcode 12.0 or higher
- iOS 13.0+ deployment target
- Apple Developer account (for device deployment)
- CocoaPods

**Setup:**
```bash
cd ios
pod install
```

**Build:**
```bash
# For simulator
flutter build ios --debug --simulator

# For device (no code signing)
flutter build ios --release --no-codesign

# For distribution (requires code signing)
flutter build ipa --release
```

**Using Fastlane (iOS):**
```bash
cd ios

# Create development keychain
bundle exec fastlane keychain_create

# Setup certificates
bundle exec fastlane keychain_setup

# Build for App Store
bundle exec fastlane build_appstore --build_number=1

# Deploy to TestFlight
bundle exec fastlane deploy_appstore
```

**Output Location:** `build/ios/iphoneos/` or `build/ios/archive/`

#### Linux

**Prerequisites:**
- Linux development environment
- GTK+ 3.0 development libraries
- Required system packages:
  ```bash
  sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
  ```

**Build:**
```bash
flutter build linux --release
```

**Output Location:** `build/linux/x64/release/bundle/`

#### macOS

**Prerequisites:**
- macOS 10.14 or higher
- Xcode command line tools

**Build:**
```bash
flutter build macos --release
```

**Output Location:** `build/macos/Build/Products/Release/`

#### Windows

**Prerequisites:**
- Windows 10 or higher
- Visual Studio 2019 or higher with C++ support

**Build:**
```bash
flutter build windows --release

# Build MSIX package
flutter build windows --release
dart run msix:create
```

**Output Location:** `build/windows/runner/Release/`

#### Web

**Build:**
```bash
flutter build web --release
```

**Output Location:** `build/web/`

### Development Commands

#### Code Generation
```bash
# Generate all code
npm run generate

# Individual generators
npm run generate:environment
npm run generate:assets
npm run generate:build_runner
npm run generate:localization

# Watch mode for build_runner
npm run generate:build_runner:watch
```

#### Development Server
```bash
# Run in debug mode
flutter run

# Run in profile mode
npm run profile
# or
flutter run --profile
```

#### Maintenance Commands

```bash
# Clean project
flutter clean

# Update dependencies
flutter pub get

# Clear CocoaPods cache (macOS/iOS)
npm run cocoapods:clear_cache

# Nuclear option: reset CocoaPods completely
npm run cocoapods:nuke
```

### Troubleshooting

#### Common Issues

1. **Build failures**: Run `flutter clean` then `flutter pub get`
2. **Code generation issues**: Run `npm run generate` to regenerate files
3. **iOS build issues**: 
   - Ensure Xcode is updated
   - Run `npm run cocoapods:nuke:ios` to reset CocoaPods
   - Check code signing settings in Xcode
4. **Dependency conflicts**: Check `flutter doctor` for environment issues

#### Environment Validation
```bash
flutter doctor -v
```

This will check your Flutter installation and highlight any missing dependencies or configuration issues.

### Release Process

1. **Prepare release**
   ```bash
   npm run release:prepare
   ```

2. **Version bump**
   ```bash
   npm run release
   ```

3. **Build for all platforms**
   ```bash
   # Run individual build commands for each target platform
   npm run build:android
   npm run build:ios
   npm run build:web
   # etc.
   ```

### Additional Information

- **Supported Platforms**: Android, iOS, Linux, macOS, Windows, Web
- **Minimum Requirements**: iOS 13.0+, Android API 21+
- **Build Time**: ~2-5 minutes depending on platform and hardware
- **Output Sizes**: ~25-30MB for mobile platforms

For platform-specific deployment guides and advanced configuration, refer to the [Flutter documentation](https://flutter.dev/docs).
