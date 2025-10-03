import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/hybrid_router.dart';
import 'package:lunasea/modules/dashboard/routes/dashboard/route.dart';

/// Hybrid wrapper for the dashboard route that uses HybridRouter for consistent navigation
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
      // Use HybridRouter to handle navigation decision and presentation
      final success = await HybridRouter.navigateTo(context, '/dashboard');

      if (success) {
        // Check if we actually navigated to SwiftUI by attempting the navigation
        // If HybridRouter used SwiftUI, we should show minimal placeholder
        // If it used Flutter navigation, we'll show the Flutter implementation

        // We can determine if SwiftUI was used by checking if the widget is still mounted
        // after a brief delay - if SwiftUI was presented, this widget will be obscured
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          // If we're still mounted and visible, it means Flutter navigation was used
          setState(() {
            _useNative = false;
            _isCheckingHybrid = false;
          });
        } else {
          // SwiftUI was presented, this widget is no longer relevant
          setState(() {
            _useNative = true;
            _isCheckingHybrid = false;
          });
        }
      } else {
        // Navigation failed, use Flutter implementation
        setState(() {
          _useNative = false;
          _isCheckingHybrid = false;
        });
      }
    } catch (e) {
      // If hybrid navigation fails, fall back to Flutter
      setState(() {
        _useNative = false;
        _isCheckingHybrid = false;
      });
      // HybridRouter already shows error snackbars, so we don't need to duplicate
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
