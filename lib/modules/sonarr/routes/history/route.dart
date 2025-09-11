import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class HistoryRoute extends StatefulWidget {
  const HistoryRoute({Key? key}) : super(key: key);

  @override
  State<HistoryRoute> createState() => _State();
}

class _State extends State<HistoryRoute>
    with LunaScrollControllerMixin, LunaLoadCallbackMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late final _pagingController = PagingController<int, SonarrHistoryRecord>(
    fetchPage: _fetchPage,
    getNextPageKey: (state) => _getNextPageKey(state),
  );
  
  // Store pagination info
  int? _totalRecords;
  int? _currentPage;
  int? _pageSize;

  @override
  Future<void> loadCallback() async {
    context.read<SonarrState>().fetchAllSeries();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<SonarrHistoryRecord>> _fetchPage(int pageKey) async {
    try {
      final data = await context
          .read<SonarrState>()
          .api!
          .history
          .get(
            page: pageKey,
            pageSize: SonarrDatabase.CONTENT_PAGE_SIZE.read(),
            sortKey: SonarrHistorySortKey.DATE,
            sortDirection: SonarrSortDirection.DESCENDING,
            includeEpisode: true,
          );
      
      // Store pagination info
      _totalRecords = data.totalRecords;
      _currentPage = data.page;
      _pageSize = data.pageSize;
      
      return data.records ?? [];
    } catch (error, stack) {
      LunaLogger().error(
        'Unable to fetch Sonarr history page: $pageKey',
        error,
        stack,
      );
      rethrow;
    }
  }

  int? _getNextPageKey(PagingState<int, SonarrHistoryRecord> state) {
    if (_totalRecords == null || _currentPage == null || _pageSize == null) {
      return null;
    }
    
    final currentPageKey = state.nextIntPageKey;
    final totalItemsFetched = currentPageKey * _pageSize!;
    
    if (totalItemsFetched < _totalRecords!) {
      return currentPageKey + 1;
    }
    
    return null;
  }

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
      title: 'sonarr.History'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return FutureBuilder(
      future: context.read<SonarrState>().series,
      builder: (context, AsyncSnapshot<Map<int, SonarrSeries>> snapshot) {
        if (snapshot.hasError) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            LunaLogger().error(
              'Unable to fetch Sonarr series',
              snapshot.error,
              snapshot.stackTrace,
            );
          }
          return LunaMessage.error(onTap: _refreshKey.currentState!.show);
        }
        if (snapshot.hasData) return _list(snapshot.data);
        return const LunaLoader();
      },
    );
  }

  Widget _list(Map<int, SonarrSeries>? series) {
    return LunaPagedListView<SonarrHistoryRecord>(
      refreshKey: _refreshKey,
      pagingController: _pagingController,
      scrollController: scrollController,
      noItemsFoundMessage: 'sonarr.NoHistoryFound'.tr(),
      itemBuilder: (context, history, _) => SonarrHistoryTile(
        history: history,
        series: series![history.seriesId!],
        type: SonarrHistoryTileType.ALL,
      ),
    );
  }
}
