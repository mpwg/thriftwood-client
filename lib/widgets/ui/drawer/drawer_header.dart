import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';

class LunaDrawerHeader extends StatelessWidget {
  final String page;

  const LunaDrawerHeader({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaSeaDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => FutureBuilder<List<Map<String, dynamic>>>(
        future: SwiftDataAccessor.getAllProfiles(),
        builder: (context, snapshot) {
          final profiles =
              snapshot.data?.map((p) => p['profileKey'] as String).toList() ??
                  [];
          final currentProfile = LunaSeaDatabase.ENABLED_PROFILE.read();

          return Container(
            child: LunaAppBar.dropdown(
              backgroundColor: Colors.transparent,
              hideLeading: true,
              useDrawer: false,
              title: profiles.length == 1 ? profiles.first : currentProfile,
              profiles: profiles,
              actions: [
                LunaIconButton(
                  icon: LunaIcons.SETTINGS,
                  onPressed: page == LunaModule.SETTINGS.key
                      ? Navigator.of(context).pop
                      : LunaModule.SETTINGS.launch,
                )
              ],
            ),
            decoration: BoxDecoration(
              color: LunaColours.accent,
              image: DecorationImage(
                image: const AssetImage(LunaAssets.brandingLogo),
                colorFilter: ColorFilter.mode(
                  LunaColours.primary.withOpacity(0.15),
                  BlendMode.dstATop,
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
