import 'package:flutter/material.dart';
import 'package:thriftwood/database/models/profile.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/nzbget.dart';
import 'package:thriftwood/modules/sabnzbd/routes.dart';
import 'package:thriftwood/utils/dialogs.dart';
import 'package:thriftwood/vendor.dart';
import 'package:thriftwood/widgets/pages/invalid_route.dart';
import 'package:thriftwood/widgets/ui.dart';

class DownloadClientSheet extends LunaBottomModalSheet {
  Future<LunaModule?> getDownloadClient() async {
    final profile = LunaProfile.current;
    final nzbget = profile.nzbgetEnabled;
    final sabnzbd = profile.sabnzbdEnabled;

    if (nzbget && sabnzbd) {
      return LunaDialogs().selectDownloadClient();
    }
    if (nzbget) {
      return LunaModule.NZBGET;
    }
    if (sabnzbd) {
      return LunaModule.SABNZBD;
    }

    return null;
  }

  @override
  Future<dynamic> show({Widget Function(BuildContext context)? builder}) async {
    final module = await getDownloadClient();
    if (module != null) {
      return showModal(
        builder: (context) {
          if (module == LunaModule.SABNZBD) {
            return const SABnzbdRoute(showDrawer: false);
          }
          if (module == LunaModule.NZBGET) {
            return const NZBGetRoute(showDrawer: false);
          }
          return InvalidRoutePage();
        },
      );
    }
  }
}
