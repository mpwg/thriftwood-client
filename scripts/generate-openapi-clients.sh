#!/bin/bash
#
# generate-openapi-clients.sh
# Thriftwood - Generate Swift 6 API clients from OpenAPI specifications
#
# Copyright (C) 2025 Matthias Wallner Géhri
# Licensed under GPL-3.0

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Directories
OPENAPI_DIR="$PROJECT_ROOT/openapi"
SERVICES_DIR="$PROJECT_ROOT/Thriftwood/Services"

# Check if openapi-generator is installed
if ! command -v openapi-generator &> /dev/null; then
    echo -e "${RED}Error: openapi-generator is not installed${NC}"
    echo "Install via Homebrew: brew install openapi-generator"
    exit 1
fi

# Verify openapi-generator version
GENERATOR_VERSION=$(openapi-generator version)
echo -e "${GREEN}Using openapi-generator version: $GENERATOR_VERSION${NC}"

# Function to generate client for a service
generate_client() {
    local service_name=$1
    local spec_file=$2
    local config_file=$3
    local output_dir=$4
    
    echo -e "${YELLOW}Generating $service_name client...${NC}"
    
    # Check if spec file exists
    if [ ! -f "$spec_file" ]; then
        echo -e "${RED}Error: Spec file not found: $spec_file${NC}"
        return 1
    fi
    
    # Check if config file exists
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}Error: Config file not found: $config_file${NC}"
        return 1
    fi
    
    # Remove old generated code
    if [ -d "$output_dir" ]; then
        echo "Removing old generated code..."
        rm -rf "$output_dir"
    fi
    
    # Generate new client
    openapi-generator generate \
        -i "$spec_file" \
        -g swift6 \
        -c "$config_file" \
        -o "$output_dir" \
        --skip-validate-spec \
        --additional-properties=projectName="${service_name}API"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $service_name client generated successfully${NC}"
        
        # Count generated files
        local file_count=$(find "$output_dir" -name "*.swift" | wc -l | tr -d ' ')
        echo "  Generated $file_count Swift files"
        
        return 0
    else
        echo -e "${RED}✗ Failed to generate $service_name client${NC}"
        return 1
    fi
}

# Main execution
main() {
    echo "================================================"
    echo "  Thriftwood OpenAPI Client Generation"
    echo "================================================"
    echo ""
    
    local total=0
    local success=0
    local failed=0
    
    # Generate Radarr client
    if [ -f "$OPENAPI_DIR/radarr-v3.yaml" ]; then
        total=$((total + 1))
        if generate_client "Radarr" \
            "$OPENAPI_DIR/radarr-v3.yaml" \
            "$OPENAPI_DIR/radarr-config.yaml" \
            "$SERVICES_DIR/Radarr/Generated"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
        echo ""
    fi
    
    # Generate Sonarr client (if spec exists)
    if [ -f "$OPENAPI_DIR/sonarr-v3.yaml" ]; then
        total=$((total + 1))
        if generate_client "Sonarr" \
            "$OPENAPI_DIR/sonarr-v3.yaml" \
            "$OPENAPI_DIR/sonarr-config.yaml" \
            "$SERVICES_DIR/Sonarr/Generated"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
        echo ""
    fi
    
    # Generate Lidarr client (if spec exists)
    if [ -f "$OPENAPI_DIR/lidarr-v1.yaml" ]; then
        total=$((total + 1))
        if generate_client "Lidarr" \
            "$OPENAPI_DIR/lidarr-v1.yaml" \
            "$OPENAPI_DIR/lidarr-config.yaml" \
            "$SERVICES_DIR/Lidarr/Generated"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
        echo ""
    fi
    
    # Summary
    echo "================================================"
    echo "  Generation Summary"
    echo "================================================"
    echo "Total:   $total"
    echo -e "Success: ${GREEN}$success${NC}"
    if [ $failed -gt 0 ]; then
        echo -e "Failed:  ${RED}$failed${NC}"
    else
        echo "Failed:  0"
    fi
    echo ""
    
    if [ $failed -gt 0 ]; then
        echo -e "${RED}Some clients failed to generate${NC}"
        exit 1
    else
        echo -e "${GREEN}All clients generated successfully!${NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Review generated code: git diff Thriftwood/Services/*/Generated/"
        echo "  2. Add to Xcode project if new files were created"
        echo "  3. Build project: xcodebuild -project Thriftwood.xcodeproj -scheme Thriftwood"
        echo "  4. Run tests: xcodebuild test -project Thriftwood.xcodeproj -scheme Thriftwood"
        echo "  5. Commit changes: git add Thriftwood/Services/*/Generated/"
    fi
}

# Run main function
main "$@"
