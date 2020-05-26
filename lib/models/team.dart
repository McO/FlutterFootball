class Team {
  final int id;
  final String name;
  String _shortName;
  final String logoUrl;

  Team({this.id, this.name, String shortName, this.logoUrl}) : _shortName = shortName;

  String get shortName {
    return _shortName ?? name;
  }

  set shortName(String name) => _shortName = name;

  String toString() {
    return "Team: $name";
  }
}
