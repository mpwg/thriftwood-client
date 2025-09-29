import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/test_widget.dart';
import 'package:lunasea/vendor.dart';

enum HybridTestRoutes {
  HOME('/hybrid-test');

  const HybridTestRoutes(this.path);

  final String path;

  GoRoute get route => GoRoute(
        path: path,
        name: runtimeType.toString(),
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const HybridBridgeTestWidget(),
        ),
      );

  /// Generate all routes for this module
  static List<GoRoute> get routes =>
      HybridTestRoutes.values.map((e) => e.route).toList();
}
