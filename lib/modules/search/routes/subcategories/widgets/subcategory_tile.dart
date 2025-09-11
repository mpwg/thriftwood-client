import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/search.dart';
import 'package:thriftwood/router/routes/search.dart';

class SearchSubcategoryTile extends StatelessWidget {
  final int index;

  const SearchSubcategoryTile({Key? key, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SearchState, NewznabCategoryData?>(
      selector: (_, state) => state.activeCategory,
      builder: (context, category, _) {
        NewznabSubcategoryData subcategory = category!.subcategories[index];
        return LunaBlock(
          title: subcategory.name ?? 'thriftwood.Unknown'.tr(),
          body: [
            TextSpan(
              text: [
                category.name ?? 'thriftwood.Unknown'.tr(),
                subcategory.name ?? 'thriftwood.Unknown'.tr(),
              ].join(' > '),
            ),
          ],
          trailing: LunaIconButton(
            icon: category.icon,
            color: LunaColours().byListIndex(index + 1),
          ),
          onTap: () async {
            context.read<SearchState>().activeSubcategory = subcategory;
            SearchRoutes.RESULTS.go();
          },
        );
      },
    );
  }
}
