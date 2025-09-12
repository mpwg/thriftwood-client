#!/bin/bash

# Helper script to convert .p8 file to environment variable format
# Usage: ./convert_p8_to_env.sh path/to/AuthKey_XXXXXXXXXX.p8

set -e

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <path-to-p8-file>"
    echo ""
    echo "This script converts a .p8 API key file to the format needed for"
    echo "the APP_STORE_CONNECT_API_KEY_CONTENT environment variable."
    echo ""
    echo "Example:"
    echo "  $0 private_keys/AuthKey_XXXXXXXXXX.p8"
    exit 1
fi

P8_FILE="$1"

if [[ ! -f "$P8_FILE" ]]; then
    echo "❌ File not found: $P8_FILE"
    exit 1
fi

echo "🔑 Converting $P8_FILE to environment variable format..."
echo ""
echo "Copy the following line to your .env file:"
echo ""
echo "APP_STORE_CONNECT_API_KEY_CONTENT=\"$(cat "$P8_FILE")\""
echo ""
echo "✅ Conversion complete!"
echo ""
echo "💡 Tip: You can also copy the content manually from the .p8 file"
echo "    and paste it directly into the .env file, preserving the newlines."