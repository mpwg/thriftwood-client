# Thriftwood App Icon

## Overview

The Thriftwood app icon features a stylized leaf design with warm orange and brown tones, symbolizing growth and natural organization - reflecting the app's purpose as a media management frontend.

## Icon Design

- **Concept**: Stylized leaf with tree branches
- **Primary Color**: Warm orange (#E67E22) - Also used as the app's accent color
- **Secondary Color**: Dark brown/burgundy
- **Style**: Modern, organic, with detailed line work
- **Resolution**: 2560x2560 source image

> **Note**: The warm orange from the icon (#E67E22) is used throughout the app as the primary accent color,
> creating visual cohesion between the icon and the user interface.
> See `docs/implementation-summaries/accent-color-update.md` for details.

## Asset Structure

All app icons are stored in `Thriftwood/Assets.xcassets/AppIcon.appiconset/` with the following sizes:

### macOS Icons

- **16x16** (`icon_16x16.png`, `icon_16x16@2x.png`)
- **32x32** (`icon_32x32.png`, `icon_32x32@2x.png`)
- **128x128** (`icon_128x128.png`, `icon_128x128@2x.png`)
- **256x256** (`icon_256x256.png`, `icon_256x256@2x.png`)
- **512x512** (`icon_512x512.png`, `icon_512x512@2x.png`)

### iOS/Universal Icons

- **1024x1024** (`icon_1024x1024.png`)

## Regenerating Icons

If you need to update the app icon:

1. Place the new source image (minimum 1024x1024, ideally 2560x2560 or higher) at `assets/images/Thriftwood.png`
2. Run the generation script:

   ```bash
   ./scripts/generate-app-icon.sh
   ```

3. The script will automatically generate all required sizes and place them in the correct location

## Source Image Location

The original high-resolution source image is stored at:

- `assets/images/Thriftwood.png` (2560x2560)

## Technical Details

- **Format**: PNG with transparency support
- **Color Profile**: sRGB
- **Platform**: macOS (Mac Catalyst) and iOS
- **Xcode Asset Catalog**: Properly configured in `Contents.json`

## Design Rationale

The leaf motif was chosen to represent:

- **Growth**: Media collections that expand over time
- **Organization**: Natural structure and hierarchy
- **Sustainability**: Efficient media management
- **Warmth**: User-friendly interface

The warm color palette creates an inviting, approachable feel while maintaining professionalism.

## Attribution

Icon design created specifically for Thriftwood.
Copyright (C) 2025 Matthias Wallner Géhri
Licensed under GPL-3.0
