class Team {
  final int id;
  final String name;
  final String logo;

  const Team({this.id, this.name, this.logo});

  static Team fromJson(dynamic json) {
    return Team(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String,
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
