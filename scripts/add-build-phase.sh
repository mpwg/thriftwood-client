#!/bin/bash

# Add Build Phase Script
# Adds the "Generate Acknowledgements" build phase to Thriftwood.xcodeproj
# This script safely modifies the project.pbxproj file

set -e

PROJECT_FILE="Thriftwood.xcodeproj/project.pbxproj"
BACKUP_FILE="${PROJECT_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=================================================="
echo "Add Generate Acknowledgements Build Phase"
echo "=================================================="
echo ""

# Check if project file exists
if [ ! -f "$PROJECT_FILE" ]; then
    echo -e "${RED}Error: Project file not found at $PROJECT_FILE${NC}"
    echo "Please run this script from the project root directory."
    exit 1
fi

# Create backup
echo -e "${YELLOW}Creating backup: $BACKUP_FILE${NC}"
cp "$PROJECT_FILE" "$BACKUP_FILE"

# Generate unique UUID (24 characters for Xcode)
generate_uuid() {
    uuidgen | tr '[:lower:]' '[:upper:]' | tr -d '-' | cut -c1-24
}

SCRIPT_PHASE_UUID=$(generate_uuid)

echo ""
echo "Generated UUID for build phase: $SCRIPT_PHASE_UUID"
echo ""

# Create a temporary file with the build phase definition
cat > /tmp/build_phase_def.txt <<'EOFPHASE'
		PHASE_UUID /* Generate Acknowledgements */ = {
			isa = PBXShellScriptBuildPhase;
			alwaysOutOfDate = 1;
			buildActionMask = 2147483647;
			files = (
			);
			inputPaths = (
			);
			name = "Generate Acknowledgements";
			outputPaths = (
			);
			runOnlyForDeploymentPostprocessing = 0;
			shellPath = /bin/sh;
			shellScript = "# Generate acknowledgements.json from SPM dependencies\nif [ -f \"${SRCROOT}/scripts/generate-acknowledgements.sh\" ]; then\n    echo \"Generating acknowledgements from SPM dependencies...\"\n    \"${SRCROOT}/scripts/generate-acknowledgements.sh\"\nelse\n    echo \"Warning: generate-acknowledgements.sh not found at ${SRCROOT}/scripts/\"\nfi\n";
			showEnvVarsInLog = 0;
		};
EOFPHASE

# Replace PHASE_UUID placeholder with actual UUID
sed "s/PHASE_UUID/$SCRIPT_PHASE_UUID/g" /tmp/build_phase_def.txt > /tmp/build_phase_final.txt

# Check if the phase already exists
if grep -q "Generate Acknowledgements" "$PROJECT_FILE"; then
    echo -e "${YELLOW}Warning: A 'Generate Acknowledgements' build phase already exists.${NC}"
    echo "The project file has not been modified."
    echo ""
    echo "To update the existing phase:"
    echo "1. Open Xcode"
    echo "2. Select the Thriftwood target → Build Phases"
    echo "3. Remove the existing 'Generate Acknowledgements' phase"
    echo "4. Re-run this script"
    exit 0
fi

# Find or create the PBXShellScriptBuildPhase section
if ! grep -q "PBXShellScriptBuildPhase section" "$PROJECT_FILE"; then
    echo "Creating new PBXShellScriptBuildPhase section..."
    # Insert new section after PBXResourcesBuildPhase section
    awk '
        /\/\* End PBXResourcesBuildPhase section \*\// {
            print
            print ""
            print "/* Begin PBXShellScriptBuildPhase section */"
            while (getline line < "/tmp/build_phase_final.txt") print line
            print "/* End PBXShellScriptBuildPhase section */"
            next
        }
        { print }
    ' "$PROJECT_FILE" > "${PROJECT_FILE}.tmp" && mv "${PROJECT_FILE}.tmp" "$PROJECT_FILE"
else
    echo "Adding to existing PBXShellScriptBuildPhase section..."
    # Add the build phase definition to the PBXShellScriptBuildPhase section
    awk '
        /\/\* Begin PBXShellScriptBuildPhase section \*\// {
            print
            while (getline line < "/tmp/build_phase_final.txt") print line
            next
        }
        { print }
    ' "$PROJECT_FILE" > "${PROJECT_FILE}.tmp" && mv "${PROJECT_FILE}.tmp" "$PROJECT_FILE"
fi

# Find the Thriftwood target and add the build phase UUID to its buildPhases array
# We need to add it after the "buildPhases = (" line in the Thriftwood target
awk -v uuid="$SCRIPT_PHASE_UUID" '
    /402888362E90441F005376F0 \/\* Thriftwood \*\/ = \{/ {
        in_target = 1
    }
    in_target && /buildPhases = \(/ {
        print
        print "\t\t\t\t" uuid " /* Generate Acknowledgements */,"
        in_target = 0
        next
    }
    { print }
' "$PROJECT_FILE" > "${PROJECT_FILE}.tmp" && mv "${PROJECT_FILE}.tmp" "$PROJECT_FILE"

echo -e "${GREEN}✅ Successfully added 'Generate Acknowledgements' build phase${NC}"
echo ""
echo "Backup saved at: $BACKUP_FILE"
echo ""
echo "Next steps:"
echo "1. Open Thriftwood.xcodeproj in Xcode"
echo "2. Select Thriftwood target → Build Phases"
echo "3. Verify the 'Generate Acknowledgements' phase appears"
echo "4. (Optional) Drag it to run before 'Copy Bundle Resources'"
echo "5. (Optional) Add Input Files: \$(SRCROOT)/Package.resolved"
echo "6. (Optional) Add Output Files: \$(SRCROOT)/Thriftwood/Resources/acknowledgements.json"
echo "7. Build the project to test: Cmd+B"
echo ""
echo "To revert changes:"
echo "  cp $BACKUP_FILE $PROJECT_FILE"
echo ""
