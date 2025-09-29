import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrAppBarSeriesSettingsAction extends StatelessWidget {
  final int seriesId;

  const SonarrAppBarSeriesSettingsAction({super.key, required this.seriesId});

  @override
  Widget build(BuildContext context) {
    return Consumer<SonarrState>(
      builder: (context, state, _) => FutureBuilder(
        future: state.series,
        builder: (context, AsyncSnapshot<Map<int?, SonarrSeries>> snapshot) {
          if (snapshot.hasError) return Container();
          if (snapshot.hasData) {
            SonarrSeries? series = snapshot.data![seriesId];
            if (series != null)
              return LunaIconButton(
                icon: Icons.more_vert_rounded,
                onPressed: () async {
                  (bool, SonarrSeriesSettingsType?) values =
                      await SonarrDialogs().seriesSettings(context, series);
                  if (values.$1) values.$2!.execute(context, series);
                },
              );
          }
          return Container();
        },
      ),
    );
  }
}
