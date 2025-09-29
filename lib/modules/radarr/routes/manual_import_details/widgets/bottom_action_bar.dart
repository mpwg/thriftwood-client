import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrManualImportDetailsBottomActionBar extends StatelessWidget {
  const RadarrManualImportDetailsBottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaBottomActionBar(
      actions: [
        RadarrDatabase.MANUAL_IMPORT_DEFAULT_MODE.listenableBuilder(
          builder: (context, _) => LunaActionBarCard(
            title: 'radarr.ImportMode'.tr(),
            subtitle: RadarrImportMode.COPY
                .from((RadarrDatabase.MANUAL_IMPORT_DEFAULT_MODE.read()))!
                .lunaReadable,
            //checkboxState: true,
            onTap: () async => _importModeOnTap(context),
          ),
        ),
        LunaButton(
          type: LunaButtonType.TEXT,
          text: 'radarr.Import'.tr(),
          icon: Icons.download_done_rounded,
          loadingState:
              context.watch<RadarrManualImportDetailsState>().loadingState,
          onTap: () async => _importOnTap(context),
        ),
      ],
    );
  }

  Future<void> _importModeOnTap(BuildContext context) async {
    (bool, RadarrImportMode?) result =
        await RadarrDialogs().setManualImportMode(context);
    if (result.$1)
      RadarrDatabase.MANUAL_IMPORT_DEFAULT_MODE.update(result.$2!.value);
  }

  Future<void> _importOnTap(BuildContext context) async {
    if (context.read<RadarrManualImportDetailsState>().canExecuteAction &&
        context.read<RadarrManualImportDetailsState>().loadingState ==
            LunaLoadingState.INACTIVE) {
      List<RadarrManualImport> _imports =
          await context.read<RadarrManualImportDetailsState>().manualImport!;
      _imports = _imports
          .where(
            (import) => context
                .read<RadarrManualImportDetailsState>()
                .selectedFiles
                .contains(import.id),
          )
          .toList();
      if (_imports.isEmpty) {
        showLunaInfoSnackBar(
          title: 'Nothing Selected',
          message: 'Please select at least one file to import',
        );
        return;
      }
      bool _allValid = true;
      List<RadarrManualImportFile> _files = [];
      _imports.forEach((import) {
        if (_allValid) {
          (RadarrManualImportFile?, String?) _file =
              RadarrAPIHelper().buildManualImportFile(import: import);
          if (_file.$1 != null) {
            _files.add(_file.$1!);
          } else {
            showLunaInfoSnackBar(title: 'Invalid Inputs', message: _file.$2);
            _allValid = false;
          }
        }
      });
      if (_allValid) {
        context.read<RadarrManualImportDetailsState>().loadingState =
            LunaLoadingState.ACTIVE;
        await RadarrAPIHelper()
            .triggerManualImport(
              context: context,
              files: _files,
              importMode: RadarrImportMode.COPY.from(
                (RadarrDatabase.MANUAL_IMPORT_DEFAULT_MODE.read()),
              )!,
            )
            .then(
              (result) => result
                  ? Navigator.of(context).pop()
                  : context
                      .read<RadarrManualImportDetailsState>()
                      .loadingState = LunaLoadingState.INACTIVE,
            )
            .catchError(
              (_) => context
                  .read<RadarrManualImportDetailsState>()
                  .loadingState = LunaLoadingState.ERROR,
            );
      }
    }
  }
}
