#!/bin/bash

# GitHub Secrets Import Script
# Imports secrets from .env file to GitHub repository using gh CLI
#
# Usage: ./scripts/import-github-secrets.sh [env-file] [repository]
#
# Arguments:
#   env-file    - Path to .env file (default: .env)
#   repository  - GitHub repository in owner/repo format (default: current repo)
#
# Prerequisites:
#   - GitHub CLI (gh) installed and authenticated
#   - .env file with secrets in KEY=value format
#   - Repository access with admin permissions

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENV_FILE="${1:-.env}"
REPOSITORY="${2:-}"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed. Please install it first:"
        print_error "  brew install gh  # macOS"
        print_error "  # or visit https://cli.github.com/"
        exit 1
    fi

    # Check if gh is authenticated
    if ! gh auth status &> /dev/null; then
        print_error "GitHub CLI is not authenticated. Please run:"
        print_error "  gh auth login"
        exit 1
    fi

    # Check if .env file exists
    if [[ ! -f "$ENV_FILE" ]]; then
        print_error ".env file not found: $ENV_FILE"
        print_error "Please create a .env file with your secrets in KEY=value format"
        exit 1
    fi

    print_success "Prerequisites check passed"
}

# Function to determine repository
get_repository() {
    if [[ -z "$REPOSITORY" ]]; then
        # Try to get repository from git remote
        if git remote get-url origin &> /dev/null; then
            local origin_url
            origin_url=$(git remote get-url origin)
            # Extract owner/repo from various URL formats
            if [[ $origin_url =~ github\.com[:/]([^/]+/[^/]+)(\.git)?$ ]]; then
                REPOSITORY="${BASH_REMATCH[1]}"
                REPOSITORY="${REPOSITORY%.git}"
                print_status "Auto-detected repository: $REPOSITORY"
            else
                print_error "Could not parse repository from git remote origin"
                print_error "Please specify repository manually: ./scripts/import-github-secrets.sh .env owner/repo"
                exit 1
            fi
        else
            print_error "No git remote found and no repository specified"
            print_error "Please specify repository: ./scripts/import-github-secrets.sh .env owner/repo"
            exit 1
        fi
    else
        print_status "Using specified repository: $REPOSITORY"
    fi
}

# Function to validate repository access
validate_repository_access() {
    print_status "Validating repository access..."

    if ! gh repo view "$REPOSITORY" &> /dev/null; then
        print_error "Cannot access repository: $REPOSITORY"
        print_error "Please check:"
        print_error "  - Repository exists"
        print_error "  - You have access to the repository"
        print_error "  - Repository name is in owner/repo format"
        exit 1
    fi

    print_success "Repository access validated"
}

# Function to parse and validate .env file
parse_env_file() {
    print_status "Parsing .env file: $ENV_FILE"

    # Read .env file and extract valid secrets
    local secrets=()
    local line_num=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        ((line_num++))

        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi

        # Check if line matches KEY=value format
        if [[ "$line" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"

            # Remove surrounding quotes if present
            if [[ "$value" =~ ^\"(.*)\"$ ]]; then
                value="${BASH_REMATCH[1]}"
            elif [[ "$value" =~ ^\'(.*)\'$ ]]; then
                value="${BASH_REMATCH[1]}"
            fi

            # Skip empty values
            if [[ -z "$value" ]]; then
                print_warning "Skipping empty secret: $key (line $line_num)"
                continue
            fi

            secrets+=("$key=$value")
        else
            print_warning "Skipping invalid line $line_num: $line"
        fi
    done < "$ENV_FILE"

    if [[ ${#secrets[@]} -eq 0 ]]; then
        print_error "No valid secrets found in $ENV_FILE"
        print_error "Expected format: KEY=value"
        exit 1
    fi

    print_success "Found ${#secrets[@]} secrets to import"

    # Return secrets array
    printf '%s\n' "${secrets[@]}"
}

# Function to import secrets
import_secrets() {
    local secrets=("$@")
    local success_count=0
    local error_count=0

    print_status "Importing secrets to repository: $REPOSITORY"
    echo

    for secret_line in "${secrets[@]}"; do
        # Parse key=value
        local key="${secret_line%%=*}"
        local value="${secret_line#*=}"

        printf "  %-30s ... " "$key"

        # Import secret using gh CLI (securely via temporary file)
        local tmpfile
        tmpfile=$(mktemp)
        chmod 600 "$tmpfile"
        printf '%s' "$value" > "$tmpfile"
        if gh secret set "$key" --repo "$REPOSITORY" < "$tmpfile" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
            ((success_count++))
        else
            echo -e "${RED}✗${NC}"
            ((error_count++))
        fi
        rm -f "$tmpfile"
    done

    echo
    print_success "Import completed: $success_count succeeded, $error_count failed"

    if [[ $error_count -gt 0 ]]; then
        print_warning "Some secrets failed to import. Please check:"
        print_warning "  - Repository admin permissions"
        print_warning "  - Secret name format (uppercase letters, numbers, underscores only)"
        print_warning "  - Network connectivity"
        return 1
    fi
}

# Function to list current secrets (for verification)
list_current_secrets() {
    print_status "Current repository secrets:"

    if gh secret list --repo "$REPOSITORY" 2>/dev/null; then
        echo
    else
        print_warning "Could not list current secrets (may require admin permissions)"
    fi
}

# Main function
main() {
    echo "🔐 GitHub Secrets Import Script"
    echo "==============================="
    echo

    check_prerequisites
    get_repository
    validate_repository_access

    # Parse secrets from .env file
    local secrets_array
    mapfile -t secrets_array < <(parse_env_file)

    echo
    print_status "Secrets to be imported:"
    for secret_line in "${secrets_array[@]}"; do
        local key="${secret_line%%=*}"
        echo "  - $key"
    done

    echo
    read -p "Continue with import? [y/N] " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Import cancelled"
        exit 0
    fi

    # Import secrets
    if import_secrets "${secrets_array[@]}"; then
        echo
        list_current_secrets
        print_success "All secrets imported successfully! 🎉"
    else
        print_error "Some secrets failed to import"
        exit 1
    fi
}

# Show help if requested
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "GitHub Secrets Import Script"
    echo
    echo "Usage: $0 [env-file] [repository]"
    echo
    echo "Arguments:"
    echo "  env-file    Path to .env file (default: .env)"
    echo "  repository  GitHub repository in owner/repo format (default: auto-detect)"
    echo
    echo "Examples:"
    echo "  $0                           # Use .env and auto-detect repo"
    echo "  $0 secrets.env               # Use custom env file"
    echo "  $0 .env owner/repo           # Specify repository"
    echo
    echo "Prerequisites:"
    echo "  - GitHub CLI (gh) installed and authenticated"
    echo "  - .env file with secrets in KEY=value format"
    echo "  - Repository admin permissions"
    exit 0
fi

# Run main function
main "$@"