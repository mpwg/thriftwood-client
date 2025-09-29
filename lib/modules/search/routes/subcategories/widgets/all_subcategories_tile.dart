import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/search.dart';
import 'package:thriftwood/router/routes/search.dart';

class SearchSubcategoryAllTile extends StatelessWidget {
  const SearchSubcategoryAllTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SearchState, NewznabCategoryData?>(
      selector: (_, state) => state.activeCategory,
      builder: (context, category, _) => LunaBlock(
        title: 'search.AllSubcategories'.tr(),
        body: [TextSpan(text: category?.name ?? 'thriftwood.Unknown'.tr())],
        trailing: LunaIconButton(
          icon: context.read<SearchState>().activeCategory?.icon,
          color: LunaColours().byListIndex(0),
        ),
        onTap: () async {
          context.read<SearchState>().activeSubcategory = null;
          SearchRoutes.RESULTS.go();
        },
      ),
    );
  }
}
