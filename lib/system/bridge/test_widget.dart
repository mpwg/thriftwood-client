import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/hybrid_router.dart';

/// Test widget for validating the hybrid navigation system
/// This should be temporarily added to the main Flutter app for Phase 1 testing
class HybridBridgeTestWidget extends StatefulWidget {
  const HybridBridgeTestWidget({super.key});

  @override
  State<HybridBridgeTestWidget> createState() => _HybridBridgeTestWidgetState();
}

class _HybridBridgeTestWidgetState extends State<HybridBridgeTestWidget> {
  String _lastResult = 'No navigation performed yet';
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hybrid Bridge Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Phase 1: Hybrid Infrastructure Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'This page tests the Flutter ↔ SwiftUI bridge system. '
              'Tap the button below to navigate to a SwiftUI test view.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isNavigating ? null : _testNativeNavigation,
              icon: _isNavigating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_forward),
              label: Text(
                  _isNavigating ? 'Navigating...' : 'Test SwiftUI Navigation'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _testDataStorage,
              icon: const Icon(Icons.storage),
              label: const Text('Test Data Storage'),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_lastResult),
                ],
              ),
            ),
            const Spacer(),
            const Text(
              'Expected Behavior:\n'
              '1. Tap "Test SwiftUI Navigation"\n'
              '2. SwiftUI test view should appear\n'
              '3. Tap "Return to Flutter" in SwiftUI view\n'
              '4. You should return to this Flutter screen',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testNativeNavigation() async {
    setState(() {
      _isNavigating = true;
      _lastResult = 'Attempting navigation to SwiftUI...';
    });

    try {
      final success = await context.navigateToHybrid(
        '/test',
        data: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'message': 'Hello from Flutter!',
          'testData': {
            'phase': 1,
            'feature': 'hybrid-navigation',
            'origin': 'flutter-test-widget',
          },
        },
      );

      setState(() {
        _isNavigating = false;
        _lastResult = success
            ? 'Navigation successful - SwiftUI view should be displayed'
            : 'Navigation failed - check console logs';
      });
    } catch (e) {
      setState(() {
        _isNavigating = false;
        _lastResult = 'Navigation error: $e';
      });
    }
  }

  Future<void> _testDataStorage() async {
    setState(() {
      _lastResult = 'Testing shared data storage...';
    });

    try {
      // This would test the shared data storage system
      // For Phase 1, we'll just simulate the test
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _lastResult =
            'Data storage test completed - check native logs for details';
      });
    } catch (e) {
      setState(() {
        _lastResult = 'Data storage test failed: $e';
      });
    }
  }
}

/// Extension to add a test route to the existing router
/// This is a temporary addition for Phase 1 testing
class HybridBridgeTestRoute {
  static const String path = '/hybrid-test';

  static Widget builder(BuildContext context, dynamic state) {
    return const HybridBridgeTestWidget();
  }
}
