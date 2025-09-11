# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **iOS** folder of Thriftwood, a Flutter-based self-hosted controller app for managing media server software (Radarr, Sonarr, Lidarr, NZBGet, SABnzbd, etc.). The project is archived and no longer actively maintained.

## Development Commands

### iOS-Specific Commands
Run these commands from the project root (`/Users/mat/code/thriftwood-client/`):

- **Build iOS app**: `npm run build:ios` - Cleans and builds release IPA
- **CocoaPods management**:
  - `npm run cocoapods:nuke:ios` - Complete Pod reset (removes Pods, Podfile.lock, deintegrate, reinstall)
  - `npm run cocoapods:clear_cache` - Clear CocoaPods cache
- **Fastlane operations**:
  - `npm run fastlane:update:ios` - Update fastlane dependencies  
  - `npm run prepare:keychain:ios` - Set up development keychain for code signing

### From iOS directory (`/Users/mat/code/thriftwood-client/ios/`):
- **Fastlane lanes**:
  - `bundle exec fastlane keychain_create` - Create signing keychain
  - `bundle exec fastlane keychain_setup` - Configure development/app store certificates
  - `bundle exec fastlane build_appstore --build_number=XXX` - Build for App Store
  - `bundle exec fastlane deploy_appstore` - Upload to TestFlight

### Flutter Commands (from project root):
- **Generate code**: `npm run generate` - Runs environment, assets, build_runner, and localization generation
- **Development setup**: `npm run prepare` - Install dependencies and run initial setup
- **Profile mode**: `npm run profile` - Run app in Flutter profile mode

## Code Architecture

### Flutter App Structure
- **Core initialization**: `lib/main.dart` - Bootstrap sequence initializes database, theme, window manager, network, caches, and router
- **API clients**: `lib/api/` - Retrofit-based API clients for each service (Radarr, Sonarr, etc.)
- **Database**: Uses Hive for local storage, initialized in bootstrap
- **Router**: Go Router for navigation management
- **Theme**: Custom theming system with AMOLED black theme support

### iOS-Specific Configuration
- **Deployment target**: iOS 13.0+ (Podfile)
- **Permission handling**: Preprocessor definitions disable unused permissions (speech, sensors, media library, events, contacts, reminders, microphone)
- **Code signing**: Uses fastlane with match for certificate management
- **Build configurations**: Debug, Profile (release), Release

### Key Dependencies
- **Flutter plugins**: Uses standard Flutter ecosystem packages for network, cache, storage
- **Fastlane**: Automated building and deployment to App Store Connect
- **CocoaPods**: iOS dependency management with disabled stats for build performance

## Development Environment
- **Platform**: iOS 13.0+
- **Flutter SDK**: >=3.0.0 <4.0.0  
- **Ruby gems**: fastlane, cocoapods (managed via Bundler)
- **Xcode project**: Runner.xcodeproj with workspace
- **Code signing**: Requires Apple Developer account and certificates for building

## Build Process
The iOS build involves Flutter compilation followed by Xcode archiving. Fastlane handles certificate provisioning and App Store uploads. CocoaPods manages native iOS dependencies.