import 'package:flutter/material.dart';
import 'package:lunasea/modules/settings/routes/settings/route.dart';
import 'package:lunasea/router/routes.dart';
import 'package:lunasea/vendor.dart';

/// SWIFT-FIRST MIGRATION ENFORCEMENT: Settings routes delegate to Swift
/// All Flutter settings implementations have been eliminated per migration rules
enum SettingsRoutes with LunaRoutesMixin {
  // Main settings route - delegates to Swift
  HOME('/settings'),

  // All sub-routes delegate to Swift with path parameters
  CONFIGURATION('/settings/configuration'),
  PROFILES('/settings/profiles'),
  SYSTEM('/settings/system'),
  SYSTEM_LOGS('/settings/system/logs');

  @override
  final String path;

  const SettingsRoutes(this.path);

  @override
  LunaModule get module => LunaModule.SETTINGS;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    // ALL SETTINGS ROUTES DELEGATE TO SWIFT (Swift-first rule enforcement)
    // Flutter implementation code has been eliminated
    switch (this) {
      case SettingsRoutes.HOME:
      case SettingsRoutes.CONFIGURATION:
      case SettingsRoutes.PROFILES:
      case SettingsRoutes.SYSTEM:
      case SettingsRoutes.SYSTEM_LOGS:
        return route(
            builder: (context, state) => SettingsRoute(
                  // Pass the specific route to Swift
                  initialRoute: path,
                  routeData: state.extra as Map<String, dynamic>?,
                ));
    }
  }
}
