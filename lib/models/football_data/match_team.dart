class MatchTeam {
  final int id;
  final String name;

  const MatchTeam({this.id, this.name});

  static MatchTeam fromJson(dynamic json) {
    return MatchTeam(id: json['id'] as int, name: json['name'] as String);
  }
}
