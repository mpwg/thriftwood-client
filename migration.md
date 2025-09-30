# Thriftwood Flutter to SwiftUI Hybrid Migration Plan

## Executive Summary

This document outlines a hybrid migration strategy to gradually transition Thriftwood from Flutter to pure SwiftUI on iOS. The approach maintains a fully functional app at every step, allowing Flutter and SwiftUI views to coexist seamlessly while transitioning one view at a time.

## Migration Philosophy

**Hybrid Coexistence Strategy:**

- Start with 100% Flutter app
- Gradually replace individual views with SwiftUI equivalents
- Maintain seamless navigation between Flutter and SwiftUI views
- End with 100% SwiftUI app
- App remains fully functional at every step of the migration

## User Migration Control

**User Choice During Migration:**

During the hybrid migration period, users have complete control over which implementation they use through a settings toggle. This ensures users can:

- **Fallback to stability**: If a SwiftUI implementation has issues, users can instantly switch back to the proven Flutter version
- **Test new features**: Users can opt into SwiftUI implementations to test new iOS-native features and performance improvements
- **Gradual adoption**: Users comfortable with the current Flutter experience can delay migration until SwiftUI versions are fully mature

**Implementation Details:**

- **Toggle Location**: Main Settings screen (`Settings > Settings Version`)
- **Database Storage**: `LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI`
- **Default State**: Flutter (for maximum stability)
- **Scope**: Affects all settings navigation and related features
- **Data Consistency**: Both implementations read from the same data store
- **Real-time Switching**: Changes take effect immediately without app restart

**User Experience:**

```text
Settings Version
┌─────────────────────────────────────────────────────────┐
│ Currently using SwiftUI settings (iOS native experience) │
│                                               [Toggle ON] │
└─────────────────────────────────────────────────────────┘

Settings Version
┌──────────────────────────────────────────────────────────┐
│ Currently using Flutter settings (cross-platform experience) │
│                                               [Toggle OFF] │
└──────────────────────────────────────────────────────────┘
```

## Current State Analysis

### Flutter Implementation Structure

- **lib/modules/**: Feature modules (dashboard, radarr, sonarr, lidarr, etc.)
- **lib/core/api/**: Service API implementations
- **lib/core/database/**: Profile management and configuration
- **lib/core/ui/**: Shared UI components
- **ios/**: Flutter iOS app with Runner target

### Target State

- Pure SwiftUI iOS app
- Modern Swift 6 with async/await and actors
- SwiftData for persistence
- iOS 18+ features and optimizations

## Hybrid Architecture Design

### 1. Flutter-SwiftUI Bridge System

```swift
// Core bridge for seamless navigation between Flutter and SwiftUI
class FlutterSwiftUIBridge: NSObject {
    static let shared = FlutterSwiftUIBridge()

    private var nativeViews: Set<String> = []
    private weak var flutterViewController: FlutterViewController?

    // Register which views are now native
    func registerNativeView(_ route: String) {
        nativeViews.insert(route)
    }

    // Check if view should be native
    func shouldUseNativeView(for route: String) -> Bool {
        return nativeViews.contains(route)
    }

    // Present SwiftUI view from Flutter
    func presentNativeView(route: String, data: [String: Any] = [:]) {
        guard let flutterVC = flutterViewController,
              shouldUseNativeView(for: route) else { return }

        let swiftUIView = createSwiftUIView(for: route, data: data)
        let hostingController = UIHostingController(rootView: swiftUIView)

        flutterVC.present(hostingController, animated: true)
    }

    // Navigate back to Flutter
    func navigateBackToFlutter(data: [String: Any] = [:]) {
        // Send data back to Flutter and dismiss SwiftUI view
        flutterViewController?.dismiss(animated: true)
    }
}
```

### 2. Shared Data Layer

```swift
// Shared data models that work with both Flutter and SwiftUI
protocol SharedDataProtocol {
    func saveToFlutterStorage()
    func loadFromFlutterStorage()
    func notifyFlutterOfChanges()
}

// Profile system that works with both platforms
class SharedProfileManager: ObservableObject {
    @Published var activeProfile: Profile?

    // Read/write to Flutter's existing Hive storage
    func syncWithFlutterStorage() async {
        // Bidirectional sync with Flutter's database
    }
}
```

### 3. Navigation Coordination

```swift
// Coordinate navigation between Flutter and SwiftUI
class HybridNavigationCoordinator {
    func navigateFromFlutter(to route: String, data: [String: Any]) {
        if FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route) {
            // Show SwiftUI view
            FlutterSwiftUIBridge.shared.presentNativeView(route: route, data: data)
        } else {
            // Continue with Flutter navigation
            // Send navigation command back to Flutter
        }
    }

    func navigateFromSwiftUI(to route: String, data: [String: Any]) {
        if FlutterSwiftUIBridge.shared.shouldUseNativeView(for: route) {
            // Show another SwiftUI view
        } else {
            // Navigate back to Flutter for this view
            FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: data)
            // Then navigate in Flutter
        }
    }
}
```

## Step-by-Step Migration Process

### Phase 1: Setup Hybrid Infrastructure (Week 1-2)

**Goal: Establish bridge between Flutter and SwiftUI**

```swift
Tasks:
1. Create FlutterSwiftUIBridge class
2. Add MethodChannel for Flutter ↔ SwiftUI communication
3. Setup shared data storage accessible by both platforms
4. Create navigation coordination system
5. Test basic view switching (Flutter → SwiftUI → Flutter)
```

**Flutter Side (Dart):**

```dart
// Method channel for communication with SwiftUI
class NativeBridge {
  static const platform = MethodChannel('com.thriftwood.bridge');

  static Future<void> navigateToNativeView(String route, Map<String, dynamic> data) async {
    await platform.invokeMethod('navigateToNative', {'route': route, 'data': data});
  }

  static Future<bool> isNativeViewAvailable(String route) async {
    return await platform.invokeMethod('isNativeViewAvailable', {'route': route});
  }
}

// Modified Flutter navigation to check for native views
class HybridRouter {
  static void navigateTo(BuildContext context, String route, {Map<String, dynamic>? data}) async {
    final isNative = await NativeBridge.isNativeViewAvailable(route);

    if (isNative) {
      await NativeBridge.navigateToNativeView(route, data ?? {});
    } else {
      // Use existing Flutter navigation
      context.go(route, extra: data);
    }
  }
}
```

### Phase 2: First Hybrid View - Settings (Week 3-4)

**Goal: Replace Settings with SwiftUI while maintaining full app functionality**

```swift
Tasks:
1. Create SettingsView in SwiftUI
2. Migrate settings data models to Swift
3. Implement bidirectional data sync with Flutter
4. Replace Flutter settings navigation with SwiftUI
5. Ensure changes reflect in both platforms
```

**SwiftUI Implementation:**

```swift
// Settings view that works with existing Flutter data
struct SettingsView: View {
    @StateObject private var profileManager = SharedProfileManager()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Profiles") {
                    ForEach(profileManager.profiles) { profile in
                        ProfileRow(profile: profile)
                    }
                }

                Section("Services") {
                    ServiceConfigurationView()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await profileManager.syncWithFlutterStorage()
        }
    }
}
```

**Flutter Integration:**

```dart
// Modified settings navigation in Flutter
class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () async {
        // This will now open SwiftUI settings instead of Flutter
        await HybridRouter.navigateTo(context, '/settings');
      },
    );
  }
}
```

### Phase 3: Dashboard Migration (Week 5-6)

**Goal: Replace Dashboard with SwiftUI while maintaining service module navigation**

```swift
Tasks:
1. Create SwiftUI Dashboard with service tiles
2. Handle navigation to both SwiftUI and Flutter service modules
3. Implement service status checking
4. Add quick actions functionality
5. Maintain existing deep linking
```

**Hybrid Dashboard:**

```swift
struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.services) { service in
                    ServiceTile(service: service) {
                        // Navigate to either SwiftUI or Flutter service view
                        navigateToService(service)
                    }
                }
            }
            .navigationTitle("Dashboard")
        }
    }

    private func navigateToService(_ service: Service) {
        if FlutterSwiftUIBridge.shared.shouldUseNativeView(for: service.route) {
            // Navigate to SwiftUI service view
        } else {
            // Navigate back to Flutter for this service
            FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
                "route": service.route
            ])
        }
    }
}
```

### Phase 4: Service Module Migration (Week 7-14)

**Goal: Migrate each service module one by one**

#### Week 7-8: Radarr Module

```swift
Tasks:
1. Create RadarrHomeView in SwiftUI
2. Implement movie list and detail views
3. Connect to existing Radarr API endpoints
4. Handle navigation from Dashboard (SwiftUI) and other modules (Flutter)
5. Maintain search and filtering functionality
```

#### Week 9-10: Sonarr Module

```swift
Tasks:
1. Create SonarrHomeView with series management
2. Implement episode views and calendar
3. Handle season management
4. Connect monitoring toggles
```

#### Week 11-12: Download Clients (SABnzbd, NZBGet)

```swift
Tasks:
1. Create unified download queue view
2. Implement queue management actions
3. Add download history
4. Handle pause/resume functionality
```

#### Week 13-14: Remaining Modules (Lidarr, Tautulli, Search, Wake-on-LAN)

```swift
Tasks:
1. Complete remaining service migrations
2. Implement cross-module search
3. Add analytics views for Tautulli
4. Create Wake-on-LAN utilities
```

### Phase 5: Pure SwiftUI Transition (Week 15-16)

**Goal: Remove Flutter completely and finalize pure SwiftUI app**

```swift
Tasks:
1. Remove FlutterSwiftUIBridge system
2. Replace all Flutter navigation with SwiftUI NavigationStack
3. Clean up hybrid data synchronization
4. Remove Flutter framework dependencies
5. Optimize for pure SwiftUI performance
6. Add iOS-exclusive features (Widgets, App Clips, etc.)
```

## Implementation Patterns

### Seamless View Transition Pattern

```swift
// Each view migration follows this pattern:

// 1. Create SwiftUI equivalent
struct NewSwiftUIView: View {
    // SwiftUI implementation
}

// 2. Register with bridge
FlutterSwiftUIBridge.shared.registerNativeView("/viewroute")

// 3. Flutter automatically uses SwiftUI version
// No changes needed in Flutter navigation code
```

### Data Synchronization Pattern

```swift
// Ensure data changes are reflected in both platforms
class HybridDataManager {
    // Write to both Flutter storage and SwiftUI storage
    func saveData<T: Codable>(_ data: T, forKey key: String) async {
        // Save to SwiftData (SwiftUI)
        await swiftDataManager.save(data, forKey: key)

        // Sync to Flutter storage
        await flutterStorageSync.save(data, forKey: key)

        // Notify both platforms of changes
        NotificationCenter.default.post(name: .dataChanged, object: key)
    }
}
```

### Navigation Consistency Pattern

```swift
// Maintain consistent navigation behavior
extension View {
    func hybridNavigationDestination<D: Hashable, C: View>(
        for data: D.Type,
        @ViewBuilder destination: @escaping (D) -> C
    ) -> some View {
        self.navigationDestination(for: data) { value in
            // Check if destination should be native or Flutter
            if shouldShowInSwiftUI(for: value) {
                destination(value)
            } else {
                // Navigate to Flutter equivalent
                FlutterNavigationView(destination: value)
            }
        }
    }
}
```

## Testing Strategy for Hybrid App

### Continuous Integration Testing

```swift
// Test both Flutter and SwiftUI components
func testHybridNavigation() {
    // Test Flutter → SwiftUI navigation
    // Test SwiftUI → Flutter navigation
    // Test data synchronization
    // Test deep linking across platforms
}

func testDataConsistency() {
    // Ensure data changes in SwiftUI reflect in Flutter
    // Ensure data changes in Flutter reflect in SwiftUI
    // Test profile switching across platforms
}
```

### User Acceptance Testing

- Test all navigation paths work seamlessly
- Verify no visual inconsistencies between platforms
- Ensure smooth transitions and animations
- Test on multiple iOS devices and versions

## Success Criteria

**Each Phase Must Meet:**

- [ ] App builds and runs successfully
- [ ] All existing functionality preserved
- [ ] No crashes or navigation dead ends
- [ ] Data consistency maintained across platforms
- [ ] Performance equal or better than previous phase
- [ ] All deep links and external integrations work

**Final Success Criteria:**

- [ ] 100% SwiftUI implementation
- [ ] Zero Flutter dependencies
- [ ] All features from original Flutter app
- [ ] Improved performance and iOS integration
- [ ] App Store ready for iOS 18+

## Risk Mitigation

### Technical Risks

- **Navigation Complexity**: Maintain detailed navigation map, test all paths
- **Data Synchronization**: Use shared storage layer, implement conflict resolution
- **Performance**: Profile each phase, ensure no regressions
- **State Management**: Careful coordination between Flutter and SwiftUI state

### Process Risks

- **User Experience**: Maintain visual consistency during transition
- **Testing Complexity**: Automated testing for both platforms at each phase
- **Rollback Strategy**: Each phase can be rolled back independently
- **Timeline Delays**: 20% buffer built into each phase

## Migration Checklist Per View

**Before Starting View Migration:**

- [ ] Analyze Flutter view implementation and dependencies
- [ ] Design SwiftUI equivalent with same functionality
- [ ] Plan data model sharing strategy
- [ ] Identify navigation entry/exit points

**During View Migration:**

- [ ] Implement SwiftUI view with feature parity
- [ ] Setup bidirectional data synchronization
- [ ] Register view with FlutterSwiftUIBridge
- [ ] Test navigation from all possible sources
- [ ] Verify data consistency

**After View Migration:**

- [ ] Remove Flutter view code (after verification)
- [ ] Update documentation
- [ ] Performance testing and optimization
- [ ] User acceptance testing

## Timeline Summary

| Phase | Duration | Deliverable                | App State                         |
| ----- | -------- | -------------------------- | --------------------------------- |
| 1     | 2 weeks  | Hybrid infrastructure      | 100% Flutter + Bridge             |
| 2     | 2 weeks  | Settings in SwiftUI        | ~95% Flutter + Settings           |
| 3     | 2 weeks  | Dashboard in SwiftUI       | ~90% Flutter + Dashboard/Settings |
| 4     | 8 weeks  | Service modules in SwiftUI | ~20% Flutter + Most SwiftUI       |
| 5     | 2 weeks  | Pure SwiftUI app           | 100% SwiftUI                      |

**Total: 16 weeks to pure SwiftUI app**

---

_This migration plan ensures the app remains fully functional at every step, with smooth transitions between Flutter and SwiftUI views until the complete migration to pure SwiftUI is achieved._
