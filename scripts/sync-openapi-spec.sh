#!/usr/bin/env bash
#
# sync-openapi-spec.sh
# 
# Syncs the OpenAPI specification from the canonical source to the service directory.
# This is needed because Xcode build plugins cannot follow symlinks.
#
# Usage: ./scripts/sync-openapi-spec.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_SPEC="$REPO_ROOT/openapi/radarr-v3.yaml"
DEST_SPEC="$REPO_ROOT/Thriftwood/Services/Radarr/openapi.yaml"

echo "🔄 Syncing OpenAPI spec..."
echo "   Source: $SOURCE_SPEC"
echo "   Dest:   $DEST_SPEC"

if [ ! -f "$SOURCE_SPEC" ]; then
    echo "❌ Error: Source spec not found: $SOURCE_SPEC"
    exit 1
fi

# Copy the file
cp "$SOURCE_SPEC" "$DEST_SPEC"

# Verify the copy
if cmp -s "$SOURCE_SPEC" "$DEST_SPEC"; then
    echo "✅ OpenAPI spec synced successfully"
    echo "   Size: $(du -h "$DEST_SPEC" | cut -f1)"
else
    echo "❌ Error: Files don't match after copy"
    exit 1
fi
