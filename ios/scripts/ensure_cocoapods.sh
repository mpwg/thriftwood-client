#!/bin/bash

# Xcode CocoaPods Installation Script
# This script ensures CocoaPods dependencies are properly installed before building

set -e

echo "🏗️ Ensuring CocoaPods dependencies are ready..."

# Get the iOS directory (assuming this script is in ios/)
IOS_DIR="${SRCROOT}"

# Change to iOS directory
cd "$IOS_DIR"

echo "📂 Working directory: $(pwd)"

# Check if we're in the iOS directory
if [ ! -f "Podfile" ]; then
    echo "❌ Error: Podfile not found. Are we in the iOS directory?"
    exit 1
fi

# Check if pod command is available
if ! command -v pod &> /dev/null; then
    echo "❌ Error: CocoaPods (pod command) not found in PATH"
    echo "💡 Install CocoaPods with: sudo gem install cocoapods"
    exit 1
fi

echo "✅ CocoaPods found"

# Function to run command with error handling
run_command() {
    local command="$1"
    local description="$2"
    
    echo "🔄 $description..."
    if eval "$command"; then
        echo "✅ $description completed successfully"
    else
        echo "❌ $description failed"
        exit 1
    fi
}

# Check if Podfile.lock exists and Pods directory exists
if [ -f "Podfile.lock" ] && [ -d "Pods" ]; then
    echo "📦 Existing CocoaPods installation found"
    
    # Check if Podfile is newer than Podfile.lock
    if [ "Podfile" -nt "Podfile.lock" ]; then
        echo "⚠️  Podfile is newer than Podfile.lock, updating pods..."
        run_command "pod install --repo-update" "Updating CocoaPods dependencies"
    else
        echo "✅ CocoaPods dependencies are up to date"
    fi
else
    echo "🆕 No existing CocoaPods installation found, installing..."
    run_command "pod install --repo-update" "Installing CocoaPods dependencies"
fi

# Verify the installation
if [ ! -d "Pods" ]; then
    echo "❌ Error: Pods directory not found after installation"
    exit 1
fi

if [ ! -f "Podfile.lock" ]; then
    echo "❌ Error: Podfile.lock not found after installation"
    exit 1
fi

echo "🎉 CocoaPods dependencies are ready!"
echo "📱 Ready for Xcode build process..."