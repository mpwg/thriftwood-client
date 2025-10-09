<!-- .github/copilot-instructions.md for PrototypeGUI -->

# PrototypeGUI — Copilot Instructions (concise)

Purpose

- Help AI coding agents be productive immediately when prototyping this SwiftUI app from screenshots.

Big picture

- This is a minimal SwiftUI prototype app. The app entrypoint is `PrototypeGUIApp.swift` and the main view is `ContentView.swift`.
- Repo artifacts to reference: `PrototypeGUI.xcodeproj/` (project), `PrototypeGUI/ContentView.swift`, `PrototypeGUI/PrototypeGUIApp.swift`, and `PrototypeGUI/Assets.xcassets/` (contains `AccentColor.colorset` and `AppIcon.appiconset`).

Primary rule (important)

- When converting screenshots into UI code for this project: strip ALL custom colors and fonts from the screenshot. Produce a "pure" SwiftUI implementation that uses only system fonts and system colors (Color.primary, Color.secondary, .tint, semantic colors and dynamic text styles like `.font(.title)`, `.font(.body)`). Do not add project-specific color assets or custom font registrations.

Why this rule

- The project is explicitly a prototype focused on layout and interaction, not branding. Keeping a neutral, system-based appearance makes components reusable and easy to iterate.

Concrete patterns and examples

- Layouts: prefer VStack/HStack/ZStack, GeometryReader only when needed. Use modifiers for spacing and alignment rather than fixed pixel offsets where possible.

  - Example conversion (from screenshot element -> SwiftUI):

  ```swift
  // screenshot: headline text and subtitle
  VStack(alignment: .leading, spacing: 6) {
      Text("Headline")
          .font(.title)
          .foregroundColor(.primary)
      Text("Subtitle goes here")
          .font(.subheadline)
          .foregroundColor(.secondary)
  }
  ```

- Colors: replace custom hex or named colors with system semantic colors. Example: custom blue -> .tint or Color.accentColor is acceptable only if it is the system accent; otherwise use `.tint`/`.primary`/`.secondary`/`.background`.

Platform compatibility — do NOT use iOS-only colors/materials

- Avoid using UIColor-backed initializers or UIKit-only semantic names directly in views that should compile cross-platform. Examples to avoid:

  - Color(.systemGroupedBackground)
  - Color(.secondarySystemGroupedBackground)
  - Color(uiColor: ...) / UIColor(...) usage
  - Material types like `.regularMaterial`, `.ultraThinMaterial`, or `.thinMaterial`

- Why: those APIs are iOS-specific and will cause compile failures on macOS. When prototyping components intended to run in both iOS and macOS targets, prefer one of the following approaches:
  - Use only the core SwiftUI semantic colors: `Color.primary`, `Color.secondary`, `Color.background`, `Color.accentColor`, `Color.tint`.
  - Provide a small platform-aware helper (in the view file or a shared file) that maps to platform colors using `#if os(iOS)` / `#else` so the implementation can still follow the screenshot while remaining cross-platform. Example pattern (not required in every file):

```swift
fileprivate extension Color {
    static var platformGroupedBackground: Color {
        #if os(iOS)
        return Color(.systemGroupedBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }
}
```

- For translucent "material" effects, prefer a subtle opaque background using a semantic color with reduced opacity (e.g., `Color.primary.opacity(0.04)` or a platform helper) instead of `.regularMaterial` so the UI remains buildable across Apple platforms.

- If you must use a platform-specific appearance for a single view, wrap it in `#if os(iOS)` / `#elseif os(macOS)` branches and document the reason in a short comment.
- Fonts: map screenshot fonts to dynamic text styles (`.largeTitle`, `.title2`, `.headline`, `.body`, `.caption`). Avoid embedding or declaring custom fonts.
- Images: prefer SF Symbols (`Image(systemName:)`) for icons, and SwiftUI `Image` with `.resizable()` and `.aspectRatio(contentMode:)` for photos. Avoid adding rasterized UI images for common icons.

Project-specific conventions

- Keep files minimal and focused: new views go under `PrototypeGUI/` alongside `ContentView.swift` (follow existing simple structure). Keep view structs small and composable.
- Preview providers: add `#Preview { ... }` blocks like the existing `ContentView.swift` to make quick visual checks in Xcode 15+.

Build & run (developer workflow)

- Primary workflow: open the Xcode project and use Xcode Previews or the simulator for quick iteration.
- Command-line build (assumption: scheme is `PrototypeGUI`):

  ```bash
  xcodebuild -project PrototypeGUI.xcodeproj -scheme PrototypeGUI -destination 'platform=iOS Simulator,name=iPhone 14' build
  ```

  Note: If the scheme name differs, open the project in Xcode and use the project scheme menu. Using Xcode is recommended for SwiftUI previews.

Integration points and things to not modify

- Do NOT add or modify `Assets.xcassets/AccentColor.colorset` or create new color assets for prototyping UI from screenshots — use system colors instead.
- App icon assets in `AppIcon.appiconset/` can remain unchanged; they are not relevant for layout prototyping.

When to ask for clarification

- If the screenshot contains a brand-specific color or font the user insists on keeping, ask whether it should be kept as a one-off or replaced with a neutral system equivalent.
- If a screenshot requires pixel-perfect raster images (photographs, illustrations), confirm whether to include those as temporary placeholders (use `Image("placeholder")`) or to recreate them as SwiftUI shapes.

Where to look for examples in this repo

- `PrototypeGUI/ContentView.swift` — simple example of a SwiftUI view and preview.
- `PrototypeGUI/PrototypeGUIApp.swift` — app entrypoint showing how views are composed into the WindowGroup.

Minimal acceptance criteria for generated changes

- New SwiftUI views build without adding asset-based colors or custom fonts.
- Views use semantic colors and dynamic fonts.
- Code includes previews using `#Preview` or `PreviewProvider` for quick verification.

If you make edits, run basic build and preview in Xcode and leave a short note in the PR describing which screenshots were converted and which system styles were chosen.

---

Please review this guidance. Tell me if you want stricter rules (for example: only use `.primary`/`.secondary` and never `.tint`), or if some brand tokens should be allowed.
