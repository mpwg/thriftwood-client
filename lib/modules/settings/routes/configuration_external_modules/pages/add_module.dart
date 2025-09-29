import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/database/models/external_module.dart';
import 'package:thriftwood/modules/settings.dart';

class ConfigurationExternalModulesAddRoute extends StatefulWidget {
  const ConfigurationExternalModulesAddRoute({super.key});

  @override
  State<ConfigurationExternalModulesAddRoute> createState() => _State();
}

class _State extends State<ConfigurationExternalModulesAddRoute>
    with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LunaExternalModule _module = LunaExternalModule();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      scrollControllers: [scrollController],
      title: 'settings.AddModule'.tr(),
    );
  }

  Widget _bottomNavigationBar() {
    return LunaBottomActionBar(
      actions: [
        LunaButton.text(
          text: 'settings.AddModule'.tr(),
          icon: Icons.add_rounded,
          onTap: () async {
            if (_module.displayName.isEmpty || _module.host.isEmpty) {
              showLunaErrorSnackBar(
                title: 'settings.AddModuleFailed'.tr(),
                message: 'settings.AllFieldsAreRequired'.tr(),
              );
            } else {
              LunaBox.externalModules.create(_module);
              showLunaSuccessSnackBar(
                title: 'settings.AddModuleSuccess'.tr(),
                message: _module.displayName,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [_displayNameTile(), _hostTile()],
    );
  }

  Widget _displayNameTile() {
    String _displayName = _module.displayName;
    return LunaBlock(
      title: 'settings.DisplayName'.tr(),
      body: [
        TextSpan(
          text: _displayName.isEmpty ? 'thriftwood.NotSet'.tr() : _displayName,
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async {
        (bool, String) values = await LunaDialogs().editText(
          context,
          'settings.DisplayName'.tr(),
          prefill: _displayName,
        );
        if (values.$1) setState(() => _module.displayName = values.$2);
      },
    );
  }

  Widget _hostTile() {
    String _host = _module.host;
    return LunaBlock(
      title: 'settings.Host'.tr(),
      body: [TextSpan(text: _host.isEmpty ? 'thriftwood.NotSet'.tr() : _host)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async {
        (bool, String) values = await SettingsDialogs()
            .editExternalModuleHost(context, prefill: _host);
        if (values.$1) setState(() => _module.host = values.$2);
      },
    );
  }
}
