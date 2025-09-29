import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';

class LidarrNavigationBar extends StatelessWidget {
  final PageController? pageController;
  static List<ScrollController> scrollControllers = List.generate(
    icons.length,
    (_) => ScrollController(),
  );

  static const List<IconData> icons = [
    Icons.people_rounded,
    Icons.event_busy_rounded,
    Icons.history_rounded,
  ];

  static List<String> get titles => ['Artists', 'Missing', 'History'];

  const LidarrNavigationBar({super.key, required this.pageController});

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
