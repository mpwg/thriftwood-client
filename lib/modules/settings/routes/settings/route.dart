import 'package:flutter/material.dart';

import 'package:lunasea/core.dart';
import 'package:lunasea/router/routes/settings.dart';
import 'package:lunasea/system/hybrid_bridge.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsRoute> createState() => _State();
}

class _State extends State<SettingsRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      drawer: _drawer(),
      body: _body(),
    );
  }

  Widget _drawer() => LunaDrawer(page: LunaModule.SETTINGS.key);

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      useDrawer: true,
      scrollControllers: [scrollController],
      title: LunaModule.SETTINGS.title,
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        _settingsVersionSelector(),
        LunaDivider(),
        _configurationBlock(),
        _profilesBlock(),
        _systemBlock(),
      ],
    );
  }

  Widget _settingsVersionSelector() {
    const _db = LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI;
    return _db.listenableBuilder(
      builder: (context, _) {
        bool useSwiftUISettings = _db.read();

        return LunaBlock(
          title: 'Settings Version',
          body: [
            TextSpan(
              text: useSwiftUISettings
                  ? 'Currently using SwiftUI settings (iOS native experience)'
                  : 'Currently using Flutter settings (cross-platform experience)',
            )
          ],
          trailing: LunaSwitch(
            value: useSwiftUISettings,
            onChanged: _db.update,
          ),
        );
      },
    );
  }

  Widget _configurationBlock() {
    const _db = LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI;
    return _db.listenableBuilder(
      builder: (context, _) {
        bool useSwiftUISettings = _db.read();

        return LunaBlock(
          title: 'settings.Configuration'.tr(),
          body: [TextSpan(text: 'settings.ConfigurationDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.device_hub_rounded),
          onTap: () =>
              _handleSettingsNavigation('configuration', useSwiftUISettings),
        );
      },
    );
  }

  Widget _profilesBlock() {
    const _db = LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI;
    return _db.listenableBuilder(
      builder: (context, _) {
        bool useSwiftUISettings = _db.read();

        return LunaBlock(
          title: 'settings.Profiles'.tr(),
          body: [TextSpan(text: 'settings.ProfilesDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.switch_account_rounded),
          onTap: () =>
              _handleSettingsNavigation('profiles', useSwiftUISettings),
        );
      },
    );
  }

  Widget _systemBlock() {
    const _db = LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI;
    return _db.listenableBuilder(
      builder: (context, _) {
        bool useSwiftUISettings = _db.read();

        return LunaBlock(
          title: 'settings.System'.tr(),
          body: [TextSpan(text: 'settings.SystemDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.settings_rounded),
          onTap: () => _handleSettingsNavigation('system', useSwiftUISettings),
        );
      },
    );
  }

  void _handleSettingsNavigation(String section, bool useSwiftUISettings) {
    if (useSwiftUISettings) {
      // Navigate to SwiftUI version
      FlutterSwiftUIBridge.navigateToNativeView(
        'settings_$section',
        data: {'section': section},
      );
    } else {
      // Navigate to Flutter version
      switch (section) {
        case 'configuration':
          SettingsRoutes.CONFIGURATION.go();
          break;
        case 'profiles':
          SettingsRoutes.PROFILES.go();
          break;
        case 'system':
          SettingsRoutes.SYSTEM.go();
          break;
      }
    }
  }
}
