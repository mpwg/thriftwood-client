import 'dart:convert';
part 'version.g.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SABnzbdVersion {
  String version;

  SABnzbdVersion({
    required this.version,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory SABnzbdVersion.fromJson(Map<String, dynamic> json) {
    return _$SABnzbdVersionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SABnzbdVersionToJson(this);
  }
}
