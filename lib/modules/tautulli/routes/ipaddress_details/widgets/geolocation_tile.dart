import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliIPAddressDetailsGeolocationTile extends StatelessWidget {
  final TautulliGeolocationInfo geolocation;

  const TautulliIPAddressDetailsGeolocationTile({
    super.key,
    required this.geolocation,
  });

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(
          title: 'country',
          body: geolocation.country ?? LunaUI.TEXT_EMDASH,
        ),
        LunaTableContent(
          title: 'region',
          body: geolocation.region ?? LunaUI.TEXT_EMDASH,
        ),
        LunaTableContent(
          title: 'city',
          body: geolocation.city ?? LunaUI.TEXT_EMDASH,
        ),
        LunaTableContent(
          title: 'postal',
          body: geolocation.postalCode ?? LunaUI.TEXT_EMDASH,
        ),
        LunaTableContent(
          title: 'timezone',
          body: geolocation.timezone ?? LunaUI.TEXT_EMDASH,
        ),
        LunaTableContent(
          title: 'latitude',
          body: '${geolocation.latitude ?? LunaUI.TEXT_EMDASH}',
        ),
        LunaTableContent(
          title: 'longitude',
          body: '${geolocation.longitude ?? LunaUI.TEXT_EMDASH}',
        ),
      ],
    );
  }
}
