import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Bridge for communication between Flutter and SwiftUI
class FlutterSwiftUIBridge {
  static const _methodChannel = MethodChannel('com.thriftwood.bridge');

  /// Navigate to native SwiftUI view
  static Future<bool> navigateToNativeView(
    String route, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final result = await _methodChannel.invokeMethod('navigateToNative', {
        'route': route,
        'data': data ?? <String, dynamic>{},
      });
      return result == true;
    } catch (e) {
      debugPrint('Error navigating to native view: $e');
      return false;
    }
  }

  /// Check if native SwiftUI view is available for route
  static Future<bool> isNativeViewAvailable(String route) async {
    try {
      final result =
          await _methodChannel.invokeMethod('isNativeViewAvailable', {
        'route': route,
      });
      return result == true;
    } catch (e) {
      debugPrint('Error checking native view availability: $e');
      return false;
    }
  }

  /// Navigate back to Flutter from SwiftUI
  static Future<bool> navigateBackToFlutter({
    Map<String, dynamic>? data,
  }) async {
    try {
      final result =
          await _methodChannel.invokeMethod('navigateBackToFlutter', {
        'data': data ?? <String, dynamic>{},
      });
      return result == true;
    } catch (e) {
      debugPrint('Error navigating back to Flutter: $e');
      return false;
    }
  }

  /// Set method call handler to receive data from SwiftUI
  static void setMethodCallHandler(
      Future<dynamic> Function(MethodCall call)? handler) {
    _methodChannel.setMethodCallHandler(handler);
  }
}

/// Hybrid router that decides between Flutter and SwiftUI views
class HybridRouter {
  /// Navigate to a route, choosing between Flutter and SwiftUI automatically
  static Future<void> navigateTo(
    BuildContext context,
    String route, {
    Map<String, dynamic>? data,
  }) async {
    final isNativeAvailable =
        await FlutterSwiftUIBridge.isNativeViewAvailable(route);

    if (isNativeAvailable) {
      // Use SwiftUI implementation
      await FlutterSwiftUIBridge.navigateToNativeView(route, data: data);
    } else {
      // Use Flutter implementation - implement your existing navigation here
      _navigateToFlutterView(context, route, data: data);
    }
  }

  /// Navigate to Flutter view (existing navigation logic)
  static void _navigateToFlutterView(
    BuildContext context,
    String route, {
    Map<String, dynamic>? data,
  }) {
    // TODO: Implement existing Flutter navigation
    // This would use your existing router like GoRouter
    debugPrint('Navigating to Flutter view: $route with data: $data');

    // Example using Navigator (replace with your actual navigation)
    switch (route) {
      case '/settings':
        Navigator.of(context).pushNamed('/settings', arguments: data);
        break;
      case '/settings/profiles':
        Navigator.of(context).pushNamed('/settings/profiles', arguments: data);
        break;
      case '/settings/configuration':
        Navigator.of(context)
            .pushNamed('/settings/configuration', arguments: data);
        break;
      default:
        Navigator.of(context).pushNamed(route, arguments: data);
    }
  }
}

/// Widget that provides a choice between Flutter and SwiftUI versions
class HybridSettingsButton extends StatelessWidget {
  const HybridSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings),
      onSelected: (String choice) {
        switch (choice) {
          case 'flutter':
            _navigateToFlutterSettings(context);
            break;
          case 'swiftui':
            _navigateToSwiftUISettings(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'flutter',
          child: Row(
            children: [
              Icon(Icons.flutter_dash, color: Colors.blue),
              SizedBox(width: 8),
              Text('Flutter Settings'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'swiftui',
          child: Row(
            children: [
              Icon(Icons.apple, color: Colors.grey),
              SizedBox(width: 8),
              Text('SwiftUI Settings (New)'),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToFlutterSettings(BuildContext context) {
    // Navigate to existing Flutter settings
    HybridRouter._navigateToFlutterView(context, '/settings');
  }

  void _navigateToSwiftUISettings(BuildContext context) {
    // Force navigate to SwiftUI settings
    FlutterSwiftUIBridge.navigateToNativeView('/settings');
  }
}

/// Widget to test the hybrid bridge functionality
class HybridTestWidget extends StatefulWidget {
  const HybridTestWidget({Key? key}) : super(key: key);

  @override
  State<HybridTestWidget> createState() => _HybridTestWidgetState();
}

class _HybridTestWidgetState extends State<HybridTestWidget> {
  String _lastMessage = 'No messages yet';

  @override
  void initState() {
    super.initState();
    _setupMethodCallHandler();
  }

  void _setupMethodCallHandler() {
    FlutterSwiftUIBridge.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onDataFromNative') {
        setState(() {
          _lastMessage = 'Received from SwiftUI: ${call.arguments}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hybrid Bridge Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bridge Status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Message:',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(_lastMessage),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _testSettingsNavigation(),
              child: const Text('Test SwiftUI Settings'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _testProfilesNavigation(),
              child: const Text('Test SwiftUI Profiles'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _testConfigurationNavigation(),
              child: const Text('Test SwiftUI Configuration'),
            ),
          ],
        ),
      ),
    );
  }

  void _testSettingsNavigation() {
    FlutterSwiftUIBridge.navigateToNativeView('/settings', data: {
      'timestamp': DateTime.now().toString(),
      'source': 'flutter_test',
    });
  }

  void _testProfilesNavigation() {
    FlutterSwiftUIBridge.navigateToNativeView('/settings/profiles', data: {
      'timestamp': DateTime.now().toString(),
      'source': 'flutter_test',
    });
  }

  void _testConfigurationNavigation() {
    FlutterSwiftUIBridge.navigateToNativeView('/settings/configuration', data: {
      'timestamp': DateTime.now().toString(),
      'source': 'flutter_test',
    });
  }
}
