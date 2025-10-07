---
description: "GPL-3.0 license header requirements for all source files"
applyTo: "**/*.swift"
---

# License Header Requirements

## Mandatory GPL-3.0 Header

**Every source file in this project MUST include the GPL-3.0 license header.**

This is a legal requirement under the GNU General Public License v3.0 and ensures proper copyright notice and license terms are communicated.

## Swift Files Header Format

All Swift files (`.swift`) must begin with the following header:

```swift
//
//  <FileName>.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
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

import Foundation
// ... rest of file
```

### Template Variables

- `<FileName>`: Replace with the actual filename (e.g., `UserPreferencesService`)
- Copyright year: Update if creating files in a different year

## Other File Types

### Markdown Files (`.md`)

**Note**: Markdown documentation files use CC BY-SA 4.0 license instead of GPL-3.0.

```markdown
<!--
Thriftwood - Frontend for Media Management
Copyright (C) 2025 Matthias Wallner Géhri

This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
International License. To view a copy of this license, visit
http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
-->

# Document Title

...
```

### YAML Files (`.yml`, `.yaml`)

```yaml
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

name: CI
```

### Shell Scripts (`.sh`)

```bash
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

set -e
...
```

## Enforcement

### Automated Checks

The project includes automated enforcement:

1. **SwiftLint Custom Rule**: Checks for GPL-3.0 header in Swift files
2. **Pre-commit Hook**: Validates headers before commits
3. **CI Pipeline**: Blocks PRs without proper headers
4. **Header Script**: `scripts/check-license-headers.sh` validates and adds headers

### Running Manual Checks

```bash
# Check all files for missing headers
./scripts/check-license-headers.sh --check

# Add headers to files missing them
./scripts/check-license-headers.sh --add

# Check specific files
./scripts/check-license-headers.sh --check Thriftwood/**/*.swift
```

## Exemptions

The following files are exempt from header requirements:

- **Configuration files**: `Package.swift`, `*.xcconfig`, `Info.plist`
- **Generated files**: Build outputs, Xcode project files
- **Assets**: Images, fonts, JSON data files
- **Third-party code**: Files in `Pods/`, `vendor/`, or explicitly marked
- **Documentation**: `README.md`, `LICENSE`, `CHANGELOG.md`

## When Creating New Files

### Using Xcode

When creating new Swift files in Xcode:

1. Create the file as usual
2. Xcode will add a default header
3. Replace the entire header with the GPL-3.0 template
4. Update `<FileName>` with the actual filename

### Using GitHub Copilot

When asking Copilot to create files:

```
Create a new Swift file called UserService.swift with GPL-3.0 header
```

Copilot will automatically include the proper header based on these instructions.

### Using Command Line

```bash
# Use the script to create a file with header
./scripts/check-license-headers.sh --add Thriftwood/Services/NewService.swift
```

## Modifying Existing Files

When modifying existing files:

1. **DO NOT** change the copyright year unless making substantial changes
2. **DO NOT** remove or modify the existing header
3. **DO** ensure the header remains at the top of the file
4. **DO** add your name to contributors if making significant contributions (see CONTRIBUTORS.md)

## Legal Considerations

### Why This Header Matters

1. **Copyright Notice**: Establishes copyright ownership
2. **License Terms**: Clearly states the software is GPL-3.0
3. **Warranty Disclaimer**: Protects against liability claims
4. **Distribution Rights**: Informs users of their rights to redistribute

### Compliance

- **GPL-3.0 Requirement**: Section 5(a) requires "appropriate copyright notice"
- **Attribution**: Maintains proper attribution to the original author
- **License Propagation**: Ensures license terms travel with the code

## FAQ

**Q: Do test files need headers?**
A: Yes, all Swift files including tests must have the GPL-3.0 header.

**Q: What about auto-generated files?**
A: Files generated by build tools (e.g., SwiftGen, OpenAPI Generator) should include headers if possible, but are not strictly required.

**Q: Can I use a shorter header?**
A: No, the full GPL-3.0 header is required for legal compliance.

**Q: What if I'm contributing code?**
A: Use the same header. Do not add your name to the copyright line. See CONTRIBUTORS.md for attribution.

**Q: Header failed CI check - how do I fix it?**
A: Run `./scripts/check-license-headers.sh --add` to add missing headers automatically.

## References

- [GNU GPL v3.0 License](https://www.gnu.org/licenses/gpl-3.0.html)
- [GPL Header Tutorial](https://www.gnu.org/licenses/gpl-howto.html)
- Project License: `/LICENSE.md`
