# Thriftwood Client

![Thriftwood icon](assets/icon/icon.png)

Thriftwood Client is a native SwiftUI application and supporting tooling for the Thriftwood ecosystem. The repository contains the SwiftUI app sources (macOS/iOS), localization and branding assets, and Fastlane configuration for automating iOS builds and releases.

## Highlights

- Native SwiftUI app with modular architecture (Coordinators, Repositories, ViewModels).
- Fastlane-based CI/CD for iOS builds, signing, and distribution.
- Localized UI with many languages under `assets/localization`.
- Assets and icons in `assets/` and `ThriftwoodNative/Resources`.

## Quick start (developer)

Prerequisites:

- Xcode (latest stable)
- Ruby and Bundler (for Fastlane tasks)

Open and run the app locally:

```bash
open ThriftwoodNative/ThriftwoodNative.xcodeproj
```

Select the desired target (macOS / iOS / simulator) in Xcode and run.

## Fastlane / CI (iOS)

This repository includes Fastlane lanes to automate building, code signing, TestFlight and App Store uploads.

Setup helper:

```bash
./setup_fastlane.sh
```

Install Ruby dependencies:

```bash
cd ThriftwoodNative
bundle install
```

Fastlane expects sensitive values (API keys, team IDs, match password) to be provided via environment variables or a secrets manager. See `.env.example` for the variables the lanes use.

> [!warning]
> Never commit `.env`, `.p8` files, or private keys. The `private_keys/` directory is gitignored.

### Common lanes

- `bundle exec fastlane ios build` — build the app
- `bundle exec fastlane ios beta` — build + upload to TestFlight
- `bundle exec fastlane ios release` — build + upload to App Store (does not submit for review)
- `bundle exec fastlane ios certificates` — sync code signing profiles via match

Use `bundle exec fastlane lanes` to list available lanes and `--verbose` for debugging.

## Project layout

- `ThriftwoodNative/` — Native app source (SwiftUI) and Xcode project
  - `App/` — App entry and scene (`ThriftwoodNativeApp.swift`, `ContentView.swift`)
  - `Core/` — Shared types, networking, repositories and services (`SharedTypes.swift`)
  - `Features/` — Feature modules (Dashboard, Settings)
  - `Resources/` — Asset catalogs and localized strings
- `assets/` — Branding, icons and localization files
- `fastlane/` & `fastlane-macos/` — Fastlane lanes and config
- `private_keys/` — Local-only folder for API keys (gitignored)

## Localization

UI translations are under `assets/localization` and `ThriftwoodNative/Resources/en.lproj/Localizable.strings`. The repo includes multiple translations ready to ship.

## Developer notes

- Architecture: repositories for data access, view models for presentation, coordinators for navigation.
- Networking: `NetworkService` and `APIEndpoint` abstractions; implementations live in `ThriftwoodNative/Core/SharedTypes.swift`.
- Storage: `StorageService` backed by `UserDefaults` for simple persistence; swap to file or DB as needed.

## Where to look next

- App entry: `ThriftwoodNative/App/ThriftwoodNativeApp.swift`
- Shared models & services: `ThriftwoodNative/Core/SharedTypes.swift`
- Fastlane lanes: `fastlane/Fastfile` and `fastlane-macos/Fastfile`

---

If you'd like, I can add a short developer checklist (run locally, simulator, debug logging) or create a small PR template — tell me which to add next.
