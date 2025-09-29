import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrMovieDetailsOverviewDescriptionTile extends StatelessWidget {
  final RadarrMovie? movie;

  const RadarrMovieDetailsOverviewDescriptionTile({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      posterPlaceholderIcon: LunaIcons.VIDEO_CAM,
      backgroundUrl: context.read<RadarrState>().getFanartURL(movie!.id),
      posterUrl: context.read<RadarrState>().getPosterURL(movie!.id),
      posterHeaders: context.read<RadarrState>().headers,
      title: movie!.title,
      body: [
        LunaTextSpan.extended(
          text: movie!.overview == null || movie!.overview!.isEmpty
              ? 'sonarr.NoSummaryAvailable'.tr()
              : movie!.overview,
        ),
      ],
      customBodyMaxLines: 3,
      onTap: () async =>
          LunaDialogs().textPreview(context, movie!.title, movie!.overview!),
    );
  }
}
