import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/native_bridge.dart';
import 'package:lunasea/widgets/ui.dart';

/// Debug widget to test dashboard hybrid navigation
class DashboardHybridDebugWidget extends StatefulWidget {
  const DashboardHybridDebugWidget({Key? key}) : super(key: key);

  @override
  State<DashboardHybridDebugWidget> createState() =>
      _DashboardHybridDebugWidgetState();
}

class _DashboardHybridDebugWidgetState
    extends State<DashboardHybridDebugWidget> {
  String _status = 'Checking hybrid navigation...';
  bool _isNativeAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkHybridStatus();
  }

  Future<void> _checkHybridStatus() async {
    try {
      final isAvailable =
          await NativeBridge.isNativeViewAvailable('/dashboard');
      setState(() {
        _isNativeAvailable = isAvailable;
        _status = isAvailable
            ? 'Dashboard SwiftUI view is available ✅'
            : 'Dashboard SwiftUI view is NOT available ❌';
      });
    } catch (e) {
      setState(() {
        _status = 'Error checking hybrid status: $e';
      });
    }
  }

  Future<void> _testNavigation() async {
    if (!_isNativeAvailable) {
      setState(() {
        _status = 'Cannot test - SwiftUI view not available';
      });
      return;
    }

    try {
      setState(() {
        _status = 'Attempting to navigate to SwiftUI dashboard...';
      });

      final success = await NativeBridge.navigateToNativeView('/dashboard');

      setState(() {
        _status = success
            ? 'Successfully navigated to SwiftUI dashboard ✅'
            : 'Failed to navigate to SwiftUI dashboard ❌';
      });
    } catch (e) {
      setState(() {
        _status = 'Navigation error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: GlobalKey<ScaffoldState>(),
      appBar: LunaAppBar(
        title: 'Dashboard Hybrid Debug',
        scrollControllers: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dashboard Hybrid Navigation Test',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checkHybridStatus,
              child: const Text('Recheck Hybrid Status'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isNativeAvailable ? _testNavigation : null,
              child: const Text('Test SwiftUI Navigation'),
            ),
            const SizedBox(height: 32),
            Text(
              'Instructions:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Check if the dashboard SwiftUI view is registered\n'
              '2. If available, test navigation to the SwiftUI dashboard\n'
              '3. The SwiftUI dashboard should appear with native navigation',
            ),
          ],
        ),
      ),
    );
  }
}
