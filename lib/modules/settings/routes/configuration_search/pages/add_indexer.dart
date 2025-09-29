import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/database/models/indexer.dart';
import 'package:thriftwood/router/routes/settings.dart';

class ConfigurationSearchAddIndexerRoute extends StatefulWidget {
  const ConfigurationSearchAddIndexerRoute({super.key});

  @override
  State<ConfigurationSearchAddIndexerRoute> createState() => _State();
}

class _State extends State<ConfigurationSearchAddIndexerRoute>
    with LunaScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _indexer = LunaIndexer();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: 'search.AddIndexer'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomActionBar() {
    return LunaBottomActionBar(
      actions: [
        LunaButton.text(
          text: 'search.AddIndexer'.tr(),
          icon: Icons.add_rounded,
          onTap: () async {
            if (_indexer.displayName.isEmpty ||
                _indexer.host.isEmpty ||
                _indexer.apiKey.isEmpty) {
              showLunaErrorSnackBar(
                title: 'search.FailedToAddIndexer'.tr(),
                message: 'settings.AllFieldsAreRequired'.tr(),
              );
            } else {
              LunaBox.indexers.create(_indexer);
              showLunaSuccessSnackBar(
                title: 'search.IndexerAdded'.tr(),
                message: _indexer.displayName,
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
      children: [_displayName(), _apiURL(), _apiKey(), _headers()],
    );
  }

  Widget _displayName() {
    String _name = _indexer.displayName;
    return LunaBlock(
      title: 'settings.DisplayName'.tr(),
      body: [TextSpan(text: _name.isEmpty ? 'thriftwood.NotSet'.tr() : _name)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async {
        (bool, String) values = await LunaDialogs().editText(
          context,
          'settings.DisplayName'.tr(),
          prefill: _name,
        );
        if (values.$1 && mounted) {
          setState(() => _indexer.displayName = values.$2);
        }
      },
    );
  }

  Widget _apiURL() {
    String _host = _indexer.host;
    return LunaBlock(
      title: 'search.IndexerAPIHost'.tr(),
      body: [TextSpan(text: _host.isEmpty ? 'thriftwood.NotSet'.tr() : _host)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async {
        (bool, String) values = await LunaDialogs().editText(
          context,
          'search.IndexerAPIHost'.tr(),
          prefill: _host,
        );
        if (values.$1 && mounted) {
          setState(() => _indexer.host = values.$2);
        }
      },
    );
  }

  Widget _apiKey() {
    String _key = _indexer.apiKey;
    return LunaBlock(
      title: 'search.IndexerAPIKey'.tr(),
      body: [TextSpan(text: _key.isEmpty ? 'thriftwood.NotSet'.tr() : _key)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async {
        (bool, String) values = await LunaDialogs().editText(
          context,
          'search.IndexerAPIKey'.tr(),
          prefill: _key,
        );
        if (values.$1 && mounted) {
          setState(() => _indexer.apiKey = values.$2);
        }
      },
    );
  }

  Widget _headers() {
    return LunaBlock(
      title: 'settings.CustomHeaders'.tr(),
      body: [TextSpan(text: 'settings.CustomHeadersDescription'.tr())],
      trailing: const LunaIconButton.arrow(),
      onTap: () => SettingsRoutes.CONFIGURATION_SEARCH_ADD_INDEXER_HEADERS.go(
        extra: _indexer,
      ),
    );
  }
}
