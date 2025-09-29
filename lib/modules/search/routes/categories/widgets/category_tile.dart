import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/search.dart';
import 'package:thriftwood/router/routes/search.dart';

class SearchCategoryTile extends StatelessWidget {
  final NewznabCategoryData category;
  final int index;

  const SearchCategoryTile({super.key, required this.category, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: category.name ?? 'thriftwood.Unknown'.tr(),
      body: [TextSpan(text: category.subcategoriesTitleList)],
      trailing: LunaIconButton(
        icon: category.icon,
        color: LunaColours().byListIndex(index),
      ),
      onTap: () async {
        context.read<SearchState>().activeCategory = category;
        SearchRoutes.SUBCATEGORIES.go();
      },
    );
  }
}
