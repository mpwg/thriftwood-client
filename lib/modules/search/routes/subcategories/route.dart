import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/search.dart';
import 'package:thriftwood/router/routes/search.dart';

class SubcategoriesRoute extends StatefulWidget {
  const SubcategoriesRoute({super.key});

  @override
  State<SubcategoriesRoute> createState() => _State();
}

class _State extends State<SubcategoriesRoute> with LunaScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      title: context.read<SearchState>().activeCategory?.name ??
          'search.Subcategories'.tr(),
      scrollControllers: [scrollController],
      actions: [
        LunaIconButton(
          icon: Icons.search_rounded,
          onPressed: () async {
            context.read<SearchState>().activeSubcategory = null;
            SearchRoutes.SEARCH.go();
          },
        ),
      ],
    );
  }

  Widget _body() {
    return Selector<SearchState, NewznabCategoryData?>(
      selector: (_, state) => state.activeCategory,
      builder: (context, category, child) {
        List<NewznabSubcategoryData> subcategories =
            category?.subcategories ?? [];
        return LunaListView(
          controller: scrollController,
          children: [
            const SearchSubcategoryAllTile(),
            ...List.generate(
              subcategories.length,
              (index) => SearchSubcategoryTile(index: index),
            ),
          ],
        );
      },
    );
  }
}
