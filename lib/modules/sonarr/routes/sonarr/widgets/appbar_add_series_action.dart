import 'package:flutter/material.dart';
import 'package:thriftwood/router/routes/sonarr.dart';
import 'package:thriftwood/widgets/ui.dart';

class SonarrAppBarAddSeriesAction extends StatelessWidget {
  const SonarrAppBarAddSeriesAction({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaIconButton(
      icon: Icons.add_rounded,
      onPressed: SonarrRoutes.ADD_SERIES.go,
    );
  }
}
