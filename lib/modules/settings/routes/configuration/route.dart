import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';
import 'package:lunasea/router/routes/settings.dart';
import 'package:lunasea/system/quick_actions/quick_actions.dart';
import 'package:lunasea/system/hybrid_bridge.dart';
import 'package:lunasea/utils/profile_tools.dart';

class ConfigurationRoute extends StatefulWidget {
  const ConfigurationRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationRoute> createState() => _State();
}

class _State extends State<ConfigurationRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      title: 'settings.Configuration'.tr(),
      scrollControllers: [scrollController],
      actions: [_enabledProfile()],
    );
  }

  Widget _enabledProfile() {
    return LunaBox.profiles.listenableBuilder(
      builder: (context, _) {
        if (LunaBox.profiles.size < 2) return const SizedBox();
        return LunaIconButton(
          icon: Icons.switch_account_rounded,
          onPressed: () async {
            final dialogs = SettingsDialogs();
            final enabledProfile = LunaSeaDatabase.ENABLED_PROFILE.read();
            final profiles = LunaProfile.list;
            profiles.removeWhere((p) => p == enabledProfile);

            if (profiles.isEmpty) {
              showLunaInfoSnackBar(
                title: 'settings.NoProfilesFound'.tr(),
                message: 'settings.NoAdditionalProfilesAdded'.tr(),
              );
              return;
            }

            final selected = await dialogs.enabledProfile(
              LunaState.context,
              profiles,
            );
            if (selected.item1) {
              LunaProfileTools().changeTo(selected.item2);
            }
          },
        );
      },
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        LunaBlock(
          title: 'settings.General'.tr(),
          body: [TextSpan(text: 'settings.GeneralDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.brush_rounded),
          onTap: SettingsRoutes.CONFIGURATION_GENERAL.go,
        ),
        LunaBlock(
          title: 'settings.Drawer'.tr(),
          body: [TextSpan(text: 'settings.DrawerDescription'.tr())],
          trailing: const LunaIconButton(icon: Icons.menu_rounded),
          onTap: SettingsRoutes.CONFIGURATION_DRAWER.go,
        ),
        if (LunaQuickActions.isSupported)
          LunaBlock(
            title: 'settings.QuickActions'.tr(),
            body: [TextSpan(text: 'settings.QuickActionsDescription'.tr())],
            trailing: const LunaIconButton(icon: Icons.rounded_corner_rounded),
            onTap: SettingsRoutes.CONFIGURATION_QUICK_ACTIONS.go,
          ),
        LunaDivider(),
        ..._moduleList(),
      ],
    );
  }

  List<Widget> _moduleList() {
    return ([LunaModule.DASHBOARD, ...LunaModule.active])
        .map(_tileFromModuleMap)
        .toList();
  }

  Widget _tileFromModuleMap(LunaModule module) {
    const _db = LunaSeaDatabase.HYBRID_SETTINGS_USE_SWIFTUI;
    return _db.listenableBuilder(
      builder: (context, _) {
        bool useSwiftUISettings = _db.read();

        return LunaBlock(
          title: module.title,
          body: [
            TextSpan(text: 'settings.ConfigureModule'.tr(args: [module.title]))
          ],
          trailing: LunaIconButton(icon: module.icon),
          onTap: () =>
              _handleModuleSettingsNavigation(module, useSwiftUISettings),
        );
      },
    );
  }

  void _handleModuleSettingsNavigation(
      LunaModule module, bool useSwiftUISettings) {
    if (useSwiftUISettings) {
      // Map modules to their SwiftUI route names
      String? swiftUIRoute = _getSwiftUIRouteForModule(module);
      if (swiftUIRoute != null) {
        FlutterSwiftUIBridge.navigateToNativeView(
          swiftUIRoute,
          data: {'module': module.key},
        );
        return;
      }
    }

    // Fallback to Flutter route
    module.settingsRoute!.go();
  }

  String? _getSwiftUIRouteForModule(LunaModule module) {
    switch (module) {
      case LunaModule.RADARR:
        return 'settings_radarr';
      case LunaModule.SONARR:
        return 'settings_sonarr';
      case LunaModule.LIDARR:
        return 'settings_lidarr';
      case LunaModule.SABNZBD:
        return 'settings_sabnzbd';
      case LunaModule.NZBGET:
        return 'settings_nzbget';
      case LunaModule.TAUTULLI:
        return 'settings_tautulli';
      case LunaModule.OVERSEERR:
        return 'settings_overseerr';
      default:
        return null; // Fall back to Flutter for unsupported modules
    }
  }
}
