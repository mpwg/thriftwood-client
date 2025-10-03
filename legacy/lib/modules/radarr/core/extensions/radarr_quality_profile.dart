import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

extension RadarrQualityProfileExtension on RadarrQualityProfile {
  String? get lunaName {
    if (this.name != null && this.name!.isNotEmpty) return this.name;
    return LunaUI.TEXT_EMDASH;
  }
}
