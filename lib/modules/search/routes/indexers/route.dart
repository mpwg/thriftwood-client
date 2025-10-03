import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/search.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';

class SearchRoute extends StatefulWidget {
  const SearchRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchRoute> createState() => _State();
}

class _State extends State<SearchRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      drawer: _drawer(),
      body: _body(),
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      useDrawer: true,
      title: LunaModule.SEARCH.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _drawer() => LunaDrawer(page: LunaModule.SEARCH.key);

  Widget _body() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: SwiftDataAccessor.getAllIndexers(),
      builder: (context, snapshot) {
        final indexers = snapshot.data ?? [];
        if (indexers.isEmpty) {
          return LunaMessage.moduleNotEnabled(
            context: context,
            module: LunaModule.SEARCH.title,
          );
        }

        return _buildIndexersList(indexers);
      },
    );
  }

  Widget _buildIndexersList(List<Map<String, dynamic>> indexers) {
    // TODO: Update SearchIndexerTile to work with SwiftData format
    final indexerWidgets = indexers
        .map((indexerData) => ListTile(
              title: Text(indexerData['displayName'] ?? 'Unknown Indexer'),
              subtitle: Text(indexerData['host'] ?? ''),
              onTap: () {
                // TODO: Implement indexer navigation
              },
            ))
        .toList();

    return LunaListView(
      controller: scrollController,
      children: indexerWidgets,
    );
  }
}
