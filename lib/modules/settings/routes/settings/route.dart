import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/hybrid_router.dart';

/// Immediate Swift delegation route for Settings
/// Enforces Swift-first migration rules - no Flutter implementation
class SettingsRoute extends StatelessWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SWIFT-FIRST RULE ENFORCEMENT:
    // Settings Swift implementation is complete - delegate immediately
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final success = await HybridRouter.navigateTo(context, '/settings');
      if (!success) {
        _showSettingsUnavailableError(context);
      }
    });

    // Temporary placeholder during navigation
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading native settings...'),
          ],
        ),
      ),
    );
  }

  void _showSettingsUnavailableError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings Unavailable'),
        content: const Text(
          'The native iOS settings implementation is not available. '
          'Please ensure you are running on iOS with the latest app version.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}