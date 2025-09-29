import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/lidarr.dart';

class LidarrDetailsOverview extends StatefulWidget {
  final LidarrCatalogueData data;

  const LidarrDetailsOverview({super.key, required this.data});

  @override
  State<LidarrDetailsOverview> createState() => _State();
}

class _State extends State<LidarrDetailsOverview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LunaListView(
      controller: LidarrArtistNavigationBar.scrollControllers[0],
      children: <Widget>[
        LidarrDescriptionBlock(
          title: widget.data.title,
          description: widget.data.overview == ''
              ? 'No Summary Available'
              : widget.data.overview,
          uri: widget.data.posterURI(),
          squareImage: true,
          headers: LunaProfile.current.lidarrHeaders,
        ),
        LunaTableCard(
          content: [
            LunaTableContent(title: 'Path', body: widget.data.path),
            LunaTableContent(title: 'Quality', body: widget.data.quality),
            LunaTableContent(title: 'Metadata', body: widget.data.metadata),
            LunaTableContent(title: 'Albums', body: widget.data.albums),
            LunaTableContent(title: 'Tracks', body: widget.data.tracks),
            LunaTableContent(title: 'Genres', body: widget.data.genre),
          ],
        ),
      ],
    );
  }
}
