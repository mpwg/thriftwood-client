import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/string/links.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrHealthCheckTile extends StatelessWidget {
  final RadarrHealthCheck healthCheck;

  const RadarrHealthCheckTile({super.key, required this.healthCheck});

  @override
  Widget build(BuildContext context) {
    return LunaExpandableListTile(
      title: healthCheck.message!,
      collapsedSubtitles: [subtitle1(), subtitle2()],
      expandedTableContent: expandedTable(),
      expandedHighlightedNodes: highlightedNodes(),
      onLongPress: healthCheck.wikiUrl!.openLink,
    );
  }

  TextSpan subtitle1() {
    return TextSpan(text: healthCheck.source);
  }

  TextSpan subtitle2() {
    return TextSpan(
      text: healthCheck.type!.readable,
      style: TextStyle(
        color: healthCheck.type.lunaColour,
        fontWeight: LunaUI.FONT_WEIGHT_BOLD,
        fontSize: LunaUI.FONT_SIZE_H3,
      ),
    );
  }

  List<LunaHighlightedNode> highlightedNodes() {
    return [
      LunaHighlightedNode(
        text: healthCheck.type!.readable!,
        backgroundColor: healthCheck.type.lunaColour,
      ),
    ];
  }

  List<LunaTableContent> expandedTable() {
    return [LunaTableContent(title: 'Source', body: healthCheck.source)];
  }
}
