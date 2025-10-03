import 'dart:convert';
part 'action_result.g.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SABnzbdActionResult {
  bool status;

  SABnzbdActionResult({
    required this.status,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory SABnzbdActionResult.fromJson(Map<String, dynamic> json) {
    return _$SABnzbdActionResultFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SABnzbdActionResultToJson(this);
  }
}
