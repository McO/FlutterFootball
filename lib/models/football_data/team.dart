class Team {
  final int id;
  final String name;
  final String shortName;
  final String crestUrl;

  const Team({this.id, this.name, this.shortName, this.crestUrl});

  static Team fromJson(dynamic json) {
    return Team(
      id: json['id'] as int,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      crestUrl: json['crestUrl'] as String,
    );
  }
}

class TeamsResult {
  final List<Team> teams;

  const TeamsResult({this.teams});

  static TeamsResult fromJson(Map<String, dynamic> json) {
    final items =
        (json['teams'] as List<dynamic>).map((dynamic item) => Team.fromJson(item as Map<String, dynamic>)).toList();
    return TeamsResult(teams: items);
  }
}
