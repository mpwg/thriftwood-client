import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/hybrid_router.dart';

/// Immediate Swift delegation route for Dashboard
/// Enforces Swift-first migration rules - no Flutter implementation
class DashboardRoute extends StatelessWidget {
  const DashboardRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SWIFT-FIRST RULE ENFORCEMENT:
    // Dashboard Swift implementation is complete - delegate immediately
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final success = await HybridRouter.navigateTo(context, '/dashboard');
      if (!success) {
        _showDashboardUnavailableError(context);
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
            Text('Loading native dashboard...'),
          ],
        ),
      ),
    );
  }

  void _showDashboardUnavailableError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dashboard Unavailable'),
        content: const Text(
          'The native iOS dashboard implementation is not available. '
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
