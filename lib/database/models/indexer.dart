import 'package:lunasea/core.dart';

part 'indexer.g.dart';

@JsonSerializable()
class LunaIndexer {
  @JsonKey()
  String displayName;

  @JsonKey()
  String host;

  @JsonKey(name: 'key')
  String apiKey;

  Map<String, String> headers;

  LunaIndexer._internal({
    required this.displayName,
    required this.host,
    required this.apiKey,
    required this.headers,
  });

  factory LunaIndexer({
    String? displayName,
    String? host,
    String? apiKey,
    Map<String, String>? headers,
  }) {
    return LunaIndexer._internal(
      displayName: displayName ?? '',
      host: host ?? '',
      apiKey: apiKey ?? '',
      headers: headers ?? {},
    );
  }

  @override
  String toString() => json.encode(this.toJson());

  Map<String, dynamic> toJson() => _$LunaIndexerToJson(this);

  factory LunaIndexer.fromJson(Map<String, dynamic> json) {
    return _$LunaIndexerFromJson(json);
  }

  factory LunaIndexer.clone(LunaIndexer profile) {
    return LunaIndexer.fromJson(profile.toJson());
  }

  // Legacy factory method - replaced by SwiftDataAccessor.getIndexer()
  @Deprecated('Use SwiftDataAccessor.getIndexer() instead')
  factory LunaIndexer.get(String key) {
    throw UnimplementedError('Use SwiftDataAccessor.getIndexer() instead');
  }
}
