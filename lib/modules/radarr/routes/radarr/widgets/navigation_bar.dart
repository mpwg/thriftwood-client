import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';

class RadarrNavigationBar extends StatelessWidget {
  final PageController? pageController;
  static List<ScrollController> scrollControllers = List.generate(
    icons.length,
    (_) => ScrollController(),
  );

  static const List<IconData> icons = [
    Icons.movie_rounded,
    Icons.insert_invitation_rounded,
    Icons.event_busy_rounded,
    Icons.more_horiz_rounded,
  ];

  static List<String> get titles => [
        'radarr.Movies'.tr(),
        'radarr.Upcoming'.tr(),
        'radarr.Missing'.tr(),
        'radarr.More'.tr(),
      ];

  const RadarrNavigationBar({super.key, required this.pageController});

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
