import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/database/models/indexer.dart';
import 'package:thriftwood/modules/search.dart';
import 'package:thriftwood/router/routes/search.dart';

class SearchIndexerTile extends StatelessWidget {
  final LunaIndexer? indexer;

  const SearchIndexerTile({Key? key, required this.indexer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: indexer!.displayName,
      body: [TextSpan(text: indexer!.host)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async {
        context.read<SearchState>().indexer = indexer!;
        SearchRoutes.CATEGORIES.go();
      },
    );
  }
}
