class FixtureLeague {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String flag;
  final int season;
  final String round;

  const FixtureLeague({this.id, this.name, this.country, this.logo, this.flag, this.season, this.round});

  static FixtureLeague fromJson(dynamic json) {
    return FixtureLeague(
        id: json['id'] as int,
        name: json['name'] as String,
        country: json['country'] as String,
        logo: json['logo'] as String,
        flag: json['flag'] as String,
        season: json['season'] as int,
        round: json['round'] as String);
  }
}


