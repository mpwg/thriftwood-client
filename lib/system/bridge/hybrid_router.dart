import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lunasea/router/router.dart';
import 'package:lunasea/system/bridge/native_bridge.dart';
import 'package:lunasea/system/logger.dart';
import 'package:lunasea/widgets/ui.dart';

/// Hybrid router that coordinates navigation between Flutter and SwiftUI views
class HybridRouter {
  /// Private constructor to prevent instantiation
  HybridRouter._();

  /// Initialize the hybrid router system
  /// This should be called during app startup
  static Future<void> initialize() async {
    // Set up method call handler for native-to-Flutter communication
    NativeBridge.setMethodCallHandler(_handleMethodCall);

    LunaLogger().debug('HybridRouter initialized');
  }

  /// Navigate to a route, automatically determining if it should use Flutter or SwiftUI
  ///
  /// [context] - Build context for Flutter navigation
  /// [route] - Target route path
  /// [data] - Optional navigation data
  /// [replace] - Whether to replace current route instead of pushing
  ///
  /// Returns true if navigation was handled
  static Future<bool> navigateTo(
    BuildContext context,
    String route, {
    Map<String, dynamic>? data,
    bool replace = false,
  }) async {
    LunaLogger().debug('HybridRouter: Navigation request to $route');

    try {
      // Check if route should use native SwiftUI view
      final isNative = await NativeBridge.isNativeViewAvailable(route);

      if (isNative) {
        // Navigate to SwiftUI view
        LunaLogger().debug('HybridRouter: Using native view for $route');
        final ok = await NativeBridge.navigateToNativeView(route, data: data);
        if (!ok) {
          showLunaErrorSnackBar(
            title: 'Navigation failed',
            message: 'Could not open $route',
          );
        }
        return ok;
      } else {
        // Use Flutter navigation
        LunaLogger().debug('HybridRouter: Using Flutter navigation for $route');
        final ok =
            _navigateInFlutter(context, route, data: data, replace: replace);
        if (!ok) {
          showLunaErrorSnackBar(
            title: 'Navigation failed',
            message: 'Could not open $route',
          );
        }
        return ok;
      }
    } catch (e) {
      LunaLogger().error('HybridRouter: Navigation error for route "$route"', e,
          StackTrace.current);
      showLunaErrorSnackBar(
        title: 'Navigation error',
        message: 'An error occurred while opening $route',
      );
      // For development, we still rethrow after surfacing the error
      if (kDebugMode) rethrow;
      return false;
    }
  }

  /// Navigate within Flutter using GoRouter
  static bool _navigateInFlutter(
    BuildContext context,
    String route, {
    Map<String, dynamic>? data,
    bool replace = false,
  }) {
    try {
      if (replace) {
        context.pushReplacement(route, extra: data);
      } else {
        context.push(route, extra: data);
      }
      return true;
    } catch (e) {
      LunaLogger().error(
          'HybridRouter: Flutter navigation error', e, StackTrace.current);
      return false;
    }
  }

  /// Go to a specific route, replacing the entire navigation stack
  static Future<bool> goTo(
    BuildContext context,
    String route, {
    Map<String, dynamic>? data,
  }) async {
    LunaLogger().debug('HybridRouter: Go to $route');

    try {
      // Check if route should use native SwiftUI view
      final isNative = await NativeBridge.isNativeViewAvailable(route);

      if (isNative) {
        // For native views, we still need to navigate through Flutter first
        // then let the native side handle the presentation
        final ok = await NativeBridge.navigateToNativeView(route, data: data);
        if (!ok) {
          showLunaErrorSnackBar(
            title: 'Navigation failed',
            message: 'Could not open $route',
          );
        }
        return ok;
      } else {
        // Use Flutter's go method
        context.go(route, extra: data);
        return true;
      }
    } catch (e) {
      LunaLogger().error('HybridRouter: Go navigation error for route "$route"',
          e, StackTrace.current);
      showLunaErrorSnackBar(
        title: 'Navigation error',
        message: 'An error occurred while opening $route',
      );
      if (kDebugMode) rethrow;
      return false;
    }
  }

  /// Pop the current route
  /// This works for both Flutter and SwiftUI views
  static void pop(BuildContext context, {dynamic result}) {
    if (context.canPop()) {
      context.pop(result);
    } else {
      LunaLogger().warning('HybridRouter: Cannot pop - no routes in stack');
    }
  }

  /// Check if we can pop the current route
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  /// Handle method calls from native SwiftUI side
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    LunaLogger().debug('HybridRouter: Received method call: ${call.method}');

    switch (call.method) {
      case 'navigateInFlutter':
        return await _handleNavigateInFlutter(call.arguments);
      case 'onReturnFromNative':
        return await _handleReturnFromNative(call.arguments);
      case 'onDataChanged':
        return await _handleDataChanged(call.arguments);
      case 'onDataRemoved':
        return await _handleDataRemoved(call.arguments);
      default:
        LunaLogger()
            .warning('HybridRouter: Unknown method call: ${call.method}');
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  }

  /// Handle navigation request from SwiftUI to Flutter
  static Future<bool> _handleNavigateInFlutter(dynamic arguments) async {
    if (arguments is! Map) {
      LunaLogger().error(
          'HybridRouter: Invalid arguments for navigateInFlutter',
          'Invalid arguments',
          StackTrace.current);
      final ctx = LunaRouter.navigator.currentContext;
      if (ctx != null) {
        showLunaErrorSnackBar(
          title: 'Navigation error',
          message:
              'Invalid arguments received from native for Flutter navigation',
        );
      }
      return false;
    }

    final route = arguments['route'] as String?;
    final data = arguments['data'] as Map<String, dynamic>?;

    if (route == null) {
      LunaLogger().error('HybridRouter: No route specified for navigation',
          'Missing route', StackTrace.current);
      final ctx = LunaRouter.navigator.currentContext;
      if (ctx != null) {
        showLunaErrorSnackBar(
          title: 'Navigation error',
          message: 'Missing route name for Flutter navigation',
        );
      }
      return false;
    }

    // Use the LunaRouter's context for navigation
    try {
      final context = LunaRouter.navigator.currentContext;
      if (context != null) {
        context.go(route, extra: data);
        return true;
      } else {
        LunaLogger().error(
            'HybridRouter: No context available for Flutter navigation to $route',
            'No context',
            StackTrace.current);
        return false;
      }
    } catch (e) {
      LunaLogger().error(
          'HybridRouter: Error navigating in Flutter from native',
          e,
          StackTrace.current);
      final ctx = LunaRouter.navigator.currentContext;
      if (ctx != null) {
        showLunaErrorSnackBar(
          title: 'Navigation error',
          message: 'Failed to navigate to $route',
        );
      }
      return false;
    }
  }

  /// Handle return from native SwiftUI view
  static Future<void> _handleReturnFromNative(dynamic arguments) async {
    if (arguments is Map) {
      final navigateTo = arguments['navigateTo'] as String?;
      final navigationData =
          arguments['navigationData'] as Map<String, dynamic>?;

      if (navigateTo != null) {
        LunaLogger().debug(
            'HybridRouter: Navigating to $navigateTo after returning from native');

        // Get the correct context from LunaRouter's navigator
        final context = LunaRouter.navigator.currentContext;
        if (context != null) {
          // Use GoRouter directly for Flutter routes
          try {
            // Check if this should be native first
            final isNative =
                await NativeBridge.isNativeViewAvailable(navigateTo);

            if (isNative) {
              // This shouldn't happen when returning from native, but handle it
              LunaLogger().warning(
                  'HybridRouter: Route $navigateTo is native but returning from native view');
              await NativeBridge.navigateToNativeView(navigateTo,
                  data: navigationData);
            } else {
              // Use Flutter navigation directly
              LunaLogger().debug(
                  'HybridRouter: Using Flutter navigation for $navigateTo');
              context.go(navigateTo, extra: navigationData);
            }
          } catch (e) {
            LunaLogger().error(
                'HybridRouter: Error navigating to $navigateTo after return from native',
                e,
                StackTrace.current);
            showLunaErrorSnackBar(
              title: 'Navigation Error',
              message: 'Failed to navigate to $navigateTo',
            );
          }
        } else {
          LunaLogger().error(
              'HybridRouter: No context available for navigation to $navigateTo',
              'No context',
              StackTrace.current);
        }
      }
    }

    LunaLogger().debug('HybridRouter: Returned from native view');
  }

  /// Handle data change notification from native side
  static Future<void> _handleDataChanged(dynamic arguments) async {
    if (arguments is Map) {
      final key = arguments['key'] as String?;
      final timestamp = arguments['timestamp'] as double?;

      LunaLogger()
          .debug('HybridRouter: Data changed for key: $key at $timestamp');

      // Here you could notify any listeners about data changes
      // For example, update providers or state management
    }
  }

  /// Handle data removal notification from native side
  static Future<void> _handleDataRemoved(dynamic arguments) async {
    if (arguments is Map) {
      final key = arguments['key'] as String?;
      final timestamp = arguments['timestamp'] as double?;

      LunaLogger()
          .debug('HybridRouter: Data removed for key: $key at $timestamp');

      // Here you could notify any listeners about data removal
    }
  }
}

/// Global navigator key for accessing navigation context
/// Note: We now use LunaRouter.navigator instead of this deprecated key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Extension on BuildContext for convenient hybrid navigation
extension HybridNavigation on BuildContext {
  /// Navigate to a route using the hybrid router
  Future<bool> navigateToHybrid(
    String route, {
    Map<String, dynamic>? data,
    bool replace = false,
  }) {
    return HybridRouter.navigateTo(this, route, data: data, replace: replace);
  }

  /// Go to a route using the hybrid router
  Future<bool> goToHybrid(
    String route, {
    Map<String, dynamic>? data,
  }) {
    return HybridRouter.goTo(this, route, data: data);
  }
}
