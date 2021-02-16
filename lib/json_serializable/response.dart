import 'matchdays.dart';
import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

@JsonSerializable(explicitToJson: true)
class Response {
  int code;
  String message;
  String status;
  MatchDays data;

  Response(this.code, this.message, this.status);

  factory Response.fromJson(Map<String, dynamic> json) => _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
