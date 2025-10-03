import 'package:flutter/material.dart';

import 'package:thriftwood/modules.dart';
import 'package:thriftwood/database/tables/dashboard.dart';
import 'package:thriftwood/database/tables/thriftwood.dart';
import 'package:thriftwood/widgets/ui.dart';
import 'package:thriftwood/modules/dashboard/routes/dashboard/pages/calendar.dart';
import 'package:thriftwood/modules/dashboard/routes/dashboard/pages/modules.dart';
import 'package:thriftwood/modules/dashboard/routes/dashboard/widgets/switch_view_action.dart';
import 'package:thriftwood/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

class DashboardRoute extends StatefulWidget {
  const DashboardRoute({Key? key}) : super(key: key);

  @override
  State<DashboardRoute> createState() => _State();
}

class _State extends State<DashboardRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LunaPageController? _pageController;

  @override
  void initState() {
    super.initState();

    int page = DashboardDatabase.NAVIGATION_INDEX.read();
    _pageController = LunaPageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      module: LunaModule.DASHBOARD,
      body: _body(),
      appBar: _appBar(),
      drawer: LunaDrawer(page: LunaModule.DASHBOARD.key),
      bottomNavigationBar: HomeNavigationBar(pageController: _pageController),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: 'thriftwood',
      useDrawer: true,
      scrollControllers: HomeNavigationBar.scrollControllers,
      pageController: _pageController,
      actions: [SwitchViewAction(pageController: _pageController)],
    );
  }

  Widget _body() {
    return thriftwoodDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => LunaPageView(
        controller: _pageController,
        children: [
          ModulesPage(key: ValueKey(thriftwoodDatabase.ENABLED_PROFILE.read())),
          CalendarPage(
            key: ValueKey(thriftwoodDatabase.ENABLED_PROFILE.read()),
          ),
        ],
      ),
    );
  }
}
