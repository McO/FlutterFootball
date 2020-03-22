import 'match.dart';
import 'package:json_annotation/json_annotation.dart';
part 'group.g.dart';

@JsonSerializable(explicitToJson: true)
class Group {

  String name;
  List<Match> matches;

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}