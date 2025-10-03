import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';
import 'package:thriftwood/router/routes/settings.dart';

class ConfigurationTautulliRoute extends StatefulWidget {
  const ConfigurationTautulliRoute({Key? key}) : super(key: key);

  @override
  State<ConfigurationTautulliRoute> createState() => _State();
}

class _State extends State<ConfigurationTautulliRoute>
    with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: LunaModule.TAUTULLI.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        LunaModule.TAUTULLI.informationBanner(),
        _enabledToggle(),
        _connectionDetailsPage(),
        LunaDivider(),
        _activityRefreshRate(),
        _defaultPagesPage(),
        _defaultTerminationMessage(),
        _statisticsItemCount(),
      ],
    );
  }

  Widget _enabledToggle() {
    return LunaBox.profiles.listenableBuilder(
      builder: (context, _) => LunaBlock(
        title: 'settings.EnableModule'.tr(args: [LunaModule.TAUTULLI.title]),
        trailing: LunaSwitch(
          value: LunaProfile.current.tautulliEnabled,
          onChanged: (value) {
            LunaProfile.current.tautulliEnabled = value;
            LunaProfile.current.save();
            context.read<TautulliState>().reset();
          },
        ),
      ),
    );
  }

  Widget _connectionDetailsPage() {
    return LunaBlock(
      title: 'settings.ConnectionDetails'.tr(),
      body: [
        TextSpan(
          text: 'settings.ConnectionDetailsDescription'.tr(
            args: [LunaModule.TAUTULLI.title],
          ),
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_TAUTULLI_CONNECTION_DETAILS.go,
    );
  }

  Widget _defaultPagesPage() {
    return LunaBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const LunaIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_TAUTULLI_DEFAULT_PAGES.go,
    );
  }

  Widget _defaultTerminationMessage() {
    const _db = TautulliDatabase.TERMINATION_MESSAGE;
    return _db.listenableBuilder(
      builder: (context, _) {
        String message = _db.read();
        return LunaBlock(
          title: 'tautulli.DefaultTerminationMessage'.tr(),
          body: [
            TextSpan(
              text: message.isEmpty ? 'thriftwood.NotSet'.tr() : message,
            ),
          ],
          trailing: const LunaIconButton(icon: Icons.videocam_off_rounded),
          onTap: () async {
            (bool, String) result =
                await TautulliDialogs.setTerminationMessage(context);
            if (result.$1) _db.update(result.$2);
          },
        );
      },
    );
  }

  Widget _activityRefreshRate() {
    const _db = TautulliDatabase.REFRESH_RATE;
    return _db.listenableBuilder(
      builder: (context, _) {
        String refreshRate = _db.read() == 1
            ? 'thriftwood.EverySecond'.tr()
            : 'thriftwood.EverySeconds'.tr(args: [_db.read().toString()]);
        return LunaBlock(
          title: 'tautulli.ActivityRefreshRate'.tr(),
          body: [TextSpan(text: refreshRate)],
          trailing: const LunaIconButton(icon: LunaIcons.REFRESH),
          onTap: () async {
            List<dynamic> _values = await TautulliDialogs.setRefreshRate(
              context,
            );
            if (_values[0]) _db.update(_values[1]);
          },
        );
      },
    );
  }

  Widget _statisticsItemCount() {
    const _db = TautulliDatabase.STATISTICS_STATS_COUNT;
    return _db.listenableBuilder(
      builder: (context, _) {
        String statisticsItems = _db.read() == 1
            ? 'thriftwood.OneItem'.tr()
            : 'thriftwood.Items'.tr(args: [_db.read().toString()]);
        return LunaBlock(
          title: 'tautulli.StatisticsItemCount'.tr(),
          body: [TextSpan(text: statisticsItems)],
          trailing: const LunaIconButton(icon: Icons.format_list_numbered),
          onTap: () async {
            List<dynamic> _values =
                await TautulliDialogs.setStatisticsItemCount(context);
            if (_values[0]) _db.update(_values[1]);
          },
        );
      },
    );
  }
}
