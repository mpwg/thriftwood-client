import 'package:flutter/material.dart';
import 'package:thriftwood/database/tables/bios.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/router/routes.dart';
import 'package:thriftwood/router/routes/dashboard.dart';
import 'package:thriftwood/system/bios.dart';
import 'package:thriftwood/vendor.dart';

enum BIOSRoutes with LunaRoutesMixin {
  HOME('/');

  @override
  final String path;

  const BIOSRoutes(this.path);

  @override
  LunaModule? get module => null;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case BIOSRoutes.HOME:
        return redirect(
          redirect: (context, _) {
            LunaOS().boot(context);

            final fallback = DashboardRoutes.HOME.path;
            return BIOSDatabase.BOOT_MODULE.read().homeRoute ?? fallback;
          },
        );
    }
  }
}
