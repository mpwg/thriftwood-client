import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class AddSeriesRoute extends StatefulWidget {
  final String query;

  const AddSeriesRoute({super.key, required this.query});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddSeriesRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SonarrAddSeriesState(context, widget.query),
      builder: (context, _) => LunaScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar() as PreferredSizeWidget?,
        body: _body(),
      ),
    );
  }

  Widget _appBar() {
    return SonarrSeriesAddAppBar(
      scrollController: scrollController,
      query: widget.query,
      autofocus: widget.query.isEmpty,
    );
  }

  Widget _body() {
    return SonarrAddSeriesSearchPage(scrollController: scrollController);
  }
}
