#!/bin/bash

# Generate acknowledgements JSON from Swift Package Manager dependencies
# This script reads Package.resolved and collects license information from checked-out packages

set -e

# Use SRCROOT if available (set by Xcode), otherwise use current directory
PROJECT_DIR="${SRCROOT:-$(pwd)}"
PACKAGE_RESOLVED="$PROJECT_DIR/Thriftwood.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved"
OUTPUT_FILE="$PROJECT_DIR/Thriftwood/Resources/acknowledgements.json"

echo "Generating acknowledgements from Swift Package Manager dependencies..."

# Detect DerivedData location
# When run from Xcode, BUILD_DIR contains the path to DerivedData
if [ -n "$BUILD_DIR" ]; then
    # Extract DerivedData path from BUILD_DIR (e.g., /path/to/DerivedData/Project-xxx/Build/Products)
    PROJECT_DERIVED_DATA=$(echo "$BUILD_DIR" | sed 's/\(.*\/DerivedData\/[^/]*\).*/\1/')
else
    # Fallback: search for Thriftwood DerivedData in standard location
    DERIVED_DATA="${DERIVED_DATA_DIR:-$HOME/Library/Developer/Xcode/DerivedData}"
    PROJECT_DERIVED_DATA=$(ls -dt "$DERIVED_DATA"/Thriftwood-* 2>/dev/null | head -1)
fi

if [ -z "$PROJECT_DERIVED_DATA" ]; then
    echo "Warning: Could not find Thriftwood DerivedData directory"
    echo "Packages may not be resolved yet. Run 'xcodebuild -resolvePackageDependencies' first."
    exit 0
fi

CHECKOUT_BASE="$PROJECT_DERIVED_DATA/SourcePackages/checkouts"

if [ ! -d "$CHECKOUT_BASE" ]; then
    echo "Warning: SourcePackages/checkouts not found at $CHECKOUT_BASE"
    echo "Packages may not be resolved yet. Run 'xcodebuild -resolvePackageDependencies' first."
    exit 0
fi

echo "Found checkouts at: $CHECKOUT_BASE"

# Create Resources directory if it doesn't exist
mkdir -p "$PROJECT_DIR/Thriftwood/Resources"

# Start JSON output
cat > "$OUTPUT_FILE" << EOF
{
  "generated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "dependencies": [
EOF

# Read Package.resolved and extract dependencies
FIRST=true

while IFS= read -r line; do
    if echo "$line" | grep -q '"identity"'; then
        IDENTITY=$(echo "$line" | sed 's/.*"identity" : "\(.*\)".*/\1/')
        
        # Find the checkout directory (identity might have different casing)
        PACKAGE_DIR=$(find "$CHECKOUT_BASE" -maxdepth 1 -type d -iname "$IDENTITY" 2>/dev/null | head -1)
        
        if [ -z "$PACKAGE_DIR" ]; then
            continue
        fi
        
        PACKAGE_NAME=$(basename "$PACKAGE_DIR")
        
        # Find LICENSE file (various naming conventions)
        LICENSE_FILE=$(find "$PACKAGE_DIR" -maxdepth 1 -type f \( -iname "LICENSE*" -o -iname "COPYING*" \) 2>/dev/null | head -1)
        
        # Extract repository URL and version from Package.resolved
        REPO_URL=""
        VERSION=""
        IN_BLOCK=false
        
        while IFS= read -r detail_line; do
            if echo "$detail_line" | grep -q "\"identity\" : \"$IDENTITY\""; then
                IN_BLOCK=true
            fi
            
            if [ "$IN_BLOCK" = true ]; then
                if echo "$detail_line" | grep -q '"location"'; then
                    REPO_URL=$(echo "$detail_line" | sed 's/.*"location" : "\(.*\)".*/\1/' | tr -d ',')
                fi
                if echo "$detail_line" | grep -q '"version"'; then
                    VERSION=$(echo "$detail_line" | sed 's/.*"version" : "\(.*\)".*/\1/' | tr -d ',')
                fi
                if echo "$detail_line" | grep -q '^[[:space:]]*}[[:space:]]*$'; then
                    break
                fi
            fi
        done < "$PACKAGE_RESOLVED"
        
        # Determine license type from LICENSE file content
        LICENSE_TYPE="Unknown"
        if [ -n "$LICENSE_FILE" ]; then
            if grep -qi "apache.*2\.0\|apache.*version 2" "$LICENSE_FILE"; then
                LICENSE_TYPE="Apache-2.0"
            elif grep -qi "mit license" "$LICENSE_FILE"; then
                LICENSE_TYPE="MIT"
            elif grep -qi "bsd.*3-clause" "$LICENSE_FILE"; then
                LICENSE_TYPE="BSD-3-Clause"
            elif grep -qi "bsd.*2-clause" "$LICENSE_FILE"; then
                LICENSE_TYPE="BSD-2-Clause"
            elif grep -qi "gnu.*general.*public.*license.*version 3\|gplv3" "$LICENSE_FILE"; then
                LICENSE_TYPE="GPL-3.0"
            elif grep -qi "gnu.*lesser.*general.*public.*license\|lgpl" "$LICENSE_FILE"; then
                LICENSE_TYPE="LGPL"
            fi
            
            # Read license text (escape for JSON)
            LICENSE_TEXT=$(sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/g' "$LICENSE_FILE" | tr -d '\n' | sed 's/\\n$//')
        else
            LICENSE_TEXT=""
        fi
        
        # Add comma before entry if not first
        if [ "$FIRST" = false ]; then
            echo "," >> "$OUTPUT_FILE"
        fi
        FIRST=false
        
        # Write JSON entry
        cat >> "$OUTPUT_FILE" << EOF
    {
      "name": "$PACKAGE_NAME",
      "version": "$VERSION",
      "repository": "$REPO_URL",
      "licenseType": "$LICENSE_TYPE",
      "licenseText": "$LICENSE_TEXT"
    }
EOF
        
        echo "  ✓ Processed: $PACKAGE_NAME ($LICENSE_TYPE)"
    fi
done < "$PACKAGE_RESOLVED"

# Close JSON
cat >> "$OUTPUT_FILE" << 'EOF'

  ]
}
EOF

echo ""
echo "✅ Generated acknowledgements.json with $(grep -c '"name"' "$OUTPUT_FILE") dependencies"
echo "   Output: $OUTPUT_FILE"
