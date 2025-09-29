import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/search.dart';
import 'package:thriftwood/router/routes/search.dart';
import 'package:thriftwood/widgets/sheets/download_client/button.dart';

class ResultsRoute extends StatefulWidget {
  const ResultsRoute({super.key});

  @override
  State<ResultsRoute> createState() => _State();
}

class _State extends State<ResultsRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  late final PagingController<int, NewznabResultData> _pagingController =
      PagingController(
    fetchPage: _fetchPage,
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<NewznabResultData>> _fetchPage(int pageKey) async {
    try {
      NewznabCategoryData? category =
          context.read<SearchState>().activeCategory;
      NewznabSubcategoryData? subcategory =
          context.read<SearchState>().activeSubcategory;
      final data = await context.read<SearchState>().api.getResults(
            categoryId: subcategory?.id ?? category?.id,
            offset: pageKey,
          );
      return data;
    } catch (error, stack) {
      LunaLogger().error(
        'Unable to fetch search results page: $pageKey',
        error,
        stack,
      );
      rethrow;
    }
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
    String? title = 'search.Results'.tr();
    NewznabCategoryData? category = context.read<SearchState>().activeCategory;
    NewznabSubcategoryData? subcategory =
        context.read<SearchState>().activeSubcategory;
    if (category != null) title = category.name;
    if (category != null && subcategory != null) {
      title = '$title > ${subcategory.name ?? 'thriftwood.Unknown'.tr()}';
    }
    return LunaAppBar(
      title: title ?? '',
      actions: [
        const DownloadClientButton(),
        LunaIconButton(
          icon: Icons.search_rounded,
          onPressed: () => SearchRoutes.SEARCH.go(),
        ),
      ],
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return LunaPagedListView<NewznabResultData>(
      refreshKey: _refreshKey,
      pagingController: _pagingController,
      scrollController: scrollController,
      noItemsFoundMessage: 'search.NoResultsFound'.tr(),
      itemBuilder: (context, result, index) => SearchResultTile(data: result),
    );
  }
}
