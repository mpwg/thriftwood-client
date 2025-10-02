# Flutter Migration Bridge - TEMPORARY CODE

## ⚠️ MIGRATION RULE: Everything in this folder is TEMPORARY

**This entire folder and all its contents will be DELETED when the migration to pure SwiftUI is complete.**

### What belongs in ios/FlutterBridge

1. **Flutter Engine Integration:**

   - Flutter engine initialization logic
   - Method channel handlers and dispatchers
   - Plugin registration and setup

2. **Hybrid Navigation System:**

   - Bridge components for Flutter ↔ SwiftUI navigation
   - Route detection and delegation logic
   - Navigation history management

3. **Data Synchronization:**

   - Code that syncs data between Flutter Hive and Swift SwiftData
   - Bridge handlers for data access from Flutter
   - Migration-specific data transformation logic

4. **Bridge Components:**
   - All classes with "Bridge" in the name
   - Method channel communication code
   - Hybrid coordination logic

### What belongs in ios/Native

1. **Pure SwiftUI Architecture:**

   - SwiftUI Views and ViewModels
   - SwiftData Models
   - Native Swift Services
   - Pure iOS app structure

2. **Permanent Features:**
   - Code that will remain after Flutter is completely removed
   - Native iOS integrations and capabilities
   - Pure Swift business logic

### File Organization Rules

- **If it mentions Flutter, method channels, or bridge → goes in ios/FlutterBridge/**
- **If it's pure SwiftUI/Swift that will remain after migration → goes in ios/Native/**
- **If only part of a file is temporary → split the file and move temporary parts here**

### When Migration is Complete

1. Delete entire `ios/FlutterBridge/` folder
2. Remove Flutter dependencies from Podfile
3. Clean up AppDelegate from Flutter-specific code
4. Remove Flutter method channel references
