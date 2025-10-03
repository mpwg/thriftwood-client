import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/string/string.dart';
import 'package:thriftwood/modules/radarr.dart';

extension LunaRadarrExtraFileExtension on RadarrExtraFile {
  String get lunaRelativePath {
    if (this.relativePath?.isNotEmpty ?? false) return this.relativePath!;
    return LunaUI.TEXT_EMDASH;
  }

  String get lunaExtension {
    if (this.extension?.isNotEmpty ?? false) return this.extension!;
    return LunaUI.TEXT_EMDASH;
  }

  String get lunaType {
    if (this.type?.isNotEmpty ?? false) return this.type!.toTitleCase();
    return LunaUI.TEXT_EMDASH;
  }
}
