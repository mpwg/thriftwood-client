import 'package:flutter/material.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/nzbget/routes/nzbget.dart';
import 'package:thriftwood/modules/nzbget/routes/statistics.dart';
import 'package:thriftwood/router/routes.dart';
import 'package:thriftwood/vendor.dart';

enum NZBGetRoutes with LunaRoutesMixin {
  HOME('/nzbget'),
  STATISTICS('statistics');

  @override
  final String path;

  const NZBGetRoutes(this.path);

  @override
  LunaModule get module => LunaModule.NZBGET;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case NZBGetRoutes.HOME:
        return route(widget: const NZBGetRoute());
      case NZBGetRoutes.STATISTICS:
        return route(widget: const StatisticsRoute());
    }
  }

  @override
  List<GoRoute> get subroutes {
    switch (this) {
      case NZBGetRoutes.HOME:
        return [NZBGetRoutes.STATISTICS.routes];
      default:
        return const [];
    }
  }
}
