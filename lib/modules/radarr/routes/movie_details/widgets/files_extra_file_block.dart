import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrMovieDetailsFilesExtraFileBlock extends StatelessWidget {
  final RadarrExtraFile file;

  const RadarrMovieDetailsFilesExtraFileBlock({Key? key, required this.file})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(title: 'relative path', body: file.lunaRelativePath),
        LunaTableContent(title: 'type', body: file.lunaType),
        LunaTableContent(title: 'extension', body: file.lunaExtension),
      ],
    );
  }
}
