import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/router/routes/radarr.dart';

class RadarrAppBarAddMoviesAction extends StatelessWidget {
  const RadarrAppBarAddMoviesAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaIconButton(
      icon: Icons.add_rounded,
      iconSize: LunaUI.ICON_SIZE,
      onPressed: RadarrRoutes.ADD_MOVIE.go,
    );
  }
}
