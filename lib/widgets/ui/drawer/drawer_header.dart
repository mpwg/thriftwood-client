import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';

class LunaDrawerHeader extends StatelessWidget {
  final String page;

  const LunaDrawerHeader({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return thriftwoodDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => Container(
        child: LunaAppBar.dropdown(
          backgroundColor: Colors.transparent,
          hideLeading: true,
          useDrawer: false,
          title: LunaBox.profiles.keys.length == 1
              ? 'Thriftwood'
              : thriftwoodDatabase.ENABLED_PROFILE.read(),
          profiles: LunaBox.profiles.keys.cast<String>().toList(),
          actions: [
            LunaIconButton(
              icon: LunaIcons.SETTINGS,
              onPressed: page == LunaModule.SETTINGS.key
                  ? Navigator.of(context).pop
                  : LunaModule.SETTINGS.launch,
            ),
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
      ),
    );
  }
}
