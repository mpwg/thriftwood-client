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

This repository includes Fastlane lanes to automate building, code signing, TestFlight and App Store uploads, with GitHub Actions CI/CD pipeline.

### Setup

Install Ruby dependencies:

```bash
bundle install
```

Configure environment variables:

```bash
# Copy the template and fill in your actual values
cp .env.example .env

# Import secrets to GitHub repository (optional, for CI/CD)
gh secret set -f .env
```

Environment variables are organized into sections:
- **Apple Developer Account**: Apple ID and team information
- **App Store Connect Authentication**: API key (recommended) or session cookie
- **Code Signing**: Fastlane Match configuration for certificate management
- **CI/CD Environment**: GitHub Actions specific settings

> [!warning]
> Never commit `.env`, `.p8` files, or private keys. The `private_keys/` directory is gitignored.

### Common lanes

- `bundle exec fastlane build` — build for CI validation (no signing required)
- `bundle exec fastlane dev` — build development version
- `bundle exec fastlane beta` — build + upload to TestFlight (auto-increments build number)
- `bundle exec fastlane release` — build + upload to App Store (auto-increments version + build, creates git tag)
- `bundle exec fastlane certificates` — sync code signing certificates and provisioning profiles
- `bundle exec fastlane update_certificates` — update certificates and push to Match repository
- `bundle exec fastlane version` — show current app version and build number
- `bundle exec fastlane show_help` — show available lanes with descriptions

### CI/CD Pipeline

The project uses GitHub Actions with multi-stage deployment:
- **`main`** branch → TestFlight deployment
- **`develop`** branch → Dev builds with artifacts
- **`feature/*`** branches → Build validation only (via PRs)
- **`v*` tags** → App Store deployment + GitHub release

See [BRANCHING_STRATEGY.md](./BRANCHING_STRATEGY.md) for detailed workflow information.

## Project layout

- `ThriftwoodNative/` — Native app source (SwiftUI) and Xcode project
  - `App/` — App entry and scene (`ThriftwoodNativeApp.swift`, `ContentView.swift`)
  - `Core/` — Shared types, networking, repositories and services (`SharedTypes.swift`)
  - `Features/` — Feature modules (Dashboard, Settings)
  - `Resources/` — Asset catalogs and localized strings
- `assets/` — Branding, icons and localization files
- `fastlane/` — Fastlane lanes and configuration
- `.github/workflows/` — GitHub Actions CI/CD pipeline
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
- Fastlane lanes: `fastlane/Fastfile`
- CI/CD workflows: `.github/workflows/ci-cd.yml`
- Development guide: `CLAUDE.md`

---

If you'd like, I can add a short developer checklist (run locally, simulator, debug logging) or create a small PR template — tell me which to add next.
