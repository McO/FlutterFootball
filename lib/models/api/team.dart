class Team {
  final int id;
  final String name;

  const Team({this.id, this.name});

  static Team fromJson(dynamic json) {
    return Team(
        id: json['id'] as int,
        name: json['name'] as String);
  }
}

