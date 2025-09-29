import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrAddMovieDetailsRootFolderTile extends StatelessWidget {
  const RadarrAddMovieDetailsRootFolderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrAddMovieDetailsState, RadarrRootFolder>(
      selector: (_, state) => state.rootFolder,
      builder: (context, folder, _) => LunaBlock(
        title: 'radarr.RootFolder'.tr(),
        body: [TextSpan(text: folder.path ?? LunaUI.TEXT_EMDASH)],
        trailing: const LunaIconButton.arrow(),
        onTap: () async {
          List<RadarrRootFolder> folders =
              await context.read<RadarrState>().rootFolders!;
          (bool, RadarrRootFolder?) values =
              await RadarrDialogs().editRootFolder(context, folders);
          if (values.$1)
            context.read<RadarrAddMovieDetailsState>().rootFolder = values.$2!;
        },
      ),
    );
  }
}
