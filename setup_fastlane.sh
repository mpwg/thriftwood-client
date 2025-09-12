#!/bin/bash

# Fastlane Setup Script for Thriftwood iOS
# This script helps set up the necessary environment for running Fastlane

set -e

echo "🚀 Setting up Fastlane for Thriftwood iOS..."

# Check if we're in the right directory
if [[ ! -d "ThriftwoodNative" ]]; then
    echo "❌ Please run this script from the . directory"
    exit 1
fi

# Check if .env file exists
if [[ ! -f ".env" ]]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created. Please edit it with your actual values."
    echo ""
    echo "📋 You need to set the following values:"
    echo "   - APPLE_ID: Your Apple Developer account email"
    echo "   - ITUNES_TEAM_ID: Your App Store Connect Team ID"
    echo "   - APPSTORE_TEAM_ID: Your Developer Portal Team ID"
    echo "   - APP_STORE_CONNECT_API_KEY_*: Your API key details"
    echo "   - APP_STORE_CONNECT_API_KEY_CONTENT: Your private key content"
    echo "   - MATCH_PASSWORD: Password for your certificates repository"
    echo ""
else
    echo "✅ .env file already exists"
fi

# Create private_keys directory if it doesn't exist
if [[ ! -d "private_keys" ]]; then
    echo "📁 Creating private_keys directory (for backup/reference)..."
    mkdir -p private_keys
    echo "✅ private_keys directory created"
    echo "📋 You can optionally store your .p8 file here for reference,"
    echo "    but the actual key content should be in the .env file"
    echo ""
fi

# Check if bundle is available
if ! command -v bundle >/dev/null 2>&1; then
    echo "❌ Bundler is not installed. Install it with:"
    echo "   gem install --user-install bundler"
    exit 1
fi

# Install gems
echo "💎 Installing Ruby gems..."
cd ThriftwoodNative
bundle install
cd ..

echo ""
echo "✅ Fastlane setup complete!"
echo ""
echo "🔧 Next steps:"
echo "1. Edit the .env file with your actual values"
echo "2. Copy your App Store Connect API key content into APP_STORE_CONNECT_API_KEY_CONTENT"
echo "3. Test the setup with: bundle exec fastlane ios certificates"
echo ""
echo "📚 Useful commands:"
echo "   bundle exec fastlane ios build     # Build the app"
echo "   bundle exec fastlane ios beta      # Upload to TestFlight"
echo "   bundle exec fastlane ios release   # Upload to App Store"
echo ""