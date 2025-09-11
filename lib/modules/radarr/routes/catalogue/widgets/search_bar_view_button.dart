import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/scroll_controller.dart';
import 'package:thriftwood/modules/radarr.dart';
import 'package:thriftwood/types/list_view_option.dart';

class RadarrCatalogueSearchBarViewButton extends StatefulWidget {
  final ScrollController controller;

  const RadarrCatalogueSearchBarViewButton({Key? key, required this.controller})
    : super(key: key);

  @override
  State<RadarrCatalogueSearchBarViewButton> createState() => _State();
}

class _State extends State<RadarrCatalogueSearchBarViewButton> {
  @override
  Widget build(BuildContext context) {
    return LunaCard(
      context: context,
      child: Consumer<RadarrState>(
        builder: (context, state, _) => LunaPopupMenuButton<LunaListViewOption>(
          tooltip: 'thriftwood.View'.tr(),
          icon: LunaIcons.VIEW,
          onSelected: (result) {
            state.moviesViewType = result;
            widget.controller.animateToStart();
          },
          itemBuilder: (context) =>
              List<PopupMenuEntry<LunaListViewOption>>.generate(
                LunaListViewOption.values.length,
                (index) => PopupMenuItem<LunaListViewOption>(
                  value: LunaListViewOption.values[index],
                  child: Text(
                    LunaListViewOption.values[index].readable,
                    style: TextStyle(
                      fontSize: LunaUI.FONT_SIZE_H3,
                      color:
                          state.moviesViewType ==
                              LunaListViewOption.values[index]
                          ? LunaColours.accent
                          : Colors.white,
                    ),
                  ),
                ),
              ),
        ),
      ),
      margin: const EdgeInsets.only(left: LunaUI.DEFAULT_MARGIN_SIZE),
      color: Theme.of(context).canvasColor,
      height: LunaTextInputBar.defaultHeight,
      width: LunaTextInputBar.defaultHeight,
    );
  }
}
