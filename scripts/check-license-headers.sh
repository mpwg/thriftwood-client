#!/bin/bash
#
# Thriftwood - Frontend for Media Management
# Copyright (C) 2025 Matthias Wallner Géhri
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CURRENT_YEAR=$(date +%Y)

# GPL-3.0 Header Template for Swift
read -r -d '' SWIFT_HEADER_TEMPLATE << 'EOF' || true
//
//  FILENAME
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) YEAR Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

EOF

# Files to exclude from header checks
EXCLUDE_PATTERNS=(
    "*/legacy/*"
    "*/Pods/*"
    "*/.build/*"
    "*/DerivedData/*"
    "*/.git/*"
    "*/docs/*"
    "*.xcodeproj/*"
    "*.xcworkspace/*"
    "Package.swift"
    "*.md"
)

# Function to print usage
usage() {
    cat << USAGE
Usage: $(basename "$0") [OPTIONS] [FILES...]

Validate and manage GPL-3.0 license headers in Swift source files.

OPTIONS:
    --check         Check files for missing headers (default)
    --add           Add missing headers to files
    --fix           Alias for --add
    --verbose       Show detailed output
    --help          Show this help message

EXAMPLES:
    # Check all Swift files
    $(basename "$0") --check

    # Add headers to all Swift files
    $(basename "$0") --add

    # Check specific files
    $(basename "$0") --check Thriftwood/Core/*.swift

    # Add headers to specific files
    $(basename "$0") --add Thriftwood/Services/NewService.swift

EXIT CODES:
    0    All files have valid headers
    1    One or more files missing headers (in check mode)
    2    Invalid arguments or execution error

USAGE
    exit "${1:-0}"
}

# Function to check if file should be excluded
should_exclude() {
    local file="$1"
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ "$file" == $pattern ]]; then
            return 0
        fi
    done
    return 1
}

# Function to check if file has GPL-3.0 header
has_gpl_header() {
    local file="$1"
    
    # Check for key header components
    if grep -q "Thriftwood - Frontend for Media Management" "$file" && \
       grep -q "Copyright (C)" "$file" && \
       grep -q "GNU General Public License" "$file" && \
       grep -q "https://www.gnu.org/licenses/" "$file"; then
        return 0
    fi
    return 1
}

# Function to generate header for a file
generate_header() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo "$SWIFT_HEADER_TEMPLATE" | \
        sed "s/FILENAME/$filename/g" | \
        sed "s/YEAR/$CURRENT_YEAR/g"
}

# Function to add header to file
add_header() {
    local file="$1"
    local verbose="$2"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}Error: File not found: $file${NC}" >&2
        return 1
    fi
    
    # Check if already has header
    if has_gpl_header "$file"; then
        [[ "$verbose" == "true" ]] && echo -e "${GREEN}✓${NC} $file (already has header)"
        return 0
    fi
    
    # Create backup
    local backup="${file}.bak"
    cp "$file" "$backup"
    
    # Generate and prepend header
    local header=$(generate_header "$file")
    {
        echo "$header"
        cat "$backup"
    } > "$file"
    
    rm "$backup"
    
    echo -e "${BLUE}+${NC} Added header to: $file"
    return 0
}

# Function to check files
check_files() {
    local files=("$@")
    local missing=0
    local checked=0
    local verbose="$VERBOSE"
    
    echo -e "${BLUE}Checking GPL-3.0 license headers...${NC}\n"
    
    for file in "${files[@]}"; do
        # Skip if should be excluded
        if should_exclude "$file"; then
            [[ "$verbose" == "true" ]] && echo -e "${YELLOW}⊘${NC} $file (excluded)"
            continue
        fi
        
        ((checked++))
        
        if has_gpl_header "$file"; then
            [[ "$verbose" == "true" ]] && echo -e "${GREEN}✓${NC} $file"
        else
            echo -e "${RED}✗${NC} Missing header: $file"
            ((missing++))
        fi
    done
    
    echo ""
    echo "-----------------------------------"
    echo "Checked: $checked files"
    
    if [[ $missing -eq 0 ]]; then
        echo -e "${GREEN}All files have valid GPL-3.0 headers!${NC}"
        return 0
    else
        echo -e "${RED}Missing headers: $missing files${NC}"
        echo ""
        echo "To add missing headers, run:"
        echo "  $(basename "$0") --add"
        return 1
    fi
}

# Function to add headers to files
add_headers() {
    local files=("$@")
    local added=0
    local skipped=0
    local errors=0
    local verbose="$VERBOSE"
    
    echo -e "${BLUE}Adding GPL-3.0 license headers...${NC}\n"
    
    for file in "${files[@]}"; do
        # Skip if should be excluded
        if should_exclude "$file"; then
            [[ "$verbose" == "true" ]] && echo -e "${YELLOW}⊘${NC} $file (excluded)"
            ((skipped++))
            continue
        fi
        
        if add_header "$file" "$verbose"; then
            if has_gpl_header "$file"; then
                if [[ "$verbose" == "true" ]] || ! grep -q "already has header" <<< "$(add_header "$file" "false" 2>&1)"; then
                    ((added++))
                else
                    ((skipped++))
                fi
            fi
        else
            ((errors++))
        fi
    done
    
    echo ""
    echo "-----------------------------------"
    echo "Added: $added files"
    echo "Skipped: $skipped files"
    
    if [[ $errors -gt 0 ]]; then
        echo -e "${RED}Errors: $errors files${NC}"
        return 1
    else
        echo -e "${GREEN}Done!${NC}"
        return 0
    fi
}

# Function to find all Swift files
find_swift_files() {
    local search_paths=("${1:-$PROJECT_ROOT}")
    
    find "${search_paths[@]}" -type f -name "*.swift" 2>/dev/null | while read -r file; do
        should_exclude "$file" || echo "$file"
    done
}

# Main function
main() {
    local mode="check"
    local files=()
    VERBOSE="false"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --check)
                mode="check"
                shift
                ;;
            --add|--fix)
                mode="add"
                shift
                ;;
            --verbose|-v)
                VERBOSE="true"
                shift
                ;;
            --help|-h)
                usage 0
                ;;
            -*)
                echo -e "${RED}Error: Unknown option: $1${NC}" >&2
                usage 2
                ;;
            *)
                files+=("$1")
                shift
                ;;
        esac
    done
    
    # If no files specified, find all Swift files
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "${BLUE}Finding Swift files in project...${NC}"
        
        # Read files into array (compatible with both bash and zsh)
        while IFS= read -r file; do
            files+=("$file")
        done < <(find_swift_files "$PROJECT_ROOT/Thriftwood" "$PROJECT_ROOT/ThriftwoodTests")
        
        if [[ ${#files[@]} -eq 0 ]]; then
            echo -e "${YELLOW}No Swift files found${NC}"
            exit 0
        fi
        
        echo -e "${BLUE}Found ${#files[@]} Swift files${NC}\n"
    fi
    
    # Execute based on mode
    case "$mode" in
        check)
            check_files "${files[@]}"
            ;;
        add)
            add_headers "${files[@]}"
            ;;
        *)
            echo -e "${RED}Error: Invalid mode: $mode${NC}" >&2
            exit 2
            ;;
    esac
}

# Run main function
main "$@"
