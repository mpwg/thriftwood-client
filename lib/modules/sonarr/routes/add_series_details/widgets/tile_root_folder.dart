import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesAddDetailsRootFolderTile extends StatelessWidget {
  const SonarrSeriesAddDetailsRootFolderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.RootFolder'.tr(),
      body: [
        TextSpan(
          text: context.watch<SonarrSeriesAddDetailsState>().rootFolder.path ??
              LunaUI.TEXT_EMDASH,
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    List<SonarrRootFolder> _folders =
        await context.read<SonarrState>().rootFolders!;
    (bool, SonarrRootFolder?) result =
        await SonarrDialogs().editRootFolder(context, _folders);
    if (result.$1) {
      context.read<SonarrSeriesAddDetailsState>().rootFolder = result.$2!;
      SonarrDatabase.ADD_SERIES_DEFAULT_ROOT_FOLDER.update(result.$2!.id);
    }
  }
}
