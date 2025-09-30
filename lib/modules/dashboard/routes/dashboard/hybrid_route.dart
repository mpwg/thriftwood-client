import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/native_bridge.dart';
import 'package:lunasea/modules/dashboard/routes/dashboard/route.dart';

/// Hybrid wrapper for the dashboard route that checks if it should use SwiftUI
class HybridDashboardRoute extends StatefulWidget {
  const HybridDashboardRoute({Key? key}) : super(key: key);

  @override
  State<HybridDashboardRoute> createState() => _HybridDashboardRouteState();
}

class _HybridDashboardRouteState extends State<HybridDashboardRoute> {
  bool _isCheckingHybrid = true;
  bool _useNative = false;

  @override
  void initState() {
    super.initState();
    _checkHybridNavigation();
  }

  Future<void> _checkHybridNavigation() async {
    try {
      // Check if the dashboard should use native SwiftUI view
      final shouldUseNative =
          await NativeBridge.isNativeViewAvailable('/dashboard');

      if (shouldUseNative) {
        // Present the SwiftUI view
        final success = await NativeBridge.navigateToNativeView('/dashboard');
        if (success) {
          // SwiftUI view was presented successfully
          setState(() {
            _useNative = true;
            _isCheckingHybrid = false;
          });
          return;
        }
      }

      // Use Flutter implementation
      setState(() {
        _useNative = false;
        _isCheckingHybrid = false;
      });
    } catch (e) {
      // If hybrid navigation fails, fall back to Flutter
      setState(() {
        _useNative = false;
        _isCheckingHybrid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingHybrid) {
      // Show loading indicator while checking hybrid navigation
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_useNative) {
      // SwiftUI view is being presented, show minimal placeholder
      return const SizedBox.shrink();
    }

    // Use Flutter implementation
    return const DashboardRoute();
  }
}
