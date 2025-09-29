import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';

class RadarrAddMovieNavigationBar extends StatelessWidget {
  final PageController? pageController;
  static List<ScrollController> scrollControllers = List.generate(
    icons.length,
    (_) => ScrollController(),
  );

  static const List<IconData> icons = [
    Icons.search_rounded,
    Icons.whatshot_rounded,
  ];

  static List<String> get titles => [
        'radarr.Search'.tr(),
        'radarr.Discover'.tr(),
      ];

  const RadarrAddMovieNavigationBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return LunaBottomNavigationBar(
      pageController: pageController,
      scrollControllers: scrollControllers,
      icons: icons,
      titles: titles,
    );
  }
}
