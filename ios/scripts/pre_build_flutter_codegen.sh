#!/bin/bash

# Xcode Pre-Build Script for Flutter Code Generation
# This script ensures all necessary Flutter code generation is completed before building

set -e

echo "🔧 Starting Flutter code generation for Xcode build..."

# Get the project root directory
# When run from Xcode, SRCROOT will be set to the ios directory
# When run manually, we need to determine the project root
if [ -n "$SRCROOT" ]; then
    # Running from Xcode
    PROJECT_ROOT="${SRCROOT}/.."
else
    # Running manually - find the project root by looking for pubspec.yaml
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_ROOT="$SCRIPT_DIR/../.."
fi

# Change to project root
cd "$PROJECT_ROOT"

echo "📂 Working directory: $(pwd)"

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Are we in the correct directory?"
    exit 1
fi

# Check if npm is available (for our generation scripts)
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is required for code generation but not found in PATH"
    exit 1
fi

# Check if flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: flutter command not found in PATH"
    exit 1
fi

# Check if dart is available
if ! command -v dart &> /dev/null; then
    echo "❌ Error: dart command not found in PATH"
    exit 1
fi

echo "✅ All required tools found"

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

# Ensure Flutter dependencies are up to date
run_command "flutter pub get" "Installing Flutter dependencies"

# Run environment configuration generation
run_command "dart run environment_config:generate" "Generating environment configuration"

# Activate and run spider for asset generation
run_command "dart pub global activate spider" "Activating Spider asset generator"
run_command "dart pub global run spider build" "Generating asset definitions"

# Run build_runner for code generation (JSON serialization, API clients, etc.)
run_command "dart run build_runner build --delete-conflicting-outputs" "Running build_runner code generation"

# Generate localization files
run_command "dart ./scripts/generate_localization.dart" "Generating localization files"

echo "🎉 All Flutter code generation completed successfully!"
echo "📱 Ready for Xcode build process..."