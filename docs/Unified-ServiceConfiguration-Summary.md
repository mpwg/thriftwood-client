# Unified Service Configuration - Architecture Change Summary

## Date: October 4, 2025

## Overview

Replaced individual service configuration models with a single unified `ServiceConfiguration` model. This simplifies the data architecture and makes it easier to manage multiple service types through a common interface.

## Changes Made

### 1. Created Unified ServiceConfiguration Model

**File**: `Thriftwood/Core/Storage/Models/ServiceConfiguration.swift`

- **ServiceType enum**: Identifies service type (radarr, sonarr, lidarr, sabnzbd, nzbget, tautulli, overseerr, wakeOnLAN)
- **AuthenticationType enum**: Specifies authentication method (apiKey, usernamePassword, none)
- **Single @Model class**: Contains all possible fields for all service types
  - Common fields: id, serviceType, isEnabled, host, headers
  - API key auth: apiKey
  - Username/password auth: username, password
  - Wake on LAN: broadcastAddress, macAddress
- **Type-safe validation**: `isValid()` method switches on service type to validate appropriate fields
- **Cleaner architecture**: One model instead of 8 separate models

### 2. Updated Profile Model

**File**: `Thriftwood/Core/Storage/Models/Profile.swift`

**Before**:

```swift
var radarrConfiguration: RadarrConfiguration?
var sonarrConfiguration: SonarrConfiguration?
var lidarrConfiguration: LidarrConfiguration?
// ... 5 more individual configurations
```

**After**:

```swift
var serviceConfigurations: [ServiceConfiguration]
```

**New convenience methods**:

- `serviceConfiguration(for:)` - Get specific service by type
- `enabledServices()` - Get all enabled services
- `hasAnyServiceEnabled()` - Simplified using array contains

### 3. Updated Model Container

**File**: `Thriftwood/Core/Storage/ModelContainer+Thriftwood.swift`

Reduced schema from 11 models to 5:

- Profile
- AppSettings
- ServiceConfiguration (unified)
- Indexer
- ExternalModule

### 4. Updated Data Migration

**File**: `Thriftwood/Core/Storage/DataMigration.swift`

Updated SchemaV1 to reference unified ServiceConfiguration model.

### 5. Removed Individual Service Configuration Files

Deleted 8 files:

- `RadarrConfiguration.swift`
- `SonarrConfiguration.swift`
- `LidarrConfiguration.swift`
- `SABnzbdConfiguration.swift`
- `NZBGetConfiguration.swift`
- `TautulliConfiguration.swift`
- `OverseerrConfiguration.swift`
- `WakeOnLANConfiguration.swift`

### 6. Updated Tests

**File**: `ThriftwoodTests/DataServiceTests.swift`

Updated all service configuration tests to use the unified model:

- Service creation and attachment tests
- Cascade delete tests
- Validation tests (API key, username/password, Wake on LAN MAC address)

## Benefits

1. **Simplified Data Model**: One model instead of 8 reduces complexity
2. **Easier to Extend**: Adding new service types only requires adding enum case
3. **Better Querying**: Can filter/query all services uniformly
4. **Reduced Boilerplate**: Shared validation and helper logic
5. **Type Safety**: ServiceType enum ensures correct service identification
6. **Flexible Storage**: Same model handles different auth types (API key vs username/password)

## Migration Path

Since this is still in foundation phase (no production data yet), no data migration is needed. The unified model will be used from the start.

## Example Usage

```swift
// Create a Radarr configuration
let radarr = ServiceConfiguration(
    serviceType: .radarr,
    isEnabled: true,
    host: "https://radarr.example.com",
    authenticationType: .apiKey,
    apiKey: "my-api-key"
)

// Add to profile
profile.serviceConfigurations.append(radarr)

// Query by type
let radarrConfig = profile.serviceConfiguration(for: .radarr)

// Get all enabled services
let enabled = profile.enabledServices()
```

## Test Results

✅ All 55 tests passing:

- 25 Coordinator tests
- 30 Deep Link tests
- 18 Data Service tests (updated for unified model)
- 7 Error tests
- 1 Logger test

## Build Status

✅ Build succeeded with no errors or warnings

## Files Modified

- Thriftwood/Core/Storage/Models/ServiceConfiguration.swift (created)
- Thriftwood/Core/Storage/Models/Profile.swift (updated)
- Thriftwood/Core/Storage/ModelContainer+Thriftwood.swift (updated)
- Thriftwood/Core/Storage/DataMigration.swift (updated)
- ThriftwoodTests/DataServiceTests.swift (updated)
- 8 individual configuration files (deleted)

## Next Steps

1. Update DataService CRUD operations if needed for service-specific queries
2. Consider adding convenience factory methods to ServiceConfiguration extension
3. Update UI layer when implementing service configuration screens
4. Document the unified model pattern in architecture docs
