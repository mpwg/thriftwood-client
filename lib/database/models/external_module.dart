import 'package:lunasea/core.dart';

part 'external_module.g.dart';

@JsonSerializable()
class LunaExternalModule {
  @JsonKey()
  String displayName;

  @JsonKey()
  String host;

  LunaExternalModule({
    this.displayName = '',
    this.host = '',
  });

  @override
  String toString() => json.encode(this.toJson());

  Map<String, dynamic> toJson() => _$LunaExternalModuleToJson(this);

  factory LunaExternalModule.fromJson(Map<String, dynamic> json) {
    return _$LunaExternalModuleFromJson(json);
  }

  factory LunaExternalModule.clone(LunaExternalModule profile) {
    return LunaExternalModule.fromJson(profile.toJson());
  }

  @Deprecated('Use SwiftDataAccessor instead - migrated to SwiftData')
  factory LunaExternalModule.get(String key) {
    throw UnsupportedError(
        'LunaExternalModule.get() deprecated - use SwiftDataAccessor');
  }
}
