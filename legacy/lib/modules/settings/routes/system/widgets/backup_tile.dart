import 'package:flutter/material.dart';

import 'package:thriftwood/core.dart';
import 'package:thriftwood/database/config.dart';
import 'package:thriftwood/system/filesystem/filesystem.dart';

class SettingsSystemBackupRestoreBackupTile extends StatelessWidget {
  const SettingsSystemBackupRestoreBackupTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'settings.BackupToDevice'.tr(),
      body: [TextSpan(text: 'settings.BackupToDeviceDescription'.tr())],
      trailing: const LunaIconButton(icon: Icons.upload_rounded),
      onTap: () async => _backup(context),
    );
  }

  Future<void> _backup(BuildContext context) async {
    try {
      String data = LunaConfig().export();
      String name = DateFormat('y-MM-dd kk-mm-ss').format(DateTime.now());
      bool result = await LunaFileSystem().save(
        context,
        '$name.thriftwood',
        data.codeUnits,
      );
      if (result) {
        showLunaSuccessSnackBar(
          title: 'settings.BackupToCloudSuccess'.tr(),
          message: '$name.thriftwood',
        );
      }
    } catch (error, stack) {
      LunaLogger().error('Failed to create device backup', error, stack);
      showLunaErrorSnackBar(
        title: 'settings.BackupToCloudFailure'.tr(),
        error: error,
      );
    }
  }
}
