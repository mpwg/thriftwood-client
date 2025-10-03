import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/hybrid_router.dart';
import 'package:lunasea/system/bridge/embedded_context_detector.dart';

/// Immediate Swift delegation route for Dashboard
/// Enforces Swift-first migration rules - no Flutter implementation
class DashboardRoute extends StatelessWidget {
  const DashboardRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: EmbeddedContextDetector.isEmbeddedInSwiftUI(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking navigation context...'),
                ],
              ),
            ),
          );
        }

        final isEmbedded = snapshot.data ?? false;

        if (isEmbedded) {
          // Flutter is embedded in SwiftUI - dashboard is already displayed
          // Return an empty container since SwiftUI is handling the UI
          return const SizedBox.shrink();
        } else {
          // Flutter is primary - attempt navigation to SwiftUI dashboard
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final success =
                await HybridRouter.navigateTo(context, '/dashboard');
            if (!success) {
              _showDashboardUnavailableError(context);
            }
          });

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
      },
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
