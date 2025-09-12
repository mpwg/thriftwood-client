# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Thriftwood is a Flutter-based self-hosted controller app for managing media server software including Radarr, Sonarr, Lidarr, NZBGet, SABnzbd, Tautulli, NZBHydra2, and Wake on LAN. It provides remote control capabilities for these services with features like webhook push notifications, multiple instance support via profiles, backup/restore functionality, and AMOLED black theme support.

## Development Commands

### Core Build Commands
```bash
# Generate all code files (run after dependency changes)
npm run generate

# Individual generators
npm run generate:build_runner
npm run generate:build_runner:watch  # Watch mode
npm run generate:environment
npm run generate:assets
npm run generate:localization

# Platform builds
npm run build:android         # Build signed APK via Fastlane
npm run build:android:apk     # Build signed APK via Fastlane
npm run build:android:aab     # Build signed AAB (App Bundle) via Fastlane
npm run build:android:all     # Build both APK and AAB via Fastlane
npm run build:ios             # Clean + build IPA release  
npm run build:linux           # Clean + build Linux release
npm run build:macos           # Clean + build macOS release
npm run build:windows         # Clean + build Windows release
npm run build:web             # Clean + build web release

# Development
npm run profile          # Run in Flutter profile mode
flutter run              # Debug mode
flutter clean            # Clean build artifacts
```

### Platform-Specific Commands

**iOS/macOS CocoaPods Management:**
```bash
npm run cocoapods:nuke                # Reset both iOS and macOS
npm run cocoapods:nuke:ios            # Complete iOS Pod reset
npm run cocoapods:nuke:macos          # Complete macOS Pod reset
npm run cocoapods:clear_cache         # Clear CocoaPods cache
```

**Android Fastlane Commands:**
```bash
npm run prepare:signing:android       # Validate Android keystore setup
npm run deploy:android                # Deploy to Google Play Store
npm run fastlane:update:android       # Update Android fastlane dependencies
```

**iOS/macOS Fastlane Commands:**
```bash
npm run fastlane:update               # Update all platforms
npm run fastlane:update:ios           # Update iOS fastlane dependencies
npm run fastlane:update:macos         # Update macOS fastlane dependencies
npm run prepare:keychain:ios          # Setup iOS signing keychain
npm run prepare:keychain:macos        # Setup macOS signing keychain
```

**Android Signing Setup:**
```bash
# 1. Create keystore (one-time setup)
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias thriftwood

# 2. Create key.properties from sample
cp android/key.properties.sample android/key.properties
# Edit android/key.properties with your keystore details:
# storePassword=your_keystore_password
# keyPassword=your_key_password  
# keyAlias=thriftwood
# storeFile=../key.jks

# 3. Validate setup
npm run prepare:signing:android
```

**Release Management:**
```bash
npm run release:prepare               # Prepare for release
npm run release                       # Version bump with changelog
```

## Code Architecture

### Application Bootstrap
The app initializes through a guarded zone in `lib/main.dart:18` with this sequence:
1. **Database**: Hive initialization (`LunaDatabase`)
2. **Logging**: Logger setup (`LunaLogger`) 
3. **Theme**: Theme system (`LunaTheme`)
4. **Window Manager**: Desktop window management (`LunaWindowManager`)
5. **Network**: Network layer (`LunaNetwork`)
6. **Image Cache**: Image caching system (`LunaImageCache`)
7. **Router**: Go Router setup (`LunaRouter`)
8. **Memory Store**: Memory caching (`LunaMemoryStore`)

Recovery mode (`LunaRecoveryMode`) handles bootstrap failures.

### Module System
The app uses a modular architecture with each service as a separate module:
- **Core Modules**: Dashboard, Search, Settings
- **Media Servers**: Lidarr, Radarr, Sonarr 
- **Download Clients**: NZBGet, SABnzbd
- **Monitoring**: Tautulli
- **Network**: Wake on LAN

Modules are defined in `lib/modules.dart` with Hive enum serialization.

### Database Layer
- **Storage**: Hive NoSQL database with type adapters
- **Structure**: `lib/database/` contains models, tables, and configuration
- **Tables**: Individual service configurations and app settings
- **Profiles**: Multi-instance support for each service

### API Layer
- **HTTP Client**: Retrofit-based API clients in `lib/api/`
- **Structure**: Separate API packages per service (Radarr, Sonarr, etc.)
- **Network**: Dio HTTP client with custom interceptors

### State Management
- **Primary**: Provider pattern for state management
- **Deprecated**: `lib/core.dart` exports are deprecated, use direct imports
- **State**: Global app state in `lib/system/state.dart`

### Routing
- **Router**: Go Router with declarative routing
- **Structure**: Routes defined in `lib/router/routes/`
- **Navigation**: Module-based route organization

### Key Dependencies

**Flutter Framework:**
- `go_router: ^16.2.1` - Declarative routing
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` - Local database
- `dio: ^5.9.0` + `retrofit: ^4.7.2` - HTTP client and API generation

**Code Generation:**
- `build_runner: ^2.4.6` - Build system
- `json_serializable: ^6.8.0` - JSON serialization  
- `hive_generator: ^2.0.1` - Hive adapters
- `retrofit_generator: ^8.2.1` - API client generation

**Development Tools:**
- `flutter_lints: ^6.0.0` - Linting with custom rules in `analysis_options.yaml`
- `environment_config: ^3.2.0` - Environment configuration
- `spider` - Asset generation

## Project Structure

```
lib/
├── api/           # Retrofit API clients per service
├── database/      # Hive database, models, and tables  
├── modules/       # Feature modules (Radarr, Sonarr, etc.)
├── router/        # Go Router configuration and routes
├── system/        # Core system services (cache, network, etc.)
├── types/         # Shared type definitions
├── utils/         # Utility functions and helpers
├── widgets/       # Reusable UI components
├── main.dart      # Application entry point and bootstrap
└── modules.dart   # Module definitions and enums
```

## Development Notes

- **Linting**: Custom rules disable several default Flutter lints (see `analysis_options.yaml:10-24`)
- **Code Generation**: Required after dependency changes - always run `npm run generate`
- **Multi-platform**: Supports Android, iOS, Linux, macOS, Windows, and Web
- **Minimum Versions**: iOS 13.0+, Android API 21+
- **Theme System**: Custom theming with AMOLED black theme support
- **Localization**: Easy Localization with English fallback

### Android Build System

- **Fastlane Integration**: Android builds use Fastlane for automated signing and deployment
- **Signing Validation**: All Android builds verify keystore configuration before building
- **Output Directory**: Built files are placed in `output/` directory as `thriftwood-android.apk` or `thriftwood-android.aab`
- **Build Types**: Supports both APK (for direct installation) and AAB (for Play Store distribution)
- **Error Handling**: Fastlane provides detailed error messages for missing keystore or configuration issues

### Fastlane Lanes Available

**Android (`android/fastlane/Fastfile`):**
- `setup_signing` - Validates keystore and key.properties configuration
- `build_apk` - Builds signed APK with automatic validation
- `build_aab` - Builds signed App Bundle for Play Store
- `build_all` - Builds both APK and AAB formats
- `deploy_playstore` - Uploads to Google Play Store with validation