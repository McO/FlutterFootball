class CompetitionArea {
  final int id;
  final String name;
  final String countryCode;
  final String ensignUrl;

  const CompetitionArea({this.id, this.name, this.countryCode, this.ensignUrl});

  static CompetitionArea fromJson(dynamic json) {
    return CompetitionArea(
        id: json['id'] as int,
        name: json['name'] as String,
        countryCode: json['countryCode'] as String,
        ensignUrl: json['ensignUrl'] as String);
  }
}
