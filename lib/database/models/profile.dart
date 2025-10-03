import 'package:lunasea/database/tables/lunasea.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';
import 'package:lunasea/vendor.dart';

part 'profile.g.dart';

@JsonSerializable()
class LunaProfile {
  static const String DEFAULT_PROFILE = 'default';

  static LunaProfile get current {
    final enabled = LunaSeaDatabase.ENABLED_PROFILE.read();
    // Legacy getter - should use SwiftDataAccessor.getProfile() for new code
    return LunaProfile(); // Return empty profile as fallback
  }

  static List<String> get list {
    // Legacy getter - should use SwiftDataAccessor.getAllProfiles() for new code
    return [DEFAULT_PROFILE]; // Return default profile as fallback
  }

  @JsonKey()
  bool lidarrEnabled;

  @JsonKey()
  String lidarrHost;

  @JsonKey()
  String lidarrKey;

  @JsonKey()
  Map<String, String> lidarrHeaders;

  @JsonKey()
  bool radarrEnabled;

  @JsonKey()
  String radarrHost;

  @JsonKey()
  String radarrKey;

  @JsonKey()
  Map<String, String> radarrHeaders;

  @JsonKey()
  bool sonarrEnabled;

  @JsonKey()
  String sonarrHost;

  @JsonKey()
  String sonarrKey;

  @JsonKey()
  Map<String, String> sonarrHeaders;

  @JsonKey()
  bool sabnzbdEnabled;

  @JsonKey()
  String sabnzbdHost;

  @JsonKey()
  String sabnzbdKey;

  @JsonKey()
  Map<String, String> sabnzbdHeaders;

  @JsonKey()
  bool nzbgetEnabled;

  @JsonKey()
  String nzbgetHost;

  @JsonKey()
  String nzbgetUser;

  @JsonKey()
  String nzbgetPass;

  @JsonKey()
  Map<String, String> nzbgetHeaders;

  @JsonKey()
  bool wakeOnLANEnabled;

  @JsonKey()
  String wakeOnLANBroadcastAddress;

  @JsonKey()
  String wakeOnLANMACAddress;

  @JsonKey()
  bool tautulliEnabled;

  @JsonKey()
  String tautulliHost;

  @JsonKey()
  String tautulliKey;

  @JsonKey()
  Map<String, String> tautulliHeaders;

  @JsonKey()
  bool overseerrEnabled;

  @JsonKey()
  String overseerrHost;

  @JsonKey()
  String overseerrKey;

  @JsonKey()
  Map<String, String> overseerrHeaders;

  LunaProfile._internal({
    //Lidarr
    required this.lidarrEnabled,
    required this.lidarrHost,
    required this.lidarrKey,
    required this.lidarrHeaders,
    //Radarr
    required this.radarrEnabled,
    required this.radarrHost,
    required this.radarrKey,
    required this.radarrHeaders,
    //Sonarr
    required this.sonarrEnabled,
    required this.sonarrHost,
    required this.sonarrKey,
    required this.sonarrHeaders,
    //SABnzbd
    required this.sabnzbdEnabled,
    required this.sabnzbdHost,
    required this.sabnzbdKey,
    required this.sabnzbdHeaders,
    //NZBGet
    required this.nzbgetEnabled,
    required this.nzbgetHost,
    required this.nzbgetUser,
    required this.nzbgetPass,
    required this.nzbgetHeaders,
    //Wake On LAN
    required this.wakeOnLANEnabled,
    required this.wakeOnLANBroadcastAddress,
    required this.wakeOnLANMACAddress,
    //Tautulli
    required this.tautulliEnabled,
    required this.tautulliHost,
    required this.tautulliKey,
    required this.tautulliHeaders,
    //Overseerr
    required this.overseerrEnabled,
    required this.overseerrHost,
    required this.overseerrKey,
    required this.overseerrHeaders,
  });

  factory LunaProfile({
    //Lidarr
    bool? lidarrEnabled,
    String? lidarrHost,
    String? lidarrKey,
    Map<String, String>? lidarrHeaders,
    //Radarr
    bool? radarrEnabled,
    String? radarrHost,
    String? radarrKey,
    Map<String, String>? radarrHeaders,
    //Sonarr
    bool? sonarrEnabled,
    String? sonarrHost,
    String? sonarrKey,
    Map<String, String>? sonarrHeaders,
    //SABnzbd
    bool? sabnzbdEnabled,
    String? sabnzbdHost,
    String? sabnzbdKey,
    Map<String, String>? sabnzbdHeaders,
    //NZBGet
    bool? nzbgetEnabled,
    String? nzbgetHost,
    String? nzbgetUser,
    String? nzbgetPass,
    Map<String, String>? nzbgetHeaders,
    //Wake On LAN
    bool? wakeOnLANEnabled,
    String? wakeOnLANBroadcastAddress,
    String? wakeOnLANMACAddress,
    //Tautulli
    bool? tautulliEnabled,
    String? tautulliHost,
    String? tautulliKey,
    Map<String, String>? tautulliHeaders,
    //Overseerr
    bool? overseerrEnabled,
    String? overseerrHost,
    String? overseerrKey,
    Map<String, String>? overseerrHeaders,
  }) {
    return LunaProfile._internal(
      // Lidarr
      lidarrEnabled: lidarrEnabled ?? false,
      lidarrHost: lidarrHost ?? '',
      lidarrKey: lidarrKey ?? '',
      lidarrHeaders: lidarrHeaders ?? {},
      // Radarr
      radarrEnabled: radarrEnabled ?? false,
      radarrHost: radarrHost ?? '',
      radarrKey: radarrKey ?? '',
      radarrHeaders: radarrHeaders ?? {},
      // Sonarr
      sonarrEnabled: sonarrEnabled ?? false,
      sonarrHost: sonarrHost ?? '',
      sonarrKey: sonarrKey ?? '',
      sonarrHeaders: sonarrHeaders ?? {},
      // SABnzbd
      sabnzbdEnabled: sabnzbdEnabled ?? false,
      sabnzbdHost: sabnzbdHost ?? '',
      sabnzbdKey: sabnzbdKey ?? '',
      sabnzbdHeaders: sabnzbdHeaders ?? {},
      // NZBGet
      nzbgetEnabled: nzbgetEnabled ?? false,
      nzbgetHost: nzbgetHost ?? '',
      nzbgetUser: nzbgetUser ?? '',
      nzbgetPass: nzbgetPass ?? '',
      nzbgetHeaders: nzbgetHeaders ?? {},
      // Wake On LAN
      wakeOnLANEnabled: wakeOnLANEnabled ?? false,
      wakeOnLANBroadcastAddress: wakeOnLANBroadcastAddress ?? '',
      wakeOnLANMACAddress: wakeOnLANMACAddress ?? '',
      // Tautulli
      tautulliEnabled: tautulliEnabled ?? false,
      tautulliHost: tautulliHost ?? '',
      tautulliKey: tautulliKey ?? '',
      tautulliHeaders: tautulliHeaders ?? {},
      // Overseerr
      overseerrEnabled: overseerrEnabled ?? false,
      overseerrHost: overseerrHost ?? '',
      overseerrKey: overseerrKey ?? '',
      overseerrHeaders: overseerrHeaders ?? {},
    );
  }

  @override
  String toString() => json.encode(this.toJson());

  Map<String, dynamic> toJson() {
    final json = _$LunaProfileToJson(this);
    // Note: key property removed during Hive migration
    return json;
  }

  factory LunaProfile.fromJson(Map<String, dynamic> json) {
    return _$LunaProfileFromJson(json);
  }

  factory LunaProfile.clone(LunaProfile profile) {
    return LunaProfile.fromJson(profile.toJson().cast<String, dynamic>());
  }

  @Deprecated(
      'Use SwiftDataAccessor.getProfile() instead - migrated to SwiftData')
  factory LunaProfile.get(String key) {
    // Legacy method - replaced by SwiftData bridge
    throw UnsupportedError(
        'LunaProfile.get() deprecated - use SwiftDataAccessor.getProfile()');
  }

  bool isAnythingEnabled() {
    for (final module in LunaModule.active) {
      if (module.isEnabled) return true;
    }
    return false;
  }
}
