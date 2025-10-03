import 'package:flutter/material.dart';

import 'package:thriftwood/system/logger.dart';
import 'package:thriftwood/widgets/pages/error_route.dart';
import 'package:thriftwood/router/routes.dart';
import 'package:thriftwood/vendor.dart';

class LunaRouter {
  static late GoRouter router;
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  void initialize() {
    router = GoRouter(
      navigatorKey: navigator,
      errorBuilder: (_, state) => ErrorRoutePage(exception: state.error),
      initialLocation: LunaRoutes.initialLocation,
      routes: LunaRoutes.values.map((r) => r.root.routes).toList(),
    );
  }

  void popSafely() {
    if (router.canPop()) router.pop();
  }

  void popToRootRoute() {
    if (navigator.currentState == null) {
      LunaLogger().warning('Not observing any navigation navigators, skipping');
      return;
    }
    navigator.currentState!.popUntil((route) => route.isFirst);
  }
}
