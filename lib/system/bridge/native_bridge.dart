import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Bridge for communicating with native SwiftUI views
class NativeBridge {
  static const MethodChannel _platform = MethodChannel('com.thriftwood.bridge');

  /// Private constructor to prevent instantiation
  NativeBridge._();

  /// Navigate to a native SwiftUI view
  ///
  /// [route] - The route path (e.g., '/settings', '/dashboard')
  /// [data] - Optional data to pass to the native view
  ///
  /// Returns true if navigation was successful, false otherwise
  static Future<bool> navigateToNativeView(
    String route, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final result = await _platform.invokeMethod('navigateToNative', {
        'route': route,
        'data': data ?? <String, dynamic>{},
      });

      if (kDebugMode) {
        print('NativeBridge: Navigation to $route successful');
      }

      return result == true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('NativeBridge: Navigation error - ${e.message}');
      }
      return false;
    }
  }

  /// Check if a native SwiftUI view is available for the given route
  ///
  /// [route] - The route path to check
  ///
  /// Returns true if a native view is available, false if Flutter should handle it
  static Future<bool> isNativeViewAvailable(String route) async {
    try {
      final result = await _platform.invokeMethod('isNativeViewAvailable', {
        'route': route,
      });

      return result == true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(
            'NativeBridge: Error checking native view availability - ${e.message}');
      }
      return false;
    }
  }

  /// Register a route to use native SwiftUI view
  ///
  /// [route] - The route path to register
  ///
  /// Returns true if registration was successful
  static Future<bool> registerNativeView(String route) async {
    try {
      final result = await _platform.invokeMethod('registerNativeView', {
        'route': route,
      });

      if (kDebugMode) {
        print('NativeBridge: Registered native view for route: $route');
      }

      return result == true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('NativeBridge: Error registering native view - ${e.message}');
      }
      return false;
    }
  }

  /// Get all registered native view routes
  ///
  /// Returns list of route paths that use native views
  static Future<List<String>> getAllNativeViews() async {
    try {
      final result = await _platform.invokeMethod('getAllNativeViews');

      if (result is List) {
        return List<String>.from(result);
      }

      return <String>[];
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('NativeBridge: Error getting native views - ${e.message}');
      }
      return <String>[];
    }
  }

  /// Save data to native storage (accessible by SwiftUI)
  ///
  /// [key] - Storage key
  /// [data] - Data to save (must be JSON serializable)
  ///
  /// Returns true if save was successful
  static Future<bool> saveToNativeStorage(
    String key,
    Map<String, dynamic> data,
  ) async {
    try {
      await _platform.invokeMethod('saveToFlutterStorage', {
        'key': key,
        'data': data,
      });

      if (kDebugMode) {
        print('NativeBridge: Saved data to native storage for key: $key');
      }

      return true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('NativeBridge: Error saving to native storage - ${e.message}');
      }
      return false;
    }
  }

  /// Load data from native storage
  ///
  /// [key] - Storage key
  ///
  /// Returns the data or null if not found
  static Future<Map<String, dynamic>?> loadFromNativeStorage(String key) async {
    try {
      final result = await _platform.invokeMethod('loadFromFlutterStorage', {
        'key': key,
      });

      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }

      return null;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('NativeBridge: Error loading from native storage - ${e.message}');
      }
      return null;
    }
  }

  /// Set up method call handler for receiving calls from native side
  ///
  /// [handler] - Function to handle method calls from native code
  static void setMethodCallHandler(
    Future<dynamic> Function(MethodCall call)? handler,
  ) {
    _platform.setMethodCallHandler(handler);
  }
}
