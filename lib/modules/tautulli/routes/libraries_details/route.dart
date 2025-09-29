import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';
import 'package:thriftwood/widgets/pages/invalid_route.dart';

class LibrariesDetailsRoute extends StatefulWidget {
  final int? sectionId;

  const LibrariesDetailsRoute({super.key, required this.sectionId});

  @override
  State<LibrariesDetailsRoute> createState() => _State();
}

class _State extends State<LibrariesDetailsRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LunaPageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = LunaPageController(
      initialPage: TautulliDatabase.NAVIGATION_INDEX_LIBRARIES_DETAILS.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sectionId == null) {
      return InvalidRoutePage(
        title: 'Library Details',
        message: 'Library Not Found',
      );
    }

    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: TautulliLibrariesDetailsNavigationBar(
        pageController: _pageController,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: 'Library Details',
      scrollControllers:
          TautulliLibrariesDetailsNavigationBar.scrollControllers,
      pageController: _pageController,
    );
  }

  Widget _body() {
    return LunaPageView(
      controller: _pageController,
      children: [
        TautulliLibrariesDetailsInformation(sectionId: widget.sectionId!),
        TautulliLibrariesDetailsUserStats(sectionId: widget.sectionId!),
      ],
    );
  }
}
