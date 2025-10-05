#!/bin/bash

# Script to generate app icons from source image
# Usage: ./generate-app-icon.sh <source-image>

set -e

SOURCE_IMAGE="${1:-assets/images/Thriftwood.png}"
OUTPUT_DIR="Thriftwood/Assets.xcassets/AppIcon.appiconset"

if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "Error: Source image not found at $SOURCE_IMAGE"
    exit 1
fi

echo "Generating app icons from $SOURCE_IMAGE..."
echo "Output directory: $OUTPUT_DIR"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# macOS icon sizes
# 16x16, 32x32, 64x64, 128x128, 256x256, 512x512, 1024x1024
# Each with @1x and @2x variants where applicable

echo "Generating macOS icons..."

# 16x16
sips -z 16 16 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_16x16.png" > /dev/null
sips -z 32 32 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_16x16@2x.png" > /dev/null

# 32x32
sips -z 32 32 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_32x32.png" > /dev/null
sips -z 64 64 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_32x32@2x.png" > /dev/null

# 128x128
sips -z 128 128 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_128x128.png" > /dev/null
sips -z 256 256 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_128x128@2x.png" > /dev/null

# 256x256
sips -z 256 256 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_256x256.png" > /dev/null
sips -z 512 512 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_256x256@2x.png" > /dev/null

# 512x512
sips -z 512 512 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_512x512.png" > /dev/null
sips -z 1024 1024 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_512x512@2x.png" > /dev/null

# iOS/Universal 1024x1024
sips -z 1024 1024 "$SOURCE_IMAGE" --out "$OUTPUT_DIR/icon_1024x1024.png" > /dev/null

echo "✓ All icon sizes generated successfully!"
echo ""
echo "Generated icons:"
ls -lh "$OUTPUT_DIR"/*.png | awk '{print "  " $9 " (" $5 ")"}'
