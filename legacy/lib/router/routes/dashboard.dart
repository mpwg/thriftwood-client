import 'package:flutter/material.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/dashboard/routes/dashboard/route.dart';
import 'package:thriftwood/router/routes.dart';
import 'package:thriftwood/vendor.dart';

enum DashboardRoutes with LunaRoutesMixin {
  HOME('/dashboard');

  @override
  final String path;

  const DashboardRoutes(this.path);

  @override
  LunaModule get module => LunaModule.DASHBOARD;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case DashboardRoutes.HOME:
        return route(widget: const DashboardRoute());
    }
  }
}
